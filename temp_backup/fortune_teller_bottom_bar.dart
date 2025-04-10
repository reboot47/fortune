import 'package:flutter/material.dart';
import '../screens/fortune_teller/fortune_teller_home_screen.dart';
import '../screens/fortune_teller/fortune_teller_mypage_screen.dart';

class FortuneTellerBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final bool isWaiting;
  final Function() onWaitingToggle;

  const FortuneTellerBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.isWaiting,
    required this.onWaitingToggle,
  }) : super(key: key);

  @override
  State<FortuneTellerBottomBar> createState() => _FortuneTellerBottomBarState();
}

class _FortuneTellerBottomBarState extends State<FortuneTellerBottomBar> {
  @override
  Widget build(BuildContext context) {
    // 画面幅を取得して中央配置を計算
    final double screenWidth = MediaQuery.of(context).size.width;
    
    return Stack(
      clipBehavior: Clip.none, // 外にはみ出す要素を表示
      alignment: Alignment.bottomCenter,
      children: [
        // ボトムナビゲーションバー
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 5,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabItem(0, Icons.home, 'ホーム'),
              _buildTabItem(1, Icons.send, 'チャット'),
              // 中央のスペース
              SizedBox(width: screenWidth / 5),
              _buildTabItem(3, Icons.school, '教えて先生'),
              _buildTabItem(4, Icons.person, 'マイページ'),
            ],
          ),
        ),
        
        // フローティングアクションボタン（待機/オフライン切り替え）
        Positioned(
          bottom: 20,
          child: GestureDetector(
            onTap: widget.onWaitingToggle,
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: widget.isWaiting ? const Color(0xFF3bcfd4) : Colors.grey,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 22,
                    ),
                    Text(
                      widget.isWaiting ? '待機中' : 'オフライン',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final bool isSelected = widget.currentIndex == index;
    
    return GestureDetector(
      onTap: () => widget.onTabTapped(index),
      child: Container(
        width: 60,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF3bcfd4) : Colors.grey,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF3bcfd4) : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
