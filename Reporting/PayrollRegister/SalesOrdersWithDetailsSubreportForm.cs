using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Reporting.WinForms;

namespace PayrollRegister
{
    public partial class SalesOrdersWithDetailsSubreportForm : Form
    {
        public SalesOrdersWithDetailsSubreportForm()
        {
            InitializeComponent();
        }

        private void SalesOrdersWithDetailsSubreportForm_Load(object sender, EventArgs e)
        {

            reportViewer1.ProcessingMode = ProcessingMode.Local;
            var localReport = reportViewer1.LocalReport;
            localReport.SubreportProcessing += new SubreportProcessingEventHandler(reportViewer1_SubreportProcessingEventHandler);
            localReport.ReportPath = "Reports\\Sales Orders With Details.rdlc";
            var dataSet = new DataSet("sp_sales_order_read");

            // Get sales orders
            GetSalesOrdersData(ref dataSet);

            // Create report data source
            var rdsSalesOrders = new ReportDataSource("sp_sales_order_read", dataSet.Tables["sp_sales_order_read"]);
            localReport.DataSources.Add(rdsSalesOrders);

            // Refresh
            reportViewer1.RefreshReport();
        }

        void reportViewer1_SubreportProcessingEventHandler(object sender, SubreportProcessingEventArgs e)
        {
            var salesOrderId = Convert.ToInt32(e.Parameters["sales_order_id"].Values[0]);
            var dataSet = new DataSet("sp_sales_order_detail_read");

            // Get sales order details
            GetSalesOrderDetailsData(salesOrderId, ref dataSet);

            var rdsSalesOrderDetails = new ReportDataSource("sp_sales_order_detail_read", dataSet.Tables["sp_sales_order_detail_read"]);
            e.DataSources.Add(rdsSalesOrderDetails);
        }

        private void GetSalesOrdersData(ref DataSet dsSalesOrders)
        {
            var sqlSalesOrder = "execute sp_sales_order_read";
            var sqlConnection =
                new SqlConnection(
                    ("Data Source=EES-P51S\\SQLEXPRESS; Initial Catalog=AdventureWorks; Integrated Security=SSPI"));
            var command = new SqlCommand(sqlSalesOrder, sqlConnection);
            var salesOrderAdapater = new SqlDataAdapter(command);
            salesOrderAdapater.Fill(dsSalesOrders, "sp_sales_order_read");
        }

        private void GetSalesOrderDetailsData(Int32 salesOrderId, ref DataSet dsSalesOrderDetails)
        {
            var sqlSalesOrderDetail = $"execute sp_sales_order_detail_read {salesOrderId}";
            var sqlConnection =
                new SqlConnection(
                    ("Data Source=EES-P51S\\SQLEXPRESS; Initial Catalog=AdventureWorks; Integrated Security=SSPI"));
            var command = new SqlCommand(sqlSalesOrderDetail, sqlConnection);
            var salesOrderDetailAdapater = new SqlDataAdapter(command);
            salesOrderDetailAdapater.Fill(dsSalesOrderDetails, "sp_sales_order_detail_read");
        }

        private void GetSalesOrderData(Int32 salesOrderId, ref DataSet dsSalesOrderDetail)
        {
            var sqlSalesOrder = "execute sp_sales_order_detail_read @sales_order_id";
            var sqlConnection =
                new SqlConnection(
                    ("Data Source=EES-P51S\\SQLEXPRESS; Initial Catalog=AdventureWorks; Integrated Security=SSPI"));
            var command = new SqlCommand(sqlSalesOrder, sqlConnection);
            command.Parameters.Add(new SqlParameter("sales_order_id", salesOrderId));
            var salesOrderAdapater = new SqlDataAdapter(command);
            salesOrderAdapater.Fill(dsSalesOrderDetail, "sp_sales_order_detail_read");

        }
    }
}
