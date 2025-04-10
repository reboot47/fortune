import 'package:flutter/material.dart';
import '../../models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  
  const ChatBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.system) {
      // システムメッセージ（通知など）
      return _buildSystemMessage();
    } else if (message.sender == MessageSender.user) {
      // ユーザーからのメッセージ
      return _buildUserMessage();
    } else {
      // 占い師からのメッセージ
      return _buildFortuneTellerMessage();
    }
  }

  // システムメッセージ（通知）の表示
  Widget _buildSystemMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info_outline, size: 14, color: Colors.grey[700]),
                const SizedBox(width: 4),
                Text(
                  message.content,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ユーザーからのメッセージ
  Widget _buildUserMessage() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 8, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.type == MessageType.text) ...[
                // 通常のテキストメッセージ
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFECB3),  // 淡いオレンジ色
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ] else if (message.type == MessageType.sticker) ...[
                // スタンプ表示
                Container(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      message.stickerUrl ?? 'assets/images/default_sticker.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              // ユーザーアイコン
              ClipOval(
                child: Container(
                  width: 36,
                  height: 36,
                  color: Colors.pink[100],
                  child: Image.asset(
                    'assets/images/user_avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      color: Colors.pink,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 時間と既読表示
          Padding(
            padding: const EdgeInsets.only(top: 2, right: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (message.isPaid) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'オフラインメッセージ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(
                  message.getFormattedTime(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  '既読',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 占い師からのメッセージ
  Widget _buildFortuneTellerMessage() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 50, top: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 占い師アイコン
              ClipOval(
                child: Container(
                  width: 36,
                  height: 36,
                  color: Colors.amber[100],
                  child: Image.asset(
                    'assets/images/fortune_teller_avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.person,
                      color: Colors.amber,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (message.type == MessageType.text) ...[
                // 通常のテキストメッセージ
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ] else if (message.type == MessageType.sticker) ...[
                // スタンプ表示
                Container(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Image.asset(
                    'assets/images/thank_you_sticker.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite, color: Colors.orange, size: 24),
                          Text(
                            'ありがとうございました',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          // 時間表示
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 48),
            child: Text(
              message.getFormattedTime(),
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
