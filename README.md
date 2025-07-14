# Planty🌱 App

## Overview
**Planty🌱** is a cross-platform mobile application designed to help farmers diagnose fruit tree leaf diseases in their orchards. The system combines the YOLO algorithm and CNN models to identify 
diseases in real-time using a smartphone camera or an uploaded image.

Unlike traditional apps that require a single leaf to be isolated, Planty🌱 can efficiently process images containing multiple leaves,
 enhancing usability and practicality in real-world farming conditions.

## How it works?

The recognition process begins right from the home screen. Simply select the type of fruit tree you want to diagnose. Currently, Planty🌱 supports
the identification of diseases in leaves from **Apple**, **Apricot**, **Cherry**, **Grape**, **Peach**, **Pear** and **Walnut** trees.
There are two ways to analyze a leaf for disease:

- 📷 **Live Camera mode:**  
  Just open the app and aim the camera at the tree. The app will automatically detect leaves and highlight those that show signs of disease.

- 🖼️ **Upload from Gallery:**  
  Tap the gallery icon, select an image with one or more leaves, and the app will run detection and classification. If a disease is found, a results screen with the diagnosis will be shown.

⚠️ Even without an internet connection, the app can perform disease recognition using its on-device models. However, please note that access to additional treatment information
will be unavailable in offline mode.

## Demo
🎥 Click to see the app in action:
<video src="https://github.com/user-attachments/assets/0360f66e-7782-4c41-9fae-7f5c01a5e467" controls>
</video>

## Future Vision
🚀 **Planned features and improvements:**
- [ ] Expand dataset with new fruit species and diseases  
- [ ] Improve classification accuracy with more robust CNN architecture  
- [ ] Integrate disease history tracking
- [ ] Publish on Google Play and App Store
