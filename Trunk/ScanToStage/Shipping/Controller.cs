using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Reflection;
using System.Windows.Forms;
using Controls;
using Shipping.Properties;
using SymbolRFGun;
using Connection;
using DataGridCustomColumns;
using DataLayer.DataAccess;
using DataLayer.dsShippingTableAdapters;
using DataLayer;

namespace Shipping
{
    public class Controller
    {
        #region Class Objects

        private formShipping shippingForm;
        private formPallets palletsForm;
        private MessageController messageController;
        private ErrorAlert alert;

        private readonly DataLayer.DataAccess.Location location;
        private readonly DataLayer.DataAccess.Shipping shipping;

        #endregion


        private DataTable dataTableShipperLines;
        public string OperatorCode { private get; set; }
        public string OperatorName { private get; set; }

        private bool _executedFromUniversalLogon;
        public bool ExecutedFromUniversalLogon
        {
            get { return _executedFromUniversalLogon; }
            set
            {
                _executedFromUniversalLogon = value;
                if (value)
                {
                    shippingForm.logOnOffControl1.txtOperator.Text = OperatorName;
                    shippingForm.logOnOffControl1.txtOperator.Visible = true;
                    shippingForm.logOnOffControl1.lblOperator.Text = "Operator:";
                    shippingForm.logOnOffControl1.tbxOpCode.Visible = false;
                    shippingForm.logOnOffControl1.btnLogOnOff.Visible = false;
                    logOnOffControl1_LogOnOffChanged(true);
                }
            }
        }

        enum alertLevel
        {
            Medium,
            High
        }


        #region ScreenStates
        enum screenStates
        {
            pendingLogin,
            loggedIn,
            shipperSelected,
            refreshScreen
        }

        private screenStates _screenState;
        private screenStates ScreenState
        {
            get { return _screenState; }
            set
            {
                _screenState = value;
                switch (_screenState)
                {
                    case screenStates.pendingLogin:
                        shippingForm.cbxShippers.DataSource = shippingForm.gridLines.DataSource =  null;

                        shippingForm.tbxSerial.Text = "";
                        shippingForm.lblDestination.Text = "DESTINATION";

                        shippingForm.pnlMain.Enabled = shippingForm.tbxSerial.Enabled = 
                            shippingForm.btnStageUnstage.Enabled = shippingForm.pnlObjects.Enabled = false;
                        
                        messageController.ShowInstruction(Resources.loginInstructions);
                        shippingForm.logOnOffControl1.txtOperator.Focus();
                        break;
                    case screenStates.loggedIn:
                        shippingForm.pnlMain.Enabled = true;
                        messageController.ShowInstruction(Resources.scanShipper);
                        GetShipperNumbers();
                        break;
                    case screenStates.shipperSelected:
                        shippingForm.tbxSerial.Enabled = shippingForm.btnStageUnstage.Enabled = 
                            shippingForm.pnlObjects.Enabled = true;
                        messageController.ShowInstruction(Resources.scanObject);
                        break;
                    case screenStates.refreshScreen:
                        shippingForm.cbxShippers.DataSource = shippingForm.gridLines.DataSource = null;

                        shippingForm.tbxSerial.Text = "";
                        shippingForm.lblDestination.Text = "DESTINATION";

                        shippingForm.tbxSerial.Enabled = shippingForm.btnStageUnstage.Enabled =
                            shippingForm.pnlObjects.Enabled = false;

                        ClosePallet();

                        messageController.ShowInstruction(Resources.scanShipper);
                        break;
                }
            }
        }
        #endregion


        public Controller(string operatorCode, string operatorName)
        {
            // Instantiate declared class objects
            shippingForm = new formShipping(this);
            location = new DataLayer.DataAccess.Location();
            shipping = new DataLayer.DataAccess.Shipping();
            palletsForm = new formPallets(this);
            alert = new ErrorAlert();
            messageController = new MessageController(shippingForm.messageBoxControl1.ucMessageBox, Resources.loginInstructions);
            ScreenState = screenStates.pendingLogin;

            // Wire control events
            shippingForm.logOnOffControl1.LogOnOffChanged += new LogOnOffControl.LogOnOffChangedEventHandler(logOnOffControl1_LogOnOffChanged);
            shippingForm.logOnOffControl1.OperatorCodeChanged += new LogOnOffControl.OperatorCodeChangedEventHandler(logOnOffControl1_OperatorCodeChanged);
            shippingForm.messageBoxControl1.MessageBoxControl_ShowPrevMessage += new EventHandler<EventArgs>(messageBoxControl1_MessageBoxControl_ShowPrevMessage);
            shippingForm.messageBoxControl1.MessageBoxControl_ShowNextMessage += new EventHandler<EventArgs>(messageBoxControl1_MessageBoxControl_ShowNextMessage);

            OperatorCode = operatorCode;
            OperatorName = operatorName;
            if (operatorCode.Length > 0)
            {
                ExecutedFromUniversalLogon = true;
            }

            Application.Run(shippingForm);
        }





