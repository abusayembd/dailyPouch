import 'package:flutter/material.dart';

/// Renders dedicated, feature-accurate 3D-styled isometric illustrations for DailyPouch launcher cards.
class Module3DIllustration extends StatelessWidget {
  final String moduleId;
  final double size;

  const Module3DIllustration({
    super.key,
    required this.moduleId,
    this.size = 68,
  });

  @override
  Widget build(BuildContext context) {
    Widget artwork;
    switch (moduleId) {
      case 'subscription_tracker':
        artwork = const _SubscriptionArtwork3D();
        break;
      case 'price_calculator':
        artwork = const _PriceCalcArtwork3D();
        break;
      case 'pantry_expiry':
        artwork = const _PantryMedicineArtwork3D();
        break;
      case 'image_compressor':
        artwork = const _ImageCompressorArtwork3D();
        break;
      case 'micro_budgeter':
        artwork = const _MicroBudgeterArtwork3D();
        break;
      case 'interval_timer':
        artwork = const _IntervalTimerArtwork3D();
        break;
      default:
        artwork = const _SubscriptionArtwork3D();
    }

    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: Alignment.center,
        child: SizedBox(
          width: 88,
          height: 88,
          child: artwork,
        ),
      ),
    );
  }
}

// =============================================================
// 1. SUBSCRIPTION TRACKER: 3D Layered Credit Cards & Renewal Badge
// =============================================================
class _SubscriptionArtwork3D extends StatelessWidget {
  const _SubscriptionArtwork3D();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateZ(-0.25)
        ..rotateX(0.36)
        ..rotateY(-0.28),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Background Card (Dark Metallic Platinum)
          Positioned(
            top: 6,
            left: 2,
            child: Container(
              width: 66,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF334155), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(4, 8),
                  ),
                ],
              ),
            ),
          ),
          // Foreground Card (Vibrant Coral-Red VIP Card with Gold Chip)
          Positioned(
            bottom: 4,
            right: 0,
            child: Container(
              width: 70,
              height: 45,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF3366), Color(0xFFD61A46)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withAlpha(120), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3366).withAlpha(110),
                    blurRadius: 14,
                    offset: const Offset(2, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Gold Chip
                      Container(
                        width: 11,
                        height: 9,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(2.5),
                          border: Border.all(color: const Color(0xFFFFA000), width: 0.8),
                        ),
                      ),
                      // Contactless Wave
                      const Icon(Icons.contactless_rounded, color: Colors.white70, size: 11),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 28,
                        height: 3.5,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Recurring Cycle Sync Icon
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.sync_rounded, color: Colors.white, size: 8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Floating Monthly Recurring Badge ($/mo)
          Positioned(
            top: -6,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF00B0FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.autorenew_rounded, color: Colors.white, size: 9),
                  SizedBox(width: 2),
                  Text(
                    '/mo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 2. SMART PRICE COMPARE: 3D Product Price Comparison & Best Deal
// =============================================================
class _PriceCalcArtwork3D extends StatelessWidget {
  const _PriceCalcArtwork3D();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateZ(-0.20)
        ..rotateX(0.34)
        ..rotateY(-0.18),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Left Product (Pack A - Standard Size in Sky/Ocean Blue)
          Positioned(
            left: 2,
            bottom: 4,
            child: Container(
              width: 36,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white70, width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(4, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product Label 'A'
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(210),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'A',
                      style: TextStyle(
                        color: Color(0xFF0369A1),
                        fontSize: 7.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  // Barcode stripes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 1.8, height: 5, color: Colors.white70),
                      const SizedBox(width: 1.2),
                      Container(width: 1.2, height: 5, color: Colors.white70),
                      const SizedBox(width: 1.2),
                      Container(width: 2.5, height: 5, color: Colors.white70),
                      const SizedBox(width: 1.2),
                      Container(width: 1.2, height: 5, color: Colors.white70),
                    ],
                  ),
                  // Price Tag Strip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                    child: const Center(
                      child: Text(
                        r'$4.99',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right Product (Pack B - Larger Best Deal Package in Amber Gold)
          Positioned(
            right: 2,
            bottom: 0,
            child: Container(
              width: 44,
              height: 62,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB300), Color(0xFFE65100)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8F00).withAlpha(120),
                    blurRadius: 14,
                    offset: const Offset(2, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Crown / Star Icon
                  const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 12),
                  // Product Label 'B'
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'B',
                      style: TextStyle(
                        color: Color(0xFFE65100),
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  // Unit Price Tag Strip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Center(
                      child: Text(
                        r'$0.30/g',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 6.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Center "VS" Badge
          Positioned(
            left: 24,
            bottom: 18,
            child: Container(
              width: 17,
              height: 17,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 6.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),

          // Floating Comparison "BEST DEAL" Badge positioned close atop Pack B & Pack A
          Positioned(
            top: 10,
            right: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.white, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(150),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.thumb_up_rounded, color: Colors.white, size: 10.5),
                  SizedBox(width: 3.5),
                  Text(
                    'BEST DEAL',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 3. PANTRY & MEDICINE EXPIRY: 3D Milk Carton & Medicine Capsule Pill
// =============================================================
class _PantryMedicineArtwork3D extends StatelessWidget {
  const _PantryMedicineArtwork3D();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateZ(-0.20)
        ..rotateX(0.34)
        ..rotateY(-0.25),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 3D Fresh Milk Carton in Background
          Positioned(
            left: 4,
            bottom: 2,
            child: Container(
              width: 38,
              height: 58,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFE2E8F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                  bottom: Radius.circular(6),
                ),
                border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(4, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gable Roof Top
                  Container(
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF38BDF8),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
                    ),
                    child: const Center(
                      child: Icon(Icons.kitchen_rounded, color: Colors.white, size: 8),
                    ),
                  ),
                  // Freshness Cow / Leaf Badge
                  const Icon(Icons.eco_rounded, color: Color(0xFF10B981), size: 14),
                  // Expiry Date Strip
                  Container(
                    width: double.infinity,
                    color: const Color(0xFFFEF08A),
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: const Center(
                      child: Text(
                        'FRESH',
                        style: TextStyle(
                          fontSize: 6,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF854D0E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 3D Two-Tone Medicine Capsule Pill in Foreground
          Positioned(
            right: 2,
            bottom: 0,
            child: Transform.rotate(
              angle: 0.45,
              child: Container(
                width: 22,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withAlpha(80),
                      blurRadius: 10,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Red Half
                    Container(
                      height: 24,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF5252), Color(0xFFD32F2F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Center(
                        child: Icon(Icons.add, color: Colors.white, size: 9),
                      ),
                    ),
                    // Bottom White Half
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating Green Shield / Expiry Badge - Bigger & nestled close to components
          Positioned(
            top: 15,
            right: 18,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF10B981)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withAlpha(160),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.check_rounded, color: Colors.white, size: 16.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 4. IMAGE COMPRESSOR & PDF: 3D Photo Frame & Compact PDF Document Stack
// =============================================================
class _ImageCompressorArtwork3D extends StatelessWidget {
  const _ImageCompressorArtwork3D();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateZ(-0.22)
        ..rotateX(0.38)
        ..rotateY(-0.22),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 3D Photo Image Canvas (Background)
          Positioned(
            left: 2,
            bottom: 4,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(4, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(Icons.image_rounded, color: Colors.white, size: 22),
                ),
              ),
            ),
          ),
          // 3D Red PDF Sheet / Document (Foreground)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 48,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withAlpha(100),
                    blurRadius: 10,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Icon(Icons.compress_rounded, color: Colors.white, size: 7),
                    ],
                  ),
                  // Compression Indicator Badge
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Center(
                      child: Text(
                        '<100KB',
                        style: TextStyle(
                          color: Color(0xFFFFD54F),
                          fontSize: 6.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// 5. MICRO BUDGETER: 3D Cash Envelope & Money Runway Gauge
// =============================================================
class _MicroBudgeterArtwork3D extends StatelessWidget {
  const _MicroBudgeterArtwork3D();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateZ(-0.25)
        ..rotateX(0.40)
        ..rotateY(0.25),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Money Banknotes sliding out
          Positioned(
            top: -4,
            child: Container(
              width: 58,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF81C784), Color(0xFF388E3C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 1),
                  ),
                  child: const Center(
                    child: Text(
                      r'$',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 3D Cash Envelope Body
          Positioned(
            bottom: 0,
            child: Container(
              width: 66,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00E676), Color(0xFF00A152)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withAlpha(140), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E676).withAlpha(100),
                    blurRadius: 14,
                    offset: const Offset(2, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Envelope Flap Lines
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _EnvelopeFlapPainter(),
                    ),
                  ),
                  // Golden Seal Badge
                  Center(
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: const BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.savings_rounded, color: Colors.white, size: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnvelopeFlapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha(80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height * 0.55)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================
// 6. INTERVAL & REST TIMER: 3D Heavy Dumbbell & HIIT Timer
// =============================================================
class _IntervalTimerArtwork3D extends StatelessWidget {
  const _IntervalTimerArtwork3D();

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateZ(-0.20)
        ..rotateX(0.34)
        ..rotateY(0.18),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 3D Cast Shadow of the Dumbbell
          Positioned(
            left: 4,
            bottom: 2,
            child: Container(
              width: 74,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(45),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),

          // 3D Solid Metallic Dumbbell (Centerpiece Hero)
          Positioned(
            left: 2,
            bottom: 6,
            child: Transform.rotate(
              angle: -0.22,
              child: SizedBox(
                width: 78,
                height: 48,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Steel Bar with Chrome Reflections
                    Container(
                      width: 44,
                      height: 10,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFFFFF),
                            Color(0xFFCBD5E1),
                            Color(0xFF64748B),
                            Color(0xFF1E293B),
                            Color(0xFF94A3B8),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(3),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 1.5, height: 10, color: Colors.black26),
                          const SizedBox(width: 2),
                          Container(width: 1.5, height: 10, color: Colors.black26),
                          const SizedBox(width: 2),
                          Container(width: 1.5, height: 10, color: Colors.black26),
                        ],
                      ),
                    ),

                    // Left Collar Lock
                    Positioned(
                      left: 17,
                      child: Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Right Collar Lock
                    Positioned(
                      right: 17,
                      child: Container(
                        width: 4,
                        height: 16,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD54F), Color(0xFFFF8F00)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Left Weight Plate Stack
                    Positioned(
                      left: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Outer Plate (Smaller)
                          Container(
                            width: 10,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF312E81)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: const Color(0xFF818CF8), width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(-2, 3),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 1.5),
                          // Inner Plate (Larger)
                          Container(
                            width: 12,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF818CF8), Color(0xFF4338CA)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white70, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 8,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Right Weight Plate Stack
                    Positioned(
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Inner Plate (Larger)
                          Container(
                            width: 12,
                            height: 46,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF818CF8), Color(0xFF4338CA)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white70, width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 8,
                                  offset: Offset(2, 4),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 1.5),
                          // Outer Plate (Smaller)
                          Container(
                            width: 10,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6366F1), Color(0xFF312E81)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: const Color(0xFF818CF8), width: 1),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(2, 3),
                                ),
                              ],
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

          // 3D Floating Digital Stopwatch / Interval Badge (Top Right)
          Positioned(
            right: 0,
            top: 2,
            child: Container(
              width: 38,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF3366), Color(0xFFC2185B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF3366).withAlpha(140),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Crown Button on top
                  Positioned(
                    top: -3,
                    child: Container(
                      width: 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Inner LED display
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B4B),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFF80AB), width: 0.8),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt_rounded, color: Color(0xFFFFD700), size: 11),
                        Text(
                          '20s',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
