using System;
using System.Collections.Generic;
using System.Windows.Forms;
using Controls;
using ScanToTruck.Properties;
using SymbolRFGun;
using Connection;
using DataLayer.DataAccess;

namespace ScanToTruck
{
    public class Controller
    {
        #region Class Objects

        private formScanToTruck STTForm;
        private MessageController messageController;
        private ErrorAlert alert;

        private readonly DataLayer.DataAccess.ScanToTruck dataScanToTruck;

        #endregion


        public string OperatorCode { private get; set; }
        public string OperatorName { private get; set; }
        public int SerialNumber { private get; set; }
        public string SerialNumberString { private get; set; }
        public string Truck { private get; set; }
        private string Shipper { get; set; }
        private int BoxCount { get; set; }

        private bool _executedFromUniversalLogon;
        public bool ExecutedFromUniversalLogon
        {
            get { return _executedFromUniversalLogon; }
            set
            {
                _executedFromUniversalLogon = value;
                if (value)
                {
                    STTForm.logOnOffControl1.txtOperator.Text = OperatorName;
                    STTForm.logOnOffControl1.txtOperator.Visible = true;
                    STTForm.logOnOffControl1.lblOperator.Text = "Operator:";
                    STTForm.logOnOffControl1.tbxOpCode.Visible = false;
                    STTForm.logOnOffControl1.btnLogOnOff.Visible = false;
                    logOnOffControl1_LogOnOffChanged(true);
                }
            }
        }

        private enum alertLevel
        {
            Medium,
            High
        }

        private Timer timer;


        #region ScreenStates

        private enum screenStates
        {
            pendingLogin,
            loggedIn,
            truckChosen,
            serialEntered,
            verifyPallet,
            endPalletVerify,
            truckVerified,
            lockDown,
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
                        STTForm.pnlMain.Enabled = false;
                        STTForm.pnlMain.BackColor = System.Drawing.Color.White;

                        STTForm.ddlTruck.DataSource = null;
                        STTForm.lblShipperList.Text = STTForm.lblDestinationList.Text = "";

                        STTForm.lblBoxesLoaded.Text = STTForm.lblPalletsLoaded.Text =
                            STTForm.tbxSerial.Text = "";

                        STTForm.tbxSerial.Enabled = STTForm.btnSerialEnter.Enabled = false;
                        STTForm.btnPalletVerify.Visible = STTForm.btnCancelPalletVerify.Visible = false;

                        messageController.ShowInstruction(Resources.loginInstructions);
                        STTForm.logOnOffControl1.txtOperator.Focus();
                        break;
                    case screenStates.loggedIn:
                        GetTruckList();
    
                        STTForm.pnlMain.Enabled = true;

                        FXRFGlobals.MyRFGun.StopRead();

                        STTForm.tbxSerial.Enabled = STTForm.btnSerialEnter.Enabled = false;
                        
                        messageController.ShowInstruction(Resources.truckInstructions);
                        STTForm.ddlTruck.Focus();
                        break;
                    case screenStates.truckChosen:
                        STTForm.pnlMain.BackColor = System.Drawing.Color.Yellow;

                        STTForm.tbxSerial.Enabled = STTForm.btnSerialEnter.Enabled = true;
                        FXRFGlobals.MyRFGun.StartRead();

                        messageController.ShowInstruction(Resources.scanningInstructions);
                        STTForm.tbxSerial.Focus();
                        break;
                    case screenStates.serialEntered:
                        STTForm.tbxSerial.Text = "";
                        STTForm.tbxSerial.Focus();

                        //GetShipperList();
                        GetTruckVerifyDetails();
                        break;
                    case screenStates.verifyPallet:
                        STTForm.pnlMain.BackColor = System.Drawing.Color.Black;
                        STTForm.btnPalletVerify.Text = String.Format("Verify {0} boxes on pallet", BoxCount);
                        STTForm.btnPalletVerify.Visible = STTForm.btnCancelPalletVerify.Visible = true;

                        STTForm.ddlTruck.Visible = STTForm.btnTruck.Visible = 
                            STTForm.tbxSerial.Visible = STTForm.btnSerialEnter.Visible = false;

