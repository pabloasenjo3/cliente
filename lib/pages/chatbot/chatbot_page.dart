import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:quimify_client/internet/chatbot/chat_service.dart';
import 'package:quimify_client/pages/widgets/bars/quimify_page_bar.dart';
import 'package:quimify_client/pages/widgets/objects/quimify_icon_button.dart';
import 'package:quimify_client/pages/widgets/quimify_colors.dart';
import 'package:quimify_client/pages/widgets/quimify_scaffold.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatbotPage extends StatelessWidget {
  const ChatbotPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QuimifyScaffold.noAd(
      header: QuimifyPageBar(
        title: 'Chatea con Atomic',
        trailing: QuimifyIconButton.square(
          height: 32,
          backgroundColor: QuimifyColors.secondaryTeal(context),
          onPressed: () async {
            await ChatService().clearHistory();
          },
          icon: Icon(
            Icons.restore,
            color: QuimifyColors.inverseText(context),
          ),
        ),
      ),
      body: const _Body(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool showAvatar;

  const ChatMessage({
    Key? key,
    required this.message,
    required this.isUser,
    this.showAvatar = false,
  }) : super(key: key);

  Widget _buildMathContent(String text, BuildContext context) {
    // Split text by math expressions
    final RegExp mathExp = RegExp(r'\\\[.*?\\\]');
    final List<String> parts = text.split(mathExp);
    final List<String?> matches =
        mathExp.allMatches(text).map((m) => m.group(0)).toList();

    List<Widget> children = [];

    for (int i = 0; i < parts.length; i++) {
      // Add text part
      if (parts[i].isNotEmpty) {
        children.add(MarkdownBody(
          data: parts[i],
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: isUser ? Colors.white : Colors.black,
            ),
            code: TextStyle(
              backgroundColor: isUser
                  ? Colors.blue[700]
                  : QuimifyColors.secondaryTeal(context),
              color: isUser ? Colors.white : Colors.black,
            ),
            codeblockDecoration: BoxDecoration(
              color: isUser
                  ? Colors.blue[700]
                  : QuimifyColors.secondaryTeal(context),
              borderRadius: BorderRadius.circular(8),
            ),
            blockquote: TextStyle(
              color: isUser ? Colors.white70 : Colors.black87,
              fontStyle: FontStyle.italic,
            ),
            blockquoteDecoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: isUser ? Colors.white30 : Colors.black26,
                  width: 4,
                ),
              ),
            ),
            listBullet: TextStyle(
              color: isUser ? Colors.white : Colors.black,
            ),
            strong: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
            em: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontStyle: FontStyle.italic,
            ),
            h1: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            h2: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            h3: TextStyle(
              color: isUser ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            listIndent: 20.0,
            blockSpacing: 8.0,
            h1Padding: EdgeInsets.only(top: 8, bottom: 4),
            h2Padding: EdgeInsets.only(top: 8, bottom: 4),
            h3Padding: EdgeInsets.only(top: 8, bottom: 4),
          ),
          selectable: true,
        ));
      }

      // Add math part if exists
      if (i < matches.length && matches[i] != null) {
        final mathText =
            matches[i]!.replaceAll(r'\[', '').replaceAll(r'\]', '').trim();

        children.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              mathText,
              textStyle: TextStyle(
                color: isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              mathStyle: MathStyle.display,
            ),
          ),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser && showAvatar) ...[
            Image.asset(
              'assets/images/atomic.png',
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue : QuimifyColors.teal(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: (message.isEmpty && !isUser)
                  ? const Text(
                      'Thinking...',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black38,
                      ),
                    )
                  : _buildMathContent(message, context),
            ),
          ),
        ],
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final ChatService _chatService = ChatService();
  bool _isFirstLoad = true;
  bool _isLoading = false; // Add this line

  static const List<String> quickQuestions = [
    'Explain this concept simply',
    'Give me an example',
    'How is this used in real life?',
    'Can you draw the structure?',
    'What is the balanced equation?',
    'Why is this important?',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return; // Add _isLoading check

    _textController.clear();

    setState(() {
      _isLoading = true; // Set loading state
    });

    if (context.mounted) FocusScope.of(context).unfocus();

    try {
      await _chatService.sendMessage(text);

      // Scroll to bottom after message is sent
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              StreamBuilder<List<ChatMessageModel>>(
                stream: _chatService.streamMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;

                  // In StreamBuilder
                  if (_isFirstLoad && messages.length > 1) {
                    _isFirstLoad = false;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollToBottom();
                      }
                    });
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final showAvatar = !message.isUser &&
                          (index == 0 || messages[index - 1].isUser);

                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/atomic.png',
                                  height: 80,
                                  width: 80,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: QuimifyColors.teal(),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      message.content,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      }

                      return ChatMessage(
                        message: message.content,
                        isUser: message.isUser,
                        showAvatar: showAvatar,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          decoration: BoxDecoration(
            color: QuimifyColors.background(context),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: double.infinity,
                color: QuimifyColors.background(context),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      ...quickQuestions.map((question) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _QuickQuestionButton(
                              text: question,
                              onTap: _isLoading
                                  ? null
                                  : () => _handleSendMessage(question),
                              enabled: !_isLoading,
                            ),
                          )),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        enabled: !_isLoading, // Disable when loading

                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: TextStyle(
                              color: QuimifyColors.quaternary(context)),
                          filled: true,
                          fillColor: _isLoading
                              ? QuimifyColors.foreground(context)
                                  .withOpacity(0.7)
                              : QuimifyColors.foreground(context),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                            borderSide: BorderSide(
                                color: QuimifyColors.tertiary(context)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                            borderSide: BorderSide(
                                color: QuimifyColors.tertiary(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24)),
                            borderSide: BorderSide(color: QuimifyColors.teal()),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        style: TextStyle(color: QuimifyColors.primary(context)),
                        onSubmitted: _isLoading ? null : _handleSendMessage,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  QuimifyColors.teal()),
                              strokeWidth: 2,
                            )
                          : Icon(Icons.send, color: QuimifyColors.teal()),
                      onPressed: () => _handleSendMessage(_textController.text),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickQuestionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool enabled;

  const _QuickQuestionButton({
    required this.text,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: enabled
              ? QuimifyColors.teal()
              : QuimifyColors.teal().withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class AutomaticKeepAliveClient extends StatefulWidget {
  final Widget child;

  const AutomaticKeepAliveClient({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  AutomaticKeepAliveClientState createState() =>
      AutomaticKeepAliveClientState();
}

class AutomaticKeepAliveClientState extends State<AutomaticKeepAliveClient>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
