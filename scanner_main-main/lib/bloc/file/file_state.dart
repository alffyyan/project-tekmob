part of 'file_bloc.dart';

@freezed
class FileState with _$FileState {
  const factory FileState({
    @Default(false) bool isInitialized,
    @Default(false) bool isUploading,
    @Default('') String downloadUrl,
    @Default(false) bool isLoading,
    @Default('') String? errorMessage,
    @Default([]) List<Map<String, dynamic>> pdfFiles,
  }) = _FileState;
}
