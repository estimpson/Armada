using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Reporting.WinForms;
using PayrollRegister.SagePayroll_ARMDataSetTableAdapters;

namespace PayrollRegister
{
    public partial class PayrollRegisterForm : Form
    {
        private readonly SagePayroll_ARMDataSet _sagePayrollDataSet = new SagePayroll_ARMDataSet();
        private readonly ftsp_CheckListTableAdapter _ftspCheckListTableAdapter = new ftsp_CheckListTableAdapter();
        private readonly ftsp_CheckSummaryTableAdapter _ftspCheckSummaryTableAdapter = new ftsp_CheckSummaryTableAdapter();
        private readonly ftsp_CheckEarningsDataTableAdapter _ftspCheckEarningsDataTableAdapter = new ftsp_CheckEarningsDataTableAdapter();
        private readonly ftsp_CheckTaxesDataTableAdapter _ftspCheckTaxesDataTableAdapter = new ftsp_CheckTaxesDataTableAdapter();
        private readonly ftsp_CheckDeductionsDataTableAdapter _ftspCheckDeductionsDataTableAdapter = new ftsp_CheckDeductionsDataTableAdapter();
        private readonly EmployeeListTableAdapter _employeeListTableAdapter = new EmployeeListTableAdapter();
        private readonly DepartmentListTableAdapter _departmentListTableAdapter = new DepartmentListTableAdapter();


        private readonly decimal? _argCheckNumber = null;
        private DateTime? _argBeginCheckDate;
        private DateTime? _argEndCheckDate;
        private string _argBeginEmployee = null;
        private string _argEndEmployee = null;
        private string _argClass1 = null;
        private Int32? _argTrialFlag = 1;
        private string _argSort = null;

        public PayrollRegisterForm()
        {
            InitializeComponent();
        }

        private void PayrollRegisterForm_Load(object sender, EventArgs e)
        {
            reportViewer1.ProcessingMode = ProcessingMode.Local;

            // Set up event for processing subreports
            reportViewer1.LocalReport.SubreportProcessing += new SubreportProcessingEventHandler(SubreportProcessingEventHandler);

            // Build employee list for combobox
            _employeeListTableAdapter.Fill(_sagePayrollDataSet.EmployeeList);
            _sagePayrollDataSet.EmployeeList.Rows.Add("", "<All>");
            uxBeginEmployee.DataSource = _sagePayrollDataSet.EmployeeList.OrderBy(r=>r.FullName).ToList();
            uxBeginEmployee.DisplayMember = "FullName";
            uxBeginEmployee.ValueMember = "Employee";
            uxEndEmployee.DataSource = _sagePayrollDataSet.EmployeeList.OrderBy(r => r.FullName).ToList(); ;
            uxEndEmployee.DisplayMember = "FullName";
            uxEndEmployee.ValueMember = "Employee";

            _departmentListTableAdapter.Fill(_sagePayrollDataSet.DepartmentList);
            _sagePayrollDataSet.DepartmentList.AddDepartmentListRow("", "<All>");
            uxDepartment.DataSource = _sagePayrollDataSet.DepartmentList.OrderBy(r => r.Department).ToList(); ;
            uxDepartment.DisplayMember = "Description";
            uxDepartment.ValueMember = "Department";

            uxPickBeginDate.Value = DateTime.Today;
            uxPickEndDate.Value = DateTime.Today;
        }

