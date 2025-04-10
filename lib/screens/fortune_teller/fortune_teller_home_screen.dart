import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_theme.dart';
import '../../services/database_service.dart';
import '../../widgets/fortune_teller_base_screen.dart';
import 'fortune_teller_mypage_screen.dart';

/// 占い師専用ホーム画面
class FortuneTellerHomeScreen extends StatefulWidget {
  const FortuneTellerHomeScreen({Key? key}) : super(key: key);

  @override
  State<FortuneTellerHomeScreen> createState() => _FortuneTellerHomeScreenState();
}

class _FortuneTellerHomeScreenState extends State<FortuneTellerHomeScreen> with SingleTickerProviderStateMixin {
  String _fortuneTellerName = '占い師';
  bool _isLoading = true;
  int _currentIndex = 0; // 現在のタブはホーム画面
  bool _isWaiting = false; // 初期状態はオフライン
  
  // 統計情報
  String _todayPoints = "---";
  String _monthlyTargetPoints = "40,322.58";
  String _waitingHours = "1";
  String _workingDays = "20";
  String _teacherResponses = "1";
  
  // タブコントローラー（日別・月別タブ切り替え用）
  late TabController _tabController;
  
  // ミッション達成状況
  bool _missionCleared = true;
  int _dailyMissionCompleted = 2;
  int _dailyMissionTotal = 2;
  int _guerrillaMissionCompleted = 4;
  int _guerrillaMissionTotal = 4;
  
  // 運営ブログ記事
  final List<Map<String, dynamic>> _blogPosts = [
    {
      'title': 'メンテナンスのお知らせ',
      'date': '3/24(月) 11時～',
      'content': 'メンテナンスのお知らせ',
      'color': const Color(0xFFE1BEE7),
      'icon': 'maintenance',
    },
    {
      'title': 'チャット報酬UP',
      'date': '[3/22(土)] 24時間',
      'content': 'チャット報酬UP!',
      'color': const Color(0xFFFFCCBC),
      'icon': 'reward',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ユーザーデータを読み込む
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // SharedPreferencesから基本情報を読み込む
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('fortune_teller_name') ?? '占い師';
      final isWaiting = prefs.getBool('is_waiting') ?? false;
      
      // 仮のモックデータをセット
      setState(() {
        _fortuneTellerName = name;
        _isWaiting = isWaiting;
        _todayPoints = "---";
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 待機状態を切り替える
  void _toggleWaitingStatus(bool value) {
    setState(() {
      _isWaiting = value;
    });
    
    // 状態が変わったことを通知
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isWaiting ? '待機状態になりました' : 'オフライン状態になりました'),
        duration: const Duration(seconds: 1),
      ),
    );
    
    // SharedPreferencesに保存
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('is_waiting', _isWaiting);
    });
  }

  // 未実装機能の通知
  void _showNotImplementedMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$featureは開発中です')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FortuneTellerBaseScreen(
      currentIndex: _currentIndex,
      isWaiting: _isWaiting,
      onWaitingStatusChanged: _toggleWaitingStatus,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3bcfd4)))
          : _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // バナー広告
          Container(
            width: double.infinity,
            height: 80,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('assets/images/banner_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.pink[100]!,
                            Colors.pink[50]!,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              color: Colors.pink,
                              child: const Text(
                                '雑誌',
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '美人 雑誌掲載企画',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  color: Colors.white,
                                  child: const Text(
                                    '期間',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '3/27(土)～4/3(日)',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '百花',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.pink,
                              ),
                            ),
                            Text(
                              'ランキング上位20名を掲載',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 日別・月別タブ
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF3bcfd4),
                    width: 3,
                  ),
                ),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: '日別'),
                Tab(text: '月別'),
              ],
            ),
          ),

          // ポイント表示
          SizedBox(
            height: 140,
            child: TabBarView(
              controller: _tabController,
              children: [
                // 日別タブのコンテンツ
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: const Color(0xFFE0F7F5),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '本日の獲得ポイント',
                              style: const TextStyle(
                                color: Color(0xFF3bcfd4),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _todayPoints,
                                    style: TextStyle(
                                      color: Color(0xFF3bcfd4),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'pts',
                                    style: TextStyle(
                                      color: Color(0xFF3bcfd4),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: const Color(0xFFFCE4EC),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '本日の目標ポイント',
                              style: const TextStyle(
                                color: Colors.pink,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: _monthlyTargetPoints,
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'pts',
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 14,
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
                
                // 月別タブのコンテンツ（同様のレイアウトで月間データ表示）
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: const Color(0xFFE0F7F5),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '今月の獲得ポイント',
                              style: TextStyle(
                                color: Color(0xFF3bcfd4),
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '125,480',
                                    style: TextStyle(
                                      color: Color(0xFF3bcfd4),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'pts',
                                    style: TextStyle(
                                      color: Color(0xFF3bcfd4),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: const Color(0xFFFCE4EC),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '月間目標ポイント',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '500,000',
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'pts',
                                    style: TextStyle(
                                      color: Colors.pink,
                                      fontSize: 14,
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
              ],
            ),
          ),

          // 統計情報
          Row(
            children: [
              _buildStatItem('待機時間', '${_waitingHours}時間'),
              _buildStatItem('稼働日数', '${_workingDays}日'),
              _buildStatItem('教えて先生回答数', '${_teacherResponses}件'),
            ],
          ),

          // ミッションセクション
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'ミッション',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ミッションカード
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                _buildMissionCard(
                  'ミッションクリア',
                  _missionCleared,
                  const Color(0xFFE1BEE7),
                  Icons.emoji_events,
                ),
                const SizedBox(width: 12),
                _buildMissionCard(
                  'デイリー',
                  false,
                  const Color(0xFF80CBC4),
                  Icons.flag,
                  progressText: '残${_dailyMissionCompleted}/${_dailyMissionTotal}件',
                ),
                const SizedBox(width: 12),
                _buildMissionCard(
                  'ゲリラ',
                  false,
                  const Color(0xFFFFAB91),
                  Icons.local_fire_department,
                  progressText: '残${_guerrillaMissionCompleted}/${_guerrillaMissionTotal}件',
                ),
              ],
            ),
          ),

          // 運営ブログセクション
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              '運営ブログ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ブログ記事カード
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: _blogPosts.map((post) => _buildBlogPostCard(post)).toList(),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // 統計情報アイテム（待機時間、稼働日数など）
  Widget _buildStatItem(String title, String value) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ミッションカード
  Widget _buildMissionCard(String title, bool isCompleted, Color color, IconData icon, {String? progressText}) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCompleted)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.star_border,
                      color: color,
                      size: 60,
                    ),
                    const Text(
                      'CLEAR',
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              else
                Icon(
                  icon,
                  color: color,
                  size: 40,
                ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (progressText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    progressText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ブログ記事カード
  Widget _buildBlogPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: post['color'],
      ),
      child: InkWell(
        onTap: () => _showNotImplementedMessage('ブログ記事の詳細表示'),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          post['icon'] == 'maintenance' ? Icons.build : Icons.monetization_on,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          post['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post['date'],
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
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
}