import 'dart:typed_data';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/bloc/leaf_disease_cubit.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/bloc/leaf_disease_state.dart';

class LeafDiseaseView extends StatelessWidget {
  const LeafDiseaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImage(context),
          SizedBox(height: 16),
          _buildDescription(context),
          SizedBox(height: 16),
          Expanded(child: _buildDetails(context)),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.8,
      child: BlocBuilder<LeafDiseaseCubit, LeafDiseaseState>(builder: (context, state) {
        return state.imageBytes != null ? _buildImageWithBackground(state.imageBytes!) : Container();
      }),
    );
  }

  Widget _buildImageWithBackground(Uint8List imageBytes) {
    return LayoutBuilder(
      builder: (context, constraints) => Image.memory(
        imageBytes,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        fit: BoxFit.cover,
      ).blurred(
        blur: 10,
        borderRadius: BorderRadius.all(Radius.circular(28)),
        blurColor: Colors.black,
        colorOpacity: 0.3,
        overlay: Image.memory(
          imageBytes,
          fit: BoxFit.contain,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return BlocBuilder<LeafDiseaseCubit, LeafDiseaseState>(builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Grape",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.diseaseName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "${(state.confidence * 100).round()}%",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDetails(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.info_outlined),
        label: Text("Get More Info"),
      ),
    );
  }
}
