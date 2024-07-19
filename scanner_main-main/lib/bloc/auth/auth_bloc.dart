import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_main/repository/auth/auth_repository.dart';
import '../../repository/models/auth/user_detail/user_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthSignIn>(_onSignIn);
    on<AuthRegister>(_onRegister);
    on<AuthSignOut>(_onSignOut);
    on<AuthSaveBio>(_onSaveBio);
    on<ClearErrorMessage>(_onClearErrorMessage);
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final token = await authRepository.getUserTokenFromPref();
    if (token != null && token.isNotEmpty) {
      final userDetail = await authRepository.getUserDetail(token);
      emit(state.copyWith(isLoggedIn: true, token: token, userDetail: userDetail));
    } else {
      emit(state.copyWith(isLoggedIn: false));
    }
  }

  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final user = await authRepository.signInWithEmailAndPassword(event.email, event.password);
      if (user != null) {
        final token = await user.getIdToken();
        await authRepository.saveUserTokenToPref(user);
        final userDetail = await authRepository.getUserDetail(token!);
        emit(state.copyWith(isLoggedIn: true, isLoading: false, token: token, userDetail: userDetail, errorMessage: null));
      } else {
        emit(state.copyWith(isLoggedIn: false, isLoading: false));
      }
    } catch (e) {
      String errorMessage;
      if (e.toString() == 'Exception: user-not-found') {
        errorMessage = 'User not found';
      } else if (e.toString() == 'Exception: email-not-verified') {
        errorMessage = 'Email not verified';
      } else {
        errorMessage = 'Login failed';
      }
      emit(state.copyWith(isLoading: false, errorMessage: errorMessage));
    }
  }

  Future<void> _onRegister(AuthRegister event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final user = await authRepository.registerWithEmailAndPassword(
        event.email,
        event.password,
        event.fullName,
        event.phoneNumber,
        event.gender,
        event.birthDate,
      );
      if (user != null) {
        final token = await user.getIdToken();
        await authRepository.saveUserTokenToPref(user);
        final userDetail = UserDetail(
          fullName: event.fullName,
          email: event.email,
          phoneNumber: event.phoneNumber,
          gender: event.gender,
          birthDate: event.birthDate,
        );
        emit(state.copyWith(isLoggedIn: false, isLoading: false, token: '', userDetail: userDetail));

        emit(state.copyWith(fullName: null, phoneNumber: null, gender: null, birthDate: null));
      } else {
        emit(state.copyWith(isLoggedIn: false, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await authRepository.signOut();
      await authRepository.clearTokenFromPref();
      emit(state.copyWith(isLoggedIn: false, isLoading: false, token: '', userDetail: null, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onSaveBio(AuthSaveBio event, Emitter<AuthState> emit) async {
    emit(state.copyWith(fullName: event.fullName, phoneNumber: event.phoneNumber, gender: event.gender, birthDate: event.birthDate));
  }

  Future<void> _onClearErrorMessage(ClearErrorMessage event, Emitter<AuthState> emit) async {
    emit(state.copyWith(errorMessage: null));
  }
}