        void messageBoxControl1_MessageBoxControl_ShowNextMessage(object sender, EventArgs e)
        {
            messageController.ShowNextMessage();
        }

        void messageBoxControl1_MessageBoxControl_ShowPrevMessage(object sender, EventArgs e)
        {
            messageController.ShowPreviousMessage();
        }





        void logOnOffControl1_LogOnOffChanged(bool state)
        {
            if (state) // A user successfully logged on
            {
                FXRFGlobals.MyRFGun.StartRead();

                // Enable controls
                ScreenState = screenStates.loggedIn;
            }
            else // A user logged off
            {
                FXRFGlobals.MyRFGun.StopRead();

                if (_executedFromUniversalLogon)
                {
                    shippingForm.Close();
                }
                else
                {
                    // Disable and clear controls until a user logs on again
                    ScreenState = screenStates.pendingLogin;
                }
            }
        }

        void logOnOffControl1_OperatorCodeChanged(string opCode)
        {
            OperatorCode = opCode;
        }




        #region Shipper Methods

        public void GetShipperNumbers()
        {
            string error = "";

            var shipperNumbers = shipping.GetShipperNumbers(out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetShipperNumbers() Error");
                return;
            }
            if (shipperNumbers == null)
            {
                alert.ShowError(alertLevel.High, "There are no active Shippers.", "GetShipperNubmers() Error");
                return;
            }
            shippingForm.cbxShippers.DataSource = shipperNumbers;
            shippingForm.cbxShippers.DisplayMember = "id";
            shippingForm.cbxShippers.ValueMember = "id";
            shippingForm.cbxShippers.SelectedItem = null;
        }
                     
        public void ShipperScanned(string shipper)        
        {
            // Validate shipper and get shipper lines
            GetShipperLines();

            // Refresh combobox
            GetShipperNumbers();

            // Set combobox text
            shippingForm.cbxShippers.Text = shipper;
        }

        public bool GetShipperLines()
        {
            string error = "";
            string customer = "";
            string duedate = "";
            int shipperID = Convert.ToInt32(shippingForm.cbxShippers.SelectedValue);

            if (shipperID == 0) return false;

            var shipperLines = shipping.GetShipperLines(shipperID, out customer, out duedate, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetShipperLines() Error");
                return false;
            }
            if (shipperLines == null)
            {
                alert.ShowError(alertLevel.High, "Failed to return any Shipper Lines.", "GetShipperLines() Error");
                return false;
            }
            dataTableShipperLines = shipperLines;

            // Customize datagrid columns
            CustomDataGridColumnStyles();

            // Bind datagrid
            shippingForm.gridLines.DataSource = shipperLines;

            ScreenState = screenStates.shipperSelected;

            messageController.ShowMessage(shippingForm.lblPallet.Text == "NONE"
                                              ? string.Format("Now staging Shipper {0}, Customer {1}, Due {2}.",
                                                              shipperID, customer, duedate)
                                              : string.Format(
                                                  "Now staging Shipper {0}, Pallet {1}, Customer {2}, Due {3}.",
                                                  shipperID, shippingForm.lblPallet.Text, customer, duedate));
            return true;
        }

        public void GetDestination()
        {
            string error = "";
            int shipper = Convert.ToInt32(shippingForm.cbxShippers.SelectedValue);

            string dest = shipping.GetDestination(shipper, out error);
            if (error == "" && dest != "") shippingForm.lblDestination.Text = dest; 
        }

