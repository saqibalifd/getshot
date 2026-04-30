import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';
import 'package:getshotapp/service/download_service.dart';

enum _DownloadStatus { downloading, success, error }

class DownloadProgressDialog extends StatefulWidget {
  final String imageUrl;
  final String title;

  const DownloadProgressDialog({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required String imageUrl,
    required String title,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (_) => DownloadProgressDialog(imageUrl: imageUrl, title: title),
    );
  }

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double _progress = 0.0;
  _DownloadStatus _status = _DownloadStatus.downloading;
  String _savedPath = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _startDownload();
  }

  Future<void> _startDownload() async {
    setState(() {
      _progress = 0.0;
      _status = _DownloadStatus.downloading;
      _errorMessage = '';
    });

    try {
      final String fileName = DownloadService.fileNameFromUrl(
        widget.imageUrl,
        fallback: '${widget.title}.png',
      );
      final String path = await DownloadService.downloadImage(
        url: widget.imageUrl,
        fileName: fileName,
        onProgress: (p) {
          if (mounted) setState(() => _progress = p);
        },
      );
      if (mounted) {
        setState(() {
          _savedPath = path;
          _status = _DownloadStatus.success;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _status = _DownloadStatus.error;
        });
      }
    }
  }

  Color get _accentColor =>
      _status == _DownloadStatus.error ? kRedColor : kPrimaryColor;

  @override
  Widget build(BuildContext context) {
    final bool isDone = _status != _DownloadStatus.downloading;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 360,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: kPrimaryColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top accent bar
              Container(
                height: 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kSecondaryColor, kPrimaryColor],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        _StatusIcon(status: _status),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _status == _DownloadStatus.success
                                ? 'Download complete'
                                : _status == _DownloadStatus.error
                                ? 'Download failed'
                                : 'Downloading...',
                            style: const TextStyle(
                              color: kWhiteColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Filename
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 12, color: kGreyColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 14),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: _status == _DownloadStatus.success
                            ? 1.0
                            : _progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.06),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _status == _DownloadStatus.error
                              ? kRedColor
                              : kPrimaryColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Progress meta row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              _status == _DownloadStatus.success
                                  ? '100%'
                                  : _status == _DownloadStatus.error
                                  ? 'Failed'
                                  : '${(_progress * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _accentColor,
                              ),
                            ),
                            if (_status == _DownloadStatus.downloading) ...[
                              const SizedBox(width: 8),
                              _SpeedBadge(label: '2.4 MB/s'),
                            ],
                          ],
                        ),
                        if (_status == _DownloadStatus.downloading)
                          Text(
                            '${(_progress * 30).toStringAsFixed(1)} / 30 MB',
                            style: const TextStyle(
                              fontSize: 11,
                              color: kGreyColor,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Success path
                    if (_status == _DownloadStatus.success) ...[
                      _InfoRow(
                        icon: Icons.folder_open_rounded,
                        label: _savedPath,
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Error message
                    if (_status == _DownloadStatus.error) ...[
                      _ErrorRow(message: _errorMessage),
                      const SizedBox(height: 4),
                    ],
                  ],
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isDone)
                      _GhostButton(
                        label: 'Cancel',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    if (_status == _DownloadStatus.error) ...[
                      const SizedBox(width: 8),
                      _DangerButton(label: 'Retry', onTap: _startDownload),
                    ],
                    if (isDone) ...[
                      if (_status == _DownloadStatus.error)
                        const SizedBox(width: 8),
                      _PrimaryButton(
                        label: 'Done',
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
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

// ── Sub-widgets ───────────────────────────────────────────────

class _StatusIcon extends StatelessWidget {
  final _DownloadStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color iconColor;
    final IconData icon;

    switch (status) {
      case _DownloadStatus.success:
        bg = kPrimaryColor.withValues(alpha: 0.12);
        iconColor = kPrimaryColor;
        icon = Icons.check_rounded;
        break;
      case _DownloadStatus.error:
        bg = kRedColor.withValues(alpha: 0.12);
        iconColor = kRedColor;
        icon = Icons.error_outline_rounded;
        break;
      case _DownloadStatus.downloading:
        bg = kPrimaryColor.withValues(alpha: 0.12);
        iconColor = kPrimaryColor;
        icon = Icons.cloud_download_rounded;
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 18),
    );
  }
}

class _SpeedBadge extends StatelessWidget {
  final String label;
  const _SpeedBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: kPrimaryColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: kPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: kGreyColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: kGreyColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorRow extends StatelessWidget {
  final String message;
  const _ErrorRow({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kRedColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kRedColor.withValues(alpha: 0.15)),
      ),
      child: Text(
        message,
        style: const TextStyle(fontSize: 12, color: kRedColor),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _GhostButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: kGreyColor,
        side: BorderSide(color: kPrimaryColor.withValues(alpha: 0.15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      child: Text(label),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kSecondaryColor, kPrimaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: kBackgroudColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _DangerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: kRedColor,
        backgroundColor: kRedColor.withValues(alpha: 0.08),
        side: BorderSide(color: kRedColor.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      child: Text(label),
    );
  }
}
