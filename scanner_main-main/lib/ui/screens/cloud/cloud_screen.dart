import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/ui/screens/pdf_viewer/cloud_pdf_viewer_screen.dart';

import '../../../bloc/file/file_bloc.dart';
import '../../../main.dart';
import '../../../router.dart';
import '../../common/scany_searchbar/scany_searchbar.dart';
import '../home/components/file_list_item.dart';
import '../home/components/scany_list_item.dart';

class CloudScreen extends StatelessWidget {
  const CloudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
        child: Column(
          children: [
            const ScanySearchBar(
              hintText: 'Search',
            ),
            const SizedBox(height: 10),
            const SizedBox(height: 33),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Cloud",
                  style: $styles.text.headingMediumBold,
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                      'assets/images/icons/files/sort_icon.svg'),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<FileBloc, FileState>(
                builder: (context, state) {
                  if (state.pdfFiles.isEmpty) {
                    $logger.d(state.toString());
                    context.read<FileBloc>().add(const LoadPdfFiles());
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: state.pdfFiles.length,
                    itemBuilder: (context, index) {
                      final file = state.pdfFiles[index];
                      return ScanyListItem(
                        item: FileListItem(
                          title: file['fileName'],
                          date: (file['timestamp'] as Timestamp).toDate().toString(),
                          qty: '',
                          imageUrl: '',
                        ),
                        index: index,
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CloudPdfViewerScreen(downloadUrl: file['downloadUrl']),
                            ),
                          );

                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: $styles.colors.primary,
        currentIndex: 2,
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
  }
}
