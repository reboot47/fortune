import 'package:flutter/material.dart';
import '../../widgets/fortune_teller_base_screen.dart';
import '../../models/chat_message.dart';
import '../../widgets/chat/chat_bubble.dart';
import '../../widgets/chat/chat_template.dart';
import '../../widgets/fortune_teller_drawer.dart';
import 'package:intl/intl.dart';

// グローバルキー - アプリ全体で使用可能
final chatScreenScaffoldKey = GlobalKey<ScaffoldState>();

// どこからでもドロワーを開くためのグローバル関数
void openGlobalDrawer(BuildContext context) {
  // 直接現在のScaffoldにアクセスして開く
  Scaffold.of(context).openDrawer();
}

class FortuneTellerChatScreen extends StatefulWidget {
  final String userName;
  final String? userAvatar;

  const FortuneTellerChatScreen({
    Key? key,
    required this.userName,
    this.userAvatar,
  }) : super(key: key);

  @override
  State<FortuneTellerChatScreen> createState() => _FortuneTellerChatScreenState();
}

class _FortuneTellerChatScreenState extends State<FortuneTellerChatScreen> {
  // ドロワーメニューを開くためのキー
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  List<ChatMessage> _messages = [];
  
  // 状態管理用
  bool _isPaidMode = true; // 有料モード（初期値）
  bool _showTemplate = false; // テンプレート表示状態
  bool _showAttachmentMenu = false; // 添付ファイルメニュー表示状態
  bool _isTyping = false; // 入力中の状態 
  // 文字数カウント
  int _maxCharacters = 69;

