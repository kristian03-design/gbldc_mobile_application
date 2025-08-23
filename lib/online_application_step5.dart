import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'online_application_step5_nextscreen.dart';
import 'package:iconsax/iconsax.dart';
import 'main.dart'; // Ensure you have a global 'cameras' list here

class SelfieWithIDCardScreen extends StatefulWidget {
  final File? frontIdImage;
  final File? backIdImage;

  const SelfieWithIDCardScreen({
    super.key,
    this.frontIdImage,
    this.backIdImage,
  });

  @override
  State<SelfieWithIDCardScreen> createState() => _SelfieWithIDCardScreenState();
}

class _SelfieWithIDCardScreenState extends State<SelfieWithIDCardScreen> {
  bool _isLoading = false;

  /// Open custom camera overlay with real-time detection
  Future<void> _openCamera() async {
    setState(() => _isLoading = true);
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => const CustomSelfieOverlayCamera(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
        Container(
          margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            "Step 5 of 6",
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LinearProgressIndicator(
                value: 0.9,
                color: Colors.green,
                backgroundColor: Color(0xFFE0E0E0),
              ),
              const SizedBox(height: 24),
              const Text(
                "Selfie with ID Card",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              const Text(
                "Align your face and ID card within the frame for verification.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Instruction Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.blueGrey.withOpacity(0.2)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.tick_circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Make sure your face and ID are clearly visible.",
                            style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Iconsax.tick_circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Use good lighting and a plain background.",
                            style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Iconsax.danger, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Avoid covering ID details or face.",
                            style: TextStyle(fontSize: 14, color: Colors.blueGrey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Take Selfie Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _openCamera,
                  icon: _isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(Iconsax.camera, color: Colors.white),
                  label: Text(
                    _isLoading ? "Opening Camera..." : "Take Selfie",
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSelfieOverlayCamera extends StatefulWidget {
  const CustomSelfieOverlayCamera({super.key});

  @override
  State<CustomSelfieOverlayCamera> createState() => _CustomSelfieOverlayCameraState();
}

class _CustomSelfieOverlayCameraState extends State<CustomSelfieOverlayCamera>
    with TickerProviderStateMixin {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRearCameraSelected = false;

  // Simulated detection results
  bool _faceDetected = false;
  bool _idDetected = false;
  String _statusMessage = "Position your face and ID card in the frame";
  Color _statusColor = Colors.orange;
  bool _canCapture = false;

  // Animation controllers for simulated detection
  late AnimationController _detectionController;
  late AnimationController _pulseController;

  // Simulated detection areas
  Rect? _faceRect;
  Rect? _idRect;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initCamera();
    _startSimulatedDetection();
  }

  void _initializeAnimations() {
    _detectionController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _startSimulatedDetection() {
    // Simulate detection process over time
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _faceDetected = true;
          _updateDetectionStatus();
          _updateSimulatedAreas();
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        setState(() {
          _idDetected = true;
          _updateDetectionStatus();
          _updateSimulatedAreas();
        });
      }
    });
  }

  void _updateSimulatedAreas() {
    // Simulate detection areas for visual feedback
    if (_faceDetected) {
      _faceRect = const Rect.fromLTWH(150, 200, 120, 150);
    }

    if (_idDetected) {
      _idRect = const Rect.fromLTWH(200, 400, 160, 100);
    }
  }

  Future<void> _initCamera([CameraLensDirection? preferredDirection]) async {
    CameraLensDirection direction = preferredDirection ??
        (_isRearCameraSelected ? CameraLensDirection.back : CameraLensDirection.front);

    CameraDescription? selectedCamera;
    try {
      selectedCamera = cameras.firstWhere((cam) => cam.lensDirection == direction);
    } catch (e) {
      direction = (direction == CameraLensDirection.front) ? CameraLensDirection.back : CameraLensDirection.front;
      try {
        selectedCamera = cameras.firstWhere((cam) => cam.lensDirection == direction);
      } catch (e) {
        selectedCamera = cameras.isNotEmpty ? cameras.first : null;
      }
    }

    if (selectedCamera == null) return;

    _controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller?.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _updateDetectionStatus() {
    if (_faceDetected && _idDetected) {
      _statusMessage = "Perfect! Both face and ID detected";
      _statusColor = Colors.green;
      _canCapture = true;
      _detectionController.forward();
    } else if (_faceDetected && !_idDetected) {
      _statusMessage = "Face detected. Please show your ID card";
      _statusColor = Colors.orange;
      _canCapture = false;
    } else if (!_faceDetected && _idDetected) {
      _statusMessage = "ID detected. Please position your face";
      _statusColor = Colors.orange;
      _canCapture = false;
    } else {
      _statusMessage = "Position your face and ID card in the frame";
      _statusColor = Colors.red;
      _canCapture = false;
    }
  }

  Future<void> _takePicture() async {
    if (!_canCapture) return;

    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, __, ___) => SelfiePreviewScreen(
            selfie: File(image.path),
            isFrontCamera: _controller?.description.lensDirection == CameraLensDirection.front,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (e) {
      debugPrint("Error taking selfie: $e");
    }
  }

  void _toggleCamera() {
    _isRearCameraSelected = !_isRearCameraSelected;
    _controller?.dispose();
    _initCamera(_isRearCameraSelected ? CameraLensDirection.back : CameraLensDirection.front);

    // Reset detection when switching cameras
    setState(() {
      _faceDetected = false;
      _idDetected = false;
      _canCapture = false;
      _faceRect = null;
      _idRect = null;
      _updateDetectionStatus();
    });

    // Restart simulated detection
    _startSimulatedDetection();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _detectionController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          FutureBuilder(
            future: _initializeControllerFuture,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller!);
              }
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            },
          ),

          // Simulated Detection Overlays
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return CustomPaint(
                painter: SimulatedDetectionPainter(
                  faceRect: _faceRect,
                  idRect: _idRect,
                  faceDetected: _faceDetected,
                  idDetected: _idDetected,
                  animationValue: _pulseController.value,
                ),
                size: Size.infinite,
              );
            },
          ),

          // GCash-style Frame Overlay with Dynamic Color
          LayoutBuilder(builder: (context, constraints) {
            double frameWidth = constraints.maxWidth * 0.85;
            double frameHeight = constraints.maxHeight * 0.7;
            double left = (constraints.maxWidth - frameWidth) / 2;
            double top = (constraints.maxHeight - frameHeight) / 3;

            return Stack(
              children: [
                // Dark overlay
                Container(color: Colors.black.withOpacity(0.6)),

                // Transparent frame area
                Positioned(
                  left: left,
                  top: top,
                  child: Container(
                    width: frameWidth,
                    height: frameHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: _canCapture ? Colors.green : Colors.orange,
                          width: 3
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),

                // Corner indicators
                ...List.generate(4, (index) {
                  double cornerSize = 30;
                  double cornerLeft = index % 2 == 0 ? left - 10 : left + frameWidth - cornerSize + 10;
                  double cornerTop = index < 2 ? top - 10 : top + frameHeight - cornerSize + 10;

                  return Positioned(
                    left: cornerLeft,
                    top: cornerTop,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: cornerSize,
                          height: cornerSize,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _canCapture
                                  ? Colors.green.withOpacity(0.8 + 0.2 * _pulseController.value)
                                  : Colors.orange.withOpacity(0.8 + 0.2 * _pulseController.value),
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            );
          }),

          // Status Message
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: _statusColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _canCapture ? Icons.check_circle : Icons.info_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _statusMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Detection Status Indicators
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatusIndicator("Face", _faceDetected),
                _buildStatusIndicator("ID Card", _idDetected),
              ],
            ),
          ),

          // Enhanced Capture Button with Animation
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                      width: 80 + (_canCapture ? 5 * _pulseController.value : 0),
                      height: 80 + (_canCapture ? 5 * _pulseController.value : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: _canCapture ? Colors.green : Colors.grey,
                            width: 4
                        ),
                        color: _canCapture
                            ? Colors.green.withOpacity(0.3 + 0.2 * _pulseController.value)
                            : Colors.grey.withOpacity(0.3),
                        boxShadow: _canCapture ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            blurRadius: 20 * _pulseController.value,
                            spreadRadius: 5 * _pulseController.value,
                          ),
                        ] : null,
                      ),
                      child: Icon(
                          Icons.camera_alt,
                          color: _canCapture ? Colors.white : Colors.grey[400],
                          size: 32
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Toggle Camera Button
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  _isRearCameraSelected ? Icons.camera_front : Icons.camera_rear,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: _toggleCamera,
              ),
            ),
          ),

          // Instructions overlay (appears initially)
          if (!_faceDetected && !_idDetected)
            Positioned(
              bottom: 120,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "📱 Hold your phone at eye level",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "🆔 Show your ID card next to your face",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String label, bool isDetected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDetected ? Colors.green : Colors.red,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isDetected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDetected ? Colors.green : Colors.red,
              size: 18,
              key: ValueKey(isDetected),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isDetected ? Colors.green : Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom Painter for Simulated Detection Overlays
class SimulatedDetectionPainter extends CustomPainter {
  final Rect? faceRect;
  final Rect? idRect;
  final bool faceDetected;
  final bool idDetected;
  final double animationValue;

  SimulatedDetectionPainter({
    this.faceRect,
    this.idRect,
    required this.faceDetected,
    required this.idDetected,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw face detection box
    if (faceDetected && faceRect != null) {
      paint.color = Colors.green.withOpacity(0.8 + 0.2 * animationValue);
      canvas.drawRRect(
        RRect.fromRectAndRadius(faceRect!, const Radius.circular(12)),
        paint,
      );

      // Draw corner indicators for face
      _drawCornerIndicators(canvas, faceRect!, Colors.green, animationValue);
    }

    // Draw ID detection box
    if (idDetected && idRect != null) {
      paint.color = Colors.blue.withOpacity(0.8 + 0.2 * animationValue);
      canvas.drawRRect(
        RRect.fromRectAndRadius(idRect!, const Radius.circular(8)),
        paint,
      );

      // Draw corner indicators for ID
      _drawCornerIndicators(canvas, idRect!, Colors.blue, animationValue);
    }
  }

  void _drawCornerIndicators(Canvas canvas, Rect rect, Color color, double animation) {
    final paint = Paint()
      ..color = color.withOpacity(0.9)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const cornerLength = 15.0;

    // Top-left corner
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.topLeft,
      rect.topLeft + const Offset(0, cornerLength),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(-cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.topRight + const Offset(0, cornerLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomLeft + const Offset(0, -cornerLength),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(-cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      rect.bottomRight,
      rect.bottomRight + const Offset(0, -cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}