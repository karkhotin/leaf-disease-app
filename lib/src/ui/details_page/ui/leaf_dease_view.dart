import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/leaf_dease_detection_repository.dart';
import 'package:image/image.dart' as img;
import 'package:leaf_disease_app/src/ui/details_page/bloc/leaf_dease_cubit.dart';
import 'package:leaf_disease_app/src/ui/details_page/bloc/leaf_dease_state.dart';

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
