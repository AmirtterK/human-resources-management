import 'package:flutter/material.dart';
import 'package:hr_management/classes/types.dart';

/// Visual chip to display an employee's status (Employed, Retired, etc.).
class StatusChip extends StatelessWidget {
  final Status status;
  final bool? retireRequest;
  const StatusChip({super.key, required this.status, this.retireRequest});

  Color _getBackgroundColor() {
    // If retireRequest is true, show yellow background regardless of status
    if (retireRequest == true) {
      return Colors.yellow;
    }
    
    switch (status) {
      case Status.employed:
        return const Color(0xffBDF4C5);
      case Status.toRetire:
        return Colors.yellow; // Yellow background for retire status
      case Status.retired:
        return const Color(0xffE0E0E0); 
    }
  }

  Color _getTextColor() {
    // If retireRequest is true, use darker text for better contrast on yellow
    if (retireRequest == true) {
      return Colors.orange.shade900;
    }
    
    switch (status) {
      case Status.employed:
        return const Color(0xff2FC96F);
      case Status.toRetire:
        return Colors.orange.shade900; // Darker text for better contrast on yellow
      case Status.retired:
        return const Color(0xff757575); 
    }
  }

  String _getStatusText() {
    // If retireRequest is true, show "To Retire" regardless of status
    if (retireRequest == true) {
      return 'To Retire';
    }
    
    switch (status) {
      case Status.employed:
        return 'Employed';
      case Status.toRetire:
        return 'Retire';
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
