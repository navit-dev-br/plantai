import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ScanController extends ChangeNotifier {
  List<CameraDescription> _cameras = [];
  var _indexCamera = 0;
  CameraController? cameraController;

  ScanController() {
    getCameras();
  }

  Future<void> getCameras() async {
    _cameras = await availableCameras();
    _startCameraController();
  }

  void changeCamera() {
    if (_indexCamera + 1 < _cameras.length) {
      _indexCamera++;
    } else {
      _indexCamera = 0;
    }
    _startCameraController();
  }

  Future<void> _startCameraController() async {
    cameraController?.dispose();
    cameraController = CameraController(
        _cameras[_indexCamera], ResolutionPreset.max,
        enableAudio: false);
    await cameraController!.initialize();
    notifyListeners();
  }

  close() {
    cameraController?.dispose();
    dispose();
  }
}
