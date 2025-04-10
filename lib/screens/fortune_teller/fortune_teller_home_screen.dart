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

// アプリ全体で共有するドロワーキー
final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey<ScaffoldState>();

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // バナー広告
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 70, // 高さを増やす
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          '新企画',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 35),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  color: Colors.pink,
                                  child: const Text(
                                    '雑誌',
                                    style: TextStyle(color: Colors.white, fontSize: 9),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '美人 雑誌掲載企画',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  color: Colors.white,
                                  child: const Text(
                                    '期間',
                                    style: TextStyle(fontSize: 9),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '3/27(土)～4/3(日)',
                                  style: TextStyle(fontSize: 9),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // この行を修正して、FittedBoxでテキストをコンテナに収める
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      '百花',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.pink,
                                      ),
                                    ),
                                    Text(
                                      ' ランキング上位20名を掲載',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: '日別'),
                Tab(text: '月別'),
              ],
            ),
          ),

          // ポイント表示
          SizedBox(
            height: 120,
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '本日の獲得ポイント',
                              style: TextStyle(
                                color: Color(0xFF3bcfd4),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '—',
                                  style: TextStyle(
                                    color: Color(0xFF3bcfd4),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                ),
                                const Text(
                                  'pts',
                                  style: TextStyle(
                                    color: Color(0xFF3bcfd4),
                                    fontSize: 14,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: const Color(0xFFFCE4EC),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '本日の目標ポイント',
                              style: TextStyle(
                                color: Colors.pink,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  _monthlyTargetPoints,
                                  style: const TextStyle(
                                    color: Colors.pink,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                ),
                                const Text(
                                  'pts',
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 14,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                // 月別タブのコンテンツ
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: const Color(0xFFE0F7F5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '当月の獲得ポイント',
                              style: TextStyle(
                                color: Color(0xFF3bcfd4),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '102,345.67',
                                  style: TextStyle(
                                    color: Color(0xFF3bcfd4),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                ),
                                const Text(
                                  'pts',
                                  style: TextStyle(
                                    color: Color(0xFF3bcfd4),
                                    fontSize: 14,
                                    height: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        color: const Color(0xFFFFF3E0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '当月の目標ポイント',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                const Text(
                                  '1,250,000',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                ),
                                const Text(
                                  'pts',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                    height: 1.0,
                                  ),
                                ),
                              ],
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
              Expanded(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '待機時間',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _waitingHours + '時間',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '稼働日数',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _workingDays + '日',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '教えて先生回答数',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _teacherResponses + '件',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ミッションセクション
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            alignment: Alignment.centerLeft,
            child: const Text(
              'ミッション',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // ミッションクリアカード
                Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/mission_clear_bg.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [const Color(0xFFE7D9F9), const Color(0xFFF1EAFC)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/crown.png',
                                    width: 20,
                                    height: 20,
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.emoji_events,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                  const Text(
                                    'mission',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Image.asset(
                                'assets/images/mission_clear.png',
                                height: 40,
                                errorBuilder: (context, error, stackTrace) => const Text(
                                  'CLEAR',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB388FF),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // デイリーミッション
                Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3BCFD4),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'デイリー',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Center(
                          child: Text(
                            '残2/2件',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // 進捗バー
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: _dailyMissionCompleted,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF3BCFD4), Colors.green],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: _dailyMissionTotal - _dailyMissionCompleted,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // ゲリラミッション
                Expanded(
                  child: Container(
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ゲリラ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Center(
                          child: Text(
                            '残4/4件',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // 進捗バー
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: _guerrillaMissionCompleted,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.deepOrange, Colors.orange],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: _guerrillaMissionTotal - _guerrillaMissionCompleted,
                                child: Container(),
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
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            alignment: Alignment.centerLeft,
            child: const Text(
              '運営ブログ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _blogPosts.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // ブログ記事を開く
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // サムネイル
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.asset(
                                'assets/images/blog_thumbnail_${index + 1}.jpg',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.article,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // ブログ情報
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // カテゴリーラベル
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0 ? const Color(0xFF3BCFD4) : Colors.orange,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      index % 2 == 0 ? 'お知らせ' : 'キャンペーン',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  // タイトル
                                  Text(
                                    _blogPosts[index]['title']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  // 投稿日
                                  Text(
                                    _blogPosts[index]['date']!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            // 矢印
                            const Icon(
                              Icons.chevron_right,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}