import 'package:flutter/material.dart';

/// Widget para mostrar un indicador de carga
class LoadingIndicator extends StatelessWidget {
  final String? message;

  /// Constructor
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[const SizedBox(height: 16), Text(message!)],
        ],
      ),
    );
  }
}
