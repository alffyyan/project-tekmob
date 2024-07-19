import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/main.dart';
import 'package:scanner_main/ui/common/scany_searchbar/scany_searchbar.dart';

import '../../../bloc/home/home_bloc.dart';
import '../../../router.dart';
import '../home/components/file_list_item.dart';
import '../home/components/scany_list_item.dart';
import '../pdf_viewer/pdf_view_screen.dart';

final List<FileListItem> items = [
  FileListItem(
    title: 'PhoneScanner 04-06-2024',
    date: '2024-06-04 22:29',
    qty: '3',
    imageUrl:
        'https://support.content.office.net/en-us/media/e0f0122a-066d-469e-8e5d-7fe7eda30c1d.png',
  ),
  FileListItem(
    title: 'PhoneScanner 04-06-2024',
    date: '2024-06-04 22:29',
    qty: '3',
    imageUrl:
        'https://support.content.office.net/en-us/media/e0f0122a-066d-469e-8e5d-7fe7eda30c1d.png',
  ),
];

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {

  @override
  void initState() {
    context.read<HomeBloc>().add(const LoadPdfFile());
    super.initState();
  }

  Future<void> _refresh() async {
    // Implement your refresh logic here, e.g., reload PDF files
    context.read<HomeBloc>().add(const LoadPdfFile());
  }

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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                          'assets/images/icons/files/file_icon.svg'),
                    ),
                    Text(
                      'Import File',
                      style: $styles.text.bodyTextSmallRegular,
                    )
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                          'assets/images/icons/files/picture_icon.svg'),
                    ),
                    Text(
                      'Import Picture',
                      style: $styles.text.bodyTextSmallRegular,
                    )
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                          'assets/images/icons/files/folder_icon.svg'),
                    ),
                    Text(
                      'New Folder',
                      style: $styles.text.bodyTextSmallRegular,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 33,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All",
                  style: $styles.text.headingMediumBold,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: (){},
                      icon: SvgPicture.asset(
                        'assets/images/icons/files/sort_icon.svg'
                      ),
                    ),
                    IconButton(
                      onPressed: (){},
                      icon: SvgPicture.asset(
                          'assets/images/icons/files/checklist_icon.svg'
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    return ListView.builder(
                      itemCount: state.pdfFiles.length,
                      itemBuilder: (context, index) {
                        final file = state.pdfFiles[index];
                        final isSelected = state.selectedItems[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PdfViewerScreen(pdfPath: file.file.path),
                                ),
                              );
                            },
                            onLongPress: () {
                              context
                                  .read<HomeBloc>()
                                  .add(const ToggleEditMode());
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0.0),
                              child: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            // Shadow color
                                            spreadRadius: 2,
                                            // Spread radius
                                            blurRadius: 5,
                                            // Blur radius
                                            offset: Offset(0,
                                                3), // Changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        child: Image(
                                          image: file.thumbnail,
                                          width: 93,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            file.file.path.split('/').last,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: $styles
                                                .text.bodyTextLargeMedium
                                                .copyWith(
                                                color: $styles
                                                    .colors.mainBlack),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            file.creationDate.toIso8601String(),
                                            style: $styles.text.labelBold
                                                .copyWith(
                                                color: $styles
                                                    .colors.mainBlack),
                                          ),
                                          const SizedBox(height: 15),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.file_copy_outlined,
                                                color: $styles
                                                    .colors.supportingGray,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${file.qty}',
                                                style: $styles.text.labelBold
                                                    .copyWith(
                                                    color: $styles.colors
                                                        .supportingGray),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: $styles.colors.primary,
                                        side: BorderSide(
                                            width: 2,
                                            color: $styles.colors.primary),
                                        value: isSelected,
                                        onChanged: (value) {
                                          if (value! && !state.isEditMode) {
                                            context
                                                .read<HomeBloc>()
                                                .add(const ToggleEditMode());
                                          }
                                          context
                                              .read<HomeBloc>()
                                              .add(CheckItem(index, value));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: $styles.colors.primary,
        // unselectedLabelStyle: $styles.text.bodyTextSmallRegular.copyWith(
        //   color: Colors.black
        // ),
        currentIndex: 1,
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
