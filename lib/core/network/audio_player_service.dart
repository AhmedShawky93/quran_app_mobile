import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playUrl(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration?> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  void dispose() {
    _player.dispose();
  }
}
