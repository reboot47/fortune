import 'package:flutter/material.dart';
import 'fortune_teller_bottom_bar.dart';
import 'fortune_teller_drawer.dart';
import '../screens/fortune_teller/fortune_teller_home_screen.dart';
import '../screens/fortune_teller/fortune_teller_mypage_screen.dart';

// アプリ全体で共有するスカフォールドキー
final GlobalKey<ScaffoldState> baseAppKey = GlobalKey<ScaffoldState>();

// ドロワーを確実に開くユーティリティ関数
void openBaseDrawer() {
  if (baseAppKey.currentState != null && !baseAppKey.currentState!.isDrawerOpen) {
    baseAppKey.currentState!.openDrawer();
  }
}

/// 占い師用の共通ベース画面
/// フッターメニューと待機/オフライン状態の切り替え機能を提供
class FortuneTellerBaseScreen extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget? customAppBar;
  final Widget? floatingActionButton;
  final int currentIndex;
  final bool isWaiting;
  final Function(bool)? onWaitingStatusChanged;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool hideBottomBar;
  final GlobalKey<ScaffoldState>? scaffoldKey; // スカフォールドキーを追加

  const FortuneTellerBaseScreen({
    Key? key,
    required this.body,
    this.customAppBar,
    this.floatingActionButton,
    required this.currentIndex,
    required this.isWaiting,
    this.onWaitingStatusChanged,
    this.centerTitle = true,
    this.actions,
    this.hideBottomBar = false,
    this.scaffoldKey, // スカフォールドキーパラメータを追加
  }) : super(key: key);

  @override
  State<FortuneTellerBaseScreen> createState() => _FortuneTellerBaseScreenState();
}

class _FortuneTellerBaseScreenState extends State<FortuneTellerBaseScreen> {
  late int _currentIndex;
  late bool _isWaiting;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _isWaiting = widget.isWaiting;
  }

  @override
  void didUpdateWidget(FortuneTellerBaseScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _currentIndex = widget.currentIndex;
    }
    if (oldWidget.isWaiting != widget.isWaiting) {
      _isWaiting = widget.isWaiting;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 確実に開けるグローバルキーを使用
    final scaffoldKey = widget.scaffoldKey ?? baseAppKey;
    
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: true, // ドラッグでもドロワーを開けるように
      appBar: widget.customAppBar ?? AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            // 左側のチャットアイコン - タップでドロワーを開く
            GestureDetector(
              onTap: () {
                // ドロワーを開く
                openBaseDrawer();
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF3bcfd4),
                  size: 22,
                ),
              ),
            ),
            
            // 待機中/オフラインテキスト - タップでドロワーを開く
            GestureDetector(
              onTap: () {
                // ドロワーを開く
                openBaseDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  _isWaiting ? '待機中' : 'オフライン',
                  style: const TextStyle(
                    color: Color(0xFF3bcfd4),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // 右側のスペースを埋める
            const Spacer(),
            
            // 右側の通知アイコン
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.notifications_none, 
                color: Color(0xFF3bcfd4), 
                size: 26,
              ),
            ),
          ],
        ),
      ),
      drawer: const FortuneTellerDrawer(),
      body: widget.body,
      bottomNavigationBar: widget.hideBottomBar ? null : FortuneTellerBottomBar(
        currentIndex: _currentIndex,
        onTabTapped: _onItemTapped,
        isWaiting: _isWaiting,
        onWaitingToggle: _toggleWaitingStatus,
        onChatTap: () {
          // チャットボタンを押したときにドロワーを開く
          if (widget.scaffoldKey != null) {
            widget.scaffoldKey!.currentState?.openDrawer();
          } else {
            Scaffold.of(context).openDrawer();
          }
        },
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  /// フッターメニューのタブタップ処理
  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    
    setState(() {
      _currentIndex = index;
    });
    
    // タブに応じた画面遷移
    switch (index) {
      case 0:
        // ホーム画面に遷移
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FortuneTellerHomeScreen()),
        );
        break;
      case 1:
        // チャット画面に遷移
        _showNotImplementedMessage('チャット機能');
        break;
      case 3:
        // 教えて先生画面に遷移
        _showNotImplementedMessage('教えて先生機能');
        break;
      case 4:
        // マイページに遷移
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FortuneTellerMyPageScreen()),
        );
        break;
    }
  }

  /// 待機状態の切り替え
  /// [newStatus] 新しい待機状態を指定する場合はその値を使用し、省略された場合は現在の状態を反転
  void _toggleWaitingStatus([bool? newStatus]) {
    setState(() {
      // 新しい状態が指定されていればそれを使用、そうでなければ現在の状態を反転
      _isWaiting = newStatus ?? !_isWaiting;
    });
    
    // 親ウィジェットに状態変更を通知
    if (widget.onWaitingStatusChanged != null) {
      widget.onWaitingStatusChanged!(_isWaiting);
    }
    
    // 状態が変わったことを通知
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isWaiting ? '待機状態になりました' : 'オフライン状態になりました'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// 未実装機能の通知
  void _showNotImplementedMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$featureは開発中です')),
    );
  }
}
