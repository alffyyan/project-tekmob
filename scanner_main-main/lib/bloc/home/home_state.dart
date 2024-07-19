part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(false) bool isEditMode,
    @Default(false) bool isChecked,
    @Default(false) bool isSaveToCloud,
    @Default([]) List<bool> selectedItems,
    @Default(0) int selectedCount,
    @Default([]) List<PdfFile> pdfFiles,
    @Default([]) List<PdfFile> filteredPdfFiles,
  }) = _HomeState;
}