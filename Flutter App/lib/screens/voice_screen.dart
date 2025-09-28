import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voice_provider.dart';
import '../providers/language_provider.dart';
import '../models/voice_models.dart';
import '../l10n/app_localizations.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VoiceProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F3F0),
          appBar: AppBar(
            backgroundColor: const Color(0xFFF5F3F0),
            elevation: 0,
            title: Text(
              localizations.appTitle,
              style: TextStyle(
                color: Color(0xFF2D5016),
                fontWeight: FontWeight.w700,
                fontSize: 20,
                fontFamily: languageProvider.isEnglish ? null : 'sans-serif',
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(localizations.clearHistory),
                      content: Text(localizations.areYouSureClearHistory),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(localizations.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<VoiceProvider>().clearTranscriptions();
                            Navigator.pop(context);
                          },
                          child: Text(localizations.clear),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFF2D5016),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Consumer<VoiceProvider>(
              builder: (context, voiceProvider, child) {
                final isRecording = voiceProvider.isRecording;
                final liveTranscription = voiceProvider.transcription;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      if (voiceProvider.transcriptionHistory.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ExpansionTile(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: const Color(0xFF2D5016),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${voiceProvider.transcriptionHistory.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D5016),
                                  ),
                                ),
                              ],
                            ),
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 120,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount:
                                      voiceProvider.transcriptionHistory.length,
                                  itemBuilder: (context, index) {
                                    final transcription = voiceProvider
                                        .transcriptionHistory[index];
                                    final isUser =
                                        transcription.type ==
                                        TranscriptionType.user;

                                    final words = transcription.text.split(' ');
                                    final truncatedText = words.length > 8
                                        ? '${words.take(8).join(' ')}...'
                                        : transcription.text;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisAlignment: isUser
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              constraints: BoxConstraints(
                                                maxWidth:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.65,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isUser
                                                    ? const Color(0xFF2D5016)
                                                    : Colors.grey[100],
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(12),
                                                  topRight:
                                                      const Radius.circular(12),
                                                  bottomLeft: isUser
                                                      ? const Radius.circular(
                                                          12,
                                                        )
                                                      : const Radius.circular(
                                                          2,
                                                        ),
                                                  bottomRight: isUser
                                                      ? const Radius.circular(2)
                                                      : const Radius.circular(
                                                          12,
                                                        ),
                                                ),
                                              ),
                                              child: Text(
                                                truncatedText,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isUser
                                                      ? Colors.white
                                                      : const Color(0xFF333333),
                                                  height: 1.2,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              voiceProvider.voiceState == VoiceState.processing
                              ? Colors.orange.withOpacity(0.1)
                              : (isRecording
                                    ? Colors.green.withOpacity(0.1)
                                    : (voiceProvider.voiceState ==
                                              VoiceState.speaking
                                          ? Colors.blue.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1))),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color:
                                voiceProvider.voiceState ==
                                    VoiceState.processing
                                ? Colors.orange
                                : (isRecording
                                      ? Colors.green
                                      : (voiceProvider.voiceState ==
                                                VoiceState.speaking
                                            ? Colors.blue
                                            : Colors.grey)),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          voiceProvider.voiceState == VoiceState.processing
                              ? localizations.thinking
                              : (isRecording
                                    ? localizations.listening
                                    : (voiceProvider.voiceState ==
                                              VoiceState.speaking
                                          ? localizations.speakingInterrupt
                                          : localizations.readyToTalk)),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color:
                                voiceProvider.voiceState ==
                                    VoiceState.processing
                                ? Colors.orange[800]
                                : (isRecording
                                      ? Colors.green[800]
                                      : (voiceProvider.voiceState ==
                                                VoiceState.speaking
                                            ? Colors.blue[800]
                                            : Colors.grey[800])),
                            fontFamily: languageProvider.isEnglish
                                ? null
                                : 'sans-serif',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 24),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              voiceProvider.voiceState == VoiceState.speaking &&
                                      voiceProvider.currentSpeakingResponse !=
                                          null
                                  ? voiceProvider.currentSpeakingResponse!
                                  : (liveTranscription.isNotEmpty
                                        ? liveTranscription
                                        : (isRecording
                                              ? localizations.speakNow
                                              : (voiceProvider.voiceState ==
                                                        VoiceState.processing
                                                    ? localizations
                                                          .gettingAnswer
                                                    : (voiceProvider
                                                                  .voiceState ==
                                                              VoiceState
                                                                  .speaking
                                                          ? localizations
                                                                .speaking
                                                          : localizations
                                                                .tapMicToStartTalking)))),
                              style: TextStyle(
                                fontSize:
                                    voiceProvider.voiceState ==
                                            VoiceState.speaking &&
                                        voiceProvider.currentSpeakingResponse !=
                                            null
                                    ? 16
                                    : (voiceProvider.voiceState ==
                                              VoiceState.speaking
                                          ? 16
                                          : 18),
                                color:
                                    voiceProvider.voiceState ==
                                            VoiceState.speaking &&
                                        voiceProvider.currentSpeakingResponse !=
                                            null
                                    ? Colors.blue[700]
                                    : (voiceProvider.voiceState ==
                                              VoiceState.speaking
                                          ? Colors.blue[700]
                                          : Color(0xFF333333)),
                                height: 1.4,
                                fontFamily: languageProvider.isEnglish
                                    ? null
                                    : 'sans-serif',
                                fontStyle:
                                    voiceProvider.voiceState ==
                                            VoiceState.speaking &&
                                        voiceProvider.currentSpeakingResponse !=
                                            null
                                    ? FontStyle.normal
                                    : (voiceProvider.voiceState ==
                                              VoiceState.speaking
                                          ? FontStyle.italic
                                          : FontStyle.normal),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      GestureDetector(
                        onTap: () {
                          if (voiceProvider.isSpeaking) {
                            voiceProvider.interruptAndSpeak('');
                          } else if (isRecording) {
                            voiceProvider.stopConversation();
                          } else {
                            voiceProvider.startRecording('en');
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isRecording
                                  ? [
                                      const Color(0xFFe57373),
                                      const Color(0xFFf44336),
                                    ]
                                  : [
                                      const Color(0xFF8db87a),
                                      const Color(0xFF2D5016),
                                    ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isRecording
                                            ? Colors.red
                                            : const Color(0xFF2D5016))
                                        .withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            isRecording ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat, size: 18),
                            label: Text(
                              localizations.textChat,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: languageProvider.isEnglish
                                    ? null
                                    : 'sans-serif',
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF2D5016),
                            ),
                          ),

                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings, size: 18),
                            label: Text(
                              localizations.settings,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: languageProvider.isEnglish
                                    ? null
                                    : 'sans-serif',
                              ),
                            ),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF2D5016),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
