import 'package:flutter/material.dart';

class AnimatedGlowTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool enabled;
  final Color glowColor;

  const AnimatedGlowTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.glowColor = const Color(0xFF00D4FF),
  });

  @override
  State<AnimatedGlowTextField> createState() => _AnimatedGlowTextFieldState();
}

class _AnimatedGlowTextFieldState extends State<AnimatedGlowTextField>
    with TickerProviderStateMixin {
  late AnimationController _focusController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late Animation<Color?> _borderAnimation;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.1,
      end: 0.3,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _borderAnimation = ColorTween(
      begin: const Color(0xFF2A2D3A),
      end: widget.glowColor,
    ).animate(CurvedAnimation(
      parent: _focusController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _focusController.forward();
      } else {
        _focusController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _focusController.dispose();
    _glowController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_focusController, _glowAnimation]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _borderAnimation.value ?? const Color(0xFF2A2D3A),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: _glowAnimation.value),
                blurRadius: 8 + (_focusController.value * 12),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: widget.labelText,

              labelStyle: TextStyle(
                color:
                    _focusNode.hasFocus ? widget.glowColor : Colors.grey[400],
                fontSize: 16,
                backgroundColor: const Color(0xFF1A1B23),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always, // 始终保持标签可见
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: const Color(0xFF1A1B23),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            keyboardType: widget.keyboardType,
            autocorrect: false,
            enabled: widget.enabled,
          ),
        );
      },
    );
  }
}
