import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IncomeFilePickerBottomSheet {
  const IncomeFilePickerBottomSheet();

  Future<bool?> showBottomSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Files'),
                onTap: () {
                  Navigator.of(context).pop(true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () {
                  Navigator.of(context).pop(null);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
