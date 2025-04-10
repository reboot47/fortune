import 'package:flutter/material.dart';
import '../screens/fortune_teller/profile_edit_screen.dart';
import '../screens/fortune_teller/template_edit_screen.dart';
import '../screens/fortune_teller/account_edit_screen.dart';
import '../screens/fortune_teller/bank_account_screen.dart';

class FortuneTellerTabBar extends StatelessWidget {
  final int currentTabIndex;
  final BuildContext parentContext;

  const FortuneTellerTabBar({
    Key? key,
    required this.currentTabIndex,
    required this.parentContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = [
      'プロフィール設定', 
      'テンプレート編集', 
      'アカウント設定', 
      '銀行口座設定',
    ];

    return Container(
      color: Colors.white,
      height: 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(tabs.length, (index) {
            return _buildTab(context, tabs[index], index);
          }),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String tabName, int index) {
    final bool isSelected = index == currentTabIndex;
    
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF3bcfd4) : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          tabName,
          style: TextStyle(
            color: isSelected ? const Color(0xFF3bcfd4) : Colors.grey,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    // 現在のタブを再タップした場合は何もしない
    if (index == currentTabIndex) return;

    // 現在の画面を閉じる
    Navigator.pop(parentContext);
    
    // 選択されたタブに対応する画面に遷移
    Widget destinationScreen;
    
    switch (index) {
      case 0:
        destinationScreen = const ProfileEditScreen();
        break;
      case 1:
        destinationScreen = const TemplateEditScreen();
        break;
      case 2:
        destinationScreen = const AccountEditScreen();
        break;
      case 3:
        destinationScreen = const BankAccountScreen();
        break;
      default:
        destinationScreen = const ProfileEditScreen();
    }
    
    Navigator.push(
      parentContext,
      MaterialPageRoute(builder: (context) => destinationScreen),
    );
  }
}
