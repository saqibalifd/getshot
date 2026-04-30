import 'package:flutter/material.dart';

/// A stunning grid card for desktop apps — takes only [imageUrl] and [title].
/// Drop it into a GridView and enjoy.
class GridCardWidget extends StatefulWidget {
  const GridCardWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    this.onDownload,
    this.onView,
  });

  final String imageUrl;
  final String title;
  final VoidCallback? onDownload;
  final VoidCallback? onView;

  @override
  State<GridCardWidget> createState() => _GridCardWidgetState();
}

class _GridCardWidgetState extends State<GridCardWidget>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _shimmer = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => _hovered = true);
    _ctrl.forward();
  }

  void _onExit(_) {
    setState(() => _hovered = false);
    _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: _CardBody(
          imageUrl: widget.imageUrl,
          title: widget.title,
          hovered: _hovered,
          shimmerProgress: _shimmer.value,
          onDownload: widget.onDownload,
          onView: widget.onView,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
// Internal card body — stateless, driven by parent state
// ─────────────────────────────────────────────────────────
class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.imageUrl,
    required this.title,
    required this.hovered,
    required this.shimmerProgress,
    this.onDownload,
    this.onView,
  });

  final String imageUrl;
  final String title;
  final bool hovered;
  final double shimmerProgress;
  final VoidCallback? onDownload;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // Ambient shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: hovered ? 0.35 : 0.18),
            blurRadius: hovered ? 40 : 20,
            spreadRadius: hovered ? 2 : 0,
            offset: const Offset(0, 8),
          ),
          // Inner glow on hover
          if (hovered)
            BoxShadow(
              color: const Color(0xFFE8C97A).withValues(alpha: 0.12),
              blurRadius: 60,
              spreadRadius: -4,
              offset: const Offset(0, -4),
            ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onView,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Background image ──────────────────────
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: const Color(0xFF1A1A2E),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFFE8C97A),
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF1A1A2E),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Color(0xFF4A4A6A),
                    size: 48,
                  ),
                ),
              ),

              // ── 2. Gradient vignette ─────────────────────
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.75),
                      Colors.black.withValues(alpha: 0.92),
                    ],
                    stops: const [0.0, 0.45, 0.78, 1.0],
                  ),
                ),
              ),

              // ── 3. Shimmer highlight on hover ────────────
              AnimatedOpacity(
                opacity: hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.08),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── 4. Gold top-edge line ────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: hovered
                          ? [
                              Colors.transparent,
                              const Color(0xFFE8C97A),
                              const Color(0xFFF5E6A3),
                              const Color(0xFFE8C97A),
                              Colors.transparent,
                            ]
                          : [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                    ),
                  ),
                ),
              ),

              // ── 5. Download button (top-right) ───────────
              Positioned(
                top: 12,
                right: 12,
                child: AnimatedOpacity(
                  opacity: hovered ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: AnimatedSlide(
                    offset: hovered ? Offset.zero : const Offset(0, -0.3),
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    child: _DownloadButton(onTap: onDownload),
                  ),
                ),
              ),

              // ── 6. Title label ───────────────────────────
              Positioned(
                left: 16,
                right: 16,
                bottom: 18,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated underline accent
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: hovered ? 32 : 0,
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8C97A),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                        height: 1.35,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.6),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
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
    );
  }
}

// ─────────────────────────────────────────────────────────
// Download button — glassmorphism pill with gold icon
// ─────────────────────────────────────────────────────────
class _DownloadButton extends StatefulWidget {
  const _DownloadButton({this.onTap});
  final VoidCallback? onTap;

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _done = false;
  late final AnimationController _bounceCtrl;
  late final Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _bounce = Tween<double>(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bounceCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _bounceCtrl.forward();
    await _bounceCtrl.reverse();

    setState(() => _done = true);
    widget.onTap?.call();

    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) setState(() => _done = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          _handleTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedBuilder(
          animation: _bounceCtrl,
          builder: (_, __) => Transform.scale(
            scale: _bounce.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: _done
                    ? const Color(0xFFE8C97A).withValues(alpha: 0.22)
                    : Colors.white.withValues(alpha: _pressed ? 0.18 : 0.12),
                border: Border.all(
                  color: _done
                      ? const Color(0xFFE8C97A).withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _done
                        ? const Color(0xFFE8C97A).withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: _done
                        ? const Icon(
                            Icons.check_rounded,
                            key: ValueKey('check'),
                            color: Color(0xFFE8C97A),
                            size: 15,
                          )
                        : const Icon(
                            Icons.download_rounded,
                            key: ValueKey('dl'),
                            color: Colors.white,
                            size: 15,
                          ),
                  ),
                  const SizedBox(width: 6),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                      color: _done ? const Color(0xFFE8C97A) : Colors.white,
                    ),
                    child: Text(_done ? 'Saved!' : 'Download'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
