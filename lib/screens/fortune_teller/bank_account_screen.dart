import 'package:flutter/material.dart';
import '../../widgets/fortune_teller_base_screen.dart';
import '../../widgets/fortune_teller_tab_bar.dart';

/// 占い師用の銀行口座情報編集画面
class BankAccountScreen extends StatefulWidget {
  const BankAccountScreen({Key? key}) : super(key: key);

  @override
  State<BankAccountScreen> createState() => _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  // ボトムナビゲーション用
  int _currentIndex = 4; // マイページタブ
  bool _isWaiting = true; // 初期状態は待機中
  
  // タブ選択状態
  final int _selectedTabIndex = 3; // 銀行口座情報タブ

  @override
  Widget build(BuildContext context) {
    return FortuneTellerBaseScreen(
      currentIndex: _currentIndex,
      isWaiting: _isWaiting,
      onWaitingStatusChanged: (value) {
        setState(() {
          _isWaiting = value;
        });
      },
      body: Column(
        children: [
          // 共通タブバー
          FortuneTellerTabBar(
            currentTabIndex: _selectedTabIndex,
            parentContext: context,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    '銀行口座情報編集画面は開発中です',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3bcfd4),
                    ),
                    child: const Text('戻る'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
