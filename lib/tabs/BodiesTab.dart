import 'package:flutter/material.dart';
import 'package:hr_management/classes/Body.dart';
import 'package:hr_management/components/AddBodieDialog.dart';
import 'package:hr_management/components/BodieCard.dart';
import 'package:hr_management/data/data.dart';
import 'package:hr_management/tabs/ExtendedBodiesTab.dart';

class BodiesTab extends StatefulWidget {
  const BodiesTab({super.key});

  @override
  State<BodiesTab> createState() => _BodiesTabState();
}

class _BodiesTabState extends State<BodiesTab> {
  bool _isViewingDetails = false;
  Body? _selectedBody;

  void _addBody() {
    showDialog(
      context: context,
      builder: (context) => const AddBodyDialog(),
    ).then((bodyData) {
      if (bodyData != null) {
        setState(() {
          bodies.add(bodyData);
        });
      }
    });
  }

  void _viewDetails(Body body) {
    setState(() {
      _isViewingDetails = true;
      _selectedBody = body;
    });
  }

  void _returnToList() {
    setState(() {
      _isViewingDetails = false;
      _selectedBody = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isViewingDetails
        ? ExtendedBodiesTab(
            body: _selectedBody,
            onReturn: _returnToList,
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: _addBody,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Body'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: bodies.length,
                    itemBuilder: (context, index) {
                      return BodyCard(
                        body: bodies[index],
                        onViewDetails: () => _viewDetails(bodies[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}