import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/bloc/auth/auth_bloc.dart';
import 'package:scanner_main/ui/common/scany_back_button/scany_back_button.dart';
import 'package:scanner_main/ui/common/scany_button/scany_button.dart';
import 'package:scanner_main/ui/common/scany_profile_preview/scany_profile_preview.dart';
import 'package:scanner_main/ui/common/scany_textfield/scany_textfield.dart';
import 'package:scanner_main/ui/common/scany_dropdown/scany_dropdown.dart';
import 'package:scanner_main/utils/context_utils.dart';

import '../../../main.dart';
import '../../../router.dart';
import '../../common/scany_date_picker/scany_date_picker.dart';

class BioRegistrationScreen extends StatefulWidget {
  const BioRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<BioRegistrationScreen> createState() => _BioRegistrationScreenState();
}

class _BioRegistrationScreenState extends State<BioRegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _birthDateController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                        ScanyProfilePreview(
                          onPressed: () {},
                        ),
                        const SizedBox(height: 32),
                        ScanyTextField(
                          labelText: "Enter FullName",
                          controller: _fullNameController,
                          svgAsset: 'assets/images/icons/profile/person_icon_bold.svg',
                        ),
                        const SizedBox(height: 16),
                        ScanyTextField(
                          labelText: "Enter phone number",
                          controller: _phoneNumberController,
                          svgAsset: 'assets/images/icons/profile/phone_icon.svg',
                        ),
                        const SizedBox(height: 16),
                        ScanyDropdown(
                          labelText: "Select Gender",
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          value: _selectedGender,
                          svgAsset: 'assets/images/icons/profile/gender_icon.svg',
                        ),
                        const SizedBox(height: 16),
                        ScanyDatePicker(
                          labelText: "Select Date",
                          controller: _birthDateController,
                          svgAsset: 'assets/images/icons/profile/birth_cake_icon.svg',
                        ),
                        const SizedBox(height: 31),
                        ScanyButton(
                          onPressed: () {
                            // Save bio data to state
                            context.read<AuthBloc>().add(AuthEvent.saveBio(
                              fullName: _fullNameController.text,
                              phoneNumber: _phoneNumberController.text,
                              gender: _selectedGender!,
                              birthDate: DateTime.parse(_birthDateController.text),
                            ));
                            // Navigate to Signup screen
                            context.push(ScreenPaths.signUp);
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
    );
  }
}
