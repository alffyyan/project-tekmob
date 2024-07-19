import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_main/bloc/auth/auth_bloc.dart';
import 'package:scanner_main/main.dart';
import 'package:scanner_main/ui/common/scany_outlined_button/scany_outline_button.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final userDetail = state.userDetail;
        if (userDetail == null) {
          return Center(
            child: Text('No user data found'),
          );
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const SizedBox(height: 44),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with your image URL or AssetImage
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userDetail.fullName,
                  style: $styles.text.headingSmallBold,
                ),
                Text(
                  userDetail.email,
                  style: $styles.text.bodyTextLargeRegular,
                ),
                const SizedBox(
                  height: 10,
                ),
                ScanyOutlinedButton(
                  text: 'Edit Profile',
                ),
                const SizedBox(
                  height: 28,
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Setting'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Implement your setting logic here
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/images/icons/profile/help_icon.svg'),
                  title: Text('Help'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Implement your setting logic here
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  title: Text('Privacy And Policy'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Implement your setting logic here
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset('assets/images/icons/profile/about_icon.svg'),
                  title: Text('About'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Implement your setting logic here
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Implement your logout logic here
                    BlocProvider.of<AuthBloc>(context).add(const AuthSignOut());
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: $styles.colors.primary,
            currentIndex: 3,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go(ScreenPaths.home);
                  break;
                case 1:
                  context.go('/files');
                  break;
                case 2:
                  context.go('/cloud');
                  break;
                case 3:
                  context.go('/profile');
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/images/icons/home/home_icon.svg',
                  color: $styles.colors.supportingGray,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/icons/home/file_icon.svg'),
                label: 'Files',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/icons/home/cloud_icon.svg'),
                label: 'Cloud',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset('assets/images/icons/home/person_icon.svg'),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
