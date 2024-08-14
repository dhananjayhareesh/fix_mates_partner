import 'package:flutter/material.dart';

class RejectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 100,
            ),
            const SizedBox(height: 16),
            const Text(
              "You didn't meet our criteria",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "We regret to inform you that your application was not successful.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
