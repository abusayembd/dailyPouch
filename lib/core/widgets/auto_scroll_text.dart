import 'dart:async';
import 'package:flutter/material.dart';

/// A widget that automatically scrolls text horizontally if it exceeds available width.
/// If the text fits within the available space, it remains static.
class AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration pauseDuration;
  final double scrollSpeed; // pixels per second

  const AutoScrollText({
    super.key,
    required this.text,
    this.style,
    this.pauseDuration = const Duration(milliseconds: 1500),
    this.scrollSpeed = 28.0,
  });

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animController;
  Timer? _cycleTimer;
  double _maxScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animController = AnimationController(vsync: this);
    _animController.addListener(_onAnimate);
  }

  void _onAnimate() {
    if (_scrollController.hasClients && _maxScroll > 0) {
      _scrollController.jumpTo(_animController.value * _maxScroll);
    }
  }

  void _scheduleCycle() {
    _cycleTimer?.cancel();
    if (!mounted || _maxScroll <= 0) return;

    _cycleTimer = Timer(widget.pauseDuration, () {
      if (!mounted || _maxScroll <= 0) return;
      final duration = Duration(
        milliseconds: ((_maxScroll / widget.scrollSpeed) * 1000).toInt(),
      );
      _animController.duration = duration;
      _animController.forward().then((_) {
        if (!mounted || _maxScroll <= 0) return;
        _cycleTimer = Timer(widget.pauseDuration, () {
          if (!mounted || _maxScroll <= 0) return;
          _animController.reverse().then((_) {
            if (mounted && _maxScroll > 0) {
              _scheduleCycle();
            }
          });
        });
      });
    });
  }

  @override
  void didUpdateWidget(covariant AutoScrollText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _cycleTimer?.cancel();
      _animController.stop();
      _animController.value = 0;
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _animController.removeListener(_onAnimate);
    _animController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          maxLines: 1,
          textDirection: Directionality.of(context),
        )..layout(minWidth: 0, maxWidth: double.infinity);

        final textWidth = textPainter.width;
        final maxWidth = constraints.maxWidth;

        if (maxWidth.isFinite && textWidth <= maxWidth) {
          _maxScroll = 0.0;
          _cycleTimer?.cancel();
          _animController.stop();
          return Text(
            widget.text,
            style: widget.style,
            maxLines: 1,
          );
        }

        final newMaxScroll = (textWidth - maxWidth).clamp(0.0, double.infinity);
        if (_maxScroll != newMaxScroll) {
          _maxScroll = newMaxScroll;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _scheduleCycle();
          });
        }

        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Text(
            widget.text,
            style: widget.style,
            maxLines: 1,
          ),
        );
      },
    );
  }
}
