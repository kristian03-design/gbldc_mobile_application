import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'online_application_step5.dart';
import 'package:iconsax/iconsax.dart';
import 'main.dart'; // global 'cameras' list

class NextScreen extends StatefulWidget {
  final File imageFile;
  final bool isFrontCamera;
  final bool isBackSide; // New parameter to identify if this is the back side
  final File? frontIdImage; // Store the front ID image when capturing back side

  const NextScreen({
    super.key,
    required this.imageFile,
    this.isFrontCamera = false,
    this.isBackSide = false,
    this.frontIdImage,
  });

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  File? _frontIdImage;
  File? _backIdImage;

  @override
  void initState() {
    super.initState();

    // Initialize images based on which side we're currently viewing
    if (widget.isBackSide) {
      _frontIdImage = widget.frontIdImage;
      _backIdImage = widget.imageFile;
    } else {
      _frontIdImage = widget.imageFile;
      _backIdImage = null;
    }
  }

  void _proceedToNextStep() {
    if (_frontIdImage != null && _backIdImage != null) {
      // Both sides captured, proceed to next screen
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, _) => SelfieWithIDCardScreen(
            frontIdImage: _frontIdImage!,
            backIdImage: _backIdImage!,
          ),
          transitionsBuilder: (context, animation, _, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut
              ),
              child: child,
            );
          },
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture both front and back of your ID'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildIdPreviewCard({
    required String title,
    required String subtitle,
    required File? imageFile,
    required VoidCallback onTap,
    required IconData icon,
    bool isCompleted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? Colors.green.shade200 : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Image preview or placeholder
              Container(
                width: 100,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: imageFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: widget.isFrontCamera
                        ? Matrix4.rotationY(3.14159)
                        : Matrix4.identity(),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    : Icon(
                  icon,
                  size: 24,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isCompleted)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Action icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.shade50 : Colors.grey.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Iconsax.edit : Iconsax.camera,
                  size: 20,
                  color: isCompleted ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool bothSidesCaptured = _frontIdImage != null && _backIdImage != null;
    final double progressValue = _frontIdImage != null
        ? (_backIdImage != null ? 0.9 : 0.75)
        : 0.7;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
              "Step 4 of 6",
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
        child: Column(
          children: [
            // Header section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: progressValue,
                    color: Colors.green,
                    backgroundColor: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "ID Verification",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Please capture both sides of your ID for verification.",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Content section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Front ID Card
                    _buildIdPreviewCard(
                      title: "Front Side",
                      subtitle: _frontIdImage != null
                          ? "Captured successfully"
                          : "Tap to capture front side",
                      imageFile: _frontIdImage,
                      onTap: () {
                        Navigator.pop(context); // Go back to capture front again
                      },
                      icon: Iconsax.card,
                      isCompleted: _frontIdImage != null,
                    ),

                    // Back ID Card
                    _buildIdPreviewCard(
                      title: "Back Side",
                      subtitle: _backIdImage != null
                          ? "Captured successfully"
                          : "Tap to capture back side",
                      imageFile: _backIdImage,
                      onTap: () async {
                        // Navigate to full camera screen for back ID capture
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BackIDCameraScreen(
                              frontIdImage: _frontIdImage!,
                            ),
                          ),
                        );

                        if (result != null && result is File) {
                          setState(() {
                            _backIdImage = result;
                          });
                        }
                      },
                      icon: Iconsax.card,
                      isCompleted: _backIdImage != null,
                    ),

                    // Progress indicator
                    if (!bothSidesCaptured) ...[
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Iconsax.info_circle,
                                color: Colors.blue.shade600, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Please capture both sides of your ID to continue.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // Bottom buttons
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: bothSidesCaptured ? _proceedToNextStep : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bothSidesCaptured
                            ? Colors.green
                            : Colors.grey.shade300,
                        foregroundColor: bothSidesCaptured
                            ? Colors.white
                            : Colors.grey.shade500,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: bothSidesCaptured ? 2 : 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: bothSidesCaptured
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: bothSidesCaptured
                                  ? Colors.white
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (!bothSidesCaptured) ...[
                    const SizedBox(height: 12),
                    Text(
                      "Complete both sides to continue",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Back ID Camera Screen - Full implementation like your front side camera
class BackIDCameraScreen extends StatefulWidget {
  final File frontIdImage;

  const BackIDCameraScreen({
    super.key,
    required this.frontIdImage,
  });

  @override
  State<BackIDCameraScreen> createState() => _BackIDCameraScreenState();
}

class _BackIDCameraScreenState extends State<BackIDCameraScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              "Step 4 of 6",
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
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            const LinearProgressIndicator(
              value: 0.75,
              color: Colors.green,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 24),
            const Text(
              "Upload Back of Your ID",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "Position the back side of your ID within the frame. The camera will automatically capture when properly aligned.",
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.green.shade200, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("• Flip your ID to show the back side.",
                      style: TextStyle(fontSize: 14, color: Colors.black87)),
                  SizedBox(height: 8),
                  Text("• Place your ID on a flat, well-lit surface.",
                      style: TextStyle(fontSize: 14, color: Colors.black87)),
                  SizedBox(height: 8),
                  Text("• Make sure all details are clear and readable.",
                      style: TextStyle(fontSize: 14, color: Colors.black87)),
                  SizedBox(height: 8),
                  Text("• Avoid glare and shadows on the ID.",
                      style: TextStyle(fontSize: 14, color: Colors.black87)),
                  SizedBox(height: 8),
                  Text("• Hold steady - auto-capture will activate when aligned.",
                      style: TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📷 Start Auto-Capture
            ElevatedButton.icon(
              onPressed: _isLoading
                  ? null
                  : () async {
                setState(() => _isLoading = true);
                Timer(const Duration(milliseconds: 1000), () async {
                  if (mounted) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BackIDCameraOverlay(
                            frontIdImage: widget.frontIdImage,
                          )),
                    );
                    if (mounted) {
                      setState(() => _isLoading = false);
                      if (result != null) {
                        Navigator.pop(context, result);
                      }
                    }
                  }
                });
              },
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
                _isLoading ? "Opening Camera..." : "Take Back ID Photo",
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Back ID Camera Overlay - Identical to your front side camera
class BackIDCameraOverlay extends StatefulWidget {
  final File frontIdImage;

  const BackIDCameraOverlay({
    super.key,
    required this.frontIdImage,
  });

  @override
  State<BackIDCameraOverlay> createState() => _BackIDCameraOverlayState();
}

class _BackIDCameraOverlayState extends State<BackIDCameraOverlay>
    with TickerProviderStateMixin {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isBackCameraSelected = true; // Start with back camera for ID scanning

  // Edge detection variables
  Timer? _frameAnalysisTimer;
  bool _isProcessingFrame = false;
  bool _isIdDetected = false;
  int _consecutiveDetections = 0;
  static const int _requiredConsecutiveDetections = 3;
  bool _isCapturing = false;
  bool _isTakingPicture = false; // New flag to prevent concurrent captures

  // Animation controllers
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  String _statusMessage = "Position the back of your ID within the frame";
  Color _frameColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initCamera();
  }

  void _initAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initCamera() async {
    try {
      if (cameras.isEmpty) {
        debugPrint("❌ No cameras found.");
        if (mounted) {
          setState(() {
            _statusMessage = "No camera available";
            _frameColor = Colors.red;
          });
        }
        return;
      }

      CameraDescription selectedCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == (_isBackCameraSelected
            ? CameraLensDirection.back
            : CameraLensDirection.front),
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture!;

      if (mounted) {
        setState(() {});
        _startFrameAnalysis();
      }
    } catch (e) {
      debugPrint("Camera initialization error: $e");
      if (mounted) {
        setState(() {
          _statusMessage = "Camera initialization failed";
          _frameColor = Colors.red;
        });
      }
    }
  }

  void _startFrameAnalysis() {
    _frameAnalysisTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isProcessingFrame &&
          _controller != null &&
          _controller!.value.isInitialized &&
          !_isCapturing &&
          !_isTakingPicture) {
        _processFrame();
      }
    });
  }

  Future<void> _processFrame() async {
    if (_isProcessingFrame ||
        _controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture ||
        _isTakingPicture ||
        _isCapturing) return;

    _isProcessingFrame = true;
    _isTakingPicture = true;

    XFile? image;
    File? imageFile;

    try {
      // Take picture for analysis
      image = await _controller!.takePicture();
      imageFile = File(image.path);

      if (!await imageFile.exists()) {
        debugPrint("Image file does not exist: ${image.path}");
        return;
      }

      final bytes = await imageFile.readAsBytes();
      if (bytes.isEmpty) {
        debugPrint("Empty image file");
        return;
      }

      // Decode image
      final decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) {
        debugPrint("Failed to decode image");
        return;
      }

      // Perform edge detection
      final hasValidEdges = await _detectRectangularShape(decodedImage);

      if (mounted) {
        setState(() {
          if (hasValidEdges) {
            _consecutiveDetections++;
            _isIdDetected = true;
            _frameColor = Colors.green;
            _statusMessage = "Back ID detected! Hold steady... (${_consecutiveDetections}/${_requiredConsecutiveDetections})";

            if (!_progressController.isAnimating) {
              _progressController.forward();
            }
            if (!_pulseController.isAnimating) {
              _pulseController.repeat(reverse: true);
            }

            // Auto-capture after consecutive detections
            if (_consecutiveDetections >= _requiredConsecutiveDetections) {
              _triggerAutoCapture();
            }
          } else {
            _consecutiveDetections = 0;
            _isIdDetected = false;
            _frameColor = Colors.white;
            _statusMessage = "Position the back of your ID within the frame";

            _progressController.reset();
            _pulseController.stop();
            _pulseController.reset();
          }
        });
      }

    } catch (e) {
      debugPrint("Frame processing error: $e");
      if (mounted) {
        setState(() {
          _statusMessage = "Processing error. Try adjusting position.";
          _frameColor = Colors.orange;
        });
      }
    } finally {
      // Clean up temporary file
      if (imageFile != null) {
        try {
          await imageFile.delete();
        } catch (e) {
          debugPrint("File deletion error: $e");
        }
      }
      _isProcessingFrame = false;
      _isTakingPicture = false;
    }
  }

  Future<bool> _detectRectangularShape(img.Image image) async {
    try {
      final resized = img.copyResize(image, width: 640);
      final grayscale = img.grayscale(resized);
      final blurred = img.gaussianBlur(grayscale, radius: 2);
      final edges = _applySobelEdgeDetection(blurred);
      return _analyzeFrameArea(edges);
    } catch (e) {
      debugPrint("Edge detection error: $e");
      return false;
    }
  }

  img.Image _applySobelEdgeDetection(img.Image image) {
    final result = img.Image(width: image.width, height: image.height);
    final sobelX = [[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]];
    final sobelY = [[-1, -2, -1], [0, 0, 0], [1, 2, 1]];

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        double gx = 0, gy = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            final pixel = image.getPixel(x + j, y + i);
            final intensity = img.getLuminance(pixel) / 255.0;
            gx += intensity * sobelX[i + 1][j + 1];
            gy += intensity * sobelY[i + 1][j + 1];
          }
        }
        final magnitude = (gx * gx + gy * gy).clamp(0.0, 1.0);
        final edgeValue = (magnitude * 255).round();
        final edgePixel = img.ColorRgb8(edgeValue, edgeValue, edgeValue);
        result.setPixel(x, y, edgePixel);
      }
    }
    return result;
  }

  bool _analyzeFrameArea(img.Image edges) {
    final width = edges.width;
    final height = edges.height;
    final frameLeft = (width * 0.2).round();
    final frameRight = (width * 0.8).round();
    final frameTop = (height * 0.25).round();
    final frameBottom = (height * 0.75).round();

    int edgePixels = 0;
    int totalPixels = 0;

    for (int y = frameTop; y < frameBottom; y++) {
      for (int x = frameLeft; x < frameRight; x++) {
        final pixel = edges.getPixel(x, y);
        final intensity = img.getLuminance(pixel);
        if (intensity > 128) edgePixels++;
        totalPixels++;
      }
    }

    final edgeDensity = totalPixels > 0 ? edgePixels / totalPixels : 0.0;
    final hasHorizontalEdges = _hasStrongHorizontalEdges(edges, frameLeft, frameRight, frameTop, frameBottom);
    final hasVerticalEdges = _hasStrongVerticalEdges(edges, frameLeft, frameRight, frameTop, frameBottom);

    return edgeDensity > 0.15 && edgeDensity < 0.6 && hasHorizontalEdges && hasVerticalEdges;
  }

  bool _hasStrongHorizontalEdges(img.Image edges, int left, int right, int top, int bottom) {
    int strongEdges = 0;
    final threshold = (right - left) * 0.3;
    for (int x = left; x < right; x++) {
      if (img.getLuminance(edges.getPixel(x, top)) > 128 ||
          img.getLuminance(edges.getPixel(x, bottom - 1)) > 128) {
        strongEdges++;
      }
    }
    return strongEdges > threshold;
  }

  bool _hasStrongVerticalEdges(img.Image edges, int left, int right, int top, int bottom) {
    int strongEdges = 0;
    final threshold = (bottom - top) * 0.3;
    for (int y = top; y < bottom; y++) {
      if (img.getLuminance(edges.getPixel(left, y)) > 128 ||
          img.getLuminance(edges.getPixel(right - 1, y)) > 128) {
        strongEdges++;
      }
    }
    return strongEdges > threshold;
  }

  Future<void> _triggerAutoCapture() async {
    if (_isCapturing || _isTakingPicture) return;

    _isCapturing = true;
    _isTakingPicture = true;
    _frameAnalysisTimer?.cancel();

    setState(() {
      _statusMessage = "📸 Capturing back side...";
      _frameColor = Colors.green;
    });

    _pulseController.stop();
    _progressController.stop();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted || _controller == null || !_controller!.value.isInitialized) return;

      final finalImage = await _controller!.takePicture();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) =>
                NextScreen(
                  imageFile: File(finalImage.path),
                  isFrontCamera: !_isBackCameraSelected,
                  isBackSide: true,
                  frontIdImage: widget.frontIdImage,
                ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    } catch (e) {
      debugPrint("Auto-capture error: $e");
      if (mounted) {
        setState(() {
          _isCapturing = false;
          _isTakingPicture = false;
          _statusMessage = "Capture failed. Try again.";
          _frameColor = Colors.red;
          _consecutiveDetections = 0;
          _isIdDetected = false;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_isCapturing) {
            _startFrameAnalysis();
            setState(() {
              _statusMessage = "Position the back of your ID within the frame";
              _frameColor = Colors.white;
            });
          }
        });
      }
    }
  }

  void _toggleCamera() {
    _frameAnalysisTimer?.cancel();
    setState(() {
      _isBackCameraSelected = !_isBackCameraSelected;
      _consecutiveDetections = 0;
      _isIdDetected = false;
      _frameColor = Colors.white;
      _statusMessage = "Position the back of your ID within the frame";
      _isCapturing = false;
      _isTakingPicture = false;
    });
    _pulseController.stop();
    _progressController.reset();
    _initCamera();
  }

  Future<void> _manualCapture() async {
    if (_isCapturing ||
        _isTakingPicture ||
        _controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.isTakingPicture) return;

    setState(() {
      _isTakingPicture = true;
      _isCapturing = true;
      _statusMessage = "📸 Taking picture...";
    });

    _frameAnalysisTimer?.cancel();

    try {
      final image = await _controller!.takePicture();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) =>
                NextScreen(
                  imageFile: File(image.path),
                  isFrontCamera: !_isBackCameraSelected,
                  isBackSide: true,
                  frontIdImage: widget.frontIdImage,
                ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    } catch (e) {
      debugPrint("Manual capture error: $e");
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
          _isCapturing = false;
          _statusMessage = "Capture failed. Try again.";
          _frameColor = Colors.red;
        });

        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _startFrameAnalysis();
            setState(() {
              _statusMessage = "Position the back of your ID within the frame";
              _frameColor = Colors.white;
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _frameAnalysisTimer?.cancel();
    _pulseController.dispose();
    _progressController.dispose();
    _controller?.dispose();
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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _controller != null &&
                  _controller!.value.isInitialized) {
                return Transform(
                  alignment: Alignment.center,
                  transform: _isBackCameraSelected
                      ? Matrix4.identity()
                      : Matrix4.identity(),
                  child: CameraPreview(_controller!),
                );
              }
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "Initializing camera...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),

          // Overlay with animated frame
          LayoutBuilder(builder: (context, constraints) {
            double frameWidth = 280;
            double frameHeight = 180;
            double left = (constraints.maxWidth - frameWidth) / 2;
            double top = (constraints.maxHeight - frameHeight) / 2;

            return Stack(
              children: [
                // Dark overlay
                Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54
                ),

                // Clear frame area
                Positioned(
                  left: left,
                  top: top,
                  child: Container(
                    width: frameWidth,
                    height: frameHeight,
                    color: Colors.transparent,
                  ),
                ),

                // Animated frame
                Positioned(
                  left: left,
                  top: top,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isIdDetected ? _pulseAnimation.value : 1.0,
                        child: Container(
                          width: frameWidth,
                          height: frameHeight,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: _frameColor,
                                width: _isIdDetected ? 4 : 3
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: _isIdDetected ? [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              )
                            ] : [],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Progress indicator
                if (_isIdDetected && !_isCapturing)
                  Positioned(
                    left: left,
                    top: top + frameHeight + 20,
                    child: SizedBox(
                      width: frameWidth,
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _progressAnimation.value,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                            minHeight: 4,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            );
          }),

          // Status message
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
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
          ),

          // Manual capture button (backup)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _manualCapture,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: _isTakingPicture ? Colors.grey : Colors.transparent,
                  ),
                  child: _isTakingPicture
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(Icons.camera_alt, color: Colors.white, size: 32),
                ),
              ),
            ),
          ),

          // Toggle Camera Button
          if (cameras.length > 1)
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: Icon(
                  _isBackCameraSelected ? Iconsax.camera5 : Iconsax.camera_slash,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: _isTakingPicture ? null : _toggleCamera,
                tooltip: "Switch Camera",
              ),
            ),

          // Auto-detection indicator
          Positioned(
            top: 40,
            left: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isIdDetected ? Colors.green : Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isIdDetected ? Icons.check_circle : Icons.search,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isIdDetected ? "Detected" : "Scanning",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                _frameAnalysisTimer?.cancel();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}