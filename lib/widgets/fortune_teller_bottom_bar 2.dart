import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../screens/fortune_teller/fortune_teller_home_screen.dart';
import '../screens/fortune_teller/fortune_teller_mypage_screen.dart';

// 斜め縞模様を描画するためのカスタムペインター
class StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;
    
    // 斜め線を描画
    for (double i = -size.width; i < size.width * 2; i += 20) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FortuneTellerBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final bool isWaiting;
  final Function(bool) onWaitingToggle;

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
            onTap: () {
              // 待機状態のモーダルを表示
              if (!widget.isWaiting) {
                // オフライン状態から待機設定モーダルを開く
                _showWaitingSettingsModal(context);
              }
            },
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
              child: GestureDetector(
                onTap: () {
                  if (widget.isWaiting) {
                    // 待機中の場合、待機終了モーダルを表示
                    _showActiveWaitingModal(context);
                  } else {
                    // 待機する場合、設定モーダルを表示
                    _showWaitingSettingsModal(context);
                  }
                },
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
                        widget.isWaiting ? '待機中' : '待機する',
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
        ),
      ],
    );
  }

  // 待機設定モーダルを表示する関数
  // 待機中モーダル - 待機中の場合に表示される
  void _showActiveWaitingModal(BuildContext context) {
    // 日時入力用コントローラー
    final TextEditingController _dateTimeController = TextEditingController();
    // チャット待機と通話相談の状態
    bool _isChatWaiting = true;
    bool _isCallWaiting = true;
    int _chatWaitingCount = 2; // チャット待機人数

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 430,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '次回ログイン予定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _dateTimeController,
                            decoration: const InputDecoration(
                              hintText: '日時を設定してください',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '公開',
                            style: TextStyle(color: Colors.grey[500], fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 12),
                  const Text(
                    '待機設定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('チャット待機',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // 人数表示
                          Text(
                            '$_chatWaitingCount 人',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 5),
                          // 下向き矢印
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                      Switch(
                        value: _isChatWaiting,
                        onChanged: (value) {
                          setState(() {
                            _isChatWaiting = value;
                          });
                        },
                        activeColor: const Color(0xFF7adedf),
                        activeTrackColor: const Color(0xFF7adedf).withOpacity(0.6),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('通話相談',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Switch(
                        value: _isCallWaiting,
                        onChanged: (value) {
                          setState(() {
                            _isCallWaiting = value;
                          });
                        },
                        activeColor: const Color(0xFF7adedf),
                        activeTrackColor: const Color(0xFF7adedf).withOpacity(0.6),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey[300],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  // 警告メッセージ
                  const Text(
                    '通話待機中にアプリをバックグラウンドからタスクキルしないでください',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 待機を終了するボタン
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // 待機終了処理
                        Navigator.pop(context);
                        widget.onWaitingToggle(false); // 待機状態を解除
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4081), // ピンク色
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('待機を終了する',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // キャンセルボタン
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        // キャンセル処理
                        Navigator.pop(context);
                      },
                      child: const Text('キャンセル',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 待機設定モーダル - 待機するボタンを押した場合に表示される
  void _showWaitingSettingsModal(BuildContext context) {
    // 日時入力用コントローラー
    final TextEditingController _dateTimeController = TextEditingController();
    // チャット待機と通話相談の状態
    bool _isChatWaiting = true;
    bool _isCallWaiting = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 430, // オーバーフローを解消するために大幅に高さを増加
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '次回ログイン予定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _dateTimeController,
                            decoration: const InputDecoration(
                              hintText: '日時を設定してください',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // より薄いグレー
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '公開',
                            style: TextStyle(color: Colors.grey[500], fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 12),
                  const Text(
                    '待機設定',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('チャット待機',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        // Switch周りのデザインを調整
                        transform: Matrix4.translationValues(0, 0, 0),
                        child: Switch(
                          value: _isChatWaiting,
                          onChanged: (value) {
                            setState(() {
                              _isChatWaiting = value;
                            });
                          },
                          activeColor: const Color(0xFF7adedf), // より薄いターコイズ色
                          activeTrackColor: const Color(0xFF7adedf).withOpacity(0.6),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('通話相談',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        // Switch周りのデザインを調整
                        transform: Matrix4.translationValues(0, 0, 0),
                        child: Switch(
                          value: _isCallWaiting,
                          onChanged: (value) {
                            setState(() {
                              _isCallWaiting = value;
                            });
                          },
                          activeColor: const Color(0xFF7adedf), // より薄いターコイズ色
                          activeTrackColor: const Color(0xFF7adedf).withOpacity(0.6),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // 待機を開始するボタン
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // 待機開始処理
                        // 設定を適用してモーダルを閉じる
                        Navigator.pop(context);
                        
                        // 待機状態を有効にする
                        widget.onWaitingToggle(true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3bcfd4),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('待機を開始する',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // キャンセルボタン
                  Center(
                    child: Container(
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
