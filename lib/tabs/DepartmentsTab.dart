import 'package:flutter/material.dart';
import 'package:hr_management/components/DepartmentCard.dart';
import 'package:hr_management/data/data.dart';

class DepartmentsTab extends StatelessWidget {
  const DepartmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24.0), 
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 300
      ),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        return DepartmentCard(
          department: departments[index],
          onSeeDetails: () {
          },
        );
      },
    );
  }
}