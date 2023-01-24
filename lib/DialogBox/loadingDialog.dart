import 'package:flutter/material.dart';

class loadingDialog extends StatelessWidget {
  final String? message;
  const loadingDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      scrollable: true,
      content: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 10,
          ),
          Text(message!),
        ],
      ),
    );
  }
}
