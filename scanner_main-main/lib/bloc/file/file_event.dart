part of 'file_bloc.dart';

@freezed
class FileEvent with _$FileEvent {
  const factory FileEvent.started() = FileStarted;
  const factory FileEvent.uploadFile(File file, String fileName) = UploadFile;
  const factory FileEvent.clearErrorMessage() = ClearErrorMessage;
  const factory FileEvent.loadPdfFiles() = LoadPdfFiles;
}