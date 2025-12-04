import 'package:flutter/material.dart';
import 'package:hr_management/classes/Department.dart';
import 'package:hr_management/components/DepartmentCard.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/tabs/ExtendedDepartmentsTab.dart';

class DepartmentsTab extends StatefulWidget {
  const DepartmentsTab({super.key});

  @override
  State<DepartmentsTab> createState() => _DepartmentsTabState();
}

class _DepartmentsTabState extends State<DepartmentsTab> {
  bool _isViewingDetails = false;
  Department? _selectedDepartment;

  void _viewDetails(Department department) {
    setState(() {
      _isViewingDetails = true;
      _selectedDepartment = department;
    });
  }

  void _returnToList() {
    setState(() {
      _isViewingDetails = false;
      _selectedDepartment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isViewingDetails
        ? ExtendedDepartmentsTab(
            department: _selectedDepartment,
            onReturn: _returnToList,
          )
        : GridView.builder(
            padding: const EdgeInsets.all(24.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 300,
            ),
            itemCount: departments.length,
            itemBuilder: (context, index) {
              return DepartmentCard(
                department: departments[index],
                onSeeDetails: () => _viewDetails(departments[index]),
              );
            },
          );
  }
}
