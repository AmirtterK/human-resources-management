import 'package:flutter/material.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:hr_management/classes/types.dart';
import 'package:hr_management/components/EmployeesTable.dart';
import 'package:hr_management/data/data.dart';
import 'package:popover/popover.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  final TextEditingController _searchController = TextEditingController();
  Employee? selectedEmployee;

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
          'Retirees',
          style: TextStyle(
            letterSpacing: 1,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(width: 20),
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
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.teal,
            side: const BorderSide(color: Colors.teal),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text('Extract List'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
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
          title: 'RequestsTab',
          employees: employees
              .where((emp) => emp.status == Status.toRetire)
              .toList(),
          onEmployeePressed: _showEmployeeActions,
        ),
      ),
    );
  }

  void _showEmployeeActions(Employee employee, BuildContext buttonContext) {
    setState(() {
      selectedEmployee = employee;
    });
    double popHeight = user == User.agent ? 40 : 80;
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
          ],
        ),
      ),
    );
  }
}
