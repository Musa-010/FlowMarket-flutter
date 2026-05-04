import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../repositories/auth_repository.dart';
import '../../../shared/widgets/glass_widgets.dart';

enum _ResetStep { email, otp, newPassword, done }

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // OTP boxes
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  _ResetStep _step = _ResetStep.email;
  bool _isLoading = false;
  String? _error;
  int _resendCountdown = 0;
  Timer? _resendTimer;
  String _resetToken = '';

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  String get _otp => _otpControllers.map((c) => c.text).join();

  void _startResendTimer() {
    setState(() => _resendCountdown = 60);
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _resendCountdown--;
        if (_resendCountdown <= 0) t.cancel();
      });
    });
  }

  Future<void> _sendOtp() async {
    if (!_emailFormKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      await ref.read(authRepositoryProvider).forgotPassword(
            _emailController.text.trim());
      if (!mounted) return;
      setState(() { _step = _ResetStep.otp; _isLoading = false; });
      _startResendTimer();
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _otpFocusNodes[0].requestFocus());
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0 || _isLoading) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      await ref.read(authRepositoryProvider).forgotPassword(
            _emailController.text.trim());
      if (!mounted) return;
      setState(() => _isLoading = false);
      _startResendTimer();
      for (final c in _otpControllers) c.clear();
      _otpFocusNodes[0].requestFocus();
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6 || _isLoading) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      final token = await ref.read(authRepositoryProvider).verifyResetOtp(
            _emailController.text.trim(), _otp);
      if (!mounted) return;
      setState(() {
        _resetToken = token;
        _step = _ResetStep.newPassword;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() { _isLoading = false; _error = _friendlyError(e); });
        for (final c in _otpControllers) c.clear();
        _otpFocusNodes[0].requestFocus();
      }
    }
  }

  Future<void> _resetPassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      await ref.read(authRepositoryProvider).resetPassword(
            _resetToken, _newPasswordController.text);
      if (!mounted) return;
      setState(() { _step = _ResetStep.done; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  void _onOtpDigit(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    setState(() {});
    if (_otp.length == 6) _verifyOtp();
  }

  void _onOtpBackspace(int index) {
    if (index > 0) {
      _otpControllers[index - 1].clear();
      _otpFocusNodes[index - 1].requestFocus();
      setState(() {});
    }
  }

  void _onOtpPaste(int startIndex, String digits) {
    for (int i = 0; i < digits.length && startIndex + i < 6; i++) {
      _otpControllers[startIndex + i].text = digits[i];
    }
    final nextIdx = (startIndex + digits.length).clamp(0, 5);
    _otpFocusNodes[nextIdx].requestFocus();
    setState(() {});
    if (_otp.length == 6) _verifyOtp();
  }

  String _friendlyError(Object e) {
    final s = e.toString().toLowerCase();
    if (s.contains('invalid') || s.contains('expired')) {
      return 'Invalid or expired code. Try again.';
    }
    return e.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Icon(Icons.bubble_chart_outlined,
                              color: Color(0xFFCEBDFF), size: 22),
                          const SizedBox(width: 8),
                          GradientText(
                            'FlowMarket',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ]),
                        // Step indicator
                        _StepDots(current: _step.index, total: 3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 100),
                child: _buildStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case _ResetStep.email:
        return _buildEmailStep();
      case _ResetStep.otp:
        return _buildOtpStep();
      case _ResetStep.newPassword:
        return _buildNewPasswordStep();
      case _ResetStep.done:
        return _buildDoneStep();
    }
  }

  Widget _buildEmailStep() {
    return Form(
      key: _emailFormKey,
      child: GlassCard(
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionIcon(icon: Icons.lock_reset_outlined),
            const SizedBox(height: 16),
            const Text(
              'Recover Access',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Enter your email and we'll send a 6-digit reset code.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: const Color(0xFFCAC4D4).withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            GlassTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'name@flowmarket.com',
              prefixIcon: Icons.mail_outline,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              validator: Validators.email,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              _ErrorBox(message: _error!),
            ],
            const SizedBox(height: 24),
            GlassButton(
              label: 'Send Reset Code',
              onPressed: _isLoading ? null : _sendOtp,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () => context.go('/login'),
                child: const Text(
                  'Back to login',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: Color(0xFFA78BFA),
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFA78BFA),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpStep() {
    return GlassCard(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SectionIcon(icon: Icons.mark_email_unread_outlined),
          const SizedBox(height: 16),
          const Text(
            'Enter Reset Code',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
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
                const TextSpan(text: 'Code sent to\n'),
                TextSpan(
                  text: _emailController.text.trim(),
                  style: const TextStyle(
                    color: Color(0xFFCEBDFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (i) => _OtpBox(
                controller: _otpControllers[i],
                focusNode: _otpFocusNodes[i],
                onChanged: (v) => _onOtpDigit(i, v),
                onBackspace: () => _onOtpBackspace(i),
                onPaste: (digits) => _onOtpPaste(i, digits),
              ),
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            _ErrorBox(message: _error!),
          ],
          const SizedBox(height: 24),
          GlassButton(
            label: 'Verify Code',
            onPressed: (_isLoading || _otp.length != 6) ? null : _verifyOtp,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Didn't receive it? ",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: const Color(0xFFCAC4D4).withValues(alpha: 0.7),
                ),
              ),
              GestureDetector(
                onTap: _resendCountdown == 0 ? _resendOtp : null,
                child: Text(
                  _resendCountdown > 0
                      ? 'Resend in ${_resendCountdown}s'
                      : 'Resend',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _resendCountdown > 0
                        ? const Color(0xFFCAC4D4).withValues(alpha: 0.35)
                        : const Color(0xFFCEBDFF),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => setState(() {
                _step = _ResetStep.email;
                _error = null;
              }),
              child: Text(
                '← Change email',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: const Color(0xFFCAC4D4).withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewPasswordStep() {
    return Form(
      key: _passwordFormKey,
      child: GlassCard(
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionIcon(icon: Icons.lock_outline),
            const SizedBox(height: 16),
            const Text(
              'Set New Password',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Choose a strong password for your account.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: const Color(0xFFCAC4D4).withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            GlassTextField(
              controller: _newPasswordController,
              label: 'New Password',
              hint: '••••••••',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: Validators.password,
            ),
            const SizedBox(height: 16),
            GlassTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              hint: '••••••••',
              prefixIcon: Icons.verified_user_outlined,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (v) => Validators.confirmPassword(
                  v, _newPasswordController.text),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              _ErrorBox(message: _error!),
            ],
            const SizedBox(height: 24),
            GlassButton(
              label: 'Reset Password',
              onPressed: _isLoading ? null : _resetPassword,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneStep() {
    return GlassCard(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 72,
            height: 72,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF4DDCC6), Color(0xFF8B5CF6)],
              ),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 36),
          ),
          const Text(
            'Password Reset!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Your password has been updated. Log in with your new password.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: const Color(0xFFCAC4D4).withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          GlassButton(
            label: 'Back to Login',
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}

class _SectionIcon extends StatelessWidget {
  final IconData icon;
  const _SectionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB4AB).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFFFFB4AB).withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: Color(0xFFFFB4AB),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  final int current;
  final int total;
  const _StepDots({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final active = i < current;
        final isCurrent = i == current;
        return Container(
          width: isCurrent ? 18 : 8,
          height: 8,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isCurrent
                ? const Color(0xFFCEBDFF)
                : active
                    ? const Color(0xFF4DDCC6)
                    : Colors.white.withValues(alpha: 0.2),
          ),
        );
      }),
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
