import 'package:flutter/material.dart';

class ResponseOverlay extends StatelessWidget {
  const ResponseOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(120),
          ),
          child: Row(spacing: 8, children: [Text('Sample response')]),
        ),
      ),
    );
  }
}
