namespace Shipping
{
    partial class formPallets
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
            this.btnNewPallet = new System.Windows.Forms.Button();
            this.btnRemovePallet = new System.Windows.Forms.Button();
            this.btnOK = new System.Windows.Forms.Button();
            this.btnCancel = new System.Windows.Forms.Button();
            this.dataGridStagedPallets = new System.Windows.Forms.DataGrid();
            this.dataGridPalletObjects = new System.Windows.Forms.DataGrid();
            this.SuspendLayout();
            // 
            // btnNewPallet
            // 
            this.btnNewPallet.Location = new System.Drawing.Point(39, 3);
            this.btnNewPallet.Name = "btnNewPallet";
            this.btnNewPallet.Size = new System.Drawing.Size(72, 20);
            this.btnNewPallet.TabIndex = 0;
            this.btnNewPallet.Text = "New";
            this.btnNewPallet.Click += new System.EventHandler(this.btnNewPallet_Click);
            // 
            // btnRemovePallet
            // 
            this.btnRemovePallet.Location = new System.Drawing.Point(133, 3);
            this.btnRemovePallet.Name = "btnRemovePallet";
            this.btnRemovePallet.Size = new System.Drawing.Size(72, 20);
            this.btnRemovePallet.TabIndex = 1;
            this.btnRemovePallet.Text = "Remove";
            this.btnRemovePallet.Click += new System.EventHandler(this.btnRemovePallet_Click);
            // 
            // btnOK
            // 
            this.btnOK.BackColor = System.Drawing.Color.White;
            this.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.btnOK.Location = new System.Drawing.Point(87, 231);
            this.btnOK.Name = "btnOK";
            this.btnOK.Size = new System.Drawing.Size(72, 34);
            this.btnOK.TabIndex = 2;
            this.btnOK.Text = "OK";
            // 
            // btnCancel
            // 
            this.btnCancel.BackColor = System.Drawing.Color.White;
            this.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancel.Location = new System.Drawing.Point(165, 231);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(72, 34);
            this.btnCancel.TabIndex = 3;
            this.btnCancel.Text = "Cancel";
            // 
            // dataGridStagedPallets
            // 
            this.dataGridStagedPallets.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.dataGridStagedPallets.Location = new System.Drawing.Point(3, 30);
            this.dataGridStagedPallets.Name = "dataGridStagedPallets";
            this.dataGridStagedPallets.Size = new System.Drawing.Size(234, 88);
            this.dataGridStagedPallets.TabIndex = 4;
            this.dataGridStagedPallets.MouseUp += new System.Windows.Forms.MouseEventHandler(this.dataGridStagedPallets_MouseUp);
            // 
            // dataGridPalletObjects
            // 
            this.dataGridPalletObjects.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.dataGridPalletObjects.Location = new System.Drawing.Point(3, 132);
            this.dataGridPalletObjects.Name = "dataGridPalletObjects";
            this.dataGridPalletObjects.Size = new System.Drawing.Size(234, 91);
            this.dataGridPalletObjects.TabIndex = 5;
            // 
            // formPallets
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(240, 268);
            this.Controls.Add(this.dataGridPalletObjects);
            this.Controls.Add(this.dataGridStagedPallets);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.btnOK);
            this.Controls.Add(this.btnRemovePallet);
            this.Controls.Add(this.btnNewPallet);
            this.Menu = this.mainMenu1;
            this.Name = "formPallets";
            this.Text = "Pallets";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button btnOK;
        private System.Windows.Forms.Button btnCancel;
        public System.Windows.Forms.Button btnNewPallet;
        public System.Windows.Forms.Button btnRemovePallet;
        public System.Windows.Forms.DataGrid dataGridStagedPallets;
        public System.Windows.Forms.DataGrid dataGridPalletObjects;
    }
}