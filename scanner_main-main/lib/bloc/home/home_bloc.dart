import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scanner_main/main.dart';
import 'package:scanner_main/repository/models/files/pdf_file_model.dart';
import 'package:scanner_main/ui/screens/home/home_screen.dart';
import 'package:pdfx/pdfx.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<ToggleEditMode>(_onToggleEditMode);
    on<CheckItem>(_onCheckItem);
    on<ChooseAllItems>(_onChooseAllItems);
    on<UnCheckAllItems>(_onUncheckAllItems);
    on<LoadPdfFile>(_onLoadPdfFiles);
    on<ToggleSaveToCloud>(_onToggleSaveToCloud);
    on<SearchPdfFiles>(_onSearchPdfFiles);

    add(const LoadPdfFile());
  }

  void _onToggleEditMode(ToggleEditMode event, Emitter<HomeState> emit) {
    emit(state.copyWith(isEditMode: !state.isEditMode));
  }

  void _onCheckItem(CheckItem event, Emitter<HomeState> emit) {
    final updatedSelectedItems = List<bool>.from(state.selectedItems);
    updatedSelectedItems[event.index] = event.isChecked;
    final selectedCount = updatedSelectedItems.where((item) => item).length;
    emit(state.copyWith(selectedItems: updatedSelectedItems, selectedCount: selectedCount));
  }

  void _onChooseAllItems(ChooseAllItems event, Emitter<HomeState> emit) {
    final updatedSelectedItems = List<bool>.filled(state.pdfFiles.length, true);
    emit(state.copyWith(selectedItems: updatedSelectedItems, selectedCount: state.pdfFiles.length));
  }

  void _onUncheckAllItems(UnCheckAllItems event, Emitter<HomeState> emit) {
    final updatedSelectedItems = List<bool>.filled(state.pdfFiles.length, false);
    emit(state.copyWith(selectedItems: updatedSelectedItems, selectedCount: 0));
  }

  Future<void> _onLoadPdfFiles(LoadPdfFile event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final pdfFiles = await _loadPdfFilesFromStorage();
    emit(state.copyWith(
      pdfFiles: pdfFiles,
      filteredPdfFiles: pdfFiles,  // Initialize filtered list
      selectedItems: List<bool>.filled(pdfFiles.length, false),
      isLoading: false,
    ));
  }

  Future<List<PdfFile>> _loadPdfFilesFromStorage() async {
    final directory = Directory("/storage/emulated/0/Download"); // Change this path as per your device
    $logger.d('Directory ${directory.path}');
    final pdfFiles = directory
        .listSync()
        .where((file) => file.path.endsWith('.pdf'))
        .map((file) async {
      final pdfFile = File(file.path);
      final creationDate = pdfFile.lastModifiedSync();
      final thumbnail = await _generateThumbnail(pdfFile); // Generate thumbnail
      final qty = await _getPageCount(pdfFile);
      return PdfFile(file: pdfFile, creationDate: creationDate, thumbnail: thumbnail, qty: qty);
    })
        .toList();

    // Wait for all asynchronous operations to complete
    final resolvedPdfFiles = await Future.wait(pdfFiles);

    $logger.d("Found PDF files: ${resolvedPdfFiles.length}");
    for (var pdfFile in resolvedPdfFiles) {
      print(pdfFile.file.path);
    } // Debug log
    return resolvedPdfFiles;
  }

  Future<ImageProvider> _generateThumbnail(File pdfFile) async {
    final pdfDocument = await PdfDocument.openFile(pdfFile.path);
    final page = await pdfDocument.getPage(1); // Get the first page
    final pageImage = await page.render(
      width: page.width,
      height: page.height,
    );
    await page.close();
    return MemoryImage(pageImage!.bytes);
  }

  Future<int> _getPageCount(File pdfFile) async {
    final pdfDocument = await PdfDocument.openFile(pdfFile.path);
    final pageCount = pdfDocument.pagesCount;
    await pdfDocument.close();
    return pageCount;
  }

  void _onToggleSaveToCloud(ToggleSaveToCloud event, Emitter<HomeState> emit) {
    emit(state.copyWith(isSaveToCloud: event.isSaveToCloud));
  }

  void _onSearchPdfFiles(SearchPdfFiles event, Emitter<HomeState> emit) {
    final query = event.query.toLowerCase();
    final filteredFiles = state.pdfFiles.where((file) {
      final fileName = file.file.path.split('/').last.toLowerCase();
      return fileName.contains(query);
    }).toList();
    emit(state.copyWith(filteredPdfFiles: filteredFiles));
  }
}
