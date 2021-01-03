
namespace PayrollRegister
{
    partial class PayrollRegisterForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

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
            this.wholeScreen = new System.Windows.Forms.TableLayoutPanel();
            this.reportViewer1 = new Microsoft.Reporting.WinForms.ReportViewer();
            this.header = new System.Windows.Forms.TableLayoutPanel();
            this.parameters = new System.Windows.Forms.TableLayoutPanel();
            this.uxDepartment = new System.Windows.Forms.ComboBox();
            this.label9 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.uxTrialFlag = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.tableLayoutPanel5 = new System.Windows.Forms.TableLayoutPanel();
            this.uxPickEndDate = new System.Windows.Forms.DateTimePicker();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.uxPickBeginDate = new System.Windows.Forms.DateTimePicker();
            this.uxNoBeginDate = new System.Windows.Forms.CheckBox();
            this.uxNoEndDate = new System.Windows.Forms.CheckBox();
            this.tableLayoutPanel6 = new System.Windows.Forms.TableLayoutPanel();
            this.uxNoEndEmployee = new System.Windows.Forms.CheckBox();
            this.uxNoBeginEmployee = new System.Windows.Forms.CheckBox();
            this.uxEndEmployee = new System.Windows.Forms.ComboBox();
            this.label7 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.uxBeginEmployee = new System.Windows.Forms.ComboBox();
            this.uxRunReport = new System.Windows.Forms.Button();
            this.headerHeader = new System.Windows.Forms.TableLayoutPanel();
            this.label1 = new System.Windows.Forms.Label();
            this.uxShowParameters = new System.Windows.Forms.Button();
            this.wholeScreen.SuspendLayout();
            this.header.SuspendLayout();
            this.parameters.SuspendLayout();
            this.tableLayoutPanel5.SuspendLayout();
            this.tableLayoutPanel6.SuspendLayout();
            this.headerHeader.SuspendLayout();
            this.SuspendLayout();
            // 
            // wholeScreen
            // 
            this.wholeScreen.BackColor = System.Drawing.Color.Black;
            this.wholeScreen.ColumnCount = 1;
            this.wholeScreen.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.wholeScreen.Controls.Add(this.reportViewer1, 0, 1);
            this.wholeScreen.Controls.Add(this.header, 0, 0);
            this.wholeScreen.Dock = System.Windows.Forms.DockStyle.Fill;
            this.wholeScreen.Location = new System.Drawing.Point(0, 0);
            this.wholeScreen.Name = "wholeScreen";
            this.wholeScreen.RowCount = 2;
            this.wholeScreen.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.wholeScreen.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.wholeScreen.Size = new System.Drawing.Size(1009, 794);
            this.wholeScreen.TabIndex = 0;
            // 
            // reportViewer1
            // 
            this.reportViewer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.reportViewer1.LocalReport.ReportEmbeddedResource = "PayrollRegister.Reports.PayrollRegister.rdlc";
            this.reportViewer1.Location = new System.Drawing.Point(3, 460);
            this.reportViewer1.Name = "reportViewer1";
            this.reportViewer1.ServerReport.BearerToken = null;
            this.reportViewer1.Size = new System.Drawing.Size(1003, 331);
            this.reportViewer1.TabIndex = 4;
            // 
            // header
            // 
            this.header.AutoSize = true;
            this.header.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.header.ColumnCount = 1;
            this.header.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.header.Controls.Add(this.parameters, 0, 1);
            this.header.Controls.Add(this.headerHeader, 0, 0);
            this.header.Dock = System.Windows.Forms.DockStyle.Fill;
            this.header.Location = new System.Drawing.Point(3, 3);
            this.header.Name = "header";
            this.header.RowCount = 2;
            this.header.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.header.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.header.Size = new System.Drawing.Size(1003, 451);
            this.header.TabIndex = 0;
            // 
            // parameters
            // 
            this.parameters.AutoSize = true;
            this.parameters.BackColor = System.Drawing.Color.MidnightBlue;
            this.parameters.CellBorderStyle = System.Windows.Forms.TableLayoutPanelCellBorderStyle.Single;
            this.parameters.ColumnCount = 2;
            this.parameters.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 73.69669F));
            this.parameters.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 351F));
            this.parameters.Controls.Add(this.uxDepartment, 1, 3);
            this.parameters.Controls.Add(this.label9, 0, 3);
            this.parameters.Controls.Add(this.label6, 0, 2);
            this.parameters.Controls.Add(this.label2, 0, 0);
            this.parameters.Controls.Add(this.uxTrialFlag, 1, 0);
            this.parameters.Controls.Add(this.label3, 0, 1);
            this.parameters.Controls.Add(this.tableLayoutPanel5, 1, 1);
            this.parameters.Controls.Add(this.tableLayoutPanel6, 1, 2);
            this.parameters.Controls.Add(this.uxRunReport, 1, 4);
            this.parameters.Dock = System.Windows.Forms.DockStyle.Fill;
            this.parameters.Location = new System.Drawing.Point(3, 46);
            this.parameters.Name = "parameters";
            this.parameters.RowCount = 5;
            this.parameters.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.parameters.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.parameters.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.parameters.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.parameters.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.parameters.Size = new System.Drawing.Size(997, 402);
            this.parameters.TabIndex = 0;
            // 
            // uxDepartment
            // 
            this.uxDepartment.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxDepartment.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxDepartment.FormattingEnabled = true;
            this.uxDepartment.Location = new System.Drawing.Point(842, 329);
            this.uxDepartment.Name = "uxDepartment";
            this.uxDepartment.Size = new System.Drawing.Size(151, 24);
            this.uxDepartment.TabIndex = 10;
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.Location = new System.Drawing.Point(4, 326);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(135, 17);
            this.label9.TabIndex = 6;
            this.label9.Text = "Select a department";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(4, 176);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(168, 17);
            this.label6.TabIndex = 4;
            this.label6.Text = "Enter an employee range";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(4, 1);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(450, 17);
            this.label2.TabIndex = 0;
            this.label2.Text = "Choose between a \"Trial Payroll Register\" or \"Posted Payroll Register\"";
            // 
            // uxTrialFlag
            // 
            this.uxTrialFlag.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxTrialFlag.AutoSize = true;
            this.uxTrialFlag.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxTrialFlag.Location = new System.Drawing.Point(881, 4);
            this.uxTrialFlag.Name = "uxTrialFlag";
            this.uxTrialFlag.Size = new System.Drawing.Size(112, 21);
            this.uxTrialFlag.TabIndex = 1;
            this.uxTrialFlag.Text = "Trial Register\r\n";
            this.uxTrialFlag.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(4, 29);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(168, 17);
            this.label3.TabIndex = 2;
            this.label3.Text = "Enter a check date range";
            // 
            // tableLayoutPanel5
            // 
            this.tableLayoutPanel5.AutoSize = true;
            this.tableLayoutPanel5.ColumnCount = 1;
            this.tableLayoutPanel5.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel5.Controls.Add(this.uxPickEndDate, 0, 5);
            this.tableLayoutPanel5.Controls.Add(this.label5, 0, 3);
            this.tableLayoutPanel5.Controls.Add(this.label4, 0, 0);
            this.tableLayoutPanel5.Controls.Add(this.uxPickBeginDate, 0, 2);
            this.tableLayoutPanel5.Controls.Add(this.uxNoBeginDate, 0, 1);
            this.tableLayoutPanel5.Controls.Add(this.uxNoEndDate, 0, 4);
            this.tableLayoutPanel5.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel5.Location = new System.Drawing.Point(645, 29);
            this.tableLayoutPanel5.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel5.Name = "tableLayoutPanel5";
            this.tableLayoutPanel5.RowCount = 6;
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel5.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel5.Size = new System.Drawing.Size(351, 146);
            this.tableLayoutPanel5.TabIndex = 3;
            // 
            // uxPickEndDate
            // 
            this.uxPickEndDate.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxPickEndDate.CustomFormat = "\'No End Date\'";
            this.uxPickEndDate.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxPickEndDate.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.uxPickEndDate.Location = new System.Drawing.Point(197, 120);
            this.uxPickEndDate.Name = "uxPickEndDate";
            this.uxPickEndDate.Size = new System.Drawing.Size(151, 23);
            this.uxPickEndDate.TabIndex = 5;
            this.uxPickEndDate.Value = new System.DateTime(2001, 1, 1, 0, 0, 0, 0);
            this.uxPickEndDate.Enter += new System.EventHandler(this.uxPickEndDate_Enter);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(3, 73);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(110, 17);
            this.label5.TabIndex = 5;
            this.label5.Text = "End Check Date";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(3, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(121, 17);
            this.label4.TabIndex = 3;
            this.label4.Text = "Begin Check Date";
            // 
            // uxPickBeginDate
            // 
            this.uxPickBeginDate.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxPickBeginDate.CustomFormat = "\'No Begin Date\'";
            this.uxPickBeginDate.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxPickBeginDate.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.uxPickBeginDate.Location = new System.Drawing.Point(197, 47);
            this.uxPickBeginDate.Name = "uxPickBeginDate";
            this.uxPickBeginDate.Size = new System.Drawing.Size(151, 23);
            this.uxPickBeginDate.TabIndex = 3;
            this.uxPickBeginDate.Value = new System.DateTime(2001, 1, 1, 0, 0, 0, 0);
            this.uxPickBeginDate.Enter += new System.EventHandler(this.uxPickBeginDate_Enter);
            // 
            // uxNoBeginDate
            // 
            this.uxNoBeginDate.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxNoBeginDate.AutoSize = true;
            this.uxNoBeginDate.Checked = true;
            this.uxNoBeginDate.CheckState = System.Windows.Forms.CheckState.Checked;
            this.uxNoBeginDate.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxNoBeginDate.Location = new System.Drawing.Point(229, 20);
            this.uxNoBeginDate.Name = "uxNoBeginDate";
            this.uxNoBeginDate.Size = new System.Drawing.Size(119, 21);
            this.uxNoBeginDate.TabIndex = 2;
            this.uxNoBeginDate.Text = "No Begin Date";
            this.uxNoBeginDate.UseVisualStyleBackColor = true;
            this.uxNoBeginDate.CheckedChanged += new System.EventHandler(this.uxNoBeginDate_CheckedChanged);
            // 
            // uxNoEndDate
            // 
            this.uxNoEndDate.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxNoEndDate.AutoSize = true;
            this.uxNoEndDate.Checked = true;
            this.uxNoEndDate.CheckState = System.Windows.Forms.CheckState.Checked;
            this.uxNoEndDate.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxNoEndDate.Location = new System.Drawing.Point(240, 93);
            this.uxNoEndDate.Name = "uxNoEndDate";
            this.uxNoEndDate.Size = new System.Drawing.Size(108, 21);
            this.uxNoEndDate.TabIndex = 4;
            this.uxNoEndDate.Text = "No End Date";
            this.uxNoEndDate.UseVisualStyleBackColor = true;
            this.uxNoEndDate.CheckedChanged += new System.EventHandler(this.uxNoEndDate_CheckedChanged);
            // 
            // tableLayoutPanel6
            // 
            this.tableLayoutPanel6.AutoSize = true;
            this.tableLayoutPanel6.ColumnCount = 1;
            this.tableLayoutPanel6.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel6.Controls.Add(this.uxNoEndEmployee, 0, 4);
            this.tableLayoutPanel6.Controls.Add(this.uxNoBeginEmployee, 0, 1);
            this.tableLayoutPanel6.Controls.Add(this.uxEndEmployee, 0, 4);
            this.tableLayoutPanel6.Controls.Add(this.label7, 0, 3);
            this.tableLayoutPanel6.Controls.Add(this.label8, 0, 0);
            this.tableLayoutPanel6.Controls.Add(this.uxBeginEmployee, 0, 2);
            this.tableLayoutPanel6.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel6.Location = new System.Drawing.Point(645, 176);
            this.tableLayoutPanel6.Margin = new System.Windows.Forms.Padding(0);
            this.tableLayoutPanel6.Name = "tableLayoutPanel6";
            this.tableLayoutPanel6.RowCount = 5;
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel6.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.tableLayoutPanel6.Size = new System.Drawing.Size(351, 149);
            this.tableLayoutPanel6.TabIndex = 5;
            // 
            // uxNoEndEmployee
            // 
            this.uxNoEndEmployee.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxNoEndEmployee.AutoSize = true;
            this.uxNoEndEmployee.Checked = true;
            this.uxNoEndEmployee.CheckState = System.Windows.Forms.CheckState.Checked;
            this.uxNoEndEmployee.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxNoEndEmployee.Location = new System.Drawing.Point(208, 94);
            this.uxNoEndEmployee.Name = "uxNoEndEmployee";
            this.uxNoEndEmployee.Size = new System.Drawing.Size(140, 21);
            this.uxNoEndEmployee.TabIndex = 8;
            this.uxNoEndEmployee.Text = "No End Employee";
            this.uxNoEndEmployee.UseVisualStyleBackColor = true;
            this.uxNoEndEmployee.CheckedChanged += new System.EventHandler(this.uxNoEndEmployee_CheckedChanged);
            // 
            // uxNoBeginEmployee
            // 
            this.uxNoBeginEmployee.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxNoBeginEmployee.AutoSize = true;
            this.uxNoBeginEmployee.Checked = true;
            this.uxNoBeginEmployee.CheckState = System.Windows.Forms.CheckState.Checked;
            this.uxNoBeginEmployee.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxNoBeginEmployee.Location = new System.Drawing.Point(197, 20);
            this.uxNoBeginEmployee.Name = "uxNoBeginEmployee";
            this.uxNoBeginEmployee.Size = new System.Drawing.Size(151, 21);
            this.uxNoBeginEmployee.TabIndex = 6;
            this.uxNoBeginEmployee.Text = "No Begin Employee";
            this.uxNoBeginEmployee.UseVisualStyleBackColor = true;
            this.uxNoBeginEmployee.CheckedChanged += new System.EventHandler(this.uxNoBeginEmployee_CheckedChanged);
            // 
            // uxEndEmployee
            // 
            this.uxEndEmployee.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxEndEmployee.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxEndEmployee.FormattingEnabled = true;
            this.uxEndEmployee.Location = new System.Drawing.Point(197, 121);
            this.uxEndEmployee.Name = "uxEndEmployee";
            this.uxEndEmployee.Size = new System.Drawing.Size(151, 24);
            this.uxEndEmployee.TabIndex = 9;
            this.uxEndEmployee.SelectedIndexChanged += new System.EventHandler(this.uxEndEmployee_SelectedIndexChanged);
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(3, 74);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(99, 17);
            this.label7.TabIndex = 5;
            this.label7.Text = "End Employee";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.Location = new System.Drawing.Point(3, 0);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(110, 17);
            this.label8.TabIndex = 3;
            this.label8.Text = "Begin Employee";
            // 
            // uxBeginEmployee
            // 
            this.uxBeginEmployee.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxBeginEmployee.Font = new System.Drawing.Font("Microsoft Sans Serif", 10F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.uxBeginEmployee.FormattingEnabled = true;
            this.uxBeginEmployee.Location = new System.Drawing.Point(197, 47);
            this.uxBeginEmployee.Name = "uxBeginEmployee";
            this.uxBeginEmployee.Size = new System.Drawing.Size(151, 24);
            this.uxBeginEmployee.TabIndex = 7;
            this.uxBeginEmployee.SelectedIndexChanged += new System.EventHandler(this.uxBeginEmployee_SelectedIndexChanged);
            // 
            // uxRunReport
            // 
            this.uxRunReport.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxRunReport.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.uxRunReport.Location = new System.Drawing.Point(918, 368);
            this.uxRunReport.Margin = new System.Windows.Forms.Padding(3, 10, 3, 10);
            this.uxRunReport.Name = "uxRunReport";
            this.uxRunReport.Size = new System.Drawing.Size(75, 23);
            this.uxRunReport.TabIndex = 11;
            this.uxRunReport.Text = "Run Report";
            this.uxRunReport.UseVisualStyleBackColor = true;
            this.uxRunReport.Click += new System.EventHandler(this.runReportButton_Click);
            // 
            // headerHeader
            // 
            this.headerHeader.AutoSize = true;
            this.headerHeader.ColumnCount = 2;
            this.headerHeader.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.headerHeader.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.headerHeader.Controls.Add(this.label1, 0, 0);
            this.headerHeader.Controls.Add(this.uxShowParameters, 1, 0);
            this.headerHeader.Dock = System.Windows.Forms.DockStyle.Fill;
            this.headerHeader.Location = new System.Drawing.Point(3, 3);
            this.headerHeader.Name = "headerHeader";
            this.headerHeader.RowCount = 1;
            this.headerHeader.RowStyles.Add(new System.Windows.Forms.RowStyle());
            this.headerHeader.Size = new System.Drawing.Size(997, 37);
            this.headerHeader.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 24F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(3, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(492, 37);
            this.label1.TabIndex = 0;
            this.label1.Text = "Armada Payroll Register";
            // 
            // uxShowParameters
            // 
            this.uxShowParameters.Anchor = System.Windows.Forms.AnchorStyles.Right;
            this.uxShowParameters.AutoSize = true;
            this.uxShowParameters.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.uxShowParameters.Location = new System.Drawing.Point(892, 6);
            this.uxShowParameters.Name = "uxShowParameters";
            this.uxShowParameters.Size = new System.Drawing.Size(102, 25);
            this.uxShowParameters.TabIndex = 1;
            this.uxShowParameters.Text = "Show Parameters";
            this.uxShowParameters.UseVisualStyleBackColor = true;
            this.uxShowParameters.Visible = false;
            this.uxShowParameters.Click += new System.EventHandler(this.uxShowParameters_Click);
            // 
            // PayrollRegisterForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.ClientSize = new System.Drawing.Size(1009, 794);
            this.Controls.Add(this.wholeScreen);
            this.ForeColor = System.Drawing.Color.White;
            this.Name = "PayrollRegisterForm";
            this.Text = "Payroll Register";
            this.Load += new System.EventHandler(this.PayrollRegisterForm_Load);
            this.wholeScreen.ResumeLayout(false);
            this.wholeScreen.PerformLayout();
            this.header.ResumeLayout(false);
            this.header.PerformLayout();
            this.parameters.ResumeLayout(false);
            this.parameters.PerformLayout();
            this.tableLayoutPanel5.ResumeLayout(false);
            this.tableLayoutPanel5.PerformLayout();
            this.tableLayoutPanel6.ResumeLayout(false);
            this.tableLayoutPanel6.PerformLayout();
            this.headerHeader.ResumeLayout(false);
            this.headerHeader.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.TableLayoutPanel wholeScreen;
        private Microsoft.Reporting.WinForms.ReportViewer reportViewer1;
        private System.Windows.Forms.TableLayoutPanel header;
        private System.Windows.Forms.TableLayoutPanel parameters;
        private System.Windows.Forms.TableLayoutPanel headerHeader;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button uxShowParameters;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.CheckBox uxTrialFlag;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel5;
        private System.Windows.Forms.DateTimePicker uxPickEndDate;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.DateTimePicker uxPickBeginDate;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel6;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.ComboBox uxDepartment;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.ComboBox uxEndEmployee;
        private System.Windows.Forms.ComboBox uxBeginEmployee;
        private System.Windows.Forms.Button uxRunReport;
        private System.Windows.Forms.CheckBox uxNoBeginDate;
        private System.Windows.Forms.CheckBox uxNoEndDate;
        private System.Windows.Forms.CheckBox uxNoEndEmployee;
        private System.Windows.Forms.CheckBox uxNoBeginEmployee;
    }
}