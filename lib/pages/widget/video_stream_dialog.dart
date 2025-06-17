import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pill_line_a_i/controllers/socket_controller.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_locator.dart';

class VideoStreamDialog extends StatefulWidget {
  final VoidCallback onClose;

  const VideoStreamDialog({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<VideoStreamDialog> createState() => _VideoStreamDialogState();
}

class _VideoStreamDialogState extends State<VideoStreamDialog> {
  final socketController = serviceLocator<SocketController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.width * 0.85 * 9 / 16,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Video frame
            StreamBuilder<Uint8List>(
              stream: socketController.videoFrameStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      gaplessPlayback: true, // Prevents flickering
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Connecting to stream...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Close button
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: widget.onClose,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
