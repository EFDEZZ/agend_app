import 'dart:math';
import 'package:flutter/material.dart';

class RippleAnimation extends StatefulWidget {
  final Color color;
  const RippleAnimation({super.key, this.color = Colors.blue});

  @override
  State<RippleAnimation> createState() => RippleAnimationState();
}

class RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Animation<double>> _waveAnimations = [];
  late Animation<double> _pulseAnimation;
  
  Color _withPreciseOpacity(Color color, double opacity) {
    return color.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();

    // Configuración para 3 ondas con delays escalonados
    for (var i = 0; i < 1; i++) {
      _waveAnimations.add(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i * 0.1, // Espaciado entre ondas
            1.0,
            curve: Curves.easeOutQuad,
          ),
        ),
      );
    }

    // Animación de pulsación para el botón central
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.05), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ondas de ripple
        ..._waveAnimations.map((animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              // Cálculo no lineal para crecimiento más orgánico
              final waveProgress = animation.value;
              final size = 60.0 + (pow(waveProgress, 0.8) * 60);

              // Curva personalizada para opacidad
              final opacity =
                  0.45 * (1 - pow(waveProgress, 1.2)).clamp(0.0, 0.2);

              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _withPreciseOpacity(widget.color, opacity),
                  boxShadow: [
                    BoxShadow(
                      color: _withPreciseOpacity(widget.color, opacity * 0.4),
                      blurRadius: 10 * waveProgress,
                      spreadRadius: 2 * waveProgress,
                    ),
                  ],
                ),
              );
            },
          );
        }),

        // Botón con efecto de pulsación
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _pulseAnimation.value, child: child);
          },
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Icon(Icons.add, size: 36, color: Theme.of(context).colorScheme.surface),
          ),
        ),
      ],
    );
  }
}

