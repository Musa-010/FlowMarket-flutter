import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/glass_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: SafeArea(
          child: Stack(
            children: [
              // Center branding
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo glass card
                    GlassCard(
                      padding: const EdgeInsets.all(32),
                      borderRadius: BorderRadius.circular(28),
                      child: SizedBox(
                        width: 64,
                        height: 64,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.waves,
                              size: 52,
                              color: Color(0xFFCEBDFF),
                            ),
                            Text(
                              'F',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                color: Colors.white.withValues(alpha: 0.12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App name
                    GradientText(
                      AppStrings.appName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline
                    Text(
                      'THE FUTURE OF WORKFLOWS',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: const Color(0xFFCAC4D4).withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),

              // System status card
              Positioned(
                bottom: 48,
                left: 20,
                right: 20,
                child: GlassCard(
                  borderRadius: BorderRadius.circular(16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SYSTEM STATUS',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFF4DDCC6),
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'All flows operational',
                              style: TextStyle(
                                color: const Color(0xFFE0E3E5)
                                    .withValues(alpha: 0.6),
                                fontSize: 14,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF00B4A0).withValues(alpha: 0.2),
                          border: Border.all(
                            color: const Color(0xFF4DDCC6).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.bolt,
                          color: Color(0xFF4DDCC6),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Progress indicator
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 120,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.65,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFCEBDFF), Color(0xFF4DDCC6)],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
