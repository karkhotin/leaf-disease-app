import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/domain/leaf_dease_detection_repository.dart';
import 'package:leaf_disease_app/src/ui/details_page/bloc/details_state.dart';
import 'package:image/image.dart' as img;

class DetailsCubit extends Cubit<DetailsState> {
  final LeafDeaseDetectionRepository leafDeaseDetectionRepository;

  DetailsCubit(super.initialState, {required this.leafDeaseDetectionRepository}) {
    _warmup();
  }

  void _warmup() async {
    if (state is DetailsClassifyingState) {
      final image = await img.decodeImageFile((state as DetailsClassifyingState).imagePath);
      if (image == null) {
        if (isClosed) {
          return;
        }
        emit(const DetailsClassificationFailedState());
        return;
      }
      final results = await leafDeaseDetectionRepository.detectDeases(image);
      if (isClosed) {
        return;
      }
      emit(DetailsClassifiedState(results));
    }
  }
}
