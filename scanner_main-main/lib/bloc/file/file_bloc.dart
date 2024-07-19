import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scanner_main/main.dart';


import '../../repository/file/file_repository.dart';
import '../auth/auth_bloc.dart';

part 'file_event.dart';
part 'file_state.dart';
part 'file_bloc.freezed.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final FileRepository fileRepository;

  FileBloc({required this.fileRepository}) : super( const FileState()) {
    on<FileStarted>(_onStarted);
    on<UploadFile>(_onUploadFile);
    on<ClearErrorMessage>(_onClearErrorMessage);
    on<LoadPdfFiles>(_onLoadPdfFiles);
  }

  Future<void> _onStarted(FileStarted event, Emitter<FileState> emit) async {
    emit(state.copyWith(isInitialized: true));
  }

  Future<void> _onUploadFile(UploadFile event, Emitter<FileState> emit) async {
    emit(state.copyWith(isUploading: true, errorMessage: null));
    try {
      final downloadUrl = await fileRepository.uploadFile(event.file, event.fileName);
      emit(state.copyWith(isUploading: false, downloadUrl: downloadUrl));
    } catch (e) {
      emit(state.copyWith(isUploading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onClearErrorMessage(ClearErrorMessage event, Emitter<FileState> emit) async {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> _onLoadPdfFiles(LoadPdfFiles event, Emitter<FileState> emit) async {
    try {
      final pdfFiles = await fileRepository.fetchPdfFiles();
      $logger.d('Fetched PDF files: $pdfFiles');
      emit(state.copyWith(pdfFiles: pdfFiles));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}