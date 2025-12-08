import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/components/EmployeesTable.dart';
import 'package:hr_management/components/ModifyRetireeDialog.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/services/pdf_service.dart';
import 'package:popover/popover.dart';

class RetirementTab extends StatefulWidget {
  const RetirementTab({super.key});

  @override
  State<RetirementTab> createState() => _RetirementTabState();
}

class _RetirementTabState extends State<RetirementTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _allEmployees = [];
  List<Employee> _filteredEmployees = [];
  Employee? selectedEmployee;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
    _searchController.addListener(_filterEmployees);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchEmployees() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch all employees including non-active ones if the API supports it
      // The user requested to fetch from /api/pm/employees which we know returns all (or usually active + others)
      // and filter by status != ACTIVE
      final allEmployees = await EmployeeService.getAllEmployeesTest();
      print('Fetched ${allEmployees.length} employees: ${allEmployees.map((e) => "${e.fullName} (${e.status})").join(", ")}');
      
      // Filter employees where status is NOT ACTIVE
      // Assuming 'ACTIVE' is mapped to Status.employed. 
      // If the API returns string "ACTIVE", we might need to check how it's parsed.
      // Based on Employee.dart, status is an enum. Let's assume employed == ACTIVE.
      
      final retiredOrToRetireEmployees = allEmployees.where((employee) {
        return employee.status == Status.retired;
      }).toList();

      setState(() {
        _allEmployees = retiredOrToRetireEmployees;
        _filteredEmployees = retiredOrToRetireEmployees;
        _isLoading = false;
      });
      
      print('Found ${retiredOrToRetireEmployees.length} retired/inactive employees');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _allEmployees = [];
        _filteredEmployees = [];
      });
      print('Error fetching employees for retirement: $e');
    }
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredEmployees = _allEmployees;
      } else {
        _filteredEmployees = _allEmployees.where((employee) {
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

    try {
      await PdfService.generateEmployeeListPDF(_filteredEmployees, title: 'Retired Employees');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('List exported successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _extractWorkCertificate(Employee employee) async {
    try {
      await PdfService.generateWorkCertificatePDF(employee);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Work certificate generated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating certificate: $e'),
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 80),
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
        const Text(
          'Retired',
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff289581),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: _fetchEmployees,
          icon: Icon(
            Icons.refresh,
            color: Color(0xff289581),
          ),
          tooltip: 'Refresh data',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 45,
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

  Widget _buildTableSection() {
    if (_isLoading) {
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
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff289581)),
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
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
                Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  'Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _fetchEmployees,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff289581),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                  'No retired employees found',
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
          title: 'RetirementTab',
          employees: _filteredEmployees,
          onEmployeePressed: _showEmployeeActions,
        ),
      ),
    );
  }

  void _showEmployeeActions(Employee employee, BuildContext buttonContext) {
    setState(() {
      selectedEmployee = employee;
    });
    // Increased height to accommodate the certificate button
    double popHeight = 85; 
    
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
            InkWell(
              onTap: () {
                Navigator.of(buttonContext).pop();
                _extractWorkCertificate(employee);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Extract Work Certificate",
                  style: TextStyle(color: Color(0xff289581), fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            InkWell(
              onTap: () {
                Navigator.of(buttonContext).pop();
                showDialog(
                  context: context,
                  builder: (context) => ModifyRetireeDialog(employee: employee),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                alignment: Alignment.center,
                child: const Text("Modify Retiree", style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}