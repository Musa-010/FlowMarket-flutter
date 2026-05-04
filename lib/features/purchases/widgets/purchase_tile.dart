import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../models/purchase/purchase_model.dart';
import '../../../models/workflow/workflow_model.dart';
import '../../../shared/widgets/glass_widgets.dart';
import '../../marketplace/widgets/category_chip.dart';

class PurchaseTile extends StatelessWidget {
  const PurchaseTile({
    super.key,
    required this.purchase,
    this.onDeploy,
    this.onDownload,
    this.onReview,
  });

  final Purchase purchase;
  final VoidCallback? onDeploy;
  final VoidCallback? onDownload;
  final VoidCallback? onReview;

  @override
  Widget build(BuildContext context) {
    final workflow = purchase.workflow;
    final hasImage = workflow?.previewImages.isNotEmpty == true;
    final category = workflow?.category;

    return GlassCard(
      borderRadius: BorderRadius.circular(20),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: hasImage
                    ? CachedNetworkImage(
                        imageUrl: workflow!.previewImages.first,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _Placeholder(),
                        errorWidget: (_, __, ___) => _Placeholder(),
                      )
                    : _Placeholder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workflow?.title ?? 'Workflow',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (category != null) ...[
                      _CategoryPill(category: category),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      'Purchased: ${Formatters.date(purchase.createdAt ?? DateTime.now())}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: const Color(0xFFCAC4D4).withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '\$${purchase.pricePaid.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFCEBDFF),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle,
                          size: 13,
                          color: Color(0xFF4DDCC6),
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          'Purchased',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Color(0xFF4DDCC6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _TileAction(
                  icon: Icons.rocket_launch_outlined,
                  label: 'Deploy',
                  color: const Color(0xFF8B5CF6),
                  onTap: onDeploy,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TileAction(
                  icon: Icons.download_outlined,
                  label: 'Download',
                  onTap: onDownload,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TileAction(
                  icon: Icons.star_outline_rounded,
                  label: 'Review',
                  onTap: onReview,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFA78BFA).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.auto_awesome_mosaic_outlined,
        size: 22,
        color: Color(0xFFCEBDFF),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final WorkflowCategory category;
  const _CategoryPill({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = CategoryChip.colorFor(category);
    final label = CategoryChip.labelFor(category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _TileAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  const _TileAction({
    required this.icon,
    required this.label,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? const Color(0xFFCAC4D4);
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: BorderRadius.circular(999),
        padding: const EdgeInsets.symmetric(vertical: 8),
        opacity: 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: c),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: c,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
