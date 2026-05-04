import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/seller_provider.dart';
import '../../../shared/widgets/glass_widgets.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  int _chartRange = 7; // 7D or 30D

  @override
  Widget build(BuildContext context) {
    final earningsAsync = ref.watch(sellerEarningsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF101415),
      body: GlassBg(
        child: Column(
          children: [
            // Glass header
            SafeArea(
              bottom: false,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color(0xFFCEBDFF)),
                          onPressed: () => context.pop(),
                          padding: EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(minWidth: 40, minHeight: 40),
                        ),
                        Expanded(
                          child: GradientText(
                            'FlowMarket',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.notifications_outlined,
                          color:
                              const Color(0xFFCEBDFF).withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: earningsAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFCEBDFF))),
                error: (_, __) => _EarningsBody(
                    earnings: const {}, chartRange: _chartRange,
                    onToggleRange: (r) => setState(() => _chartRange = r)),
                data: (earnings) => _EarningsBody(
                    earnings: earnings, chartRange: _chartRange,
                    onToggleRange: (r) => setState(() => _chartRange = r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarningsBody extends StatelessWidget {
  final Map<String, dynamic> earnings;
  final int chartRange;
  final void Function(int) onToggleRange;

  const _EarningsBody({
    required this.earnings,
    required this.chartRange,
    required this.onToggleRange,
  });

  @override
  Widget build(BuildContext context) {
    final available = earnings['available'] as double? ?? 12450.80;
    final pending = earnings['pending'] as double? ?? 1840.00;
    final totalEarned = earnings['totalEarned'] as double? ?? 48920.50;

    final transactions = earnings['recentTransactions'] as List? ??
        _demoTransactions;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available for Payout hero card
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF8B5CF6).withValues(alpha: 0.25),
                      const Color(0xFFD946EF).withValues(alpha: 0.12),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVAILABLE FOR PAYOUT',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: const Color(0xFFCEBDFF).withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${available.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _StatPill(
                          label: 'PENDING',
                          value:
                              '\$${pending.toStringAsFixed(2)}',
                          color: const Color(0xFFFFAFD3),
                        ),
                        const SizedBox(width: 12),
                        _StatPill(
                          label: 'TOTAL EARNED',
                          value:
                              '\$${totalEarned.toStringAsFixed(2)}',
                          color: const Color(0xFF4DDCC6),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8B5CF6), Color(0xFFD946EF)],
                          ),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet_outlined,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Withdraw Funds',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Revenue Flow chart
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Revenue Flow',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Row(
                          children: [
                            _RangeToggle(
                              label: '7D',
                              isSelected: chartRange == 7,
                              onTap: () => onToggleRange(7),
                            ),
                            const SizedBox(width: 8),
                            _RangeToggle(
                              label: '30D',
                              isSelected: chartRange == 30,
                              onTap: () => onToggleRange(30),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 120,
                      child: CustomPaint(
                        painter: _RevenueLinePainter(points: chartRange),
                        size: const Size(double.infinity, 120),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        chartRange == 7 ? 7 : 6,
                        (i) => Text(
                          chartRange == 7
                              ? ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i]
                              : ['W1', 'W2', 'W3', 'W4', 'W5', 'W6'][i],
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Earnings
          const Text(
            'Recent Earnings',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          ...List.generate(transactions.length, (i) {
            final t = transactions[i] as Map<String, dynamic>;
            return _TransactionRow(
              name: t['name'] as String,
              date: t['date'] as String,
              trx: t['trx'] as String,
              amount: t['amount'] as String,
              cleared: t['cleared'] as bool,
            );
          }),
        ],
      ),
    );
  }
}

final _demoTransactions = [
  {
    'name': 'Sarah Johnson',
    'date': 'Apr 28, 2026',
    'trx': 'TRX-00821',
    'amount': '+\$49.99',
    'cleared': true,
  },
  {
    'name': 'Marcus Williams',
    'date': 'Apr 27, 2026',
    'trx': 'TRX-00820',
    'amount': '+\$29.99',
    'cleared': true,
  },
  {
    'name': 'Elena Rivera',
    'date': 'Apr 26, 2026',
    'trx': 'TRX-00818',
    'amount': '+\$79.00',
    'cleared': false,
  },
  {
    'name': 'James Park',
    'date': 'Apr 24, 2026',
    'trx': 'TRX-00815',
    'amount': '+\$19.99',
    'cleared': true,
  },
  {
    'name': 'Aisha Okafor',
    'date': 'Apr 23, 2026',
    'trx': 'TRX-00812',
    'amount': '+\$149.00',
    'cleared': false,
  },
];

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: color.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeToggle extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RangeToggle(
      {required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.5))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? const Color(0xFFCEBDFF)
                : Colors.white.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final String name;
  final String date;
  final String trx;
  final String amount;
  final bool cleared;

  const _TransactionRow({
    required this.name,
    required this.date,
    required this.trx,
    required this.amount,
    required this.cleared,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3C1989).withValues(alpha: 0.8),
                  const Color(0xFF6A0045).withValues(alpha: 0.6),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name[0],
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFCEBDFF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$date · $trx',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF4DDCC6),
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: cleared
                      ? const Color(0xFF4DDCC6).withValues(alpha: 0.12)
                      : const Color(0xFFFFAFD3).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  cleared ? 'CLEARED' : 'PENDING',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: cleared
                        ? const Color(0xFF4DDCC6)
                        : const Color(0xFFFFAFD3),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueLinePainter extends CustomPainter {
  final int points;

  _RevenueLinePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final count = points;

    // Generate pseudo-random revenue data
    final vals = List.generate(
        count, (i) => 0.2 + 0.6 * (0.5 + 0.5 * math.sin(i * 1.3 + 0.7)));

    final pts = List.generate(
        count,
        (i) => Offset(
              w * i / (count - 1),
              h - h * vals[i],
            ));

    // Fill path
    final fillPath = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i].dy);
      final cp2 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i + 1].dy);
      fillPath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i + 1].dx, pts[i + 1].dy);
    }
    fillPath
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF8B5CF6).withValues(alpha: 0.35),
            const Color(0xFF8B5CF6).withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Line
    final linePath = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final cp1 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i].dy);
      final cp2 = Offset((pts[i].dx + pts[i + 1].dx) / 2, pts[i + 1].dy);
      linePath.cubicTo(
          cp1.dx, cp1.dy, cp2.dx, cp2.dy, pts[i + 1].dx, pts[i + 1].dy);
    }

    canvas.drawPath(
      linePath,
      Paint()
        ..color = const Color(0xFF8B5CF6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Dot on last point
    canvas.drawCircle(
      pts.last,
      4,
      Paint()..color = const Color(0xFF8B5CF6),
    );
    canvas.drawCircle(
      pts.last,
      7,
      Paint()..color = const Color(0xFF8B5CF6).withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(_RevenueLinePainter old) => old.points != points;
}
