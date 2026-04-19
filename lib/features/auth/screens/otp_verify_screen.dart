import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerifyScreen extends ConsumerWidget {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verify')),
      body: const Center(child: Text('OTP Verify')),
    );
  }
}
