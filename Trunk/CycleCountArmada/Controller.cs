using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using Controls;
using SymbolRFGun;
using Connection;
using DataLayer.DataAccess;

namespace CycleCount
{
    public class Controller
    {
        #region Class Objects

        private formCycleCount cycleCountForm;
        private MessageController messageController;
        private ErrorAlert alert;

        private readonly DataLayer.DataAccess.CycleCount cycle;

        #endregion


        public string OperatorCode { private get; set; }
        public string OperatorName { private get; set; }


        private string _part;
        private decimal _quantity;
        private string _location;


        //private bool _executedFromUniversalLogon;
        //public bool ExecutedFromUniversalLogon
        //{
        //    get { return _executedFromUniversalLogon; }
        //    set
        //    {
        //        _executedFromUniversalLogon = value;
        //        if (value)
        //        {
        //            cycleCountForm.logOnOffControl1.txtOperator.Text = OperatorName;
        //            cycleCountForm.logOnOffControl1.txtOperator.Visible = true;
        //            cycleCountForm.logOnOffControl1.lblOperator.Text = "Operator:";
        //            cycleCountForm.logOnOffControl1.tbxOpCode.Visible = false;
        //            cycleCountForm.logOnOffControl1.btnLogOnOff.Visible = false;
        //            logOnOffControl1_LogOnOffChanged(true);
        //        }
        //    }
        //}



        private bool isDatabindingCycleCountList { get; set; }

        private string _selectedCycleCount;
        public string SelectedCycleCount
        {
            get { return _selectedCycleCount; }
            set
            {
                _selectedCycleCount = value;
                if (!isDatabindingCycleCountList)
                {
                    ClearForm();
                    cycleCountForm.tbxSerial.Focus();
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
                        ClearForm();
                        cycleCountForm.cbxCycleCount.DataSource = null;
                        cycleCountForm.pnlMain.Enabled = cycleCountForm.pnlDataForm.Enabled = false;
                        messageController.ShowInstruction(Resources.loginInstructions);
                        cycleCountForm.logOnOffControl1.txtOperator.Focus();
                        break;
                    case screenStates.loggedIn:
                        cycleCountForm.pnlMain.Enabled = true;
                        messageController.ShowInstruction(Resources.scanningInstructions);
                        GetCycleCountList();
                        break;
                    case screenStates.refreshScreen:
                        cycleCountForm.tbxSerial.Text = "";
                        messageController.ShowInstruction(Resources.scanningInstructions);
                        GetCycleCountList();
                        break;
                }
            }
        }
        #endregion


        public Controller(string operatorCode, string operatorName)
        {
            // Instantiate declared class objects
            cycleCountForm = new formCycleCount(this);
            cycle = new DataLayer.DataAccess.CycleCount();
            alert = new ErrorAlert();
            messageController = new MessageController(cycleCountForm.messageBoxControl1.ucMessageBox, Resources.loginInstructions);
            ScreenState = screenStates.pendingLogin;

            // Wire control events
            cycleCountForm.logOnOffControl1.LogOnOffChanged += new LogOnOffControl.LogOnOffChangedEventHandler(logOnOffControl1_LogOnOffChanged);
            cycleCountForm.logOnOffControl1.OperatorCodeChanged += new LogOnOffControl.OperatorCodeChangedEventHandler(logOnOffControl1_OperatorCodeChanged);
            cycleCountForm.messageBoxControl1.MessageBoxControl_ShowPrevMessage += new EventHandler<EventArgs>(messageBoxControl1_MessageBoxControl_ShowPrevMessage);
            cycleCountForm.messageBoxControl1.MessageBoxControl_ShowNextMessage += new EventHandler<EventArgs>(messageBoxControl1_MessageBoxControl_ShowNextMessage);

            // Clear form fields
            ClearForm();

            OperatorCode = operatorCode;
            OperatorName = operatorName;
            //if (operatorCode.Length > 0)
            //{
            //    ExecutedFromUniversalLogon = true;
            //}

            Application.Run(cycleCountForm);
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

                // Disable and clear controls until a user logs on again
                ScreenState = screenStates.pendingLogin;
            }
        }

        void logOnOffControl1_OperatorCodeChanged(string opCode)
        {
            OperatorCode = opCode;
        }




        #region Cycle Count Combobox Methods

