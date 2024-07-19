import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:scanner_main/bloc/auth/auth_bloc.dart';
import 'package:scanner_main/repository/auth/auth_repository.dart';
import 'package:scanner_main/repository/file/file_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../bloc/file/file_bloc.dart';
import '../bloc/home/home_bloc.dart';
import '../main.dart';
import '../styles/styles.dart';
import 'common/token_refresher/token_refresher.dart';

final logger = Logger();

class ScanyAppScaffold extends StatefulWidget {
  const ScanyAppScaffold({Key? key, required this.child}) : super(key: key);

  static AppStyle get style => _style;

  static Logger get logger => _logger;
  static final AppStyle _style = AppStyle();
  static final Logger _logger = Logger();

  final Widget child;

  @override
  State<ScanyAppScaffold> createState() => _ScanyAppScaffoldState();
}

class _ScanyAppScaffoldState extends State<ScanyAppScaffold> {
  late AuthRepository authRepository;
  late FileRepository fileRepository;

  void _handleTokenChanges(String token) {
    if (token.isNotEmpty) {
      setState(() {
        logger.d('Token: $token');
      });
    }
  }

  @override
  void initState() {
    super.initState();

    authRepository = AuthRepository();
    fileRepository = FileRepository();

    SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString('userToken');
      if (token != null) {
        _handleTokenChanges(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository: authRepository)
              ..add(const AuthEvent.started()),
          ),
          BlocProvider<FileBloc>(
            create: (context) => FileBloc(fileRepository: fileRepository),
          ),
          BlocProvider<HomeBloc>(
            create: (_) => HomeBloc()..add(const LoadPdfFile()),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state.isLoggedIn && state.token.isNotEmpty) {
                  _handleTokenChanges(state.token);
                }
              },
            ),
          ],
          child: Theme(
            data: $styles.colors.toThemeData(),
            child: TokenRefresher(child: widget.child),
          ),
        )
    );
  }
}
