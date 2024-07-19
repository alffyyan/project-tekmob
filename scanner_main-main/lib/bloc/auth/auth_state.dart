part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoggedIn,
    @Default('') String token,
    @Default(false) bool isLoading,
    @Default('') String? errorMessage,
    UserDetail? userDetail,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? gender,
    DateTime? birthDate,
  }) = _AuthState;
}
