import 'package:flutter/material.dart';
import 'package:hr_management/classes/Department.dart';

class DepartmentCard extends StatelessWidget {
  final Department department;
  final VoidCallback onSeeDetails;

  const DepartmentCard({
    super.key,
    required this.department,
    required this.onSeeDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE0E0E0), width: 1),
      ),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            department.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xff0A866F),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: OutlinedButton(
              onPressed: onSeeDetails,
              style: OutlinedButton.styleFrom(
                backgroundColor: Color.fromARGB(25, 40, 149, 129),
                foregroundColor: const Color(0xff0A866F),
                side: const BorderSide(color: Color(0xff0A866F), width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'See All Details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
