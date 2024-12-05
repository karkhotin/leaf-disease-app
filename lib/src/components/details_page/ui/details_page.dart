import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/bloc/leaf_disease_cubit.dart';
import 'package:leaf_disease_app/src/domain/disease_detection/leaf_disease_detection_repository.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/details_bloc.dart';
import 'package:leaf_disease_app/src/components/details_page/bloc/details_state.dart';
import 'package:leaf_disease_app/src/components/details_page/leaf_disease_card/ui/leaf_disease_view.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  static Route<void> routeWithResults({required List<LeafDiseaseResult> results}) {
    return _routeWithInitialState(DetailsClassifiedState(results));
  }

  static Route<void> routeWithImagePath({required String imagePath}) {
    return _routeWithInitialState(DetailsClassifyingState(imagePath: imagePath));
  }

  static Route<void> _routeWithInitialState(DetailsState state) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => DetailsCubit(
          state,
          leafDiseaseDetectionRepository: context.read(),
          settingsRepository: context.read(),
        ),
        child: const DetailsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details Page"),
      ),
      body: SafeArea(
        child: BlocBuilder<DetailsCubit, DetailsState>(builder: (context, state) {
          switch (state) {
            case DetailsClassifyingState _:
              return _buildLoadingPage(context);
            case DetailsClassifiedState state:
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

  Widget _buildErrorPage(BuildContext context) {
    return Center(
      child: Text("Failed to classify leafs 💩"),
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

    // return CarouselView(
    //   scrollDirection: Axis.horizontal,
    //   padding: const EdgeInsets.all(16),
    //   itemSnapping: true,
    //   itemExtent: double.infinity,
    //   shrinkExtent: 100,

    //   children: [
    //     ...state.results.map((result) => BlocProvider(
    //           create: (context) => LeafDiseaseCubit(result),
    //           child: const LeafDiseaseView(),
    //         )),
    //   ],
    // );
  }
}
