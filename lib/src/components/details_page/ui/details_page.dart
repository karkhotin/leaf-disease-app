import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/bloc/leaf_disease_cubit.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/details_cubit.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/details_state.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/ui/leaf_disease_view.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  static Route<void> routeWithResults(List<LeafDiseaseDetectionResult> results) {
    return _routeWithInitialState(DetailsClassifiedState(results));
  }

  static Route<void> routeWithImage(img.Image image) {
    return _routeWithInitialState(DetailsClassifyingImageState(image));
  }

  static Route<void> routeWithImagePath(String imagePath) {
    return _routeWithInitialState(DetailsClassifyingImagePathState(imagePath));
  }

  static Route<void> _routeWithInitialState(DetailsState state) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => DetailsCubit(
          state,
          leafDiseaseDetectionRepository: context.read(),
          settingsRepository: context.read(),
        )..warmup(),
        child: const DetailsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detailsTitle),
      ),
      body: SafeArea(
        child: BlocBuilder<DetailsCubit, DetailsState>(builder: (context, state) {
          switch (state) {
            case DetailsClassifyingImagePathState _:
            case DetailsClassifyingImageState _:
              return _buildLoadingPage(context);
            case DetailsClassifiedState state:
              if (state.results.isEmpty) {
                return _buildEmptyResultsPage(context);
              }
              return _buildClassifiedPage(context, state);
            case DetailsClassificationFailedState _:
              return _buildErrorPage(context);
          }
        }),
      ),
    );
  }

  Widget _buildLoadingPage(BuildContext context) {
    return Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }

  Widget _buildEmptyResultsPage(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.detailsNoLeafsFound,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildErrorPage(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.detailsClassificationFailed,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _buildClassifiedPage(BuildContext context, DetailsClassifiedState state) {
    return PageView(
      children: [
        ...state.results.map((result) => BlocProvider(
              create: (context) => LeafDiseaseCubit(result),
              child: const LeafDiseaseView(),
            )),
      ],
    );
  }
}
