namespace CycleCount
{
    partial class formCycleCount
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
            this.pnlDataForm = new System.Windows.Forms.Panel();
            this.tbxSerial = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.btnSerialEnter = new System.Windows.Forms.Button();
            this.cbxCycleCount = new System.Windows.Forms.ComboBox();
            this.label1 = new System.Windows.Forms.Label();
            this.lblScannedMsg = new System.Windows.Forms.Label();
            this.lblPartMsg = new System.Windows.Forms.Label();
            this.lblProgressMsg = new System.Windows.Forms.Label();
            this.messageBoxControl1 = new Controls.MessageBoxControl();
            this.logOnOffControl1 = new Controls.LogOnOffControl();
            this.pnlMain.SuspendLayout();
            this.pnlDataForm.SuspendLayout();
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
            this.menuItem1.Click += new System.EventHandler(this.menuItemClose_Click);
            // 
            // menuItem2
            // 
            this.menuItem2.Text = "Refresh";
            this.menuItem2.Click += new System.EventHandler(this.menuItemRefresh_Click);
            // 
            // pnlMain
            // 
            this.pnlMain.BackColor = System.Drawing.Color.White;
            this.pnlMain.Controls.Add(this.pnlDataForm);
            this.pnlMain.Controls.Add(this.cbxCycleCount);
            this.pnlMain.Controls.Add(this.label1);
            this.pnlMain.Location = new System.Drawing.Point(0, 29);
            this.pnlMain.Name = "pnlMain";
            this.pnlMain.Size = new System.Drawing.Size(240, 185);
            // 
            // pnlDataForm
            // 
            this.pnlDataForm.BackColor = System.Drawing.Color.White;
            this.pnlDataForm.Controls.Add(this.lblProgressMsg);
            this.pnlDataForm.Controls.Add(this.lblPartMsg);
            this.pnlDataForm.Controls.Add(this.lblScannedMsg);
            this.pnlDataForm.Controls.Add(this.tbxSerial);
            this.pnlDataForm.Controls.Add(this.label3);
            this.pnlDataForm.Controls.Add(this.btnSerialEnter);
            this.pnlDataForm.Location = new System.Drawing.Point(5, 31);
            this.pnlDataForm.Name = "pnlDataForm";
            this.pnlDataForm.Size = new System.Drawing.Size(232, 151);
            // 
            // tbxSerial
            // 
            this.tbxSerial.Location = new System.Drawing.Point(49, 5);
            this.tbxSerial.Name = "tbxSerial";
            this.tbxSerial.Size = new System.Drawing.Size(101, 21);
            this.tbxSerial.TabIndex = 5;
            this.tbxSerial.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.tbxSerial_KeyPress);
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(8, 6);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(46, 20);
            this.label3.Text = "Serial:";
            // 
            // btnSerialEnter
            // 
            this.btnSerialEnter.BackColor = System.Drawing.Color.White;
            this.btnSerialEnter.Location = new System.Drawing.Point(155, 6);
            this.btnSerialEnter.Name = "btnSerialEnter";
            this.btnSerialEnter.Size = new System.Drawing.Size(72, 20);
            this.btnSerialEnter.TabIndex = 7;
            this.btnSerialEnter.Text = "Enter Box";
            this.btnSerialEnter.Click += new System.EventHandler(this.btnSerialEnter_Click);
            // 
            // cbxCycleCount
            // 
            this.cbxCycleCount.Location = new System.Drawing.Point(30, 3);
            this.cbxCycleCount.Name = "cbxCycleCount";
            this.cbxCycleCount.Size = new System.Drawing.Size(202, 22);
            this.cbxCycleCount.TabIndex = 0;
            this.cbxCycleCount.SelectedIndexChanged += new System.EventHandler(this.cbxCycleCount_SelectedIndexChanged);
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(5, 5);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(31, 20);
            this.label1.Text = "CC:";
            // 
            // lblScannedMsg
            // 
            this.lblScannedMsg.Location = new System.Drawing.Point(8, 41);
            this.lblScannedMsg.Name = "lblScannedMsg";
            this.lblScannedMsg.Size = new System.Drawing.Size(217, 16);
            this.lblScannedMsg.Text = "lblScannedMsg";
            // 
            // lblPartMsg
            // 
            this.lblPartMsg.Location = new System.Drawing.Point(8, 57);
            this.lblPartMsg.Name = "lblPartMsg";
            this.lblPartMsg.Size = new System.Drawing.Size(217, 16);
            this.lblPartMsg.Text = "lblPartMsg";
            // 
            // lblProgressMsg
            // 
            this.lblProgressMsg.Location = new System.Drawing.Point(8, 78);
            this.lblProgressMsg.Name = "lblProgressMsg";
            this.lblProgressMsg.Size = new System.Drawing.Size(217, 16);
            this.lblProgressMsg.Text = "lblProgressMsg";
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
            this.logOnOffControl1.TabIndex = 2;
            // 
            // formCycleCount
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
            this.Name = "formCycleCount";
            this.Text = "Cycle Count 1.3";
            this.pnlMain.ResumeLayout(false);
            this.pnlDataForm.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.MenuItem menuItem1;
        private System.Windows.Forms.MenuItem menuItem2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.Button btnSerialEnter;
        public System.Windows.Forms.TextBox tbxSerial;
        public System.Windows.Forms.ComboBox cbxCycleCount;
        public System.Windows.Forms.Panel pnlMain;
        public Controls.LogOnOffControl logOnOffControl1;
        public Controls.MessageBoxControl messageBoxControl1;
        public System.Windows.Forms.Panel pnlDataForm;
        public System.Windows.Forms.Label lblScannedMsg;
        public System.Windows.Forms.Label lblProgressMsg;
        public System.Windows.Forms.Label lblPartMsg;
    }
}

