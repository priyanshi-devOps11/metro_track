import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/voice_helper.dart';

class VoiceButton extends StatefulWidget {
  const VoiceButton({super.key});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton> {
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: _toggleListening,
      icon: Icon(
        _isListening ? Icons.mic : Icons.mic_none,
        color: _isListening ? AppColors.error : AppColors.primary,
      ),
      label: Text(_isListening ? 'Listening...' : 'Use Voice'),
      style: OutlinedButton.styleFrom(
        foregroundColor: _isListening ? AppColors.error : AppColors.primary,
        side: BorderSide(
          color: _isListening ? AppColors.error : AppColors.primary,
        ),
        minimumSize: const Size(double.infinity, 56),
      ),
    );
  }

  void _toggleListening() async {
    if (_isListening) {
      await VoiceHelper.stopListening();
      setState(() => _isListening = false);
    } else {
      final result = await VoiceHelper.startListening();
      setState(() => _isListening = true);
      
      // Simulate listening
      await Future.delayed(const Duration(seconds: 3));
      setState(() => _isListening = false);
      
      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You said: $result')),
        );
      }
    }
  }
}