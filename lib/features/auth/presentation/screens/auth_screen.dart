import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_cubit.dart';
import '../bloc/auth_state.dart';
import 'package:quran_app_mobile/core/theme/app_theme.dart';
import 'package:quran_app_mobile/features/quran/presentation/screens/home_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated || state is GuestMode) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.deepEmerald, AppTheme.emerald, AppTheme.surfaceGreen],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_book, size: 100, color: AppTheme.quranGold),
              const SizedBox(height: 20),
              const Text(
                'القرآن الكريم',
                style: TextStyle(
                  fontSize: 32,
                  color: AppTheme.quranGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator(color: AppTheme.quranGold);
                  }
                  return Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.person_outline),
                        label: const Text('الدخول كضيف'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                          backgroundColor: AppTheme.quranGold,
                          foregroundColor: AppTheme.deepEmerald,
                        ),
                        onPressed: () {
                          context.read<AuthCubit>().loginAsGuest();
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.phone),
                        label: const Text('تسجيل بالهاتف'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(250, 50),
                          backgroundColor: AppTheme.brightGold,
                          foregroundColor: AppTheme.deepEmerald,
                        ),
                        onPressed: () {
                          // TODO: Phone login
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