                        STTForm.ddlTruck.Enabled = STTForm.btnTruck.Enabled =
                             STTForm.tbxSerial.Enabled = STTForm.btnSerialEnter.Enabled = false;

                        FXRFGlobals.MyRFGun.Beep();
                        break;
                    case screenStates.endPalletVerify:
                        STTForm.pnlMain.BackColor = System.Drawing.Color.Yellow;
                        STTForm.btnPalletVerify.Visible = STTForm.btnCancelPalletVerify.Visible = false;

                        STTForm.ddlTruck.Visible = STTForm.btnTruck.Visible =
                            STTForm.tbxSerial.Visible = STTForm.btnSerialEnter.Visible = true;

                        STTForm.ddlTruck.Enabled = STTForm.btnTruck.Enabled =
                             STTForm.tbxSerial.Enabled = STTForm.btnSerialEnter.Enabled = true;

                        STTForm.tbxSerial.Text = "";
                        STTForm.tbxSerial.Focus();
                        break;
                    case screenStates.truckVerified:
                        STTForm.pnlMain.BackColor = System.Drawing.Color.LimeGreen;
                        STTForm.btnPalletVerify.Visible = STTForm.btnCancelPalletVerify.Visible = false;

                        STTForm.pnlMain.Enabled = false;  

                        STTForm.ddlTruck.Visible = STTForm.btnTruck.Visible =
                            STTForm.tbxSerial.Visible = STTForm.btnSerialEnter.Visible = true;

                        STTForm.ddlTruck.Enabled = STTForm.btnTruck.Enabled = true;

                        STTForm.tbxSerial.Enabled = STTForm.btnSerialEnter.Enabled = false;

                        STTForm.lblShipperList.Text = STTForm.lblDestinationList.Text = 
                            STTForm.lblBoxesLoaded.Text = STTForm.lblPalletsLoaded.Text = "";

                        GetTruckList();

                        FXRFGlobals.MyRFGun.BeepSuccess();
                        messageController.ShowInstruction(Resources.truckInstructions);
                        STTForm.ddlTruck.Focus();
                        break;    
                    case screenStates.lockDown:
                        STTForm.pnlMain.Enabled = false;    
                        FXRFGlobals.MyRFGun.StopRead();
                        break;                    
                    case screenStates.refreshScreen:
                        STTForm.pnlMain.BackColor = System.Drawing.Color.White;

                        FXRFGlobals.MyRFGun.StopRead();

                        STTForm.ddlTruck.DataSource = null;
                        GetTruckList();

                        STTForm.lblShipperList.Text = STTForm.lblDestinationList.Text = "";

                        STTForm.lblBoxesLoaded.Text = STTForm.lblPalletsLoaded.Text =
                            STTForm.tbxSerial.Text = "";

                        STTForm.tbxSerial.Enabled = STTForm.btnSerialEnter.Enabled = false;
                        STTForm.btnPalletVerify.Visible = STTForm.btnCancelPalletVerify.Visible = false;

