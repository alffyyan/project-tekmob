import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:scanner_main/main.dart';
import 'package:scanner_main/ui/common/scany_searchbar/scany_searchbar.dart';

import 'package:scanner_main/ui/screens/home/components/file_list_item.dart';

import '../../../bloc/home/home_bloc.dart';
import '../../../router.dart';
import '../../../utils/fab_utils.dart';
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

// home_screen.dart
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);  // Add listener for search changes
    context.read<HomeBloc>().add(const LoadPdfFile());
  }

  Future<void> _refresh() async {
    // Implement your refresh logic here, e.g., reload PDF files
    context.read<HomeBloc>().add(const LoadPdfFile());
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    context.read<HomeBloc>().add(SearchPdfFiles(query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: $styles.colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
        child: Column(
          children: [
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              return state.isEditMode
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                            'assets/images/icons/home/close_icon.svg'),
                        onPressed: () {
                          context
                              .read<HomeBloc>()
                              .add(const UnCheckAllItems());
                          context
                              .read<HomeBloc>()
                              .add(const ToggleEditMode());
                        },
                      ),
                      Text(
                        '${state.selectedCount} selected',
                        style: $styles.text.headingMediumBold.copyWith(
                          color: $styles.colors.mainBlack,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<HomeBloc>()
                          .add(const ChooseAllItems());
                    },
                    child: Text(
                      'Choose All',
                      style: $styles.text.headingSmallRegular.copyWith(
                        color: $styles.colors.primary,
                      ),
                    ),
                  ),
                ],
              )
                  : ScanySearchBar(
                hintText: 'Search',
                controller: _searchController,  // Set controller for the search bar
              );
            }),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent",
                  style: $styles.text.headingMediumBold,
                ),
                InkWell(
                  onTap: () {
                    // Handle view all action
                  },
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          context.go('/files');
                        },
                        child: Text(
                          "View All",
                          style: $styles.text.bodyTextMedium.copyWith(
                            color: $styles.colors.supportingGray,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: $styles.colors.supportingGray,
                        size: 16,
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    final pdfFiles = state.filteredPdfFiles;  // Use filtered list
                    return ListView.builder(
                      itemCount: pdfFiles.length,
                      itemBuilder: (context, index) {
                        final file = pdfFiles[index];
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
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                3),
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
      floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.isEditMode
              ? Container()
              : FloatingActionButton(
              onPressed: () {
                context.push(ScreenPaths.camera);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                    'assets/images/icons/camera/camera_icon.svg'),
              ));
        },
      ),
      floatingActionButtonLocation:
      CustomFloatingActionButtonLocation(offset: 50),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
            fixedColor: $styles.colors.primary,
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 0:
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
            items: state.isEditMode
                ? [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/share_icon.svg'),
                label: 'Share',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/cloud_upload_icon.svg'),
                label: 'Upload',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/rename_icon.svg'),
                label: 'Rename',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/save_icon.svg'),
                label: 'Save',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/trash_icon.svg'),
                label: 'Delete',
              ),
            ]
                : [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/home_icon.svg'),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/file_icon.svg'),
                label: 'Files',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/cloud_icon.svg'),
                label: 'Cloud',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    'assets/images/icons/home/person_icon.svg'),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
