import 'package:flutter/material.dart';
import 'package:turtagent/features/overlay/presentation/input_overlay.dart';
import 'package:turtagent/features/overlay/presentation/response_overlay.dart';

class AgentOverlay extends StatelessWidget {
  AgentOverlay({super.key});

  bool _showResponseOverlay = false;
  //String _latestPrompt = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [if (_showResponseOverlay) ResponseOverlay(), InputOverlay()],
    );
  }

  //void _onPrompt(String prompt) {}
}
