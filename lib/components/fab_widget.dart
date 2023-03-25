import 'package:flutter/material.dart';

class FabWidget extends StatelessWidget {
  const FabWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: () => Navigator.of(context).pop(),
      backgroundColor: Colors.white24,
      elevation: 0,
      tooltip: 'Back',
      child: const Icon(Icons.arrow_back, color: Colors.black38),
    );
  }
}
