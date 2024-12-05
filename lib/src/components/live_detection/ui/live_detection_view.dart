import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/ui/details_page.dart';
import 'package:leaf_disease_app/src/components/live_detection/bloc/live_detection_bloc.dart';
import 'package:leaf_disease_app/src/components/live_detection/bloc/live_detection_event.dart';
import 'package:leaf_disease_app/src/components/live_detection/bloc/live_detection_state.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LiveDetectionView extends StatelessWidget {
  const LiveDetectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => LiveDetectionBloc(
        cameraFrameSize: screenSize,
        leafDiseaseDetectionRepository: context.read(),
        settingsRepository: context.read(),
      )..add(LiveDetectionCameraInitTriggered()),
      child: _LiveDetectionCameraView(),
    );
  }
}

class _LiveDetectionCameraView extends StatefulWidget {
  const _LiveDetectionCameraView();

  @override
  State<_LiveDetectionCameraView> createState() => _LiveDetectionCameraViewState();
}

class _LiveDetectionCameraViewState extends State<_LiveDetectionCameraView> with WidgetsBindingObserver {
  CameraController? _cameraController;

  Future<void> _initCameraController() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    final controller = CameraController(cameras[0], ResolutionPreset.medium, enableAudio: false);
    await controller.initialize();
    _cameraController = controller;
    if (mounted) {
      context.read<LiveDetectionBloc>().add(LiveDetectionCameraInitialized());
    }
  }

  void _stopStreaming() {
    if (_cameraController == null || !mounted) {
      return;
    }
    if (_cameraController!.value.isStreamingImages) {
      _cameraController?.stopImageStream();
    }
    _cameraController!.pausePreview();
  }

  void _startStreaming() {
    if (_cameraController == null || !mounted) {
      return;
    }
    if (!_cameraController!.value.isStreamingImages) {
      _cameraController?.startImageStream(_processImage);
    }
    _cameraController!.resumePreview();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        _stopStreaming();
        break;
      case AppLifecycleState.resumed:
        if (context.read<LiveDetectionBloc>().state.cameraPreviewActive) {
          _startStreaming();
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('live-detection-camera'),
      onVisibilityChanged: (info) {
        context.read<LiveDetectionBloc>().add(LiveDetectionCameraVisibilityChanged(info.visibleFraction > 0));
      },
      child: Stack(children: [
        _build(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 125),
            child: _buildCaptureButton(context),
          ),
        ),
      ]),
    );
  }

  Widget _build(BuildContext context) {
    return BlocConsumer<LiveDetectionBloc, LiveDetectionState>(
      listenWhen: (previous, current) => previous.cameraState != current.cameraState,
      listener: (context, state) {
        if (state.cameraState == LiveDetectionCameraState.initialization) {
          _initCameraController();
        }
      },
      builder: (context, state) {
        if (state.cameraState != LiveDetectionCameraState.initialized || _cameraController == null) {
          return Center(child: CircularProgressIndicator.adaptive());
        }
        return _buildCamera(context);
      },
    );
  }

  Widget _buildCamera(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: _buildCameraPreview(context)),
        Positioned.fill(child: _buildCameraOverlay(context)),
      ],
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    return BlocListener<LiveDetectionBloc, LiveDetectionState>(
      listenWhen: (previous, current) => previous.cameraPreviewActive != current.cameraPreviewActive,
      listener: (context, state) async {
        if (state.cameraPreviewActive) {
          _startStreaming();
        } else {
          _stopStreaming();
        }
      },
      child: OverflowBox(
        maxWidth: double.infinity,
        child: CameraPreview(
          _cameraController!,
          child: GestureDetector(
            onTap: () => context.read<LiveDetectionBloc>().add(const LiveDetectionCameraPreviewToggled()),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraOverlay(BuildContext context) {
    return BlocBuilder<LiveDetectionBloc, LiveDetectionState>(
      buildWhen: (previous, current) => previous.rects != current.rects,
      builder: (context, state) {
        return IgnorePointer(child: _buildRects(state.rects));
      },
    );
  }

  Future<void> _processImage(CameraImage cameraImage) async {
    if (mounted) {
      context.read<LiveDetectionBloc>().add(LiveDetectionFrameCaptured(cameraImage));
    }
  }

  Widget _buildRects(List<LiveDetectionRect> rects) {
    return LayoutBuilder(builder: (context, constraints) {
      double factorX = constraints.maxWidth;
      double factorY = constraints.maxHeight;
      return Stack(
        children: rects.map((result) {
          final rect = result.relativeRect;
          return Positioned(
            left: rect.left * factorX,
            top: rect.top * factorY,
            width: rect.width * factorX,
            height: rect.height * factorY,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: result.healthy ? Colors.green.shade800 : Colors.amber.shade700,
                  width: 3,
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _buildCaptureButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final frame = await this.context.read<LiveDetectionBloc>().state.lastFrameImage;
        if (frame == null || !mounted) {
          return;
        }
        Navigator.of(this.context).push(DetailsPage.routeWithImage(frame));
      },
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        side: BorderSide(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          width: 8,
        ),
        padding: EdgeInsets.all(20),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      ),
      child: SizedBox(
        width: 56,
        height: 56,
        child: Icon(
          Icons.camera_alt_outlined,
          size: 42,
        ),
      ),
    );
  }
}
