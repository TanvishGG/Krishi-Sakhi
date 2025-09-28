import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import 'voice_screen.dart';
import 'settings_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().addWelcomeMessage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
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
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF2D5016)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Consumer<LanguageProvider>(
            builder: (context, languageProvider, child) => IconButton(
              onPressed: () {
                final localizations = AppLocalizations.of(context)!;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(localizations.clearHistory),
                    content: Text(
                      localizations
                          .areYouSureYouWantToClearAllConversationHistory,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(localizations.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<ChatProvider>().clearMessages();
                          Navigator.pop(context);
                        },
                        child: Text(localizations.clear),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_outline, color: Color(0xFF2D5016)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFF2D5016)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFFE0E0E0), height: 1.0),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer2<ChatProvider, LanguageProvider>(
                builder: (context, chatProvider, languageProvider, child) {
                  final messages = chatProvider.messages;
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg.isUser;
                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 6,
                            bottom: 6,
                            left: isUser ? 50 : 0,
                            right: isUser ? 0 : 50,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          constraints: const BoxConstraints(
                            maxWidth: double.infinity,
                          ),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF8db87a)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: isUser
                                ? null
                                : Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : const Color(0xFF333333),
                              fontSize: 16,
                              height: 1.25,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<LanguageProvider>(
              builder: (context, languageProvider, child) => Container(
                color: const Color(0xFF8db87a),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: localizations.typeYourMessage,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                              ),
                              minLines: 1,
                              maxLines: 4,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: _messageController.text.trim().isNotEmpty
                                  ? const Color(0xFF333333)
                                  : const Color(0xFF999999),
                            ),
                            onPressed: () {
                              final text = _messageController.text.trim();
                              if (text.isNotEmpty) {
                                context.read<ChatProvider>().sendMessage(
                                  text,
                                  context,
                                );
                                _messageController.clear();
                                _scrollToBottom();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VoiceScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5016),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.mic, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            localizations.talk,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // End of class
}
