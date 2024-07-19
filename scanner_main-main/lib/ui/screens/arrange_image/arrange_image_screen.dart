import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_svg/svg.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:scanner_main/utils/file_storage.dart';
import 'package:scanner_main/router.dart';
import '../../../bloc/file/file_bloc.dart';
import '../../../bloc/home/home_bloc.dart';
import '../../../main.dart';
import '../scany_camera/scany_camera_screen.dart';

class ArrangeImageScreen extends StatefulWidget {
  final File imageFile;

  const ArrangeImageScreen({super.key, required this.imageFile});

  @override
  _ArrangeImageScreenState createState() => _ArrangeImageScreenState();
}

class _ArrangeImageScreenState extends State<ArrangeImageScreen> {
  late List<File> _imageFiles;

  @override
  void initState() {
    super.initState();
    _imageFiles = [widget.imageFile];
  }

  Future<void> _addImage() async {
    final result = await Navigator.push<File?>(
      context,
      MaterialPageRoute(builder: (context) => const ScanyCameraScreen()),
    );

    if (result != null) {
      setState(() {
        _imageFiles.add(result);
      });
    }
  }

  Future<void> _saveAsPdf() async {
    String? pdfFileName;

    pdfFileName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save as PDF'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'PDF File Name'),
              onChanged: (value) {
                pdfFileName = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to start
              children: [
                BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  return Checkbox(
                    value: state.isSaveToCloud,
                    onChanged: (value) {
                      setState(() {
                        context
                            .read<HomeBloc>()
                            .add(HomeEvent.toggleSaveToCloud(value!));
                      });
                    },
                  );
                }),
                Text("Save on cloud", style: $styles.text.bodyTextSmall),
              ],
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () async {
              if (pdfFileName != null && pdfFileName!.isNotEmpty) {
                final pdf = pw.Document();

                for (var imageFile in _imageFiles) {
                  final image =
                      pw.MemoryImage(File(imageFile.path).readAsBytesSync());
                  pdf.addPage(
                    pw.Page(
                      build: (pw.Context context) {
                        return pw.Center(
                          child: pw.Image(image),
                        );
                      },
                    ),
                  );
                }

                // Save PDF using FileStorage
                final output = await FileStorage.savePdf(
                    await pdf.save(), '$pdfFileName.pdf');

                if (context.read<HomeBloc>().state.isSaveToCloud) {
                  // Upload file to Firebase
                  context
                      .read<FileBloc>()
                      .add(FileEvent.uploadFile(output, '$pdfFileName.pdf'));
                }

                // Notify user about successful save
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('PDF Saved'),
                    content: Text('PDF file saved to: ${output.path}'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );

                Navigator.of(context).pop(pdfFileName);
                context.push(ScreenPaths.home);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReorderableItem(BuildContext context, int index) {
    return Card(
      key: ValueKey(_imageFiles[index]),
      margin: const EdgeInsets.all(8),
      child: GridTile(
        footer: GridTileBar(
          title: Text('${index + 1}'),
        ),
        child: AspectRatio(
          aspectRatio: 1.0, // Adjust the aspect ratio to fit your needs
          child: Image.file(
            _imageFiles[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arrange Images'),
      ),
      body: ReorderableGridView.builder(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _imageFiles.removeAt(oldIndex);
            _imageFiles.insert(newIndex, item);
          });
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 9.0 / 16.0,
        ),
        itemBuilder: (context, index) {
          return _buildReorderableItem(context, index);
        },
        itemCount: _imageFiles.length,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.white, // Background color of the bottom row
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildIconButton(
              'assets/images/icons/arrange/edit_icon.svg',
              'Edit',
            ),
            _buildIconButton(
              'assets/images/icons/arrange/share_icon.svg',
              'Share',
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: $styles.colors.supportingBackground,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      'assets/images/icons/arrange/camera_icon.svg',
                    ),
                    onPressed: _addImage,
                  ),
                ),
                const Text(
                  'Add',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
            _buildIconButton(
              'assets/images/icons/arrange/other_icon.svg',
              'Other',
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/icons/arrange/save_icon.svg',
                    color: Colors.black,
                  ),
                  onPressed: _saveAsPdf,
                ),
                const Text(
                  'Save',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String? svgAsset, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            svgAsset!,
            color: Colors.black,
          ),
          onPressed: () {
            // Implement action based on the icon
            if (label == 'Edit') {
              // Handle edit action
            } else if (label == 'Share') {
              // Handle share action
            } else if (label == 'Other') {
              // Handle other action
            }
          },
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
      ],
    );
  }
}
