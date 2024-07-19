import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/ui/screens/home/home_screen.dart';
import 'package:scanner_main/utils/context_utils.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../main.dart';
import '../../../router.dart';
import '../../common/scany_button/scany_button.dart';
import '../../common/scany_textfield/scany_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isLoggedIn && state.userDetail != null) {
            $logger.d('Login successful');
            context.clearAndNavigate(ScreenPaths.home);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
            context.read<AuthBloc>().add(const ClearErrorMessage());
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Container(
                      color: $styles.colors.white,
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 200),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign In',
                                style: $styles.text.headingExtraLargeBold,
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                'Please sign in to continue',
                                style: $styles.text.bodyTextMedium,
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          ScanyTextField(
                            labelText: "Enter your email",
                            controller: _emailController,
                            svgAsset:
                                'assets/images/icons/sign_up/mail_icon.svg',
                          ),
                          const SizedBox(height: 16),
                          ScanyTextField(
                            labelText: "Enter your password",
                            isPassword: true,
                            controller: _passwordController,
                            svgAsset:
                                'assets/images/icons/sign_up/lock_icon.svg',
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                // Handle forgot password tap
                                print('Forgot Password tapped');
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: $styles.colors.mainBlack,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ScanyButton(
                            onPressed: () {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              context.read<AuthBloc>().add(
                                  AuthSignIn(email: email, password: password));
                            },
                            text: "Continue",
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                context.push(ScreenPaths.bioRegistration);
                              },
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  color: $styles.colors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
