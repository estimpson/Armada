using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Connection;
using SymbolRFGun;

namespace ScanToTruck
{
    public partial class formScanToTruck : Form
    {
        private Controller controller;

        public formScanToTruck(Controller con)
        {
            InitializeComponent();

            InitializeScanning();

            controller = con;
        }


        ~formScanToTruck()
        {
#if PocketPC
            if (FXRFGlobals.MyRFGun != null)
            {
                FXRFGlobals.MyRFGun.StopRead();
                FXRFGlobals.MyRFGun.RFScan -= _RFScanEventHandler;
                FXRFGlobals.MyRFGun.Close();
            }
#endif
        }


        
        #region RFScanner
#if PocketPC
                private RFScanEventHandler _RFScanEventHandler;
#endif

                private void InitializeScanning()
                {
#if PocketPC
                    _RFScanEventHandler = new RFScanEventHandler(MyRFGun_RFScan);
                    FXRFGlobals.MyRFGun.RFScan += _RFScanEventHandler;
#endif
                }


                void MyRFGun_RFScan(object sender, RFScanEventArgs e)
                {
                    controller.handleScan(e);
                }        
        #endregion


                
        #region MenuItems
        
        private void menuItem1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void menuItem2_Click(object sender, EventArgs e)
        {
            controller.RefreshScreen();
        }
   
        #endregion



        #region Truck

        private void btnTruck_Click(object sender, EventArgs e)
        {
            if (ddlTruck.Text == "") return;
            controller.Truck = ddlTruck.Text;
            controller.GetTruckInfo();
        }

        #endregion


        #region Serial

        private void btnSerialEnter_Click(object sender, EventArgs e)
        {
            //int serial = controller.ValidateSerial(tbxSerial.Text.Trim());
            //if (serial > 0)
            //{
            //    controller.SerialNumber = serial;
            //    controller.ValidateShipperSerial();
            //}
            controller.SerialNumberString = tbxSerial.Text.Trim();
            controller.ValidateTruckSerial();
        }

        private void tbxSerial_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                //int serial = controller.ValidateSerial(tbxSerial.Text.Trim());
                //if (serial > 0)
                //{
                //    controller.SerialNumber = serial;
                //    controller.ValidateTruckSerial();
                //}
                controller.SerialNumberString = tbxSerial.Text.Trim();
                controller.ValidateTruckSerial();
            }
        }

        #endregion


        #region Pallet Verify

        private void btnPalletVerify_Click(object sender, EventArgs e)
        {
            controller.PalletVerify();
        }

        private void btnCancelPalletVerify_Click(object sender, EventArgs e)
        {
            controller.CancelPalletVerify();
        }

        #endregion



    }
}