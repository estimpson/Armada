namespace ScanToTruck
{
    partial class formScanToTruck
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.MainMenu mainMenu1;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.mainMenu1 = new System.Windows.Forms.MainMenu();
            this.menuItem1 = new System.Windows.Forms.MenuItem();
            this.menuItem2 = new System.Windows.Forms.MenuItem();
            this.pnlMain = new System.Windows.Forms.Panel();
            this.lblShipperList = new System.Windows.Forms.Label();
            this.ddlTruck = new System.Windows.Forms.ComboBox();
            this.label2 = new System.Windows.Forms.Label();
            this.btnTruck = new System.Windows.Forms.Button();
            this.btnCancelPalletVerify = new System.Windows.Forms.Button();
            this.lblDestinationList = new System.Windows.Forms.Label();
            this.btnSerialEnter = new System.Windows.Forms.Button();
            this.btnPalletVerify = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.lblPalletsLoaded = new System.Windows.Forms.Label();
            this.lblBoxesLoaded = new System.Windows.Forms.Label();
            this.tbxSerial = new System.Windows.Forms.TextBox();
            this.messageBoxControl1 = new Controls.MessageBoxControl();
            this.logOnOffControl1 = new Controls.LogOnOffControl();
            this.pnlMain.SuspendLayout();
            this.SuspendLayout();
            // 
            // mainMenu1
            // 
            this.mainMenu1.MenuItems.Add(this.menuItem1);
            this.mainMenu1.MenuItems.Add(this.menuItem2);
            // 
            // menuItem1
            // 
            this.menuItem1.Text = "Close";
            this.menuItem1.Click += new System.EventHandler(this.menuItem1_Click);
            // 
            // menuItem2
            // 
            this.menuItem2.Text = "Refresh";
            this.menuItem2.Click += new System.EventHandler(this.menuItem2_Click);
            // 
            // pnlMain
            // 
            this.pnlMain.Controls.Add(this.lblShipperList);
            this.pnlMain.Controls.Add(this.ddlTruck);
            this.pnlMain.Controls.Add(this.label2);
            this.pnlMain.Controls.Add(this.btnTruck);
            this.pnlMain.Controls.Add(this.btnCancelPalletVerify);
            this.pnlMain.Controls.Add(this.lblDestinationList);
            this.pnlMain.Controls.Add(this.btnSerialEnter);
            this.pnlMain.Controls.Add(this.btnPalletVerify);
            this.pnlMain.Controls.Add(this.label1);
            this.pnlMain.Controls.Add(this.lblPalletsLoaded);
            this.pnlMain.Controls.Add(this.lblBoxesLoaded);
            this.pnlMain.Controls.Add(this.tbxSerial);
            this.pnlMain.Location = new System.Drawing.Point(0, 29);
            this.pnlMain.Name = "pnlMain";
            this.pnlMain.Size = new System.Drawing.Size(240, 185);
            // 
            // lblShipperList
            // 
            this.lblShipperList.Location = new System.Drawing.Point(11, 31);
            this.lblShipperList.Name = "lblShipperList";
            this.lblShipperList.Size = new System.Drawing.Size(218, 20);
            this.lblShipperList.Text = "Shipper List";
            this.lblShipperList.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // ddlTruck
            // 
            this.ddlTruck.Location = new System.Drawing.Point(63, 7);
            this.ddlTruck.Name = "ddlTruck";
            this.ddlTruck.Size = new System.Drawing.Size(104, 22);
            this.ddlTruck.TabIndex = 0;
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(11, 9);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(47, 20);
            this.label2.Text = "Trailer:";
            // 
            // btnTruck
            // 
            this.btnTruck.BackColor = System.Drawing.Color.White;
            this.btnTruck.Location = new System.Drawing.Point(175, 7);
            this.btnTruck.Name = "btnTruck";
            this.btnTruck.Size = new System.Drawing.Size(57, 20);
            this.btnTruck.TabIndex = 1;
            this.btnTruck.Text = "Pick";
            this.btnTruck.Click += new System.EventHandler(this.btnTruck_Click);
            // 
            // btnCancelPalletVerify
            // 
            this.btnCancelPalletVerify.BackColor = System.Drawing.Color.Red;
            this.btnCancelPalletVerify.Location = new System.Drawing.Point(182, 145);
            this.btnCancelPalletVerify.Name = "btnCancelPalletVerify";
            this.btnCancelPalletVerify.Size = new System.Drawing.Size(50, 35);
            this.btnCancelPalletVerify.TabIndex = 10;
            this.btnCancelPalletVerify.Text = "Cancel";
            this.btnCancelPalletVerify.Click += new System.EventHandler(this.btnCancelPalletVerify_Click);
            // 
            // lblDestinationList
            // 
            this.lblDestinationList.Location = new System.Drawing.Point(11, 48);
            this.lblDestinationList.Name = "lblDestinationList";
            this.lblDestinationList.Size = new System.Drawing.Size(218, 20);
            this.lblDestinationList.Text = "Destination";
            this.lblDestinationList.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // btnSerialEnter
            // 
            this.btnSerialEnter.BackColor = System.Drawing.Color.White;
            this.btnSerialEnter.Location = new System.Drawing.Point(175, 119);
            this.btnSerialEnter.Name = "btnSerialEnter";
            this.btnSerialEnter.Size = new System.Drawing.Size(57, 20);
            this.btnSerialEnter.TabIndex = 5;
            this.btnSerialEnter.Text = "Enter";
            this.btnSerialEnter.Click += new System.EventHandler(this.btnSerialEnter_Click);
            // 
            // btnPalletVerify
            // 
            this.btnPalletVerify.BackColor = System.Drawing.Color.White;
            this.btnPalletVerify.Location = new System.Drawing.Point(11, 145);
            this.btnPalletVerify.Name = "btnPalletVerify";
            this.btnPalletVerify.Size = new System.Drawing.Size(165, 35);
            this.btnPalletVerify.TabIndex = 4;
            this.btnPalletVerify.Text = "Verify 10 boxes on pallet";
            this.btnPalletVerify.Click += new System.EventHandler(this.btnPalletVerify_Click);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(11, 121);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(52, 20);
            this.label1.Text = "Serial:";
            // 
            // lblPalletsLoaded
            // 
            this.lblPalletsLoaded.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.lblPalletsLoaded.Location = new System.Drawing.Point(11, 90);
            this.lblPalletsLoaded.Name = "lblPalletsLoaded";
            this.lblPalletsLoaded.Size = new System.Drawing.Size(218, 20);
            this.lblPalletsLoaded.Text = "0 of 0 Pallets";
            this.lblPalletsLoaded.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // lblBoxesLoaded
            // 
            this.lblBoxesLoaded.Font = new System.Drawing.Font("Tahoma", 14F, System.Drawing.FontStyle.Regular);
            this.lblBoxesLoaded.Location = new System.Drawing.Point(11, 67);
            this.lblBoxesLoaded.Name = "lblBoxesLoaded";
            this.lblBoxesLoaded.Size = new System.Drawing.Size(218, 20);
            this.lblBoxesLoaded.Text = "0 of 0 Boxes";
            this.lblBoxesLoaded.TextAlign = System.Drawing.ContentAlignment.TopCenter;
            // 
            // tbxSerial
            // 
            this.tbxSerial.Location = new System.Drawing.Point(63, 119);
            this.tbxSerial.Name = "tbxSerial";
            this.tbxSerial.Size = new System.Drawing.Size(104, 21);
            this.tbxSerial.TabIndex = 2;
            this.tbxSerial.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbxSerial_KeyPress);
            // 
            // messageBoxControl1
            // 
            this.messageBoxControl1.Location = new System.Drawing.Point(0, 214);
            this.messageBoxControl1.Name = "messageBoxControl1";
            this.messageBoxControl1.Size = new System.Drawing.Size(240, 54);
            this.messageBoxControl1.TabIndex = 1;
            // 
            // logOnOffControl1
            // 
            this.logOnOffControl1.Location = new System.Drawing.Point(0, 0);
            this.logOnOffControl1.Name = "logOnOffControl1";
            this.logOnOffControl1.Size = new System.Drawing.Size(240, 29);
            this.logOnOffControl1.TabIndex = 0;
            // 
            // formScanToTruck
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.ControlBox = false;
            this.Controls.Add(this.pnlMain);
            this.Controls.Add(this.messageBoxControl1);
            this.Controls.Add(this.logOnOffControl1);
            this.Menu = this.mainMenu1;
            this.Name = "formScanToTruck";
            this.Text = "ScanToTruck v1.2";
            this.pnlMain.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.MenuItem menuItem1;
        private System.Windows.Forms.MenuItem menuItem2;
        public System.Windows.Forms.Panel pnlMain;
        public System.Windows.Forms.Button btnTruck;
        public System.Windows.Forms.ComboBox ddlTruck;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.Label lblPalletsLoaded;
        public System.Windows.Forms.Label lblBoxesLoaded;
        public System.Windows.Forms.TextBox tbxSerial;
        public System.Windows.Forms.Button btnPalletVerify;
        public Controls.LogOnOffControl logOnOffControl1;
        public Controls.MessageBoxControl messageBoxControl1;
        public System.Windows.Forms.Button btnSerialEnter;
        public System.Windows.Forms.Label lblDestinationList;
        public System.Windows.Forms.Button btnCancelPalletVerify;
        private System.Windows.Forms.Label label2;
        public System.Windows.Forms.Label lblShipperList;
    }
}

