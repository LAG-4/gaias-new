import 'package:flutter/material.dart';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text,
          isUser: true,
        ),
      );
      _isTyping = true;
    });

    final userMessage = _messageController.text;
    _messageController.clear();

    // Simulate AI response after a short delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            text: "This is a simulated response to: $userMessage",
            isUser: false,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : Colors.white,
        elevation: 0,
        shape: Border(
          bottom: BorderSide(width: 2, color: Colors.teal[400]!),
        ),
        centerTitle: true,
        title: Text(
          "AI ASSISTANT",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontFamily: 'Habibi',
            letterSpacing: 1.2,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _messages[_messages.length - 1 - index];
                      },
                    ),
            ),
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF262626)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.grey[800]!
                              : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Animated dot container
                          Container(
                            width: 40,
                            height: 20,
                            margin: const EdgeInsets.only(right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 3; i++)
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    height: 8,
                                    width: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.teal[400],
                                      shape: BoxShape.circle,
                                    ),
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      duration: Duration(milliseconds: 800 + (i * 200)),
                                      builder: (context, value, child) {
                                        return Transform.scale(
                                          scale: 0.6 + (0.4 * (value > 0.5 ? 1 - value : value) * 2),
                                          child: child,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.teal[400],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            "AI is thinking",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            _buildInputArea(isDarkMode),
          ],
        ),
      ),
    );
  }

  // Method for the empty state UI
  Widget _buildEmptyState(bool isDarkMode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust UI based on available height
        final bool isSmallScreen = constraints.maxHeight < 500;
        
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: isSmallScreen ? 20 : 40),
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    size: isSmallScreen ? 48 : 64,
                    color: Colors.teal[400],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 16 : 24),
                Text(
                  "How can I assist you today?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Text(
                  "Ask me anything - from answering questions to generating content or providing recommendations.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 32),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildSuggestionChip("Explain quantum computing"),
                    _buildSuggestionChip("Write a poem about nature"),
                    _buildSuggestionChip("Recommend books to read"),
                    _buildSuggestionChip("Tell me a fun fact"),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 20 : 40),
              ],
            ),
          ),
        );
      }
    );
  }

  // Method for the input area UI
  Widget _buildInputArea(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine if we need to show all buttons based on width
          final bool isNarrow = constraints.maxWidth < 300;
          
          return Container(
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF262626) : Colors.grey[100],
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Emoji button - hide on narrow screens
                if (!isNarrow)
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        size: 22,
                      ),
                      onPressed: () {
                        // Emoji picker functionality would go here
                      },
                    ),
                  ),
                
                // Text input field
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: isNarrow ? 12 : 4,
                      bottom: 8,
                      top: 4,
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 16,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      cursorColor: Colors.teal[400],
                      cursorWidth: 2,
                      cursorRadius: const Radius.circular(2),
                    ),
                  ),
                ),

                // Attachment button - hide on narrow screens
                if (!isNarrow)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      icon: Icon(
                        Icons.attach_file_rounded,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        size: 22,
                      ),
                      onPressed: () {
                        // Attachment functionality would go here
                      },
                    ),
                  ),
                
                // Send button
                Padding(
                  padding: const EdgeInsets.only(right: 4, bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _sendMessage,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.teal[300]!,
                              Colors.teal[500]!,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  // Helper method to build suggestion chips
  Widget _buildSuggestionChip(String suggestion) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return InkWell(
      onTap: () {
        _messageController.text = suggestion;
        _sendMessage();
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          suggestion,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.teal[400],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? Colors.teal[400]
                    : isDarkMode
                        ? const Color(0xFF262626)
                        : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : isDarkMode
                          ? Colors.white
                          : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.teal[400],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
} 