        private void CustomDataGridColumnStyles()
        {
            shippingForm.gridLines.TableStyles.Clear();
            var ts = new DataGridTableStyle { MappingName = "GetShipperLines" };


            // Part Column
            var dataGridCustomColumn0 = new DataGridCustomTextBoxColumn
            {
                Owner = shippingForm.gridLines,
                HeaderText = "Part",
                MappingName = "part",
                Width = shippingForm.gridLines.Width * 35 / 100,
                ReadOnly = true
            };
            dataGridCustomColumn0.SetCellFormat += CgsSetCellFormat;
            ts.GridColumnStyles.Add(dataGridCustomColumn0);


            //// Customer Part Column
            //var dataGridCustomColumn1 = new DataGridCustomTextBoxColumn
            //{
            //    Owner = shippingForm.gridLines,
            //    HeaderText = "CPart",
            //    MappingName = "customer_part",
            //    Width = shippingForm.gridLines.Width * 30 / 100,
            //    ReadOnly = true
            //};
            //dataGridCustomColumn1.SetCellFormat += CgsSetCellFormat;
            //ts.GridColumnStyles.Add(dataGridCustomColumn1);


            // Quantity Required Column
            var dataGridCustomColumn2 = new DataGridCustomTextBoxColumn
            {
                Owner = shippingForm.gridLines,
                HeaderText = "Rqd",
                Format = "0.#",
                FormatInfo = null,
                MappingName = "qty_required",
                Width = shippingForm.gridLines.Width * 15 / 100,
                Alignment = HorizontalAlignment.Right,
                ReadOnly = true
            };
            dataGridCustomColumn2.SetCellFormat += CgsSetCellFormat;
            ts.GridColumnStyles.Add(dataGridCustomColumn2);


            // Quantity Packed Column
            var dataGridCustomColumn3 = new DataGridCustomTextBoxColumn
            {
                Owner = shippingForm.gridLines,
                HeaderText = "Pkd",
                Format = "0.#",
                FormatInfo = null,
                MappingName = "qty_packed",
                Width = shippingForm.gridLines.Width * 15 / 100,
                Alignment = HorizontalAlignment.Right,
                ReadOnly = true
            };
            dataGridCustomColumn3.SetCellFormat += CgsSetCellFormat;
            ts.GridColumnStyles.Add(dataGridCustomColumn3);


            // Boxes Staged Column
            var dataGridCustomColumn4 = new DataGridCustomTextBoxColumn
            {
                Owner = shippingForm.gridLines,
                HeaderText = "Staged",
                MappingName = "boxes_staged",
                Width = shippingForm.gridLines.Width * 18 / 100,
                ReadOnly = true
            };
            dataGridCustomColumn4.SetCellFormat += CgsSetCellFormat;
            ts.GridColumnStyles.Add(dataGridCustomColumn4);

            //  Add new table style to Grid.
            shippingForm.gridLines.TableStyles.Add(ts);
        }

        // Define Event Handler. It must conform to the paramters defined in the delegate.
        private void CgsSetCellFormat(object sender, DataGridCustomColumns.DataGridFormatCellEventArgs e)
        {
            var rowShipperLines = dataTableShipperLines.Rows[e.Row] as DataLayer.dsShipping.GetShipperLinesRow;

            try
            {
                decimal d = Convert.ToDecimal(rowShipperLines.qty_packed);
            }
            catch (Exception)
            {
                e.CellColor = Color.White;
                return;
            }

            if (rowShipperLines.qty_packed == 0)
            {
                e.CellColor = Color.White;
                return;
            }
                
            if (rowShipperLines.qty_packed < rowShipperLines.qty_required) e.CellColor = Color.Yellow;
            if (rowShipperLines.qty_packed == rowShipperLines.qty_required) e.CellColor = Color.LightGreen;
            if (rowShipperLines.qty_packed > rowShipperLines.qty_required) e.CellColor = Color.Tomato;
        }

        #endregion



        #region Serial Methods

        //public void GetObjects(string part) // Get list of staged objects for the shipper/part
        //{
        //    string error = "";
        //    int shipperID = Convert.ToInt32(shippingForm.cbxShippers.SelectedValue);

        //    var shipperLineObjects = shipping.GetShipperLineObjects(shipperID, part, out error);
        //    if (error != "")
        //    {
        //        alert.ShowError(alertLevel.High, error, "GetShipperLineObjects() Error");
        //        return;
        //    }
        //    if (shipperLineObjects == null) return;

        //    // Customize datagrid columns
        //    CustomDataGridColumnStylesForLineObjects();

        //    // Bind datagrid
        //    shippingForm.gridObjects.DataSource = shipperLineObjects;

        //    // Set form focus
        //    shippingForm.tbxSerial.Focus();
        //}

        //private void CustomDataGridColumnStylesForLineObjects()
        //{
        //    shippingForm.gridObjects.TableStyles.Clear();
        //    var ts = new DataGridTableStyle { MappingName = "GetShipperLineObjects" };

