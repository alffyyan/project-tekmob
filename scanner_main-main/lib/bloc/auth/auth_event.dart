part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = AuthStarted;
  const factory AuthEvent.signIn({required String email, required String password}) = AuthSignIn;
  const factory AuthEvent.register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String gender,
    required DateTime birthDate,
  }) = AuthRegister;
  const factory AuthEvent.saveBio({
    required String fullName,
    required String phoneNumber,
    required String gender,
    required DateTime birthDate,
  }) = AuthSaveBio;
  const factory AuthEvent.signOut() = AuthSignOut;
  const factory AuthEvent.clearErrorMessage() = ClearErrorMessage;
}
