import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/ui/screens/arrange_image/arrange_image_screen.dart';
import 'package:scanner_main/ui/screens/bio_registration/bio_registration_screen.dart';
import 'package:scanner_main/ui/screens/camera/camera_screen.dart';
import 'package:scanner_main/ui/screens/cloud/cloud_screen.dart';
import 'package:scanner_main/ui/screens/crop_image/image_crop_screen.dart';
import 'package:scanner_main/ui/screens/files/files_screen.dart';
import 'package:scanner_main/ui/screens/home/home_screen.dart';
import 'package:scanner_main/ui/screens/image_filter/image_filter_screen.dart';
import 'package:scanner_main/ui/screens/image_preview/image_preview_screen.dart';
import 'package:scanner_main/ui/screens/login/login_screen.dart';
import 'package:scanner_main/ui/screens/profile/profile_screen.dart';
import 'package:scanner_main/ui/screens/sign_up/sign_up_screen.dart';

import 'bloc/auth/auth_bloc.dart';
import 'main.dart';

class ScreenPaths {
  static String home = '/home';
  static String bioRegistration = '/bio_registration';
  static String signUp = '/sign_up';
  static String login = '/login';
  static String camera = '/camera';
  static String imagePreview = '/image_preview';
  static String imageCrop = '/image_crop';
  static String imageFilter = '/image_filter';
  static String profile = '/profile';
  static String cloud = '/cloud';
  static String files = '/files';
  static String arrangeImage = '/arrange_image';
  static String pdfViewer = '/pdf_viewer';
}

final routes = [
  AppRoute(ScreenPaths.home, (_) => const HomeScreen()),
  AppRoute(ScreenPaths.bioRegistration, (_) => const BioRegistrationScreen()),
  AppRoute(ScreenPaths.signUp, (_) => const SignUpScreen()),
  AppRoute(ScreenPaths.login, (_) => const LoginScreen()),
  AppRoute(ScreenPaths.profile, (_) => const ProfileScreen()),
  AppRoute(ScreenPaths.cloud, (_) => const CloudScreen()),
  AppRoute(ScreenPaths.files, (_) => const FilesScreen()),
  AppRoute(ScreenPaths.camera, (_) => const CameraScreen()),
  AppRoute(ScreenPaths.imagePreview, (state) {
    final imageFile = state.extra as File;
    return ImagePreviewScreen(imageFile: imageFile);
  }),
  AppRoute(ScreenPaths.imageCrop, (state) {
    final imageFile = state.extra as File;
    return ImageCropScreen(imageFile: imageFile);
  }),
  AppRoute(ScreenPaths.imageFilter, (state) {
    final imageFile = state.extra as File;
    return ImageFilterScreen(imageFile: imageFile);
  }),
  AppRoute(ScreenPaths.arrangeImage, (state) {
    final imageFile = state.extra as File;
    return ArrangeImageScreen(imageFile: imageFile);
  }),
];

final appRouter = GoRouter(
    redirect: _handleRedirect,
    routes: routes,
    initialLocation: ScreenPaths.login);

class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
            name: path,
            path: path,
            routes: routes,
            pageBuilder: (context, state) {
              final pageContent = Scaffold(
                body: builder(state),
                resizeToAvoidBottomInset: false,
              );
              if (useFade) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: pageContent,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              }
              return CupertinoPage(child: pageContent);
            });
  final bool useFade;
}

FutureOr<String?> _handleRedirect(BuildContext ctx, GoRouterState state) {
  var result = ctx.read<AuthBloc>().state;
  $logger.d('Auth redirect: ${result.isLoggedIn}');
  $logger.d('Navigate to: ${state.matchedLocation}');
  FirebaseAnalytics.instance.logScreenView(screenName: state.name);
  return null; // do nothing
}