        //    // Serial Column
        //    var dataGridCustomColumn0 = new DataGridCustomTextBoxColumn
        //    {
        //        Owner = shippingForm.gridObjects,
        //        HeaderText = "Serial",
        //        MappingName = "serial",
        //        Width = shippingForm.gridObjects.Width * 25 / 100,
        //        ReadOnly = true
        //    };
        //    //dataGridCustomColumn0.SetCellFormat += CgsSetCellFormat;
        //    ts.GridColumnStyles.Add(dataGridCustomColumn0);

        //    // Part Column
        //    var dataGridCustomColumn1 = new DataGridCustomTextBoxColumn
        //    {
        //        Owner = shippingForm.gridObjects,
        //        HeaderText = "Part",
        //        MappingName = "part",
        //        Width = shippingForm.gridObjects.Width * 35 / 100,
        //        ReadOnly = true
        //    };
        //    //dataGridCustomColumn1.SetCellFormat += CgsSetCellFormat;
        //    ts.GridColumnStyles.Add(dataGridCustomColumn1);

        //    // Quantity Column
        //    var dataGridCustomColumn2 = new DataGridCustomTextBoxColumn
        //    {
        //        Owner = shippingForm.gridObjects,
        //        HeaderText = "Qty",
        //        Format = "0.#",
        //        FormatInfo = null,
        //        MappingName = "quantity",
        //        Width = shippingForm.gridObjects.Width * 18 / 100,
        //        Alignment = HorizontalAlignment.Right,
        //        ReadOnly = true
        //    };
        //    //dataGridCustomColumn2.SetCellFormat += CgsSetCellFormat;
        //    ts.GridColumnStyles.Add(dataGridCustomColumn2);

        //    //  Add new table style to Grid.
        //    shippingForm.gridObjects.TableStyles.Add(ts);
        //}

        public int ParseSerial(string ser)
        {
            string error = "";
            int serialInt = shipping.ParseSerial(ser, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "ParseSerial() Error");
                return 0;
            }
            if (serialInt == 0)
            {
                alert.ShowError(alertLevel.High, "Scanned serial was not found in the system.", "ParseSerial() Error");
                return 0;
            }
            return serialInt;
        }

        public void StageOrUnstageSerial(int serial)
        {
            string error = "";
            int result;
            int shipperID = Convert.ToInt32(shippingForm.cbxShippers.SelectedValue);

            string pallet = shippingForm.lblPallet.Text;
            if (pallet != "NONE") // Staging a box to a pallet, or unstaging a box from a pallet
            {
                int palletSerial = Convert.ToInt32(pallet);
                result = shipping.StageObject(OperatorCode, shipperID, serial, palletSerial, out error);
            }
            else // Staging a box or pallet to a shipper, or unstaging a box or pallet from a shipper
            {
                result = shipping.StageObject(OperatorCode, shipperID, serial, null, out error);
            }

            if (error != "")
            {
                alert.ShowError(alertLevel.High, string.Format("Serial {0} was not staged. ", serial) + error, "StageObject() Error");
                shippingForm.tbxSerial.Text = "";
                shippingForm.tbxSerial.Focus();
                return;
            }
            
            if (result == 100) // Unstage object
            {
                // Show pop-up dialog to verify unstage
                FXRFGlobals.MyRFGun.Beep();
                DialogResult dr = MessageBox.Show("Object is already staged. Do you want to unstage it?", "Message",
                                MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2);
                if (dr == DialogResult.Yes)
                {
                    shipping.UnstageObject(OperatorCode, serial, out error);
                    if (error != "")
                    {
                        alert.ShowError(alertLevel.High, string.Format("Serial {0} was not unstaged. ", serial) + error, "UnstageObject() Error");
                    }
                    else // Successful unstage
                    {
                        if (shippingForm.tbxSerial.Text == shippingForm.lblPallet.Text) ClosePallet();
                        RefreshAfterStageOrUnstage(serial);
                        messageController.ShowMessage(string.Format("Unstaged {0} from Shipper {1}.", serial, shipperID));
                    }
                }  
                shippingForm.tbxSerial.Text = "";
                shippingForm.tbxSerial.Focus();
            }
            else if (result == 0) // Successful stage
            {
                RefreshAfterStageOrUnstage(serial);
                messageController.ShowMessage(string.Format("Staged {0} to Shipper {1}.", serial, shipperID));
            }
        }

