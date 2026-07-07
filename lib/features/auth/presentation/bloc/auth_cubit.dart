import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_client.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiClient apiClient;

  AuthCubit(this.apiClient) : super(AuthInitial());

  Future<void> loginAsGuest() async {
    emit(AuthLoading());
    try {
      final response = await apiClient.dio.post('auth/register', data: {
        'authProvider': 'Guest',
      });
      
      if (response.statusCode == 200) {
        final token = response.data['token'];
        emit(Authenticated(token, 'Guest'));
      } else {
        emit(const AuthError('Failed to login as guest'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logout() {
    emit(Unauthenticated());
  }
}
