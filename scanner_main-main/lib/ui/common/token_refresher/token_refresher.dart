import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:logger/logger.dart';
import 'package:scanner_main/bloc/auth/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenRefresher extends StatefulWidget {
  const TokenRefresher({super.key, required this.child});

  final Widget child;

  @override
  State<TokenRefresher> createState() => _TokenRefresherState();
}

class _TokenRefresherState extends State<TokenRefresher> {
  Timer? timer;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> _refreshToken() async {
    final User? user = _firebaseAuth.currentUser;
    if (user == null) return null;

    String? token = await user.getIdToken(true);
    Logger().d('New Token: $token');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token!);

    return token;
  }

  void _runTimer() {
    timer = Timer.periodic(const Duration(minutes: 30), (Timer timer) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('userToken');
      if (token != null) {
        final isExpired = JwtDecoder.isExpired(token);
        if (isExpired) {
          final newToken = await _refreshToken();
          if (newToken != null) {
            context.read<AuthBloc>().add(const AuthEvent.started());
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _runTimer();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
