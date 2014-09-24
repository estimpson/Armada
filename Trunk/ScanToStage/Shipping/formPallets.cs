using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Controls;
using SymbolRFGun;
using Connection;
using DataGridCustomColumns;

namespace Shipping
{
    public partial class formPallets : Form
    {
        private Controller controller;
        private ErrorAlert alert;

        public int Shipper { get; set; }
        public string SelectedPalletSerial { get; set; }

        enum alertLevel
        {
            Medium,
            High
        }

        public formPallets(Controller con)
        {
            InitializeComponent();

            controller = con;
            alert = new ErrorAlert();

            SelectedPalletSerial = "";
        }


        #region Form Actions

        private void dataGridStagedPallets_MouseUp(object sender, MouseEventArgs e)
        {
            if (dataGridStagedPallets.VisibleRowCount > 0)
            {
                int rowNumber = dataGridStagedPallets.CurrentCell.RowNumber;
                string selectedPallet = dataGridStagedPallets[rowNumber, 0].ToString();               

                controller.GetPalletObjects(selectedPallet);
                SelectedPalletSerial = selectedPallet;
            }
        }

        private void btnNewPallet_Click(object sender, EventArgs e)
        {
            controller.CreateNewPallet();
        }

        private void btnRemovePallet_Click(object sender, EventArgs e)
        {
            if (SelectedPalletSerial == "")
            {
                alert.ShowError(alertLevel.High, "Please select a pallet to remove.", "Message");
                return;
            }
            controller.RemovePallet(SelectedPalletSerial);
        }

        #endregion




    }
}