import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/core/di/service_locator.dart';
import 'package:quran_app_mobile/core/network/audio_player_service.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/surah.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/verse.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/verse_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/verse_state.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/tafsir_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/tafsir_state.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/bookmark_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/bookmark_state.dart';
import 'package:quran_app_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:quran_app_mobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/reading_progress_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/widgets/tafsir_display_widget.dart';

class SurahReaderScreen extends StatefulWidget {
  final Surah surah;
  final int? initialVerseId;

  const SurahReaderScreen({super.key, required this.surah, this.initialVerseId});

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialVerseId != null) {
        _scrollToVerse(widget.initialVerseId!); // Scroll to the initial verse if provided
      }
    });
  }

  void _scrollToVerse(int verseId) {
    // This is a simplified scroll. A more robust solution would calculate item heights.
    // For now, we assume each verse item has a roughly equal height.
    // A better approach would be to use GlobalKey for each verse item and scroll to its context.
    final double itemHeight = 60.0; // Approximate height of a verse ListTile
    final double offset = (verseId - 1) * itemHeight;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.nameAr),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show Surah info
            },
          ),
        ],
      ),
      body: BlocBuilder<VerseCubit, VerseState>(
        builder: (context, state) {
          if (state is VerseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VerseError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is VerseLoaded) {
            final verses = state.verses;
            return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: verses.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final verse = verses[index];
                return ListTile(
                  title: Text(
                    verse.textUthmani,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'Uthmanic',
                    ),
                  ),
                  subtitle: Text(
                    '(${verse.verseNumber})',
                    textAlign: TextAlign.left,
                  ),
                  onTap: () {
                    _showVerseActions(context, verse, widget.surah);
                    // Save reading progress
                    final authState = context.read<AuthCubit>().state;
                    if (authState is Authenticated) {
                      context.read<ReadingProgressCubit>().saveReadingProgress(authState.token, widget.surah.id, verse.id);
                    }
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showVerseActions(BuildContext context, Verse verse, Surah surah) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('استماع'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  // Assuming ApiClient is registered in service locator
                  // final apiClient = sl<ApiClient>();
                  // final response = await apiClient.dio.get('quran/verses/${verse.id}/audio');
                  // if (response.statusCode == 200) {
                  //   final audioUrl = response.data['url'];
                  //   await sl<AudioPlayerService>().playUrl(audioUrl);
                  // }
                  // For now, let's use a placeholder audio URL
                  await sl<AudioPlayerService>().playUrl('https://download.quranicaudio.com/quran/abdullah_basfar/001005.mp3');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('خطأ في تشغيل الصوت: $e')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('تفسير'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => BlocProvider<TafsirCubit>(
                    create: (context) => sl<TafsirCubit>()..fetchTafsirSources(),
                    child: TafsirDisplayWidget(verse: verse, surah: surah),
                  ),
                );
              },
            ),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) {
                if (authState is Authenticated) {
                  return BlocBuilder<BookmarkCubit, BookmarkState>(
                    builder: (context, bookmarkState) {
                      final isBookmarked = (bookmarkState is BookmarksLoaded && bookmarkState.bookmarks.any((b) => b.verseId == verse.id));
                      return ListTile(
                        leading: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                        title: Text(isBookmarked ? "إزالة العلامة" : "حفظ في العلامات"),
                        onTap: () {
                          Navigator.pop(context);
                          final userId = (authState as Authenticated).token;
                          if (isBookmarked) {
                            context.read<BookmarkCubit>().removeBookmark(userId, verse.id);
                          } else {
                            context.read<BookmarkCubit>().addBookmark(userId, verse.id);
                          }
                        },
                      );
                    },
                  );
                }
                return ListTile(
                  leading: const Icon(Icons.bookmark_border),
                  title: const Text("حفظ في العلامات"),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please login to add bookmarks.")),
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('مشاركة'),
              onTap: () {
                // Share verse
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('نسخ'),
              onTap: () {
                // Copy verse
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
