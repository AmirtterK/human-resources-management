import 'package:flutter/material.dart';
import 'package:hr_management/classes/types.dart';

class StatusChip extends StatelessWidget {
  final Status status;
  const StatusChip({super.key, required this.status});

  Color _getBackgroundColor() {
    switch (status) {
      case Status.employed:
        return const Color(0xffBDF4C5);
      case Status.toRetire:
        return const Color(0xffFEFFD8);
      case Status.retired:
        return const Color(0xffE0E0E0); 
    }
  }

  Color _getTextColor() {
    switch (status) {
      case Status.employed:
        return const Color(0xff2FC96F);
      case Status.toRetire:
        return const Color(0xffD0D500);
      case Status.retired:
        return const Color(0xff757575); 
    }
  }

  String _getStatusText() {
    switch (status) {
      case Status.employed:
        return 'Employed';
      case Status.toRetire:
        return 'To Retire';
      case Status.retired:
        return 'Retired';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getStatusText(),
        style: TextStyle(
          color: _getTextColor(),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
