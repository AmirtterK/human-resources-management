import 'package:flutter/material.dart';

class DomainCard extends StatelessWidget {
  final String domainName;
  final VoidCallback onModify;
  final VoidCallback? onDelete;

  const DomainCard({
    super.key,
    required this.domainName,
    required this.onModify,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        border: Border.all(color: Color(0x2609866F), width: 2),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              domainName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.teal,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(children: [
              if (onDelete != null)
                OutlinedButton(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text('Delete'),
                ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onModify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff289581),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('Modify'),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