                        messageController.ShowInstruction(Resources.truckInstructions);
                        STTForm.ddlTruck.Focus();
                        break;
                }
            }
        }

        #endregion



        public Controller(string operatorCode, string operatorName)
        {
            // Instantiate declared class objects
            STTForm = new formScanToTruck(this);

            dataScanToTruck = new DataLayer.DataAccess.ScanToTruck();
            alert = new ErrorAlert();
            messageController = new MessageController(STTForm.messageBoxControl1.ucMessageBox,
                                                      Resources.loginInstructions);
            ScreenState = screenStates.pendingLogin;

            // Wire control events
            STTForm.logOnOffControl1.LogOnOffChanged +=
                new LogOnOffControl.LogOnOffChangedEventHandler(logOnOffControl1_LogOnOffChanged);
            STTForm.logOnOffControl1.OperatorCodeChanged +=
                new LogOnOffControl.OperatorCodeChangedEventHandler(logOnOffControl1_OperatorCodeChanged);
            STTForm.messageBoxControl1.MessageBoxControl_ShowPrevMessage +=
                new EventHandler<EventArgs>(messageBoxControl1_MessageBoxControl_ShowPrevMessage);
            STTForm.messageBoxControl1.MessageBoxControl_ShowNextMessage +=
                new EventHandler<EventArgs>(messageBoxControl1_MessageBoxControl_ShowNextMessage);

            // Create a timer to delay the user between scans
            timer = new Timer();
            timer.Interval = (1000) * (30); // Timer will tick every 30 seconds
            timer.Enabled = false;
            timer.Tick += new EventHandler(timer_Tick);

            OperatorCode = operatorCode;
            OperatorName = operatorName;
            if (operatorCode.Length > 0)
            {
                ExecutedFromUniversalLogon = true;
            }

            Application.Run(STTForm);
        }

        void timer_Tick(object sender, EventArgs e)
        {
            STTForm.pnlMain.Enabled = true;
            FXRFGlobals.MyRFGun.StartRead();
            timer.Enabled = false;
        }

        #region UserControls

        private void messageBoxControl1_MessageBoxControl_ShowNextMessage(object sender, EventArgs e)
        {
            messageController.ShowNextMessage();
        }

        private void messageBoxControl1_MessageBoxControl_ShowPrevMessage(object sender, EventArgs e)
        {
            messageController.ShowPreviousMessage();
        }


        private void logOnOffControl1_LogOnOffChanged(bool state)
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
                    STTForm.Close();
                }
                else
                {
                    // Disable and clear controls until a user logs on again
                    ScreenState = screenStates.pendingLogin;
                }
            }
        }

        private void logOnOffControl1_OperatorCodeChanged(string opCode)
        {
            OperatorCode = opCode;
        }

        #endregion


        #region Truck Methods

        public void GetTruckList()
        {
            string error = "";

            var truckNumbers = dataScanToTruck.GetTruckList(out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetTruckList() Error");
                return;
            }
            if (truckNumbers == null)
            {
                alert.ShowError(alertLevel.High, "There are no Trucks ready to depart.", "GetTruckList() Error");
                return;
            }
            STTForm.ddlTruck.DataSource = truckNumbers;
            STTForm.ddlTruck.DisplayMember = "TruckNumber";
            STTForm.ddlTruck.ValueMember = "TruckNumber";
            STTForm.ddlTruck.SelectedItem = null;
        }

        public void GetTruckInfo()
        {
            GetShipperList();
            GetTruckVerifyDetails();
            ScreenState = screenStates.truckChosen;
        }

        private void GetShipperList()
        {
            string error = "";
            string shipperList = "";
            string shipToList = "";

            dataScanToTruck.GetShipperList(Truck, out shipperList, out shipToList,out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetShipperList() Error");
                return;
            }
            if (shipperList == "")
            {
                alert.ShowError(alertLevel.High, "There are no Shippers ready to depart for this Truck.", "GetShipperList() Error");
                return;
            }
            STTForm.lblShipperList.Text = "Shp: " + shipperList;
            STTForm.lblDestinationList.Text = "Dst: " + shipToList;
        }

        public void GetTruckVerifyDetails()
        {
            string error = "";
            string totalLooseBoxes = "";
            string totalPallets = "";
            string verifiedBoxes = "";
            string verifiedPallets = "";
            int isVerified = 0;

            dataScanToTruck.GetTruckVerifyDetails(Truck, out totalLooseBoxes, out totalPallets, out verifiedBoxes, out verifiedPallets, out isVerified, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetTruckVerifyDetails() Error");
                return;
            }
            STTForm.lblBoxesLoaded.Text = String.Format("{0} of {1} Box/Bin", verifiedBoxes, totalLooseBoxes);
            STTForm.lblPalletsLoaded.Text = String.Format("{0} of {1} Pallets", verifiedPallets, totalPallets);

            if (ScreenState == screenStates.loggedIn || ScreenState == screenStates.truckVerified)
            {
                // User just logged in and selected a truck number, or completed scanning for this truck
                //  and chose a new one
                ScreenState = screenStates.truckChosen;
            }
            else
            {
                // A serial was verified, so check to see if scan to truck is now complete
                if (isVerified == 1)
                {
                    // Shipment is verified
                    messageController.ShowMessage(string.Format("Scanning completed for Truck {0}.", Truck));
                    ScreenState = screenStates.truckVerified;
                }
            }
        }

        #endregion


        #region Serial Methods

        public void ValidateTruckSerial()
        {
            string error = "";
            string shipper = "";
            string objectType = "";
            int rowCount = 0;
            int isScannedToTruck = 0;
            int boxCount = 0;
            int serial = 0;
            int? parentSerial = null;

            dataScanToTruck.ValidateTruckSerial(Truck, SerialNumberString, out serial, out shipper, out isScannedToTruck, out objectType, out boxCount, out parentSerial, out error, out rowCount);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "ValidateShipperSerial() Error");
                dataScanToTruck.LogErrors(Truck, SerialNumberString, error);
                STTForm.tbxSerial.Text = "";
                STTForm.tbxSerial.Focus();
                return;
            }
            if (rowCount == 0)
            {
                alert.ShowError(alertLevel.High, "Serial entered does not belong to this truck or it is invalid.", "ValidateShipperSerial() Error");
                dataScanToTruck.LogErrors(Truck, SerialNumberString, "Serial entered does not belong to this truck or it is invalid.");
                STTForm.tbxSerial.Text = "";
                STTForm.tbxSerial.Focus();
                return;
            }
            if (isScannedToTruck == 1)
            {
                alert.ShowError(alertLevel.High, String.Format("Serial {0} has already been scanned to the truck.", serial), "ValidateShipperSerial() Error");
                dataScanToTruck.LogErrors(Truck, SerialNumberString, "Serial has already been scanned to the truck.");
                STTForm.tbxSerial.Text = "";
                STTForm.tbxSerial.Focus();
                return;
            }
            if (objectType == "Box on Pallet")
            {
                alert.ShowError(alertLevel.High, String.Format("Serial {0} is on Pallet {1}. Please scan the pallet.", serial, parentSerial), "ValidateShipperSerial() Error");
                dataScanToTruck.LogErrors(Truck, SerialNumberString, "Serial is on a Pallet. Scan the pallet.");
                STTForm.tbxSerial.Text = "";
                STTForm.tbxSerial.Focus();
                return;
            }

            Shipper = shipper;
            SerialNumber = serial;

            if (objectType == "Pallet")
            {
                BoxCount = boxCount;
                ScreenState = screenStates.verifyPallet;
            }
            else
            {
                BoxCount = 1;
                ProcessSerial();
            }
        }

        public void PalletVerify()
        {
            ScreenState = screenStates.endPalletVerify;
            ProcessSerial();
        }

        public void CancelPalletVerify()
        {
            ScreenState = screenStates.endPalletVerify;
        }

        public void ProcessSerial()
        {
            string error = "";
                
            dataScanToTruck.ProcessSerial(OperatorCode, Truck, Shipper, SerialNumber, BoxCount, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "ProcessSerial() Error");
                return;
            }

            // Serial is verified
            messageController.ShowMessage(string.Format("Serial {0} scanned to Truck {1}, Shipper {2}.", SerialNumber, Truck, Shipper));
            ScreenState = screenStates.serialEntered;

            // Lockdown the scanning for thirty seconds before proceeding
            //timer.Enabled = true;
            //ScreenState = screenStates.lockDown;
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


        #region Scanning

        public void handleScan(RFScanEventArgs e)
        {
            try
            {
                ScanData scanData = e.Text;

                if (scanData.ScanDataType == eScanDataType.Serial || scanData.ScanDataType == eScanDataType.Undef)
                {
                    if (scanData.DataValue.Length > 50)
                    {
                        alert.ShowError(alertLevel.High, "You hit the 2D barcode.", "Wrong Barcode Scan");
                        return;
                    }

                    //int serial = int.Parse(scanData.DataValue.Trim());
                    STTForm.tbxSerial.Text = SerialNumberString = scanData.DataValue.Trim();
                    ValidateTruckSerial();
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

        #endregion


        #region Other Methods

        public void RefreshScreen()
        {
            ScreenState = screenStates.refreshScreen;
        }

        #endregion

    }
}
