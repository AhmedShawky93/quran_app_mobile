import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/core/di/service_locator.dart';
import 'package:quran_app_mobile/core/theme/app_theme.dart';
import 'package:quran_app_mobile/core/network/audio_player_service.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/surah.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/verse.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/verse_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/verse_state.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/tafsir_cubit.dart';
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
        _scrollToVerse(widget.initialVerseId!);
      }
    });
  }

  void _scrollToVerse(int verseId) {
    final double itemHeight = 60.0;
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
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final verse = verses[index];
                return Card(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      _showVerseActions(context, verse, widget.surah);
                      final authState = context.read<AuthCubit>().state;
                      if (authState is Authenticated) {
                        context.read<ReadingProgressCubit>().saveReadingProgress(
                              authState.token,
                              widget.surah.id,
                              verse.id,
                            );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            verse.textUthmani,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: AppTheme.quranTextStyle,
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.quranGold),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('﴿${verse.verseNumber}﴾'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Wrap(
              children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('استماع'),
              onTap: () async {
                Navigator.pop(context);
                try {
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
                          final userId = authState.token;
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('نسخ'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
              ],
            ),
          ),
        );
      },
    );
  }
}
