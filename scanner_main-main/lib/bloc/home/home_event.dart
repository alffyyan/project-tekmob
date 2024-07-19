part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  const factory HomeEvent.started() = _Started;
  const factory HomeEvent.toggleEditMode() = ToggleEditMode;
  const factory HomeEvent.checkItem(int index, bool isChecked) = CheckItem;
  const factory HomeEvent.chooseAllItems() = ChooseAllItems;
  const factory HomeEvent.unCheckAllItems() = UnCheckAllItems;
  const factory HomeEvent.LoadPdfFiles() = LoadPdfFile;
  const factory HomeEvent.toggleSaveToCloud(bool isSaveToCloud) = ToggleSaveToCloud;
  const factory HomeEvent.searchPdfFiles(String query) = SearchPdfFiles;
}
