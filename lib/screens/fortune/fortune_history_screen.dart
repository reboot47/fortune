import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/fortune_type.dart';
import '../../theme/app_theme.dart';
import '../../services/database_service.dart';
import 'fortune_result_screen.dart';

class FortuneHistoryScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const FortuneHistoryScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _FortuneHistoryScreenState createState() => _FortuneHistoryScreenState();
}

class _FortuneHistoryScreenState extends State<FortuneHistoryScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _fortuneHistory = [];

  @override
  void initState() {
    super.initState();
    _loadFortuneHistory();
  }

  // 占い履歴を読み込む
  Future<void> _loadFortuneHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ユーザーIDを取得
      final userId = widget.userData['id'];
      
      if (userId == null) {
        throw Exception('ユーザーIDが見つかりません');
      }

      // データベースサービスの初期化
      final dbService = DatabaseService();
      await dbService.connect();
      
      // 占い履歴を取得
      final result = await dbService.getUserFortuneHistory(userId);
      
      if (result['success']) {
        setState(() {
          _fortuneHistory = List<Map<String, dynamic>>.from(result['history']);
          _isLoading = false;
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('占い履歴の読み込みに失敗しました: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '占い履歴',
          style: TextStyle(
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildHistoryContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryContent() {
    if (_fortuneHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              '占い履歴がありません',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('占いを始める'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _fortuneHistory.length,
      itemBuilder: (context, index) {
        final historyItem = _fortuneHistory[index];
        final fortuneType = FortuneTypes.getById(historyItem['fortune_type']);
        final createdAt = DateTime.parse(historyItem['created_at']);
        final formattedDate = '${createdAt.year}年${createdAt.month}月${createdAt.day}日';
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          child: InkWell(
            onTap: () {
              // 占い結果の詳細画面に遷移
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FortuneResultScreen(
                    userData: widget.userData,
                    fortuneType: fortuneType ?? FortuneTypes.tarot,
                    resultContent: historyItem['result_content'],
                    resultId: historyItem['id'],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getColorForFortuneType(historyItem['fortune_type']).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getIconForFortuneType(historyItem['fortune_type']),
                          color: _getColorForFortuneType(historyItem['fortune_type']),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fortuneType?.name ?? historyItem['fortune_type'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1a237e),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (historyItem['fortune_teller_name'] != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '占い師: ${historyItem['fortune_teller_name']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    historyItem['result_content'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '詳細を見る',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
