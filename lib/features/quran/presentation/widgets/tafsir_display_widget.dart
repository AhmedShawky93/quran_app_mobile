import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/core/theme/app_theme.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/surah.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/verse.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/tafsir_source.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/tafsir_cubit.dart';
import 'package:quran_app_mobile/features/quran/presentation/bloc/tafsir_state.dart';

class TafsirDisplayWidget extends StatelessWidget {
  final Verse verse;
  final Surah surah;

  const TafsirDisplayWidget({super.key, required this.verse, required this.surah});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'تفسير الآية ${verse.verseNumber} من سورة ${surah.nameAr}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.quranGold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  BlocBuilder<TafsirCubit, TafsirState>(
                    builder: (context, state) {
                      List<TafsirSource> sources = [];
                      TafsirSource? selectedSource;

                      if (state is TafsirSourcesLoaded) {
                        sources = state.sources;
                        selectedSource = state.selectedSource;
                      } else if (state is VerseTafsirLoaded) {
                        sources = state.sources;
                        selectedSource = state.selectedSource;
                      }

                      if (sources.isNotEmpty) {
                        return DropdownButton<int>(
                          value: selectedSource?.id,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              final selected = sources.firstWhere(
                                (s) => s.id == newValue,
                              );
                              final cubit = context.read<TafsirCubit>();
                              cubit.selectTafsirSource(selected);
                              cubit.getVerseTafsir(verse.id);
                            }
                          },
                          items: sources.map<DropdownMenuItem<int>>(
                            (TafsirSource source) {
                            return DropdownMenuItem<int>(
                              value: source.id,
                              child: Text(source.name),
                            );
                            },
                          ).toList(),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<TafsirCubit, TafsirState>(
                builder: (context, state) {
                  if (state is TafsirLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TafsirError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is VerseTafsirLoaded) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        state.tafsirText,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 18, height: 1.8),
                      ),
                    );
                  } else if (state is TafsirSourcesLoaded) {
                    if (state.selectedSource != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<TafsirCubit>().getVerseTafsir(verse.id);
                      });
                    }
                    return const Center(child: Text('اختر مصدر التفسير.'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            ],
          ),
        );
      },
    );
  }
}
