import 'package:flutter/material.dart';

class ChatTemplate extends StatelessWidget {
  final Function(String) onTemplateSelected;
  final VoidCallback onClose;
  
  const ChatTemplate({
    Key? key,
    required this.onTemplateSelected,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // テンプレートボタンのリスト
    final templates = [
      "はじめまして",
      "ありがとう",
      "失恋",
      "オン優先",
      "よろしく",
      "どんなお悩み",
      "見ていきます",
      "微妙結果✓",
      "新規営業",
      "復縁について",
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 30), // 左側のスペース確保
              const Text(
                'テンプレート',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // 閉じるボタン
              GestureDetector(
                onTap: onClose,
                child: Row(
                  children: [
                    const Icon(
                      Icons.close, 
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'テンプレを閉じる',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // テンプレートボタングリッド
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 3.5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: templates.map((template) {
              return _buildTemplateButton(template);
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // テンプレートボタンを生成
  Widget _buildTemplateButton(String text) {
    return OutlinedButton(
      onPressed: () => onTemplateSelected(text),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: const Color(0xFF3bcfd4), // ターコイズ色
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF3bcfd4),
          fontSize: 14,
        ),
      ),
    );
  }
}
