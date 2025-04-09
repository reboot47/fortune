import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/fortune_type.dart';
import '../../theme/app_theme.dart';

class FortuneResultScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final FortuneType fortuneType;
  final String resultContent;
  final int resultId;

  const FortuneResultScreen({
    Key? key,
    required this.userData,
    required this.fortuneType,
    required this.resultContent,
    required this.resultId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${fortuneType.name}の結果',
          style: const TextStyle(
            color: Color(0xFF1a237e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // 背景デザイン要素
          Positioned(
            top: -50,
            left: -20,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFFf8bbd0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // メインコンテンツ
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultHeader(),
                  const SizedBox(height: 24),
                  _buildResultContent(),
                  const SizedBox(height: 32),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 結果ヘッダー
  Widget _buildResultHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getColorForFortuneType(fortuneType.id),
            _getColorForFortuneType(fortuneType.id).withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _getIconForFortuneType(fortuneType.id),
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            fortuneType.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${DateTime.now().year}年${DateTime.now().month}月${DateTime.now().day}日の占い結果',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms, delay: 100.ms)
      .moveY(begin: 10, end: 0, duration: 350.ms, curve: Curves.easeOutQuad);
  }

  // 結果内容
  Widget _buildResultContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '占い結果',
            style: TextStyle(
              color: Color(0xFF1a237e),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            resultContent,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms, delay: 300.ms)
      .moveY(begin: 10, end: 0, duration: 350.ms, curve: Curves.easeOutQuad);
  }

  // アクションボタン
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          icon: Icons.share,
          label: '共有する',
          color: Colors.blue,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('共有機能は開発中です')),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.chat_bubble,
          label: '占い師に相談',
          color: AppTheme.primaryColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('占い師相談機能は開発中です')),
            );
          },
        ),
        _buildActionButton(
          icon: Icons.bookmark,
          label: '保存する',
          color: Colors.amber,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('保存機能は開発中です')),
            );
          },
        ),
      ],
    ).animate()
      .fadeIn(duration: 500.ms, delay: 500.ms)
      .moveY(begin: 10, end: 0, duration: 350.ms, curve: Curves.easeOutQuad);
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 占いタイプに応じたアイコンを取得
  IconData _getIconForFortuneType(String fortuneTypeId) {
    switch (fortuneTypeId) {
      case 'tarot':
        return Icons.style;
      case 'horoscope':
        return Icons.star;
      case 'palmistry':
        return Icons.pan_tool;
      case 'onmyoji':
        return Icons.brightness_4;
      case 'compatibility':
        return Icons.favorite;
      default:
        return Icons.star;
    }
  }

  // 占いタイプに応じた色を取得
  Color _getColorForFortuneType(String fortuneTypeId) {
    switch (fortuneTypeId) {
      case 'tarot':
        return Colors.purple;
      case 'horoscope':
        return Colors.blue;
      case 'palmistry':
        return Colors.orange;
      case 'onmyoji':
        return Colors.indigo;
      case 'compatibility':
        return Colors.pink;
      default:
        return AppTheme.primaryColor;
    }
  }
}