        public void GetCycleCountList()
        {
            string error = "";
            isDatabindingCycleCountList = true;

            var cycleCountNumbers = cycle.GetCycleCountNumbers(out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetCycleCountList() Error");
                return;
            }
            if (cycleCountNumbers == null)
            {
                alert.ShowError(alertLevel.High, "There are no active Cycle Counts.", "GetCycleCountList() Error");
                return;
            }
            cycleCountForm.cbxCycleCount.DataSource = cycleCountNumbers;
            cycleCountForm.cbxCycleCount.DisplayMember = "Description";
            cycleCountForm.cbxCycleCount.ValueMember = "CycleCountNumber";

            SelectedCycleCount = cycleCountForm.cbxCycleCount.SelectedValue.ToString();
            cycleCountForm.pnlDataForm.Enabled = true;
            cycleCountForm.cbxCycleCount.Focus();

            isDatabindingCycleCountList = false;
        }

        #endregion


        #region Serial Methods

        public void SerialEntered(int serial)
        {
            if (GetObjectInfo(serial) == 0) return;
            if (CycleCountTheObject(serial) == 1) GetScanProgressPerPart(serial);
        }

        private int GetObjectInfo(int serial)
        {
            string part, quantity, loc, error;
            decimal? parentSerial;

            cycle.GetObjectInfo(serial, out part, out quantity, out loc, out parentSerial, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "GetObjectInfo() Error");
                cycleCountForm.tbxSerial.Text = "";
                cycleCountForm.tbxSerial.Focus();
                return 0;
            }

            _part = part;
            _quantity = Convert.ToDecimal(quantity);
            _location = loc;
            return 1;
        }

        private int CycleCountTheObject(int serial)
        {
            string error = "";
            string actionTakenMessage = "";
            int? actionTaken = null;
            decimal? parentSerial = null;
            //string ccnumber = cycleCountForm.cbxCycleCount.SelectedValue.ToString();

            int? result = cycle.CycleCountTheObject(OperatorCode, _selectedCycleCount, serial, parentSerial, _part, _quantity, _location, out actionTakenMessage, out actionTaken, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.High, error, "CycleCountTheObject() Error");
                return 0;
            }
            messageController.ShowMessage(actionTakenMessage);
            return 1;
        }

        private void GetScanProgressPerPart(int serial)
        {
            string error;
            int scannedCount;
            int expectedCount;
            //string ccnumber = cycleCountForm.cbxCycleCount.SelectedValue.ToString();

            cycle.GetScanProgressPerPart(_selectedCycleCount, _part, out scannedCount, out expectedCount, out error);
            if (error != "")
            {
                alert.ShowError(alertLevel.Medium, "Box was cycle counted, but failed to return scanning progress.", "GetScanProgressPerPart() Error");
                //alert.ShowError(alertLevel.Medium, error, "GetScanProgressPerPart() Error");
                cycleCountForm.lblScannedMsg.Text = cycleCountForm.lblPartMsg.Text =                                 
                    cycleCountForm.lblProgressMsg.Text = "";
                return;
            }

            cycleCountForm.lblScannedMsg.Text = string.Format("Serial {0} scanned.", serial.ToString());
            cycleCountForm.lblPartMsg.Text = string.Format("Progress on part {0}:", _part);
            cycleCountForm.lblProgressMsg.Text = string.Format("Boxes {0} of {1}.", scannedCount.ToString(), expectedCount.ToString());      
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


        #region HandleScan Method

        public void handleScan(RFScanEventArgs e)
        {
            try
            {
                ScanData scanData = e.Text;

                if (scanData.ScanDataType == eScanDataType.Serial || scanData.ScanDataType == eScanDataType.Undef)
                {
                    int serial = int.Parse(scanData.DataValue.Trim());

                    cycleCountForm.tbxSerial.Text = scanData.DataValue.Trim();
                    SerialEntered(serial); 
                }
                else
                {
                    alert.ShowError(alertLevel.High, "Invalid scan.", "Error");
                }
            }
            catch (Exception ex)
            {
                string err = (ex.InnerException != null) ? ex.InnerException.Message : ex.Message;
                alert.ShowError(alertLevel.High, err, "handleScan() Error");
            }
        }

        #endregion


        #region Other Methods

        public void RefreshScreen()
        {
            ScreenState = screenStates.refreshScreen;
        }

        public void ClearForm()
        {
            cycleCountForm.tbxSerial.Text = cycleCountForm.lblScannedMsg.Text = 
                cycleCountForm.lblPartMsg.Text = cycleCountForm.lblProgressMsg.Text = "";
        }

        public void DisplayErrorMessageFromForm(Enum alertLevel, string message)
        {
            alert.ShowError(alertLevel, message, "Message");
        }

        #endregion


    }
}
