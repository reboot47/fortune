import 'package:flutter/material.dart';
import '../screens/fortune_teller/fortune_teller_home_screen.dart';
import '../screens/fortune_teller/fortune_teller_mypage_screen.dart';
import '../screens/chat/fortune_teller_chat_screen.dart'; // chatScreenScaffoldKeyをインポート
import 'fortune_teller_drawer.dart'; // ドロワーウィジェットをインポート
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FortuneTellerBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final bool isWaiting;
  final Function(bool) onWaitingToggle;
  final VoidCallback? onChatTap; // ドロワーを開くためのコールバック

  const FortuneTellerBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.isWaiting,
    required this.onWaitingToggle,
    this.onChatTap, // ドロワーを開くためのコールバック（オプション）
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
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    // その場でドロワーを開く
                    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
                    if (scaffold != null) {
                      scaffold.openDrawer();
                    } else {
                      // ドロワーが見つからない場合ユーザーに通知
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ドロワーを開くことができませんでした'))
                      );
                    }
                  },
                  child: Container(
                    width: 70,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.send,
                          size: 22,
                          color: Color(0xFF757575), // グレー色
                        ),
                        SizedBox(height: 2),
                        Text(
                          'チャット',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF757575), // グレー色
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
              // 待機状態の切り替え
              if (!widget.isWaiting) {
                // オフライン状態から待機設定モーダルを開く
                _showWaitingSettingsModal(context);
              } else {
                // 待機中の場合、待機終了モーダルを表示
                _showActiveWaitingModal(context);
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
      ],
    );
  }

  // 待機設定モーダルを表示する関数
  void _showWaitingSettingsModal(BuildContext context) {
    // 日時入力用コントローラー
    final TextEditingController _dateTimeController = TextEditingController();
    
    // 日本語ロケール初期化
    Locale myLocale = const Locale('ja');
    initializeDateFormatting(myLocale.toString());
    // チャット待機と通話相談の状態
    bool _isChatWaiting = true;
    bool _isCallWaiting = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              height: 420,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '次回ログイン予定',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _dateTimeController,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: '例: 4/1 15:00頃',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today, size: 20),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              locale: const Locale('ja'),
                            );
                            if (picked != null) {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              );
                              if (time != null) {
                                setState(() {
                                  final formatter = DateFormat('M/d HH:mm頃');
                                  final dateTime = DateTime(
                                    picked.year,
                                    picked.month,
                                    picked.day,
                                    time.hour,
                                    time.minute,
                                  );
                                  _dateTimeController.text = formatter.format(dateTime);
                                });
                              }
                            }
                          },
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('チャット待機',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
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
                        
                        // チャット待機か通話待機が有効なら待機状態を有効化
                        if (_isChatWaiting || _isCallWaiting) {
                          widget.onWaitingToggle(true);
                        } else {
                          // 両方とも無効なら待機状態を解除
                          widget.onWaitingToggle(false);
                        }
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
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
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
                ],
              ),
            );
          },
        );
      },
    );
  }

  // 待機中モーダル - 待機中の場合に表示される
  void _showActiveWaitingModal(BuildContext context) {
    // 日時入力用コントローラー
    final TextEditingController _dateTimeController = TextEditingController();
    
    // 日本語ロケール初期化
    Locale myLocale = const Locale('ja');
    initializeDateFormatting(myLocale.toString());
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
              height: 420,
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
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextField(
                            controller: _dateTimeController,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: '例: 4/1 15:00頃',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today, size: 18),
                                onPressed: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    locale: const Locale('ja'),
                                  );
                                  if (picked != null) {
                                    final TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (BuildContext context, Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    );
                                    if (time != null) {
                                      setState(() {
                                        final formatter = DateFormat('M/d HH:mm頃');
                                        final dateTime = DateTime(
                                          picked.year,
                                          picked.month,
                                          picked.day,
                                          time.hour,
                                          time.minute,
                                        );
                                        _dateTimeController.text = formatter.format(dateTime);
                                      });
                                    }
                                  }
                                },
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 15),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // チャット待機状態表示（人数付き）
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('チャット待機',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // 人数表示
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3bcfd4).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text('$_chatWaitingCount人',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF3bcfd4),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: Color(0xFF3bcfd4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // 切替スイッチ
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
                  // 通話待機状態表示
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('通話相談',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 15),
                  // 警告メッセージ
                  const SizedBox(height: 20),
                  // 待機終了ボタン - 色をピンク系に変更
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // 待機終了処理
                        Navigator.pop(context);
                        widget.onWaitingToggle(false); // 待機状態を解除
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF8BBD0), // ピンク系の色
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
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
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // キャンセル処理
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                      ),
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
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
    bool isSelected = widget.currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        // インデックス1（チャット）の場合、ドロワーを開く
        if (index == 1) {
          // 直接キーを使って開く
          if (chatScreenScaffoldKey.currentState != null) {
            chatScreenScaffoldKey.currentState!.openDrawer();
          } else {
            // 移動してから開く
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FortuneTellerChatScreen(
                  userName: 'テストユーザー',
                ),
              ),
            ).then((_) {
              // 画面遷移後にドロワーを開く
              Future.delayed(const Duration(milliseconds: 100), () {
                if (chatScreenScaffoldKey.currentState != null) {
                  chatScreenScaffoldKey.currentState!.openDrawer();
                }
              });
            });
          }
        } else {
          // その他のタブは通常通り処理
          widget.onTabTapped(index);
        }
      },
      child: Container(
        width: 70,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                ? const Color(0xFF3bcfd4) // ターコイズ色（選択中）
                : const Color(0xFF757575), // グレー（非選択）
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                  ? const Color(0xFF3bcfd4) // ターコイズ色（選択中）
                  : const Color(0xFF757575), // グレー（非選択）
              ),
            ),
          ],
        ),
      ),
    );
  }
}
