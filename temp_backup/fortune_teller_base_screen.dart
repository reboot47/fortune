import 'package:flutter/material.dart';
import 'fortune_teller_bottom_bar.dart';
import '../screens/fortune_teller/fortune_teller_home_screen.dart';
import '../screens/fortune_teller/fortune_teller_mypage_screen.dart';

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
    return Scaffold(
      appBar: widget.customAppBar ?? AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          _isWaiting ? 'チャット相談中' : 'オフライン',
          style: TextStyle(
            color: const Color(0xFF3bcfd4),
            fontSize: 16,
          ),
        ),
        centerTitle: widget.centerTitle,
        actions: widget.actions,
      ),
      body: widget.body,
      bottomNavigationBar: FortuneTellerBottomBar(
        currentIndex: _currentIndex,
        onTabTapped: _onItemTapped,
        isWaiting: _isWaiting,
        onWaitingToggle: _toggleWaitingStatus,
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
  void _toggleWaitingStatus() {
    setState(() {
      _isWaiting = !_isWaiting;
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
