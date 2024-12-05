import 'package:flutter/material.dart';
import 'package:leaf_disease_app/src/ui/detection_view_pytorch.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: DetectionPytorchView());
  }
}
