import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/storage/secure_storage_helper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SecureStorageHelper storageHelper;

  AuthBloc({required this.authRepository, required this.storageHelper}) : super(AuthInitial()) {
    
    on<AuthCheckRequested>((event, emit) async {
      final hasToken = await storageHelper.hasToken();
      if (hasToken) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.login(event.email, event.password);
        if (success) {
          emit(AuthAuthenticated());
        } else {
          emit(AuthError("Login gagal, periksa email dan password."));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthRegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final success = await authRepository.register(event.email, event.password);
        if (success) {
          // Otomatis login kalau berhasil daftar
          add(AuthLoginRequested(event.email, event.password));
        } else {
          emit(AuthError("Gagal mendaftar, periksa kembali data Anda."));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    });
  }
}