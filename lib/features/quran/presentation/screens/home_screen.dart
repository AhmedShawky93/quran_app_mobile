import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/surah_cubit.dart';
import '../bloc/surah_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم')),
      body: BlocBuilder<SurahCubit, SurahState>(
        builder: (context, state) {
          if (state is SurahLoading || state is SurahInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SurahError) {
            return Center(child: Text('Error: '));
          } else if (state is SurahLoaded) {
            final surahs = state.surahs;
            return ListView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return ListTile(
                  leading: CircleAvatar(child: Text(surah.id.toString())),
                  title: Text(surah.nameAr),
                  subtitle: Text(' -  آية'),
                  trailing: Text(surah.nameEn),
                  onTap: () {
                    // Navigate to Surah Reader (next step)
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
}
