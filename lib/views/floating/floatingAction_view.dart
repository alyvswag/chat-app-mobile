import 'package:chatapp_project/widgets/modal_widget.dart';
import 'package:flutter/material.dart';

class FloatingactionWidget extends StatefulWidget {
  final BuildContext context;
  const FloatingactionWidget({super.key, required this.context});

  @override
  State<FloatingactionWidget> createState() => _FloatingactionWidgetState();
}

class _FloatingactionWidgetState extends State<FloatingactionWidget> {
  void _showAddRoomDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return ModalWidget(context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _showAddRoomDialog, // Otaq yaratma dialogunu aç
      tooltip: 'Otaq Yarat',
      backgroundColor: Colors.purple[100],
      child: const Icon(Icons.add),
    );
  }
}
