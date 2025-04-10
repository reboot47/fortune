import 'package:flutter/material.dart';

enum MessageType {
  text,
  image,
  sticker,
  system,
}

enum MessageSender {
  user,
  fortuneTeller,
  system,
}

class ChatMessage {
  final String id;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageSender sender;
  final bool isRead;
  final String? imageUrl;
  final String? stickerUrl;
  final bool isPaid;

  ChatMessage({
    required this.id,
    required this.content,
    required this.timestamp,
    required this.type,
    required this.sender,
    this.isRead = false,
    this.imageUrl,
    this.stickerUrl,
    this.isPaid = false,
  });

  // 日付フォーマット用
  String getFormattedTime() {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  // デモ用チャットデータを生成
  static List<ChatMessage> getDemoMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
        id: '1',
        content: 'こんにちは、占い師さん。彼との関係について相談したいことがあります。',
        timestamp: now.subtract(const Duration(minutes: 35)),
        type: MessageType.text,
        sender: MessageSender.user,
        isRead: true,
      ),
      ChatMessage(
        id: '2',
        content: 'こんにちは。どのようなお悩みがありますか？具体的に教えていただけると鑑定しやすいです。',
        timestamp: now.subtract(const Duration(minutes: 33)),
        type: MessageType.text,
        sender: MessageSender.fortuneTeller,
        isRead: true,
      ),
      ChatMessage(
        id: '3',
        content: '彼とは3年ほど付き合っていますが、最近連絡が減っていて不安です。仕事が忙しいと言っていますが、本当はほかに理由があるのではないかと心配しています。',
        timestamp: now.subtract(const Duration(minutes: 30)),
        type: MessageType.text,
        sender: MessageSender.user,
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        content: 'なるほど、お気持ちお察しします。少しカードを引いてみましょう。',
        timestamp: now.subtract(const Duration(minutes: 28)),
        type: MessageType.text,
        sender: MessageSender.fortuneTeller,
        isRead: true,
        isPaid: true,
      ),
      ChatMessage(
        id: '5',
        content: 'システムメッセージ: 有料鑑定が開始されました。',
        timestamp: now.subtract(const Duration(minutes: 27)),
        type: MessageType.system,
        sender: MessageSender.system,
        isRead: true,
      ),
      ChatMessage(
        id: '6',
        content: 'カードを見る限り、彼の気持ちに変化はなさそうです。ただ、仕事の状況が本当に厳しいようです。連絡が減ったのは一時的なものかもしれません。',
        timestamp: now.subtract(const Duration(minutes: 25)),
        type: MessageType.text,
        sender: MessageSender.fortuneTeller,
        isRead: true,
        isPaid: true,
      ),
      ChatMessage(
        id: '7',
        content: 'そうですか...でも、以前はどんなに忙しくても連絡をくれていたんです。何か変わったのでしょうか？',
        timestamp: now.subtract(const Duration(minutes: 23)),
        type: MessageType.text,
        sender: MessageSender.user,
        isRead: true,
      ),
      ChatMessage(
        id: '8',
        content: 'カードからは、彼が今抱えているプレッシャーが見えます。以前とは違う責任を負うようになったのかもしれません。ただ、あなたへの気持ちは変わっていないようです。もう少し様子を見てみましょう。',
        timestamp: now.subtract(const Duration(minutes: 20)),
        type: MessageType.text,
        sender: MessageSender.fortuneTeller,
        isRead: true,
        isPaid: true,
      ),
      ChatMessage(
        id: '9',
        content: 'わかりました。少し安心しました。ありがとうございます。',
        timestamp: now.subtract(const Duration(minutes: 18)),
        type: MessageType.text,
        sender: MessageSender.user,
        isRead: true,
      ),
      ChatMessage(
        id: '10',
        content: 'いいえ、どういたしまして。何かあればいつでもご相談ください。',
        timestamp: now.subtract(const Duration(minutes: 15)),
        type: MessageType.text,
        sender: MessageSender.fortuneTeller,
        isRead: true,
      ),
      // 追加のシステムメッセージ
      ChatMessage(
        id: '11',
        content: 'システムメッセージ: 無料モードに切り替わりました。',
        timestamp: now.subtract(const Duration(minutes: 10)),
        type: MessageType.system,
        sender: MessageSender.system,
        isRead: true,
      ),
      ChatMessage(
        id: '4',
        content: 'ありがとうございました',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        type: MessageType.sticker,
        sender: MessageSender.fortuneTeller,
        stickerUrl: 'assets/images/thank_you_sticker.png',
        isRead: true,
      ),
      ChatMessage(
        id: '5',
        content: '[通知] チャットが終了しました。',
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        type: MessageType.system,
        sender: MessageSender.system,
        isRead: true,
      ),
      ChatMessage(
        id: '6',
        content: '本日はありがとうございました✨ 良い結果も辛い結果も見えたままをお伝えしているのは、幸せへのお導きをしたいからです！👑しっかり寄り添わせて頂くので気軽にいつでもお声かけくださいね💪',
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        type: MessageType.text,
        sender: MessageSender.user,
        isRead: true,
      ),
    ];
  }
}
