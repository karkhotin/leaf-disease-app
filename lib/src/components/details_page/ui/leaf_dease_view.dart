import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/leaf_dease_cubit.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/leaf_dease_state.dart';

class LeafDeaseView extends StatelessWidget {
  const LeafDeaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeafDeaseCubit, LeafDeaseState>(builder: (context, state) {
      return Column(
        children: [
          if (state.imageBytes != null) Expanded(child: Image.memory(state.imageBytes!)),
          Text("${state.deaseName}: ${state.confidence}"),
        ],
      );
    });
  }
}