        void SubreportProcessingEventHandler(object sender, SubreportProcessingEventArgs e)
        {
            ReportDataSource RdsCheckSummary()
            {
                var checkHeader = e.Parameters["CheckHeader"].Values[0];
                DateTime? beginCheckDate = Convert.ToDateTime(e.Parameters["BeginCheckDate"].Values[0]);
                if (beginCheckDate == DateTime.MinValue)
                {
                    beginCheckDate = null;
                }
                DateTime? endCheckDate = Convert.ToDateTime(e.Parameters["EndCheckDate"].Values[0]);
                if (endCheckDate == DateTime.MinValue)
                {
                    endCheckDate = null;
                }
                var beginEmployee = e.Parameters["BeginEmployee"].Values[0];
                var endEmployee = e.Parameters["EndEmployee"].Values[0];
                var class1 = e.Parameters["Class1"].Values[0];
                var trialFlag = Convert.ToInt32(e.Parameters["TrialFlag"].Values[0]);

                // Get registry summary (null CheckHeader, null Class1)
                _ftspCheckSummaryTableAdapter.Fill(_sagePayrollDataSet.ftsp_CheckSummary, checkHeader, beginCheckDate, endCheckDate, beginEmployee, endEmployee, class1, trialFlag);

                return new ReportDataSource("checkSummaryDataSet", (DataTable)_sagePayrollDataSet.ftsp_CheckSummary);
            }

            ReportDataSource RdsEarnings()
            {
                var checkHeader = e.Parameters["CheckHeader"].Values[0];
                DateTime? beginCheckDate = Convert.ToDateTime(e.Parameters["BeginCheckDate"].Values[0]);
                if (beginCheckDate == DateTime.MinValue)
                {
                    beginCheckDate = null;
                }
                DateTime? endCheckDate = Convert.ToDateTime(e.Parameters["EndCheckDate"].Values[0]);
                if (endCheckDate == DateTime.MinValue)
                {
                    endCheckDate = null;
                }
                var beginEmployee = e.Parameters["BeginEmployee"].Values[0];
                var endEmployee = e.Parameters["EndEmployee"].Values[0];
                var class1 = e.Parameters["Class1"].Values[0];
                var includeZerosFlag = Convert.ToInt32(e.Parameters["IncludeZerosFlag"].Values[0]);
                var trialFlag = Convert.ToInt32(e.Parameters["TrialFlag"].Values[0]);

                // Get registry summary (null CheckHeader, null Class1)
                _ftspCheckEarningsDataTableAdapter.Fill(_sagePayrollDataSet.ftsp_CheckEarningsData, checkHeader,
                    beginCheckDate, endCheckDate, beginEmployee, endEmployee, class1, includeZerosFlag,
                    trialFlag);

                return new ReportDataSource("earningsDataSet", (DataTable)_sagePayrollDataSet.ftsp_CheckEarningsData);
            }

            ReportDataSource RdsTaxes()
            {
                var checkHeader = e.Parameters["CheckHeader"].Values[0];
                DateTime? beginCheckDate = Convert.ToDateTime(e.Parameters["BeginCheckDate"].Values[0]);
                if (beginCheckDate == DateTime.MinValue)
                {
                    beginCheckDate = null;
                }
                DateTime? endCheckDate = Convert.ToDateTime(e.Parameters["EndCheckDate"].Values[0]);
                if (endCheckDate == DateTime.MinValue)
                {
                    endCheckDate = null;
                }
                var beginEmployee = e.Parameters["BeginEmployee"].Values[0];
                var endEmployee = e.Parameters["EndEmployee"].Values[0];
                var class1 = e.Parameters["Class1"].Values[0];
                var includeZerosFlag = Convert.ToInt32(e.Parameters["IncludeZerosFlag"].Values[0]);
                var trialFlag = Convert.ToInt32(e.Parameters["TrialFlag"].Values[0]);

                // Get registry summary (null CheckHeader, null Class1)
                _ftspCheckTaxesDataTableAdapter.Fill(_sagePayrollDataSet.ftsp_CheckTaxesData, checkHeader,
                    beginCheckDate, endCheckDate, beginEmployee, endEmployee, class1, includeZerosFlag,
                    trialFlag);

                return new ReportDataSource("taxesDataSet", (DataTable)_sagePayrollDataSet.ftsp_CheckTaxesData);
            }

            ReportDataSource RdsDeductions()
            {
                var checkHeader = e.Parameters["CheckHeader"].Values[0];
                DateTime? beginCheckDate = Convert.ToDateTime(e.Parameters["BeginCheckDate"].Values[0]);
                if (beginCheckDate == DateTime.MinValue)
                {
                    beginCheckDate = null;
                }
                DateTime? endCheckDate = Convert.ToDateTime(e.Parameters["EndCheckDate"].Values[0]);
                if (endCheckDate == DateTime.MinValue)
                {
                    endCheckDate = null;
                }
                var beginEmployee = e.Parameters["BeginEmployee"].Values[0];
                var endEmployee = e.Parameters["EndEmployee"].Values[0];
                var class1 = e.Parameters["Class1"].Values[0];
                var includeZerosFlag = Convert.ToInt32(e.Parameters["IncludeZerosFlag"].Values[0]);
                var trialFlag = Convert.ToInt32(e.Parameters["TrialFlag"].Values[0]);

                // Get registry summary (null CheckHeader, null Class1)
                _ftspCheckDeductionsDataTableAdapter.Fill(_sagePayrollDataSet.ftsp_CheckDeductionsData, checkHeader,
                    beginCheckDate, endCheckDate, beginEmployee, endEmployee, class1, includeZerosFlag,
                    trialFlag);

                return new ReportDataSource("deductionsDataSet", (DataTable)_sagePayrollDataSet.ftsp_CheckDeductionsData);
            }

            switch (e.ReportPath)
            {
                case "RegisterSummary":
                    e.DataSources.Add(RdsCheckSummary());
                    break;
                case "CheckSummary":
                    e.DataSources.Add(RdsCheckSummary());
                    break;
                case "DepartmentSummary":
                    e.DataSources.Add(RdsCheckSummary());
                    break;
                case "Earnings":
                    e.DataSources.Add(RdsEarnings());
                    break;
                case "Taxes":
                    e.DataSources.Add(RdsTaxes());
                    break;
                case "Deductions":
                    e.DataSources.Add(RdsDeductions());
                    break;
                case "":
                    break;
            }
        }