        private void RefreshAfterStageOrUnstage(int serial)
        {
            string err = "";
            shippingForm.tbxSerial.Text = "";

            // Refresh shipper lines grid
            GetShipperLines();

            // Scroll to row in lines grid based on part number of scanned serial
            var part = shipping.GetObjectInfo(serial, out err);
            if (err != "")
            {
                alert.ShowError(alertLevel.High, err, "GetShipperLineObjects() Error");
                return;
            }
            if (part == "") return;

            for (int i = 0; i < shippingForm.gridLines.VisibleRowCount; i++)
            {
                if (shippingForm.gridLines[i, 0].ToString() == part)
                    ScrollGridToRow(shippingForm.gridLines, i);
            }

            // Refresh staged objects grid
            //GetObjects(part);

            shippingForm.tbxSerial.Focus();
        }

        private void ScrollGridToRow(DataGrid control, int rowNumber)
        {
            FieldInfo fi = control.GetType().GetField("m_sbVert",
                                                   BindingFlags.NonPublic | BindingFlags.GetField |
                                                   BindingFlags.Instance);
            ((VScrollBar)fi.GetValue(shippingForm.gridLines)).Value = rowNumber;
        }

        public int ValidateSerial(string ser)
        {
            int serial = 0;
            try
            {
                serial = Convert.ToInt32(ser);
            }
            catch (Exception)
            {
                return serial;
            }
            return serial;
        }

        #endregion



        #region PalletMethods

        public void ShowPalletScreen()
        {
            if (shippingForm.btnOpenClosePallet.Text == "Close")
            {
                ClosePallet();
                return;
            }
            palletsForm.dataGridStagedPallets.DataSource = null;

            // Set the Shipper variable, which will be used in pallet methods
            palletsForm.Shipper = Convert.ToInt32(shippingForm.cbxShippers.SelectedValue);
 
            // Get a list of the staged pallets for the shipper
            GetStagedPalletsForShipper();

            // Show Pallets form
            if (palletsForm.ShowDialog() == DialogResult.OK)
            {
                if (palletsForm.SelectedPalletSerial != "") 
                {
                    OpenPallet(palletsForm.SelectedPalletSerial);
                }
            }
        }

        private void GetStagedPalletsForShipper()
        {
            // Populate pallets grid
            string error = "";

            var pallets = shipping.GetStagedPallets(palletsForm.Shipper, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetStagedPallets() Error");
                return;
            }

            // Customize datagrid columns
            CustomPalletsDataGridColumnStyles();

            // Bind datagrid
            palletsForm.dataGridStagedPallets.DataSource = pallets;

            // Clear pallet objects grid until the user selects a pallet
            palletsForm.dataGridPalletObjects.DataSource = null;
        }

        private void CustomPalletsDataGridColumnStyles()
        {
            palletsForm.dataGridStagedPallets.TableStyles.Clear();
            var ts = new DataGridTableStyle { MappingName = "GetStagedPallets" };


            // Pallet Column
            var dataGridCustomColumn0 = new DataGridCustomTextBoxColumn
            {
                Owner = palletsForm.dataGridStagedPallets,
                HeaderText = "Pallet",
                MappingName = "PalletSerial",
                Width = palletsForm.dataGridStagedPallets.Width * 30 / 100,
                ReadOnly = true
            };
            ts.GridColumnStyles.Add(dataGridCustomColumn0);


            // Boxes Column
            var dataGridCustomColumn1 = new DataGridCustomTextBoxColumn
            {
                Owner = palletsForm.dataGridStagedPallets,
                HeaderText = "Boxes",
                MappingName = "NumberOfBoxes",
                Width = palletsForm.dataGridStagedPallets.Width * 20 / 100,
                ReadOnly = true
            };
            ts.GridColumnStyles.Add(dataGridCustomColumn1);


            //  Add new table style to Grid.
            palletsForm.dataGridStagedPallets.TableStyles.Add(ts);
        }

        public void GetPalletObjects(string palletSerial)
        {
            // Populate pallet objects grid
            string error = "";

            var palletObjects = shipping.GetPalletObjects(palletsForm.Shipper, Convert.ToInt32(palletSerial), out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetPalletsObjects() Error");
                return;
            }

            // Customize datagrid columns
            CustomPalletObjectsDataGridColumnStyles();

            // Bind datagrid
            palletsForm.dataGridPalletObjects.DataSource = palletObjects;
        }

