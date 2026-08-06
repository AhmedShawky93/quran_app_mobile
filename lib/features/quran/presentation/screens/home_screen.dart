import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/core/di/service_locator.dart';
import 'package:quran_app_mobile/core/theme/app_theme.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/surah_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/surah_state.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/verse_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/bookmark_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/reading_progress_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/reading_progress_state.dart';
import 'package:quran_app_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:quran_app_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:quran_app_mobile/features/quran/presentation/screens/surah_reader_screen.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/reading_progress.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadReadingProgress();
  }

  void _loadReadingProgress() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is Authenticated) {
      await context.read<ReadingProgressCubit>().loadReadingProgress(authState.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: BlocBuilder<ReadingProgressCubit, ReadingProgressState>(
        builder: (context, readingProgressState) {
          return BlocBuilder<SurahCubit, SurahState>(
            builder: (context, state) {
              if (state is SurahLoading || state is SurahInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SurahError) {
                return Center(child: Text('Error: ${state.message}'));
              } else if (state is SurahLoaded) {
                final surahs = state.surahs;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: surahs.length,
                  itemBuilder: (context, index) {
                    final surah = surahs[index];
                    ReadingProgress? progress;
                    if (readingProgressState is ReadingProgressLoaded) {
                      progress = readingProgressState.readingProgress;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.quranGold,
                          foregroundColor: AppTheme.deepEmerald,
                          child: Text(surah.id.toString()),
                        ),
                        title: Text(
                          surah.nameAr,
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          '${surah.revelationType} - ${surah.totalVerses} آية',
                          textAlign: TextAlign.right,
                        ),
                        trailing: Text(surah.nameEn),
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(create: (context) => sl<VerseCubit>()..fetchVerses(surah.id)),
                                BlocProvider(create: (context) {
                                  final authState = context.read<AuthCubit>().state;
                                  if (authState is Authenticated) {
                                    return sl<BookmarkCubit>()..fetchBookmarks(authState.token);
                                  }
                                  return sl<BookmarkCubit>();
                                }),
                                BlocProvider(create: (context) {
                                  final authState = context.read<AuthCubit>().state;
                                  if (authState is Authenticated) {
                                    return sl<ReadingProgressCubit>()..loadReadingProgress(authState.token);
                                  }
                                  return sl<ReadingProgressCubit>();
                                }),
                              ],
                              child: SurahReaderScreen(
                                surah: surah,
                                initialVerseId: (progress?.lastSurahId == surah.id) ? progress?.lastVerseId : null,
                              ),
                            ),
                          ),
                        );
                        },
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
