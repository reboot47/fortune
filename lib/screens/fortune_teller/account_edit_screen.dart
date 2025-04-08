import 'package:flutter/material.dart';
import '../../widgets/fortune_teller_base_screen.dart';
import '../../widgets/fortune_teller_tab_bar.dart';
import 'bank_account_screen.dart';

class AccountEditScreen extends StatefulWidget {
  const AccountEditScreen({Key? key}) : super(key: key);

  @override
  _AccountEditScreenState createState() => _AccountEditScreenState();
}

class _AccountEditScreenState extends State<AccountEditScreen> {
  // タブ関連
  final int _selectedTabIndex = 2; // アカウント編集タブ
  
  // ボトムナビゲーション用
  int _currentIndex = 4; // マイページタブ
  bool _isWaiting = true; // 初期状態は待機中
  
  // アカウント情報
  final TextEditingController _nameController = TextEditingController(text: '榎並沙知');
  final TextEditingController _emailController = TextEditingController(text: 'ena.k0310@gmail.com');
  
  // 通知設定
  final Map<String, bool> _notifications = {
    'チャット・電話相談リクエスト受信時': false,
    'レビュー受信時': false,
    'お気に入りされた時': false,
    'ログイン予定時間の1時間前': true,
  };
  
  // チャット着信メロディ
  int _selectedMelody = 1;
  
  // 各種設定
  bool _vibrationEnabled = true;
  bool _melodyEnabledDuringSession = true;
  bool _notificationSoundEnabledDuringSession = true;
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  
  // 未実装機能のメッセージを表示
  void _showNotImplementedMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureは開発中です'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
      customAppBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          _isWaiting ? 'チャット相談中' : 'オフライン',
          style: const TextStyle(
            color: Color(0xFF3bcfd4),
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
          onPressed: () {},
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.grey),
                onPressed: () {},
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.pink[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '93+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 共通タブバー
          FortuneTellerTabBar(
            currentTabIndex: _selectedTabIndex,
            parentContext: context,
          ),
          
          // アカウント編集コンテンツ
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // アカウント情報セクション
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'アカウント',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'お客様側には公開されません',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // 本名フィールド
                        const Text(
                          '本名',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // メールアドレスフィールド
                        const Text(
                          'メールアドレス',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]!)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 通知設定セクション
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '通知',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // 通知オプションのチェックボックス
                        ..._notifications.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: entry.value,
                                  onChanged: (value) {
                                    setState(() {
                                      _notifications[entry.key] = value!;
                                    });
                                  },
                                  activeColor: const Color(0xFF3bcfd4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                        
                        // 登録ボタン
                        Container(
                          width: double.infinity,
                          height: 44,
                          margin: const EdgeInsets.only(top: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              _showNotImplementedMessage('設定の保存');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3bcfd4),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              '登録',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // チャット着信メロディセクション
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'チャット着信メロディ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'お好きなメロディを選択してください',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // メロディ選択肢
                        for (int i = 1; i <= 5; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _selectedMelody == i,
                                    onChanged: (value) {
                                      if (value == true) {
                                        setState(() {
                                          _selectedMelody = i;
                                        });
                                      }
                                    },
                                    activeColor: const Color(0xFF3bcfd4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'メロディ$i',
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () {
                                    _showNotImplementedMessage('メロディ再生');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      side: const BorderSide(color: Colors.black12),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.play_arrow, size: 16),
                                      const SizedBox(width: 4),
                                      const Text('再生する'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        const SizedBox(height: 16),
                        
                        // チャット着信時の振動設定
                        const Text(
                          'チャット着信時の振動',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '依頼があったときのスマホのバイブ有効無効を選べます',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: _vibrationEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _vibrationEnabled = value!;
                                });
                              },
                              activeColor: const Color(0xFF3bcfd4),
                            ),
                            const Text('ON'),
                            const SizedBox(width: 32),
                            Radio<bool>(
                              value: false,
                              groupValue: _vibrationEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _vibrationEnabled = value!;
                                });
                              },
                              activeColor: const Color(0xFF3bcfd4),
                            ),
                            const Text('OFF'),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 鑑定中のチャット着信メロディ設定
                        const Text(
                          'チャット鑑定中のチャット着信メロディ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '鑑定中、新たに依頼が来たときのメロディのオンオフを選べます',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: _melodyEnabledDuringSession,
                              onChanged: (value) {
                                setState(() {
                                  _melodyEnabledDuringSession = value!;
                                });
                              },
                              activeColor: const Color(0xFF3bcfd4),
                            ),
                            const Text('ON'),
                            const SizedBox(width: 32),
                            Radio<bool>(
                              value: false,
                              groupValue: _melodyEnabledDuringSession,
                              onChanged: (value) {
                                setState(() {
                                  _melodyEnabledDuringSession = value!;
                                });
                              },
                              activeColor: const Color(0xFF3bcfd4),
                            ),
                            const Text('OFF'),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // 鑑定中のメッセージ通知音設定
                        const Text(
                          'チャット鑑定中のメッセージ通知音',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '鑑定中、チャットが届いたときに鳴る通知音のオンオフを選べます',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: _notificationSoundEnabledDuringSession,
                              onChanged: (value) {
                                setState(() {
                                  _notificationSoundEnabledDuringSession = value!;
                                });
                              },
                              activeColor: const Color(0xFF3bcfd4),
                            ),
                            const Text('ON'),
                            const SizedBox(width: 32),
                            Radio<bool>(
                              value: false,
                              groupValue: _notificationSoundEnabledDuringSession,
                              onChanged: (value) {
                                setState(() {
                                  _notificationSoundEnabledDuringSession = value!;
                                });
                              },
                              activeColor: const Color(0xFF3bcfd4),
                            ),
                            const Text('OFF'),
                          ],
                        ),
                        
                        // 設定ボタン
                        Container(
                          width: double.infinity,
                          height: 44,
                          margin: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              _showNotImplementedMessage('音声設定の保存');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3bcfd4),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Text(
                              '設定',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 年齢認証セクション
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '年齢認証',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'ご本人様確認と18歳以上であることの確認のため身分証の提出が必要です。\n事務局での確認が済みますと、お仕事を開始できます。',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              '年齢認証状況:',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '認証済み、お仕事を開始できます。',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.pink[300],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // パスワード変更リンク
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        _showNotImplementedMessage('パスワード変更');
                      },
                      child: Text(
                        'パスワード変更はこちら',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF3bcfd4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
