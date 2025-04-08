import 'package:flutter/material.dart';
import '../../widgets/fortune_teller_base_screen.dart';
import '../../widgets/fortune_teller_tab_bar.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  // タブ選択状態
  final int _selectedTabIndex = 0; // プロフィール設定タブ
  
  // 底部ナビゲーション用
  int _currentIndex = 4; // マイページタブが選択されている状態
  bool _isWaiting = true; // 初期状態は待機中
  
  // 性別選択
  String _selectedGender = '女性';
  
  // 得意ジャンルのチェックボックス状態
  final Map<String, bool> _genres = {
    '相性': true,
    '結婚': true,
    '離婚': false,
    '夫婦仲': false,
    '復縁': true,
    '不倫': true,
    '縁結び': false,
    '縁切り': false,
    '遠距離恋愛': true,
    '同性愛': false,
    '三角関係': false,
    '金運': false,
    '仕事': false,
    '起業': true,
    '転職': true,
    '対人関係': false,
    '自分の気持ち': false,
    '相手の気持ち': true,
    '家庭問題': false,
    '運勢': true,
    '開運方法': false,
  };
  
  // 得意占術のチェックボックス状態
  final Map<String, bool> _fortuneTellingTypes = {
    '透視': false,
    '霊感': true,
    '送念': true,
    '祈願': false,
    '祈祷': false,
    '波動修正': true,
    '遠隔ヒーリング': false,
    'オーラ': false,
    'ルーン': false,
    'タロット': true,
    'オラクルカード': false,
    'ルノルマンカード': false,
    'パワーストーン': false,
    '数秘術': false,
    '東洋占星術': true,
    '西洋占星術': false,
    '夢占い': false,
    '血液型': false,
    'レイキ': false,
    'ダウジング': false,
    'スピリチュアル': false,
    'チャネリング': true,
    'チャクラ': false,
    'カウンセリング': false,
    'セラピー': false,
    '守護霊対話': false,
    '前世観': false,
    '易': false,
    '風水': false,
    '手相': false,
    '九星気学': false,
    '姓名判断': false,
    '四柱推命': false,
    '紫微斗数': false,
    '算命学': false,
  };
  
  // 相談スタイルのチェックボックス状態
  final Map<String, bool> _consultationStyles = {
    '簡潔': false,
    '素早い': false,
    'ゆっくり': false,
    'じっくり': true,
    '丁寧': false,
    '優しい': false,
    '暖かい': false,
    '癒し': false,
    'ズバッと': false,
    '論理的': false,
    'ユーモア': false,
    'フレンドリー': true,
    'ポジティブ': true,
    '頼りになる': false,
    '聞き上手': false,
    '話し上手': false,
  };
  
  // 自己紹介文
  final TextEditingController _introductionController = TextEditingController(
    text: '''✨未来を変えるお手伝いをします✨

初めまして、Enaです😊

私の鑑定では、とことん深掘りをしてネガティブな気持ちをポジティブになって返してもらいたいという気持ちから、上げ下げせず、本来の幸せへお導きできたらという気持ちであなた様のお悩みに寄り添います。
「この人に見てもらってよかった」と思ってもらえるよう、しっかり向き合います🌸
しっかり向き合いますが、無駄は作らず簡潔を目に しています。

🔮 鑑定スタイル 🔮
⭐ 基本的に聞かれた事のみお伝えします
⭐ ただの未来予測ではなく、あなた様が幸せを掴むためのアドバイスは現実的にお伝えします。
⭐ あなた様と繋がりやすい方法で鑑定していくので占術はそれぞれですが、主に直感性を持っていただくためにタロットを使い、あなた様の今の状況を深く読み解きます。
⭐ 一人で悩まず、どんな小さなことでもご相談くださいね😊'''
  );
  
  // サンプルボイス用テキスト
  final TextEditingController _sampleVoiceController = TextEditingController(
    text: '''希望の方のみお声がけください
ご説明いたします🔥
無料ではないので必要であれば言ってください

あなたが幸せに進むためのお手伝いをさせてください✨
お話しできるのを楽しみにしています😊'''
  );
  
  // 名前
  final TextEditingController _nameController = TextEditingController(text: '霊感お姉さん');
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _sampleVoiceController.dispose();
    _nameController.dispose();
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
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.grey),
            onPressed: () {},
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
          
          // スクロール可能なコンテンツ
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // プロフィール情報セクション
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'プロフィール情報',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'お客様に公開される情報です',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // プロフィール画像
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // グラデーション背景の円形コンテナ
                                    Container(
                                      width: 110,
                                      height: 110,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF3bcfd4),
                                            Color(0xFF1a237e),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // プロフィール画像
                                    const CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=1288&auto=format&fit=crop',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // 写真選択ボタン
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.photo_camera, color: Colors.grey[700], size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        '写真選択',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // 名前入力
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '名前',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: '例: 霊感お姉さん',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // 性別選択
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '性別',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: '女性',
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                                    activeColor: const Color(0xFF3bcfd4),
                                  ),
                                  const Text('女性'),
                                  const SizedBox(width: 20),
                                  Radio<String>(
                                    value: '男性',
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                                    activeColor: const Color(0xFF3bcfd4),
                                  ),
                                  const Text('男性'),
                                  const SizedBox(width: 20),
                                  Radio<String>(
                                    value: '非公開',
                                    groupValue: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                                    activeColor: const Color(0xFF3bcfd4),
                                  ),
                                  const Text('非公開'),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // 得意ジャンル
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '得意ジャンル (3〜9つ)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: _genres.keys.map((genre) {
                                  return FilterChip(
                                    label: Text(genre),
                                    selected: _genres[genre]!,
                                    onSelected: (selected) {
                                      setState(() {
                                        _genres[genre] = selected;
                                      });
                                    },
                                    selectedColor: const Color(0xFF3bcfd4),
                                    checkmarkColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: _genres[genre]! ? Colors.white : Colors.black,
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // 得意占術
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '得意占術 (1〜6つ)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: _fortuneTellingTypes.keys.map((type) {
                                  return FilterChip(
                                    label: Text(type),
                                    selected: _fortuneTellingTypes[type]!,
                                    onSelected: (selected) {
                                      setState(() {
                                        _fortuneTellingTypes[type] = selected;
                                      });
                                    },
                                    selectedColor: const Color(0xFF3bcfd4),
                                    checkmarkColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: _fortuneTellingTypes[type]! ? Colors.white : Colors.black,
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // 相談スタイル
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '相談スタイル (3つ)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: _consultationStyles.keys.map((style) {
                                  return FilterChip(
                                    label: Text(style),
                                    selected: _consultationStyles[style]!,
                                    onSelected: (selected) {
                                      setState(() {
                                        _consultationStyles[style] = selected;
                                      });
                                    },
                                    selectedColor: const Color(0xFF3bcfd4),
                                    checkmarkColor: Colors.white,
                                    labelStyle: TextStyle(
                                      color: _consultationStyles[style]! ? Colors.white : Colors.black,
                                    ),
                                    backgroundColor: Colors.grey[200],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // 自己紹介文
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '自己紹介文',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _introductionController,
                                maxLines: 10,
                                maxLength: 400,
                                decoration: const InputDecoration(
                                  hintText: '自己紹介文を入力してください',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // サンプルボイス
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'サンプルボイス',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'お客様に聞かれた時のサンプルボイスです',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // サンプルボイスの録音・再生UI
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  children: [
                                    // 録音済みボイスの再生UI
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF3bcfd4),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        // 波形表示
                                        Expanded(
                                          child: Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: List.generate(
                                                20,
                                                (index) => Container(
                                                  width: 3,
                                                  height: (index % 3 + 1) * 6.0,
                                                  color: const Color(0xFF3bcfd4),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // 録音用テキスト
                                    TextField(
                                      controller: _sampleVoiceController,
                                      maxLines: 5,
                                      maxLength: 200,
                                      decoration: const InputDecoration(
                                        hintText: 'ボイス内容のテキストを入力してください',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(12),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // 録音ボタン
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        icon: const Icon(Icons.mic),
                                        label: const Text('録音する'),
                                        onPressed: () {
                                          _showNotImplementedMessage('ボイス録音機能');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF3bcfd4),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // プレビューと保存ボタン
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _showNotImplementedMessage('プレビュー機能');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF3bcfd4)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: const Text(
                                    'プレビュー',
                                    style: TextStyle(
                                      color: Color(0xFF3bcfd4),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showNotImplementedMessage('プロフィール保存機能');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3bcfd4),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: const Text(
                                    '保存する',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
