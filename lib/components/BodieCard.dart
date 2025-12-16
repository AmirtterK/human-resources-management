import 'package:flutter/material.dart';
import 'package:hr_management/classes/Body.dart';

/// Card widget to display key information about an organizational Body.
class BodieCard extends StatelessWidget {
  final Body body;
  final VoidCallback onViewDetails;
  final VoidCallback? onDelete;
  final String primaryLabel;
  final int? memberCount;

  const BodieCard({
    super.key,
    required this.body,
    required this.onViewDetails,
    this.onDelete,
    this.primaryLabel = 'View Details',
    this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Text(
            body.id,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          const Text('|', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(width: 16),
          Text(
            body.nameEn,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          const Text('|', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(width: 16),
          Text(
            body.nameAr,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'Alfont',
            ),
          ),
          const SizedBox(width: 16),
          const Text('|', style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(width: 16),
          Text(
            'Total Member: ${memberCount ?? body.totalMembers}',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Spacer(),
          if (onDelete != null) ...[
            OutlinedButton(
              onPressed: onDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text('Delete Body'),
            ),
            const SizedBox(width: 12),
          ],
          ElevatedButton(
            onPressed: onViewDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF09866F),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              primaryLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