  @override
  void initState() {
    super.initState();
    // デモデータを読み込む
    _messages = ChatMessage.getDemoMessages();
    
    // テキスト入力の変更を監視
    _messageController.addListener(_onTextChanged);
    
    // 少し遅延させてスクロールする
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // テキスト変更時の処理
  void _onTextChanged() {
    setState(() {});
  }

  // 画面下部にスクロール
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // メッセージを送信
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _messageController.text,
          timestamp: DateTime.now(),
          type: MessageType.text,
          sender: MessageSender.fortuneTeller,
          isPaid: _isPaidMode,
        ),
      );
      _messageController.clear();
      _showTemplate = false;
    });
    
    // 少し遅延させてスクロール
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });
  }

  // テンプレートを選択
  void _selectTemplate(String template) {
    setState(() {
      _messageController.text = template;
      _showTemplate = false;
      _focusNode.requestFocus();
    });
  }
  
  // 有料/無料モードを切り替え
  void _togglePaidMode() {
    setState(() {
      _isPaidMode = !_isPaidMode;
    });
  }
  
  // 添付ファイルメニューを表示
  void _showAttachmentOptions() {
    // _showTemplateがtrueの場合は閉じる
    if (_showTemplate) {
      setState(() {
        _showTemplate = false;
      });
    }
    
    // 添付ファイルメニューを表示
    setState(() {
      _showAttachmentMenu = true;
    });
  }
  
  // 添付ファイルメニューを閉じる
  void _closeAttachmentMenu() {
    setState(() {
      _showAttachmentMenu = false;
    });
  }
  
  // 添付ファイルのオプションを選択
  void _selectAttachmentOption(int index) {
    // メニューを閉じる
    _closeAttachmentMenu();
    
    // オプションに応じた処理
    if (index == 0) {
      // TODO: カメラ機能を実装
    } else if (index == 1) {
      // TODO: ギャラリー機能を実装
    }
    // index == 2 はキャンセルなので何もしない
  }
  
  // オプションボタンを生成
  Widget _buildOptionButton({required String text, required VoidCallback onTap}) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Color(0xFF3bcfd4), // ターコイズ色
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF3bcfd4),
          fontSize: 14,
        ),
      ),
    );
  }
  
  // カスタムドロワーをビルドするメソッド
  Widget _buildCustomDrawer() {
    return Drawer(
      child: Column(
        children: [
          // ヘッダー部分
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
            color: const Color(0xFF3bcfd4), // ターコイズ色
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ユーザー情報
                Row(
                  children: [
                    // プロフィール画像
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF3bcfd4),
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 名前とポイント
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '霊感お姉さん',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '報酬：1,005,445.49PT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '現在のステージ stage5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 対応中セクション
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '対応中のお客様',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '対応中のお客様はいません。お客様を待ちましょう。',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          
          // リクエストセクションヘッダー
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'リクエスト受付',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                // ソートボタン
                Row(
                  children: const [
                    Icon(Icons.sort, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('受付日が新しい順', style: TextStyle(fontSize: 12)),
                    Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          
          // リクエストリスト
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4, // ダミーデータ
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => _buildRequestItem(index),
            ),
          ),
          
          // バージョン情報
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const Text(
              'Version 8.7',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          
          // 下部インジケーター
          Container(
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
  
  // リクエストアイテムをビルドするメソッド
  Widget _buildRequestItem(int index) {
    // ダミーデータ
    final List<Map<String, dynamic>> users = [
      {
        'name': '藤田麻衛子',
        'time': '11時間前',
        'hasCall': true,
      },
      {
        'name': '浜田藍花',
        'time': '1日前',
        'hasCall': false,
      },
      {
        'name': '鈴木ゆき',
        'time': '2日前',
        'hasCall': true,
      },
      {
        'name': '小川花子',
        'time': '3日前',
        'hasCall': false,
      },
    ];
    
    final user = users[index];
    
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        user['name'] ?? '',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(user['time'] ?? ''),
      trailing: user['hasCall'] == 'true' || user['hasCall'] == true
          ? const Icon(Icons.phone, color: Colors.green, size: 20) 
          : null,
      onTap: () {
        // チャット画面を開く
        Navigator.pop(context); // ドロワーを閉じる
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // カスタムアプリバー
    final customAppBar = PreferredSize(
      preferredSize: const Size.fromHeight(55.0),
      child: AppBar(
        elevation: 1,
        backgroundColor: Colors.grey[50], // 明るいグレー背景色
        automaticallyImplyLeading: false, // 自動のバックボタンを無効化
        titleSpacing: 0,
        title: Row(
          children: [
            // チャットアイコン（ドロワーを開く）
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.chat_outlined,
                  color: Color(0xFF757575), // グレー色
                ),
                onPressed: () {
                  // 直接開く
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            // ホームアイコン（ホーム画面に戻る）
            IconButton(
              icon: const Icon(
                Icons.home_outlined,
                color: Color(0xFF757575), // グレー色
              ),
              onPressed: () {
                Navigator.of(context).pop(); // ホーム画面に戻る
              },
            ),
            // ユーザー名（中央に配置）
            Expanded(
              child: Center(
                child: Text(
                  widget.userName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            // 編集ボタン
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: Color(0xFF3bcfd4), // ターコイズ色
              ),
              onPressed: () {
                // 編集機能（未実装）
              },
            ),
            // プロフィールボタン
            IconButton(
              icon: const Icon(
                Icons.person_outline,
                color: Color(0xFF3bcfd4), // ターコイズ色
              ),
              onPressed: () {
                // プロフィール機能（未実装）
              },
            ),
          ],
        ),
      ),
    );
    
    // Scaffoldを直接使用する形に変更
    return Scaffold(
      key: chatScreenScaffoldKey,
      drawer: _buildCustomDrawer(),
      appBar: customAppBar,
      body: Column(
        children: [
          // チャット履歴表示エリア
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
          ),
          // テンプレート表示エリア
          if (_showTemplate)
            ChatTemplate(
              onTemplateSelected: _selectTemplate,
              onClose: () => setState(() => _showTemplate = false),
            ),
          // 添付ファイルメニュー表示エリア
          if (_showAttachmentMenu)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ヘッダー部分
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 30), // 左側のスペース確保
                      const Text(
                        'ファイルの選択',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // 閉じるボタン
                      GestureDetector(
                        onTap: _closeAttachmentMenu,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.close, 
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '閉じる',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // オプションボタンをグリッドで表示
                  GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3.0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildOptionButton(
                        text: 'カメラで撮る',
                        onTap: () => _selectAttachmentOption(0),
                      ),
                      _buildOptionButton(
                        text: 'ギャラリーから選ぶ',
                        onTap: () => _selectAttachmentOption(1),
                      ),
                      _buildOptionButton(
                        text: 'キャンセル',
                        onTap: () => _selectAttachmentOption(2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          // メッセージ入力エリア
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8.0,
              bottom: 16.0,
            ),
            child: Stack(
              children: [
                // 入力フィールドとボタンのロウ
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 無料ボタン
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _isPaidMode ? Colors.grey[300]! : const Color(0xFF3bcfd4), width: 1.5),
                        color: Colors.white,
                      ),
                      child: InkWell(
                        onTap: _togglePaidMode,
                        customBorder: const CircleBorder(),
                        child: Center(
                          child: Text(
                            '無料',
                            style: TextStyle(
                              color: _isPaidMode ? Colors.grey : const Color(0xFF3bcfd4),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // テンプレボタン
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: const Color(0xFF3bcfd4), width: 1.5),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17),
                        onTap: () {
                          setState(() {
                            _showTemplate = !_showTemplate;
                            if (_showTemplate) {
                              FocusScope.of(context).unfocus();
                            }
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Text(
                              'テンプレ',
                              style: TextStyle(
                                color: Color(0xFF3bcfd4),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 添付ファイルボタン
                    IconButton(
                      icon: Icon(
                        Icons.attach_file_outlined,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(8),
                      visualDensity: VisualDensity.compact,
                      onPressed: _showAttachmentOptions,
                    ),
                  ],
                ),
                // テキストエリア
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'メッセージを入力してください',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 15),
                      maxLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                // 送信ボタン(右下)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3bcfd4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
