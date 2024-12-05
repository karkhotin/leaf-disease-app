import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/leaf_disease_cubit.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/leaf_disease_state.dart';

class LeafDiseaseView extends StatelessWidget {
  const LeafDiseaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeafDiseaseCubit, LeafDiseaseState>(builder: (context, state) {
      return Column(
        children: [
          if (state.imageBytes != null) Expanded(child: Image.memory(state.imageBytes!)),
          Text("${state.diseaseName}: ${state.confidence}"),
        ],
      );
    });
  }
}