        private void runReportButton_Click(object sender, EventArgs e)
        {
            RunReport();
            parameters.Visible = false;
            uxShowParameters.Visible = true;
        }

        private void RunReport()
        {
            //  Get args
            _argTrialFlag = uxTrialFlag.Checked ? 1 : 0;

            _argBeginCheckDate = uxNoBeginDate.Checked ? (DateTime?)null : uxPickBeginDate.Value;
            _argEndCheckDate = uxNoEndDate.Checked ? (DateTime?)null : uxPickEndDate.Value;

            _argBeginEmployee = uxBeginEmployee.SelectedValue as string;
            if (_argBeginEmployee == "")
            {
                _argBeginEmployee = null;
            }
            _argEndEmployee = uxEndEmployee.SelectedValue as string;
            if (_argEndEmployee == "")
            {
                _argEndEmployee = null;
            }

            _argClass1 = uxDepartment.SelectedValue as string;
            if (_argClass1 == "")
            {
                _argClass1 = null;
            }

            if (uxNameSort.Checked)
            {
                _argSort = "NAME";
            }
            else if (uxNumberSort.Checked)
            {
                _argSort = "NUMBER";
            }
            else _argSort = null;

            _ftspCheckListTableAdapter.Fill(_sagePayrollDataSet.ftsp_CheckList, _argCheckNumber, _argBeginCheckDate,
                _argEndCheckDate, _argBeginEmployee, _argEndEmployee, _argClass1, _argTrialFlag, _argSort);

            // Create report data source
            var dsCheckList = new ReportDataSource("CheckList", (DataTable)_sagePayrollDataSet.ftsp_CheckList);
            reportViewer1.LocalReport.DataSources.Clear();
            reportViewer1.LocalReport.DataSources.Add(dsCheckList);

            // Create report parameter
            var rpTransNumber = new ReportParameter("TransNumber", (string)null);
            var rpBeginCheckDate = _argBeginCheckDate == null
                ? new ReportParameter("BeginCheckDate", DateTime.MinValue.ToShortDateString())
                : new ReportParameter("BeginCheckDate", _argBeginCheckDate?.ToShortDateString());
            var rpEndCheckDate = _argEndCheckDate == null
                ? new ReportParameter("EndCheckDate", DateTime.MaxValue.ToShortDateString())
                : new ReportParameter("EndCheckDate", _argEndCheckDate?.ToShortDateString());
            var rpBeginEmployee = new ReportParameter("BeginEmployee", _argBeginEmployee);
            var rpEndEmployee = new ReportParameter("EndEmployee", _argEndEmployee);
            var rpClass1 = new ReportParameter("Class1", _argClass1);
            var rpTrialFlag = new ReportParameter("TrialFlag", _argTrialFlag.ToString());

            // Set the report parameter
            reportViewer1.LocalReport.SetParameters(new ReportParameter[] { rpTransNumber, rpBeginCheckDate, rpEndCheckDate, rpBeginEmployee, rpEndEmployee, rpClass1, rpTrialFlag });

            // Refresh
            reportViewer1.RefreshReport();
        }

        private void uxShowParameters_Click(object sender, EventArgs e)
        {
            parameters.Visible = true;
            uxShowParameters.Visible = false;
        }

        private void uxNoBeginDate_CheckedChanged(object sender, EventArgs e)
        {
            uxPickBeginDate.CustomFormat = uxNoBeginDate.Checked ? "'No Begin Date'" : "MM/dd/yyyy";
        }

        private void uxPickBeginDate_Enter(object sender, EventArgs e)
        {
            uxNoBeginDate.Checked = false;
            uxPickBeginDate.CustomFormat = "MM/dd/yyyy";
        }

        private void uxNoEndDate_CheckedChanged(object sender, EventArgs e)
        {
            uxPickEndDate.CustomFormat = uxNoEndDate.Checked ? "'No Begin Date'" : "MM/dd/yyyy";
        }
        
        private void uxPickEndDate_Enter(object sender, EventArgs e)
        {
            uxNoEndDate.Checked = false;
            uxPickEndDate.CustomFormat = "MM/dd/yyyy";
        }

        private void uxNoBeginEmployee_CheckedChanged(object sender, EventArgs e)
        {
            if (uxNoBeginEmployee.Checked)
            {
                uxBeginEmployee.SelectedIndex = 0;
            }
        }

        private void uxNoEndEmployee_CheckedChanged(object sender, EventArgs e)
        {
            if (uxNoEndEmployee.Checked)
            {
                uxEndEmployee.SelectedIndex = 0;
            }
        }

        private void uxBeginEmployee_SelectedIndexChanged(object sender, EventArgs e)
        {
            uxNoBeginEmployee.Checked = uxBeginEmployee.SelectedIndex == 0;
        }

        private void uxEndEmployee_SelectedIndexChanged(object sender, EventArgs e)
        {
            uxNoEndEmployee.Checked = uxEndEmployee.SelectedIndex == 0;
        }
    }
}
