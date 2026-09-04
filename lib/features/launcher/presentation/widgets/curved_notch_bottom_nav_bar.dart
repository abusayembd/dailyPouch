import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class CurvedNavItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String? label;

  const CurvedNavItem({
    required this.icon,
    this.selectedIcon,
    this.label,
  });
}

class CurvedNotchBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CurvedNavItem> items;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;

  const CurvedNotchBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ?? AppColors.textMuted;
    final effectiveBgColor = backgroundColor ?? Colors.white;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      height: 64,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final itemWidth = totalWidth / items.length;
          final targetX = (currentIndex + 0.5) * itemWidth;

          return TweenAnimationBuilder<double>(
            tween: Tween<double>(end: targetX),
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            builder: (context, animatedX, child) {
              return CustomPaint(
                painter: _CurvedNotchPainter(
                  activeX: animatedX,
                  backgroundColor: effectiveBgColor,
                  borderColor: AppColors.cardBorder.withAlpha(120),
                  dotColor: Colors.white,
                  notchWidth: 54.0,
                  notchDepth: 15.0,
                  cornerRadius: 26.0,
                ),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = index == currentIndex;
                    final hasLabel = item.label != null && item.label!.isNotEmpty;

                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onTap(index),
                          borderRadius: BorderRadius.circular(24),
                          splashColor: effectiveActiveColor.withAlpha(30),
                          highlightColor: Colors.transparent,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: hasLabel ? 8 : 10),
                            child: hasLabel
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        isSelected
                                            ? (item.selectedIcon ?? item.icon)
                                            : item.icon,
                                        size: 22,
                                        color: isSelected
                                            ? effectiveActiveColor
                                            : effectiveInactiveColor,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.label!,
                                        style: AppTypography.labelSmall.copyWith(
                                          fontSize: 11,
                                          fontWeight: isSelected
                                              ? FontWeight.w800
                                              : FontWeight.w600,
                                          color: isSelected
                                              ? effectiveActiveColor
                                              : effectiveInactiveColor,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  )
                                : Icon(
                                    isSelected
                                        ? (item.selectedIcon ?? item.icon)
                                        : item.icon,
                                    size: 25,
                                    color: isSelected
                                        ? effectiveActiveColor
                                        : effectiveInactiveColor,
                                  ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CurvedNotchPainter extends CustomPainter {
  final double activeX;
  final Color backgroundColor;
  final Color borderColor;
  final Color dotColor;
  final double notchWidth;
  final double notchDepth;
  final double cornerRadius;

  _CurvedNotchPainter({
    required this.activeX,
    required this.backgroundColor,
    required this.borderColor,
    required this.dotColor,
    required this.notchWidth,
    required this.notchDepth,
    required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final r = cornerRadius;

    final leftNotch = activeX - notchWidth / 2;
    final rightNotch = activeX + notchWidth / 2;
    final midNotch = activeX;

    final path = Path();
    path.moveTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);

    // Left straight edge to notch
    path.lineTo(leftNotch, 0);

    // Smooth concave scoop curve dipping down
    path.cubicTo(
      leftNotch + notchWidth * 0.22,
      0,
      midNotch - notchWidth * 0.28,
      notchDepth,
      midNotch,
      notchDepth,
    );
    path.cubicTo(
      midNotch + notchWidth * 0.28,
      notchDepth,
      rightNotch - notchWidth * 0.22,
      0,
      rightNotch,
      0,
    );

    // Right straight edge to top right corner
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);

    // Right vertical edge
    path.lineTo(w, h - r);
    path.quadraticBezierTo(w, h, w - r, h);

    // Bottom horizontal edge
    path.lineTo(r, h);
    path.quadraticBezierTo(0, h, 0, h - r);

    path.close();

    // 1. Draw outer shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(path.shift(const Offset(0, 4)), shadowPaint);

    // 2. Draw background fill
    final fillPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 3. Draw border stroke
    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawPath(path, strokePaint);

    // 4. Draw the floating white dot inside/above the scoop curve
    final dotCenter = Offset(activeX, notchDepth * 0.08);
    const dotRadius = 4.8;

    // Dot shadow
    final dotShadowPaint = Paint()
      ..color = Colors.black.withAlpha(50)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(dotCenter + const Offset(0, 1.2), dotRadius, dotShadowPaint);

    // Dot fill
    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(dotCenter, dotRadius, dotPaint);

    // Dot border for crisp contrast
    final dotBorderPaint = Paint()
      ..color = borderColor.withAlpha(160)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawCircle(dotCenter, dotRadius, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _CurvedNotchPainter oldDelegate) {
    return oldDelegate.activeX != activeX ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.dotColor != dotColor;
  }
}
