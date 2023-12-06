import 'package:flutter/material.dart';
import 'package:soltalk/util/constants.dart';

// ignore: must_be_immutable
class SexOrientationDialog extends StatefulWidget {
  String sexOrientation;
  SexOrientationDialog({super.key, required this.sexOrientation});

  @override
  State<SexOrientationDialog> createState() => _SexOrientationDialogState();
}

class _SexOrientationDialogState extends State<SexOrientationDialog> {
   

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text('Select Sex Orientation'),
      content: SizedBox(
        height: 150, // Adjust the height as needed
        child: Column(
          children: [
            DropdownButton<String>(
              value: widget.sexOrientation,
              items: kSexOrientationList.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                
                if (value != null && value != widget.sexOrientation) {
                  setState(() {
                    widget.sexOrientation = value;
                  });
                }
              },
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.sexOrientation);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
