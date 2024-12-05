import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leaf_disease_app/src/components/details_page/ui/details_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:leaf_disease_app/src/components/leaf_type_selection/ui/leaf_type_selection_radio_view.dart';
import 'package:leaf_disease_app/src/components/live_detection/ui/live_detection_view.dart';
import 'package:leaf_disease_app/src/components/settings_page/ui/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildCamera(context),
          _buildCameraOverlay(context),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   shape: const CircleBorder(),
      //   key: const Key('homeView_addTodo_floatingActionButton'),
      //   onPressed: () {},
      //   // onPressed: () => Navigator.of(context).push(EditTodoPage.route()),
      //   child: const Icon(Icons.insert_photo_outlined),
      // ),
    );
    // return SafeArea(child: LiveDetectionView());
  }

  Widget _buildCamera(BuildContext context) {
    return LiveDetectionView();
  }

  Widget _buildCameraOverlay(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeader(context),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        "Planty 🌱",
        // style: GoogleFonts.chewy(
        //   textStyle: Theme.of(context).textTheme.headlineLarge,
        // ),

        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
    ).frosted(
      blur: 10,
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).push(SettingsPage.route()),
            child: Icon(Icons.settings_outlined),
          ),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.insert_photo_outlined),
            label: Text(AppLocalizations.of(context)!.openFromGallery),
          ),
          ElevatedButton(
            onPressed: () => _pickLeafType(),
            child: Icon(Icons.energy_savings_leaf_outlined),
          ),
        ],
      ),
    );
  }

  // Actions

  void _pickImage() async {
    final result = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    final imagePath = result?.path;
    if (imagePath == null) {
      return;
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).push(
      DetailsPage.routeWithImagePath(imagePath),
    );
  }

  void _pickLeafType() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: LeafTypeSelectionRadioView(),
      ),
    );
  }
}
