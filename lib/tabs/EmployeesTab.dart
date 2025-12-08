import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/components/AddEmployeeDialog.dart';
import 'package:hr_management/components/EmployeesTable.dart';
import 'package:hr_management/components/ModifyEmployeeDialog.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/services/employee_service.dart';
import 'package:hr_management/services/pdf_service.dart';
import 'package:popover/popover.dart';

class EmployeesTab extends StatefulWidget {
  const EmployeesTab({super.key});

  @override
  State<EmployeesTab> createState() => _EmployeesTabState();
}

class _EmployeesTabState extends State<EmployeesTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Employee> _allEmployees = [];
  List<Employee> _filteredEmployees = [];
  Employee? selectedEmployee;
  bool _isLoading = true;
  String? _errorMessage;
  
  // Filter state
  String? _selectedDepartment;
  String? _selectedRank;
  Status? _selectedStatus;

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
      final fetchedEmployees = await EmployeeService.getEmployees();
      setState(() {
        _allEmployees = fetchedEmployees;
        _filteredEmployees = fetchedEmployees;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        // Do not fallback to local data
        _allEmployees = [];
        _filteredEmployees = [];
      });
    }
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      var filtered = _allEmployees;

      // Apply search query
      if (query.isNotEmpty) {
        filtered = filtered.where((employee) {
          final nameMatch = employee.fullName.toLowerCase().contains(query);
          final idMatch = employee.id.toLowerCase().contains(query);
          return nameMatch || idMatch;
        }).toList();
      }

      // Apply department filter
      if (_selectedDepartment != null && _selectedDepartment!.isNotEmpty) {
        filtered = filtered.where((employee) {
          return employee.department.toLowerCase() == _selectedDepartment!.toLowerCase();
        }).toList();
      }

      // Apply rank filter
      if (_selectedRank != null && _selectedRank!.isNotEmpty) {
        filtered = filtered.where((employee) {
          return employee.rank == _selectedRank;
        }).toList();
      }

      // Apply status filter
      if (_selectedStatus != null) {
        filtered = filtered.where((employee) {
          return employee.status == _selectedStatus;
        }).toList();
      }

      _filteredEmployees = filtered;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedDepartment = null;
      _selectedRank = null;
      _selectedStatus = null;
      _filterEmployees();
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
      await PdfService.generateEmployeeListPDF(_filteredEmployees, title: 'Employees');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Employee list exported successfully'),
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

  Future<void> _requestRetirement(Employee employee) async {
    try {
      final nameParts = employee.fullName.trim().split(RegExp(r'\\s+'));
      final firstName = employee.firstName ?? (nameParts.isNotEmpty ? nameParts.first : '');
      final lastName = employee.lastName ?? (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');

      String? dateOfBirth;
      if (employee.dateOfBirth != null) {
        final dob = employee.dateOfBirth!;
        dateOfBirth =
            '${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}';
      }

      final Map<String, dynamic> payload = {
        'firstName': firstName,
        'lastName': lastName,
        'dateOfBirth': dateOfBirth,
        'address': employee.address ?? '',
        'originalRank': employee.rank,
        'departmentId': employee.departmentId ?? 0,
        'specialityId': employee.specialityId ?? 0,
        'step': employee.step,
        'reference': employee.reference ?? '',
        'retireRequest': true,
      };
      payload.removeWhere((k, v) => v == null);

      final result = await EmployeeService.modifyEmployee(employee.id, payload);

      if (!mounted) return;
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retirement requested successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _fetchEmployees(); // Refresh list
      } else {
        throw Exception(result['message'] ?? 'Unknown error');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error requesting retirement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Employees'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            // Get unique values for filters
            final departments = _allEmployees.map((e) => e.department).where((d) => d.isNotEmpty).toSet().toList()..sort();
            final ranks = _allEmployees.map((e) => e.rank).where((r) => r.isNotEmpty).toSet().toList()..sort();

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Department filter
                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Departments'),
                      ),
                      ...departments.map((dept) => DropdownMenuItem<String>(
                        value: dept,
                        child: Text(dept),
                      )),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedDepartment = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Rank filter
                  DropdownButtonFormField<String>(
                    value: _selectedRank,
                    decoration: const InputDecoration(
                      labelText: 'Rank',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All Ranks'),
                      ),
                      ...ranks.map((rank) => DropdownMenuItem<String>(
                        value: rank,
                        child: Text(rank),
                      )),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedRank = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Status filter
                  DropdownButtonFormField<Status>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      const DropdownMenuItem<Status>(
                        value: null,
                        child: Text('All Statuses'),
                      ),
                      ...Status.values.map((status) => DropdownMenuItem<Status>(
                        value: status,
                        child: Text(status.name.toUpperCase()),
                      )),
                    ],
                    onChanged: (value) {
                      setDialogState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearFilters();
              Navigator.of(context).pop();
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _filterEmployees();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
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
          'Employees',
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xff289581),
          ),
        ),
        const SizedBox(width: 12),
        // Refresh button
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
        if (user != User.pm) ...{
          // Extract List button - available for non-PM users
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
        },
        // Add Employee button - only for PM users
        if (user == User.pm) ...{
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AddEmployeeDialog(
                  onEmployeeAdded: _fetchEmployees,
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xff289581),
              side: const BorderSide(color: Color(0xff289581)),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Employee',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(width: 4),
                Icon(Icons.add),
              ],
            ),
          ),
        },
        // Filter button - available for all users
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _showFilterDialog,
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
      ],
    );
  }

  Widget _buildTableSection() {
    if (_isLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xff289581),
          ),
        ),
      );
    }

    if (_errorMessage != null && _allEmployees.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text(
                'Failed to load employees',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _fetchEmployees,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredEmployees.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No employees found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
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
          title: 'EmployeesTab',
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
                    style: TextStyle(color: Color(0xff289581), fontSize: 14),
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              Ink(
                color: (employee.status == Status.employed && employee.retireRequest != true)
                    ? Colors.white
                    : Colors.grey.shade200,
                child: InkWell(
                  onTap: (employee.status == Status.employed && employee.retireRequest != true)
                      ? () {
                          Navigator.of(buttonContext).pop();
                          _requestRetirement(employee);
                        }
                      : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      employee.retireRequest == true ? "Retirement Requested" : "To Retirement",
                      style: TextStyle(
                        color: (employee.status == Status.employed && employee.retireRequest != true)
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
                    "Obtain Work Certificate",
                    style: TextStyle(color: Color(0xff289581), fontSize: 14),
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
