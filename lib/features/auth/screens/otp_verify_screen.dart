import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../models/user/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../shared/widgets/glass_widgets.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  final String email;
  final String fullName;
  final String password;
  final UserRole role;

  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.fullName,
    required this.password,
    required this.role,
  });

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _error;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_resendSeconds == 0) {
        _timer?.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    setState(() {});
    if (_otp.length == 6) _verify();
  }

  void _onBackspace(int index) {
    if (index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {});
    }
  }

  void _onOtpPaste(int startIndex, String digits) {
    for (int i = 0; i < digits.length && startIndex + i < 6; i++) {
      _controllers[startIndex + i].text = digits[i];
    }
    final nextIdx = (startIndex + digits.length).clamp(0, 5);
    _focusNodes[nextIdx].requestFocus();
    setState(() {});
    if (_otp.length == 6) _verify();
  }

  Future<void> _verify() async {
    final otp = _otp;
    if (otp.length != 6 || _isLoading) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      await Supabase.instance.client.auth.verifyOTP(
        email: widget.email,
        token: otp,
        type: OtpType.email,
      );
      await ref.read(authProvider.notifier).register(
        fullName: widget.fullName,
        email: widget.email,
        password: widget.password,
        role: widget.role,
      );
      // Router redirect handles navigation to /dashboard on auth state change
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = _friendlyError(e);
        });
        for (final c in _controllers) { c.clear(); }
        _focusNodes[0].requestFocus();
      }
    }
  }

  Future<void> _resend() async {
    if (_resendSeconds > 0 || _isLoading) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      await Supabase.instance.client.auth.signUp(
        email: widget.email,
        password: widget.password,
      );
      _startTimer();
    } catch (e) {
      if (mounted) setState(() => _error = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _friendlyError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('invalid') || s.contains('expired')) {
      return 'Invalid or expired code. Request a new one.';
    }
    if (s.contains('already registered') || s.contains('already exists')) {
      return 'Email already registered. Try logging in.';
    }
    return e.toString();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) {
          if (mounted) setState(() { _isLoading = false; _error = e.toString(); });
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              children: [
                const SizedBox(height: 48),
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                    ),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Verify Your Email',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: const Color(0xFFCAC4D4).withValues(alpha: 0.8),
                    ),
                    children: [
                      const TextSpan(text: 'Enter the 6-digit code sent to\n'),
                      TextSpan(
                        text: widget.email,
                        style: const TextStyle(
                          color: Color(0xFFCEBDFF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                GlassCard(
                  borderRadius: BorderRadius.circular(28),
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (i) => _OtpBox(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            onChanged: (v) => _onDigitEntered(i, v),
                            onBackspace: () => _onBackspace(i),
                            onPaste: (digits) => _onOtpPaste(i, digits),
                          ),
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB4AB).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFB4AB).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Color(0xFFFFB4AB),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      const SizedBox(height: 28),
                      GlassButton(
                        label: 'Verify Email',
                        onPressed:
                            (_isLoading || _otp.length != 6) ? null : _verify,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive a code? ",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: const Color(0xFFCAC4D4).withValues(alpha: 0.7),
                            ),
                          ),
                          GestureDetector(
                            onTap: _resendSeconds == 0 ? _resend : null,
                            child: Text(
                              _resendSeconds > 0
                                  ? 'Resend in ${_resendSeconds}s'
                                  : 'Resend',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _resendSeconds > 0
                                    ? const Color(0xFFCAC4D4)
                                        .withValues(alpha: 0.35)
                                    : const Color(0xFFCEBDFF),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Text(
                          '← Change email',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            color: const Color(0xFFCAC4D4).withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;
  final ValueChanged<String>? onPaste;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
    this.onPaste,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.onKeyEvent = (node, event) {
      if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
          event.logicalKey == LogicalKeyboardKey.backspace &&
          widget.controller.text.isEmpty) {
        widget.onBackspace();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  Widget build(BuildContext context) {
    final isFilled = widget.controller.text.isNotEmpty;
    return SizedBox(
      width: 44,
      height: 54,
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: 'Inter',
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: true,
          fillColor: isFilled
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.07),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isFilled
                  ? const Color(0xFF8B5CF6).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
          ),
        ),
        onChanged: (val) {
          final digits = val.replaceAll(RegExp(r'\D'), '');
          if (digits.length > 1) {
            widget.onPaste?.call(digits);
            widget.controller.value = TextEditingValue(
              text: digits[0],
              selection: const TextSelection.collapsed(offset: 1),
            );
            return;
          }
          widget.onChanged(val);
          setState(() {});
        },
      ),
    );
  }
}
