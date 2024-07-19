import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/ui/common/scany_confirm_dialog/scany_confirm_dialog.dart';
import 'package:scanner_main/utils/context_utils.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../main.dart';
import '../../../router.dart';
import '../../common/scany_back_button/scany_back_button.dart';
import '../../common/scany_button/scany_button.dart';
import '../../common/scany_textfield/scany_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.userDetail != null) {
            $logger.d('Registration successful');
            ScanyConfirmDialog.show(
              context: context,
              title: 'Sign Up Successful!',
              body: 'A verification email has been sent. Please verify your email.',
              cancelable: false,
              okText: 'Continue',
              onOkPressed: () {
                context.clearAndNavigate(ScreenPaths.login);
              },
            );
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
                        children: [
                          const SizedBox(height: 31),
                          Row(
                            children: [
                              const ScanyBackButton(),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Sign Up',
                                    style: $styles.text.headingExtraLargeBold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                            child: Text(
                              'Access all that apps has to offer with a single account. All fields are required.',
                              style: $styles.text.bodyTextLargeRegular,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          ScanyTextField(
                            labelText: "Enter your email",
                            controller: _emailController,
                            svgAsset: 'assets/images/icons/sign_up/mail_icon.svg',
                          ),
                          const SizedBox(height: 16),
                          ScanyTextField(
                            labelText: "Enter your password",
                            isPassword: true,
                            controller: _passwordController,
                            svgAsset: 'assets/images/icons/sign_up/lock_icon.svg',
                          ),
                          const SizedBox(height: 16),
                          ScanyTextField(
                            labelText: "Verify your password",
                            isPassword: true,
                            controller: _confirmPasswordController,
                            svgAsset: 'assets/images/icons/sign_up/lock_icon.svg',
                          ),
                          const SizedBox(height: 48),
                          ScanyButton(
                            onPressed: () {
                              if (_passwordController.text != _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Passwords do not match")),
                                );
                                return;
                              }

                              final state = context.read<AuthBloc>().state;

                              if (state.fullName == null || state.phoneNumber == null || state.gender == null || state.birthDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Bio data is missing")),
                                );
                                return;
                              }

                              context.read<AuthBloc>().add(AuthEvent.register(
                                email: _emailController.text,
                                password: _passwordController.text,
                                fullName: state.fullName!,
                                phoneNumber: state.phoneNumber!,
                                gender: state.gender!,
                                birthDate: state.birthDate!,
                              ));
                            },
                            text: "Continue",
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