        private void CustomPalletObjectsDataGridColumnStyles()
        {
            palletsForm.dataGridPalletObjects.TableStyles.Clear();
            var ts = new DataGridTableStyle { MappingName = "GetPalletObjects" };


            // Part Column
            var dataGridCustomColumn0 = new DataGridCustomTextBoxColumn
            {
                Owner = palletsForm.dataGridPalletObjects,
                HeaderText = "part",
                MappingName = "Part",
                Width = palletsForm.dataGridPalletObjects.Width * 40 / 100,
                ReadOnly = true
            };
            ts.GridColumnStyles.Add(dataGridCustomColumn0);


            // QuantityPerPart Column
            var dataGridCustomColumn1 = new DataGridCustomTextBoxColumn
            {
                Owner = palletsForm.dataGridPalletObjects,
                HeaderText = "qty",
                Format = "0.#",
                FormatInfo = null,
                MappingName = "QuantityPerPart",
                Width = palletsForm.dataGridPalletObjects.Width * 18 / 100,
                Alignment = HorizontalAlignment.Right,
                ReadOnly = true
            };
            ts.GridColumnStyles.Add(dataGridCustomColumn1);


            // BoxesPerPart Column
            var dataGridCustomColumn2 = new DataGridCustomTextBoxColumn
            {
                Owner = palletsForm.dataGridPalletObjects,
                HeaderText = "boxes",
                MappingName = "BoxesPerPart",
                Width = palletsForm.dataGridPalletObjects.Width * 18 / 100,
                ReadOnly = true
            };
            ts.GridColumnStyles.Add(dataGridCustomColumn2);


            //  Add new table style to Grid.
            palletsForm.dataGridPalletObjects.TableStyles.Add(ts);
        }

        public void CreateNewPallet()
        {
            // Create new pallet
            NewPallet();

            // Refresh grids
            GetStagedPalletsForShipper();
        }

        private void NewPallet()
        {
            string error = "";

            shipping.NewPallet(OperatorCode, palletsForm.Shipper, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, "Failed to create new pallet. " + error, "NewPallet() Error");
                return;
            }
            messageController.ShowMessage("New pallet created.");
        }

        public void RemovePallet(string palletSerial)
        {
            string error = "";
            int pallet = Convert.ToInt32(palletSerial);

            shipping.UnstageObject(OperatorCode, pallet, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, string.Format("Failed to remove pallet {0}. ", palletSerial) + error, "RemovePallet() Error");
            }
            else // Successful
            {
                palletsForm.SelectedPalletSerial = "";
                messageController.ShowMessage(string.Format("Removed {0} from Shipper {1}.", palletSerial, palletsForm.Shipper));
            }

            // Refresh grid
            GetStagedPalletsForShipper();
        }

        private void OpenPallet(string PalletSerial)
        {
            shippingForm.lblPallet.Text = PalletSerial;
            shippingForm.pnlObjects.BackColor = Color.LimeGreen;
            shippingForm.btnOpenClosePallet.Text = "Close";
        }

        private void ClosePallet()
        {
            shippingForm.lblPallet.Text = "NONE";
            shippingForm.pnlObjects.BackColor = Color.DarkGray;
            shippingForm.btnOpenClosePallet.Text = "Open";
        }

        #endregion



        #region Additional Methods

        public void handleScan(RFScanEventArgs e)
        {
            try
            {
                ScanData scanData = e.Text;

                if (scanData.ScanDataType == eScanDataType.Serial || scanData.ScanDataType == eScanDataType.Undef)
                {
                    //int serial = int.Parse(scanData.DataValue.Trim());

                    // If the serial number has any prefixes (supplier number, etc.) remove them
                    int serial = ParseSerial(scanData.DataValue.Trim());
                    if (serial == 0) return;

                    shippingForm.tbxSerial.Text = scanData.DataValue.Trim();
                    StageOrUnstageSerial(serial);
                }
                else if (scanData.ScanDataType == eScanDataType.Shipper)
                {
                    ShipperScanned(scanData.DataValue.Trim());
                }
                else
                {
                    alert.ShowError(alertLevel.High, "Invalid scan.", "Error");
                }
            }
            catch (Exception ex)
            {
                if (ex.InnerException != null)
                {
                    alert.ShowError(alertLevel.High, ex.InnerException.ToString(), "handleScan() Error");
                }
                else
                {
                    alert.ShowError(alertLevel.High, ex.Message, "handleScan() Error");
                }
            }
        }

        public void RefreshScreen()
        {
            ScreenState = screenStates.refreshScreen;
        }

        public void DisplayErrorMessageFromForm(Enum alertLevel, string message)
        {
            alert.ShowError(alertLevel, message, "Message");
        }

        #endregion


    }
}
