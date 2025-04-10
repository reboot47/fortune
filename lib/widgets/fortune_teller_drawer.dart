import 'package:flutter/material.dart';
import '../screens/chat/fortune_teller_chat_screen.dart';

// グローバルキーを定義
final GlobalKey<ScaffoldState> globalScaffoldKey = GlobalKey<ScaffoldState>();

// どこからでもドロワーを開くための関数
void openDrawer() {
  if (globalScaffoldKey.currentState != null && !globalScaffoldKey.currentState!.isDrawerOpen) {
    globalScaffoldKey.currentState!.openDrawer();
  }
}

class FortuneTellerDrawer extends StatefulWidget {
  const FortuneTellerDrawer({Key? key}) : super(key: key);

  @override
  State<FortuneTellerDrawer> createState() => _FortuneTellerDrawerState();
}

class _FortuneTellerDrawerState extends State<FortuneTellerDrawer> {
  String _sortOrder = '受付日が新しい順';
  int _selectedTabIndex = 0; // 0: 対応履歴, 1: 待機中, 2: フォロワー
  
  // タブボタンをビルド
  Widget _buildTabButton(int index, IconData icon) {
    final bool isSelected = _selectedTabIndex == index;
    final Color color = isSelected ? Colors.white : Colors.grey;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 2),
          // 選択中のタブのみインジケーターを表示
          if (isSelected)
            Container(
              height: 3,
              width: 30,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3bcfd4), Colors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85, // 画面の85%の幅
      color: const Color(0xFF424B5A), // ダークグレー背景
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStageInfo(),
            // 選択中のタブに応じて切り替え
            Expanded(
              child: _getTabContent(),
            ),
            _buildVersion(),
          ],
        ),
      ),
    );
  }

  // プロフィールセクション
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // プロフィール画像
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF3bcfd4),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: Image.network(
                'https://randomuser.me/api/portraits/women/32.jpg', // サンプル画像
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, color: Colors.white);
                },
              ),
            ),
          ),
          const SizedBox(width: 15),
          // ユーザー情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '霊感お姉さん',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '報酬：1,005,445.49PT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // 通知アイコン
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE74C3C), // 赤色の通知バッジ
            ),
            child: const Text(
              '34',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ステージ情報
  Widget _buildStageInfo() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF282C38), // より暗いグレー
      child: Column(
        children: [
          // ステージ表示部分
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '現在のステージ',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 20), // より広いスペース
                Text(
                  'stage5',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22, // フォントサイズを大きく
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0, // 文字間隔を少し広く
                  ),
                ),
              ],
            ),
          ),
          
          // タブナビゲーション
          Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFF1F2230),
              border: Border(
                top: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 対応履歴タブ
                _buildTabButton(0, Icons.chat_bubble_outline),
                
                // 待機中タブ
                _buildTabButton(1, Icons.access_time),
                
                // フォロワータブ
                _buildTabButton(2, Icons.favorite),
              ],
            ),
          ),
          
          // プログレスバー
          Container(
            height: 5,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3bcfd4), Colors.green],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 対応中ステータス
  Widget _buildCurrentStatus() {
    // デモ用に対応中のお客様データ（実際の実装ではサービスから取得）
    // nullの場合は対応中のお客様がいない
    final activeCustomer = {
      'name': '松田あかり',
      'time': '3分前',
      'message': 'また1人で待ますいつつもお声かけして...',
    };
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '対応中',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          
          // 対応中のお客様がいるかどうかで表示を切り替え
          activeCustomer != null
            ? InkWell(
                onTap: () {
                  // チャット画面に遷移
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FortuneTellerChatScreen(
                        userName: activeCustomer['name'] as String,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  activeCustomer['name'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3bcfd4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '対応中',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeCustomer['message'] as String,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        activeCustomer['time'] as String,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const Text(
                '対応中のお客様はいません。お客様を待ちましょう。',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24, height: 1),
        ],
      ),
    );
  }

  // リクエスト一覧ヘッダー
  Widget _buildRequestListHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'リクエスト受付',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          // ソート順ドロップダウン
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => _buildSortDialog(),
              );
            },
            child: Row(
              children: [
                Text(
                  _sortOrder,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white70,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // リクエスト一覧
  Widget _buildRequestList() {
    // モックデータ
    final requests = [
      {'name': '藤田麻衣子', 'time': '11時間前', 'hasCall': false},
      {'name': '里吉さやか', 'time': '11時間前', 'hasCall': true},
      {'name': 'そら', 'time': '2日前', 'hasCall': false},
      {'name': '小川令', 'time': '3日前', 'hasCall': true},
      {'name': '平川洋介', 'time': '1週間前', 'hasCall': false},
      {'name': '尾形陽香', 'time': '2週間前', 'hasCall': false},
      {'name': 'てんか', 'time': '4週間前', 'hasCall': false},
      {'name': 'リュウ', 'time': '6ヶ月前', 'hasCall': false},
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        // リクエストアイテムをタップ可能にする
        return InkWell(
          onTap: () {
            // チャット画面に遷移
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FortuneTellerChatScreen(
                  userName: request['name'] as String,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      request['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (request['hasCall'] as bool)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3bcfd4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          '電話',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                Text(
                  request['time'] as String,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ソート順選択ダイアログ
  Widget _buildSortDialog() {
    final options = [
      '受付日が新しい順',
      '受付日が古い順',
      '名前順',
    ];

    return SimpleDialog(
      title: const Text('並び替え'),
      children: options.map((option) {
        return SimpleDialogOption(
          onPressed: () {
            setState(() {
              _sortOrder = option;
            });
            Navigator.pop(context);
          },
          child: Text(option),
        );
      }).toList(),
    );
  }

  // 選択されたタブに応じたコンテンツを取得
  Widget _getTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildHistoryTab();
      case 1:
        return _buildWaitingTab();
      case 2:
        return _buildFollowersTab();
      default:
        return _buildHistoryTab();
    }
  }
  
  // 対応履歴タブ
  Widget _buildHistoryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCurrentStatus(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: const Text(
            '対応履歴',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: _buildHistoryList(),
        ),
      ],
    );
  }
  
  // 待機中タブ
  Widget _buildWaitingTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCurrentStatus(),
        _buildRequestListHeader(),
        Expanded(
          child: _buildRequestList(),
        ),
      ],
    );
  }
  
  // フォロワータブ
  Widget _buildFollowersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'フォロワー',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // ソート順ドロップダウン
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => _buildSortDialog(),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      '新着順',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _buildFollowersList(),
        ),
      ],
    );
  }
  
  // 対応履歴リスト
  Widget _buildHistoryList() {
    // モックデータ
    final histories = [
      {'name': '松田あかり', 'time': '3分前', 'message': 'また1人で悱まずいつつもお声がけして…'},
      {'name': '棡渡直美', 'time': '15分前', 'message': '本日はありがとうございました☆良い…'},
      {'name': 'りさ', 'time': '22分前', 'message': 'また1人で悱まずいつつもお声がけして…'},
      {'name': 'るな', 'time': '22分前', 'message': 'また1人で悱まずいつつもお声がけして…'},
      {'name': '坂下愛莉', 'time': '22分前', 'message': 'また1人で悱まずいつつもお声がけして…'},
      {'name': '松尾 優希', 'time': '1時間前', 'message': '通話相談時間'},
      {'name': '杭奈', 'time': '1時間前', 'message': '[通知] チャットが終了しました。'},
      {'name': 'やないあきな', 'time': '1時間前', 'message': 'また1人で悱まずいつつもお声がけして…'},
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: histories.length,
      itemBuilder: (context, index) {
        final history = histories[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    history['name'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        history['time'] as String,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.star_border,
                        color: Colors.white60,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                history['message'] as String,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
  
  // フォロワーリスト
  Widget _buildFollowersList() {
    // モックデータ
    final followers = [
      {'name': '後藤美佳子', 'time': '1時間前', 'isNew': true},
      {'name': '宮内紗子', 'time': '6時間前', 'isNew': true},
      {'name': 'ナリタサヤカ', 'time': '10時間前', 'isNew': true},
      {'name': '豊田安紀', 'time': '12時間前', 'isNew': true},
      {'name': '林 久美', 'time': '13時間前', 'isNew': true},
      {'name': '五味川 敵勇', 'time': '13時間前', 'isNew': true},
      {'name': '金光優里', 'time': '16時間前', 'isNew': true},
      {'name': 'ふるばやしあやね', 'time': '23時間前', 'isNew': true},
      {'name': '田中弘依', 'time': '1日前', 'isNew': true},
      {'name': '田中弘依', 'time': '1日前', 'isNew': true},
      {'name': '橋本 遊', 'time': '1日前', 'isNew': true},
      {'name': '長岡美由紀', 'time': '1日前', 'isNew': true},
      {'name': 'りおん', 'time': '1日前', 'isNew': true},
    ];

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: followers.length,
      itemBuilder: (context, index) {
        final follower = followers[index];
        // タップ可能なフォロワーアイテム
        return InkWell(
          onTap: () {
            // チャット画面に遷移
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => FortuneTellerChatScreen(
                  userName: follower['name'] as String,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      follower['name'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (follower['isNew'] as bool)
                      const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.pink,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                Text(
                  follower['time'] as String,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // バージョン情報
  Widget _buildVersion() {
    return Container(
      padding: const EdgeInsets.only(bottom: 30, top: 10),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            'Version 8.7',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}
