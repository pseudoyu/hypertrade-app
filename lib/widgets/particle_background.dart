import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;
  final int particleCount;
  final List<Color> colors;

  const ParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.colors = const [
      Color(0xFF00D4FF),
      Color(0xFF00FF88),
      Color(0xFF8B5CF6),
    ],
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15), // 调整为15秒，让动画更明显
      vsync: this,
    )..repeat();

    _initializeParticles();
  }

  void _initializeParticles() {
    particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 6 + 2, // 增大粒子大小：2-8像素
        speed: random.nextDouble() * 0.3 + 0.05, // 稍微减慢速度，更平滑
        color: widget.colors[random.nextInt(widget.colors.length)],
        opacity: random.nextDouble() * 0.5 + 0.3, // 增加透明度：0.3-0.8
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(particles, _controller.value),
                child: Container(), // 确保CustomPaint有明确的大小
              );
            },
          ),
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final Color color;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.opacity,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // 确保size有效
    if (size.width <= 0 || size.height <= 0) return;

    for (var particle in particles) {
      // 更新粒子位置 - 垂直向上漂浮，水平轻微摆动
      final progress = (animationValue + particle.speed * 0.5) % 1.0;
      final currentY = (particle.y + progress) % 1.0;
      final currentX =
          particle.x + sin(animationValue * pi + particle.y * 5) * 0.05;

      // 确保粒子在屏幕范围内
      final x = (currentX.clamp(0.0, 1.0)) * size.width;
      final y = currentY * size.height;

      // 绘制主粒子
      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint,
      );

      // 绘制发光效果
      final glowPaint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(
        Offset(x, y),
        particle.size * 1.5,
        glowPaint,
      );

      // 添加额外的外层光晕
      final outerGlowPaint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity * 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(
        Offset(x, y),
        particle.size * 2.5,
        outerGlowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
