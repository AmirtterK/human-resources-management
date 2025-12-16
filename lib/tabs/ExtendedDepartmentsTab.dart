import 'package:flutter/material.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/components/EmployeesTable.dart';
import 'package:hr_management/components/ModifyEmployeeDialog.dart';
import 'package:hr_management/components/AddEmployeeToDepartmentDialog.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/services/pdf_service.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:popover/popover.dart';

/// Detailed view of a specific Department, showing its employees.
class ExtendedDepartmentsTab extends StatefulWidget {
  const ExtendedDepartmentsTab({
    super.key,
    required this.department,
    required this.onReturn,
  });
  final VoidCallback onReturn;
  final Department? department;
  @override
  State<ExtendedDepartmentsTab> createState() => _ExtendedDepartmentsTabState();
}

class _ExtendedDepartmentsTabState extends State<ExtendedDepartmentsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _filteredEmployees = [];
  Employee? selectedEmployee;

  @override
  void initState() {
    super.initState();
    _filteredEmployees = widget.department?.emloyees ?? [];
    print('ExtendedDepartmentsTab initialized with ${_filteredEmployees.length} employees for department: ${widget.department?.name}');
    _searchController.addListener(_filterEmployees);
    _refreshDepartmentEmployees();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    final sourceList = widget.department?.emloyees ?? [];
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = sourceList;
      } else {
        _filteredEmployees = sourceList.where((employee) {
          final nameMatch = employee.fullName.toLowerCase().contains(query);
          final idMatch = employee.id.toLowerCase().contains(query);
          return nameMatch || idMatch;
        }).toList();
      }
    });
  }

  Future<void> _extractEmployeeList() async {
    if (_filteredEmployees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No employees to export'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                _performExport('pdf');
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart, color: Colors.green),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                _performExport('csv');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performExport(String format) async {
    try {
      final departmentName = widget.department?.name ?? 'Department';
      
      if (format == 'pdf') {
        await PdfService.generateEmployeeListPDF(_filteredEmployees, title: departmentName);
      } else {
        await PdfService.generateEmployeeListCSV(_filteredEmployees, title: departmentName);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Employee list exported as ${format.toUpperCase()}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting ${format.toUpperCase()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          padding: EdgeInsets.only(left: 40),
          child: Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: widget.onReturn,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Return'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xffEF5350),
                side: const BorderSide(color: Color(0xffEF5350)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 20,
                    ),
                    child: _buildHeaderSection(),
                  ),
                  const SizedBox(height: 24),
                  _buildTableSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        Text(
          "${widget.department?.name} ",
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff289581),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: _refreshDepartmentEmployees,
          icon: const Icon(
            Icons.refresh,
            color: Color(0xff289581),
          ),
          tooltip: 'Refresh employees',
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            height: 40, // Resized to 40
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by ID or Names',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Extract List button - available for all users
        OutlinedButton(
          onPressed: _extractEmployeeList,
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xff289581),
            side: const BorderSide(color: Color(0xff289581)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Extract List'),
        ),
        // Add Employee button - only for PM users
        // Add Employee button removed as requested
        if (user == User.agent) ...{
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff289581),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.expand_more_rounded, size: 30),
              ],
            ),
          ),
        },
      ],
    );
  }

  Future<void> _refreshDepartmentEmployees() async {
    final depId = int.tryParse(widget.department?.id ?? '');
    try {
      final all = await EmployeeService.getEmployees();
      final filtered = all.where((e) => e.departmentId == depId || (e.department.toLowerCase() == (widget.department?.name.toLowerCase() ?? ''))).toList();
      setState(() {
        _filteredEmployees = filtered;
      });
    } catch (e) {
      print('Failed to refresh department employees: $e');
    }
  }

  Widget _buildTableSection() {
    if (_filteredEmployees.isEmpty) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No employees found in this department',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: EmployeesTable(
          title: 'ExtendedDepartementsTab',
          employees: _filteredEmployees,
          onEmployeePressed: null,
        ),
      ),
    );
  }

  void _showEmployeeActions(Employee employee, BuildContext buttonContext) {
    setState(() {
      selectedEmployee = employee;
    });
    double popHeight = user == User.agent ? 40 : 75;
    showPopover(
      context: buttonContext,
      backgroundColor: Colors.white,
      width: 200,
      height: popHeight,
      arrowWidth: 0,
      arrowHeight: 0,
      direction: PopoverDirection.left,
      bodyBuilder: (context) => Material(
        color: Colors.white,
        child: Column(
          children: [
            if (user == User.pm) ...{
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ModifyEmployeeDialog(employee: employee),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Modify",
                    style: TextStyle(color: Color(0xff0A866F), fontSize: 14),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Ink(
                color: employee.status == Status.employed
                    ? Colors.white
                    : Colors.grey.shade200,
                child: InkWell(
                  onTap: employee.status == Status.employed ? () {} : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "To Retirement",
                      style: TextStyle(
                        color: employee.status == Status.employed
                            ? Colors.red
                            : Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            } else if (user == User.agent) ...{
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Obtain Work Certificate",
                    style: TextStyle(color: Color(0xff0A866F), fontSize: 14),
                  ),
                ),
              ),
            } else ...{
              InkWell(
                onTap: () {},
                child: Container(
                  color: Color(0xffEEFFFA),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Accept Retirement",
                    style: TextStyle(color: Color(0xff0A866F), fontSize: 14),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              InkWell(
                onTap: () {},
                child: Container(
                  color: Color(0xffFFF8F8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Deny Retirement",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}
