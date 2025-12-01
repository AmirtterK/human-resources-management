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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Department head',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                department.headName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(165, 0, 0, 0),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Color(0xff289581)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Staff Members',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${department.totalStaffMembers}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Spacer(),
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
