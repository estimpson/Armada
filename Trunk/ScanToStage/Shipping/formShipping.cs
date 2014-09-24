using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System;
using System.Windows.Forms;
using Connection;
using System.Drawing;
using Controls;
using SymbolRFGun;

namespace Shipping
{
    public partial class formShipping : Form
    {        
        private Controller controller;

        enum alertLevel
        {
            Medium,
            High
        }

        public formShipping(Controller con)
        {
            InitializeComponent();
            
            InitializeScanning();

            controller = con;
        }



        ~formShipping()
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


        //        private void formFXMES_Closing(object sender, CancelEventArgs e)
        //        {
        //#if PocketPC
        //            if (FXRFGlobals.MyRFGun != null)
        //            {
        //                FXRFGlobals.MyRFGun.StopRead();
        //                FXRFGlobals.MyRFGun.RFScan -= _RFScanEventHandler;
        //                FXRFGlobals.MyRFGun.Close();
        //            }
        //#endif
        //        }
                #endregion



            
        #region Menu Items

        private void menuItemClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void menuItemRefresh_Click(object sender, EventArgs e)
        {
            controller.RefreshScreen();
        }

        #endregion




        #region Shippers

        private void btnPickShipper_Click(object sender, EventArgs e)
        {
            // Populate grid with shipper lines (part based), and get shipper destination 
            bool isSuccessful = controller.GetShipperLines();
            if (isSuccessful) controller.GetDestination();
        }

        private void cbxShippers_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        #endregion



        #region Objects

        private void btnStageUnstage_Click(object sender, EventArgs e)
        {
            // If the serial number has any prefixes (supplier number, etc.) remove them
            int serial = controller.ParseSerial(tbxSerial.Text.Trim());
            if (serial > 0)
            {
                controller.StageOrUnstageSerial(serial);
            }
        }

        private void tbxSerial_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (e.KeyChar == (char)13)
            {
                int serial = controller.ParseSerial(tbxSerial.Text.Trim());
                if (serial > 0)
                {
                    controller.StageOrUnstageSerial(serial);
                }
            }
        }

        private void gridLines_MouseUp(object sender, MouseEventArgs e)
        {
            //if (gridLines.VisibleRowCount > 0)
            //{
            //    int x = gridLines.CurrentCell.RowNumber;
            //    controller.GetObjects(gridLines[x, 0].ToString());
            //}
        }

        #endregion


        #region Pallets

        private void btnOpenClosePallet_Click(object sender, EventArgs e)
        {
            controller.ShowPalletScreen();
        }

        #endregion


    }
}