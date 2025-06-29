import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// voice to text related service
class VoiceToTextService {
  /// use riverpod reference
  final Ref ref;
  final stt.SpeechToText _speech = stt.SpeechToText();

  ///calling the provider
  final isListeningProvider = StateProvider<bool>((ref) => false);

  ///made the constructor
  VoiceToTextService(this.ref);

  /// its speech listener lisen to text
  Future<String?> listenForText() async {
    ref.read(isListeningProvider.notifier).state = true;
    final available = await _speech.initialize();
    if (!available) {
      ref.read(isListeningProvider.notifier).state = false;
      return null;
    }

    String resultText = '';
    await _speech.listen(
      onResult: (result) {
        resultText = result.recognizedWords;
      },
      listenFor: const Duration(seconds: 8),
      pauseFor: const Duration(seconds: 3),
      onSoundLevelChange: null,
    );

    /// Wait until listening ends
    await Future.doWhile(() async {
      await Future.delayed(const Duration(microseconds: 200));
      return _speech.isListening;
    });
    ref.read(isListeningProvider.notifier).state = false;
    return resultText.isNotEmpty ? resultText : null;
  }
}
