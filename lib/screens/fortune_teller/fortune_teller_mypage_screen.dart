import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/fortune_teller_base_screen.dart';
import '../../services/database_service.dart';
import 'profile_edit_screen.dart';

class FortuneTellerMyPageScreen extends StatefulWidget {
  const FortuneTellerMyPageScreen({Key? key}) : super(key: key);

  @override
  State<FortuneTellerMyPageScreen> createState() => _FortuneTellerMyPageScreenState();
}

class _FortuneTellerMyPageScreenState extends State<FortuneTellerMyPageScreen> {
  // 現在表示中のタブ
  int _currentIndex = 4; // マイページは4番目のタブ
  
  // 編集可能な一言メッセージ
  String oneWordMessage = '';
  bool isEditingMessage = false;
  final TextEditingController _messageController = TextEditingController();
  
  // ユーザー情報
  Map<String, dynamic> _userData = {};
  bool _isLoading = true;
  
  // データベースサービス
  final DatabaseService _databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  
  // ユーザープロフィールを読み込む
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // ユーザーIDを取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail == null) {
        throw Exception('ユーザーメールアドレスが見つかりません');
      }
      
      // データベース接続
      await _databaseService.connect();
      
      // プロフィール情報を取得
      final result = await _databaseService.getUserProfile(userEmail);
      
      if (result['success']) {
        setState(() {
          _userData = result['profile'];
          
          // 一言メッセージを設定
          oneWordMessage = _userData['one_word_message'] ?? '';
          _messageController.text = oneWordMessage;
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('プロフィール情報の読み込みに失敗しました: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  // 一言メッセージを保存
  Future<void> _saveOneWordMessage() async {
    if (isEditingMessage) {
      setState(() {
        isEditingMessage = false;
        oneWordMessage = _messageController.text;
      });
      
      try {
        // ユーザーメールアドレスを取得
        final prefs = await SharedPreferences.getInstance();
        final userEmail = prefs.getString('userEmail');
        
        if (userEmail == null) {
          throw Exception('ユーザーメールアドレスが見つかりません');
        }
        
        // 更新データを準備
        final updateData = {
          'one_word_message': oneWordMessage,
        };
        
        // データベース接続
        await _databaseService.connect();
        
        // 一言メッセージを更新
        final result = await _databaseService.updateUserProfile(userEmail, updateData);
        
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('一言メッセージを保存しました')),
          );
        } else {
          throw Exception(result['message']);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('一言メッセージの保存に失敗しました: $e')),
        );
      }
    } else {
      setState(() {
        isEditingMessage = true;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FortuneTellerBaseScreen(
      currentIndex: _currentIndex,
      isWaiting: false,  // マイページではデフォルトでオフライン表示
      onWaitingStatusChanged: (value) {
        // 必要に応じて待機状態を処理
        setState(() {
          // 状態変更の通知
        });
      },

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 画像1パートのプロフィールセクション
            Container(
              color: const Color(0xFFEEEEEE),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: const Text(
                'お客様からみたプロフィール',
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // プロフィールカード
            _buildProfileCard(),
            
            // 画像1に合わせたメニューカードセクション
            Container(
              width: double.infinity,
              color: const Color(0xFFEEEEEE),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'メニュー',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // メニューカード（画像1通りの3つのアイコンとラベル）
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMenuCard(icon: Icons.person, label: 'プロフィール'),
                  _buildMenuCard(icon: Icons.star, label: 'レビュー'),
                  _buildMenuCard(icon: Icons.description, label: 'タイムライン'),
                ],
              ),
            ),
            
            // 一言メッセージセクション（画像1に合わせて正確に再現）
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '一言メッセージ',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: isEditingMessage
                            ? TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '一言メッセージを入力してください',
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                                style: TextStyle(color: Colors.grey[800], fontSize: 13),
                                maxLines: 2,
                              )
                            : Text(
                                oneWordMessage.isNotEmpty
                                    ? oneWordMessage
                                    : '一言メッセージを設定してください',
                                style: TextStyle(color: Colors.grey[800], fontSize: 13),
                              ),
                        ),
                        GestureDetector(
                          onTap: _saveOneWordMessage,
                          child: Icon(
                            isEditingMessage ? Icons.check : Icons.edit,
                            color: const Color(0xFF3bcfd4),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.arrow_right, color: Colors.pink[300], size: 18),
                      Text(
                        '良い記入例のサンプルを見る',
                        style: TextStyle(
                          color: Colors.pink[300],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 所持ポイント（画像1に応じて正確に再現）
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '所持ポイント',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_userData['points'] ?? 0}pts',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3bcfd4),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text('精算する', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 画像2 - メニュー項目リスト
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: _buildMenuItems(),
            ),
          ],
        ),
      ),
    );
  }

  // プロフィールカード
  Widget _buildProfileCard() {
    if (_isLoading) {
      return Container(
        margin: const EdgeInsets.all(12),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    // プロフィール情報を取得
    final displayName = _userData['display_name'] ?? '';
    final oneWordMsg = _userData['one_word_message'] ?? '';
    final profileImageUrl = _userData['profile_image'] ?? '';
    final pricePerChar = _userData['price_per_char'] ?? 8;
    final responseTime = _userData['response_time'] ?? 7;
    final reviewCount = _userData['review_count'] ?? 0;
    final reviewRating = _userData['review_rating'] ?? 5.0;
    final reviewComment = _userData['review_comment'] ?? '';
    final points = _userData['points'] ?? 0;
    
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // プロフィール画像 - クリックでプロフィール編集画面へ
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ProfileEditScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pink[100]!,
                          Colors.pink[50]!,
                        ],
                      ),
                    ),
                    child: Center(
                      child: ClipOval(
                        child: profileImageUrl.isNotEmpty
                            ? Image.network(
                                profileImageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    color: Colors.grey[200],
                                    child: const Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                width: 80,
                                height: 80,
                                color: Colors.grey[200],
                                child: const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // 名前とプロフィール情報
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName.isNotEmpty ? displayName : '名前未設定',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        oneWordMsg.isNotEmpty ? oneWordMsg : '一言メッセージを設定してください',
                        style: const TextStyle(
                          color: Color(0xFF444444),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // 料金情報
                          Text(
                            '${pricePerChar}pts/1文字',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          // 返信時間
                          const Icon(Icons.access_time, size: 12, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            '$responseTime 分以内',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // レビュー情報
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'お客様からの声 ',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(width: 2),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 14,
                      color: index < reviewRating.floor() ? Colors.amber : Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '($reviewCount)',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // レビューコメント
            Text(
              reviewComment.isNotEmpty ? reviewComment : 'まだレビューはありません',
              style: TextStyle(
                fontSize: 13,
                height: 1.3,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

    // メニューカードウィジェット（画像1通り）
  Widget _buildMenuCard({required IconData icon, required String label}) {
    return GestureDetector(
      onTap: () {
        // プロフィールメニューの場合、プロフィール編集画面に遷移
        if (label == 'プロフィール') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ProfileEditScreen(),
            ),
          );
        } else {
          // その他のメニューは未実装
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$labelは開発中です')),
          );
        }
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF3bcfd4).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF3bcfd4),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // 画像2に基づいた詳細メニュー項目
  Widget _buildMenuItems() {
    return Column(
      children: [
        // 日別報酬＆レポート
        _buildSingleMenuItem('日別報酬＆レポート'),
        
        // アクセス解析
        _buildSingleMenuItem('アクセス解析'),
        
        // 顧客管理
        _buildSingleMenuItem('顧客管理'),
        
        // イベントセクション
        _buildMenuSection('イベント', [
          'イベントスケジュール',
          'ランキングイベント履歴',
        ]),
        
        // 困ったときはセクション
        _buildMenuSection('困ったときは', [
          '使い方/お仕事テクニック',
          'ヘルプ',
        ]),
        
        // その他セクション
        _buildMenuSection('その他', [
          '年齢確認・アカウント情報',
          'お知り合いに紹介する',
          'ユーザーアプリのインストール',
          '利用規約',
          'アカウント退会・削除',
        ]),
      ],
    );
  }
  
  // 画像2の通りの単一メニュー項目（サブ項目なし）
  Widget _buildSingleMenuItem(String title) {
    return Column(
      children: [
        // カテゴリーヘッダー背景なし
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFD8D8D8), size: 22),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  // 画像2の通りのセクション付きメニュー（サブ項目あり）
  Widget _buildMenuSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // カテゴリーヘッダー・グレー背景
        Container(
          width: double.infinity,
          color: const Color(0xFFEEEEEE),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF444444),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // サブメニュー項目
        ...items.map((item) => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item,
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFD8D8D8), size: 22),
              ],
            ),
          ),
        )).toList(),
      ],
    );
  }

  // FortuneTellerBaseScreenが内部でタブ切り替えを処理するため
  // _onItemTappedメソッドは不要
}
