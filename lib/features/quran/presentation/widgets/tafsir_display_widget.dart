import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/surah.dart';
import 'package:quran_app_mobile/features/quran/domain/entities/verse.dart';
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تفسير الآية ${verse.verseNumber} من سورة ${surah.nameAr}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<TafsirCubit, TafsirState>(
                    builder: (context, state) {
                      if (state is TafsirSourcesLoaded) {
                        return DropdownButton<int>(
                          value: state.selectedSource?.id,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              final selected = state.sources.firstWhere((s) => s.id == newValue);
                              context.read<TafsirCubit>().selectTafsirSource(selected);
                              context.read<TafsirCubit>().getVerseTafsir(verse.id);
                            }
                          },
                          items: state.sources.map<DropdownMenuItem<int>>((TafsirSource source) {
                            return DropdownMenuItem<int>(
                              value: source.id,
                              child: Text(source.name),
                            );
                          }).toList(),
                        );
                      } else if (state is VerseTafsirLoaded) {
                        return DropdownButton<int>(
                          value: state.selectedSource.id,
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                              final cubit = context.read<TafsirCubit>();
                              final selected = (cubit.state as TafsirSourcesLoaded).sources.firstWhere((s) => s.id == newValue);
                              cubit.selectTafsirSource(selected);
                              cubit.getVerseTafsir(verse.id);
                            }
                          },
                          items: (context.read<TafsirCubit>().state as TafsirSourcesLoaded).sources.map<DropdownMenuItem<int>>((TafsirSource source) {
                            return DropdownMenuItem<int>(
                              value: source.id,
                              child: Text(source.name),
                            );
                          }).toList(),
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
                        style: const TextStyle(fontSize: 18),
                      ),
                    );
                  } else if (state is TafsirSourcesLoaded) {
                    // If sources are loaded but no tafsir yet, trigger fetch for the first source
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (state.selectedSource != null) {
                        context.read<TafsirCubit>().getVerseTafsir(verse.id);
                      }
                    });
                    return const Center(child: Text('Select a Tafsir source.'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
