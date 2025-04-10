import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/database_service.dart';
import '../../widgets/fortune_teller_tab_bar.dart';
import '../../widgets/fortune_teller_base_screen.dart';
import '../../models/fortune_type.dart';

class TemplateEditScreen extends StatefulWidget {
  const TemplateEditScreen({Key? key}) : super(key: key);

  @override
  _TemplateEditScreenState createState() => _TemplateEditScreenState();
}

class _TemplateEditScreenState extends State<TemplateEditScreen> {
  // タブ関連
  final int _selectedTabIndex = 1; // テンプレート編集タブ
  
  // ボトムナビゲーション用
  int _currentIndex = 4; // マイページタブ
  bool _isWaiting = true; // 初期状態は待機中
  
  // テンプレート一覧
  List<Map<String, dynamic>> _templates = [];
  bool _isLoading = true;
  bool _isEditing = false;
  
  // テンプレート編集用
  int? _currentTemplateId;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  // テンプレート一覧を読み込む
  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // 仮データを用意（データベース機能が実装されるまで）
      await Future.delayed(const Duration(milliseconds: 500)); // ローディング表示のため
      
      setState(() {
        _templates = [
          {
            'id': 1,
            'title': 'はじめまして',
            'description': '初回の挨拶',
            'content': 'はじめまして、占い師の◯◯です。どのようなお悩みでしょうか？',
            'fortune_type': '全般',
          },
          {
            'id': 2,
            'title': 'お礼',
            'description': '相談後のお礼',
            'content': 'ご相談ありがとうございました。また何かありましたらお気軽にご相談ください。',
            'fortune_type': '全般',
          },
          {
            'id': 3,
            'title': '失恋',
            'description': '失恋に関する助言',
            'content': '辛い時期ですが、あなたの前には新しい扉が開かれています。',
            'fortune_type': '恋愛',
          },
          {
            'id': 4,
            'title': '復縁',
            'description': '復縁に関する助言',
            'content': '相手の気持ちを尊重しながら、自分の気持ちを素直に伝えてみてはいかがでしょうか。',
            'fortune_type': '恋愛',
          },
          {
            'id': 5,
            'title': '片思い',
            'description': '片思いに関する助言',
            'content': 'あなたの気持ちは素晴らしいものです。少しずつ距離を縮めていくことをお勧めします。',
            'fortune_type': '恋愛',
          },
          {
            'id': 6,
            'title': '仕事の悩み',
            'description': '仕事に関する助言',
            'content': '今の試練はあなたを成長させるためのものです。焦らず一歩ずつ進んでいきましょう。',
            'fortune_type': '仕事',
          },
          {
            'id': 7,
            'title': '人間関係',
            'description': '人間関係の悩みに関する助言',
            'content': '相手の立場に立って考えることで、新たな視点が生まれるかもしれません。',
            'fortune_type': '人間関係',
          },
          {
            'id': 8,
            'title': '金運',
            'description': '金運に関する助言',
            'content': '今は無理な投資は控え、堅実な貯蓄を心がけると良いでしょう。',
            'fortune_type': '金運',
          },
          {
            'id': 9,
            'title': '結婚',
            'description': '結婚に関する助言',
            'content': '焦らずに自分の気持ちに正直になることが大切です。運命の人は必ず現れます。',
            'fortune_type': '恋愛',
          },
          {
            'id': 10,
            'title': '健康',
            'description': '健康に関する助言',
            'content': '規則正しい生活を心がけ、十分な休息をとることが大切です。',
            'fortune_type': '健康',
          },
        ];
        _isLoading = false;
      });
      
      // SharedPreferencesに保存（モック）
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('templates', _templates.toString());
    } catch (e) {
      print('Error loading templates: $e');
      setState(() {
        _isLoading = false;
        _templates = []; // エラー時は空のリストを設定
      });
    }
  }
  
  // テンプレート編集フォームを表示
  void _showEditForm(Map<String, dynamic>? template) {
    setState(() {
      _isEditing = true;
      _currentTemplateId = template?['id'];
      _titleController.text = template?['title'] ?? '';
      _descriptionController.text = template?['description'] ?? '';
      _contentController.text = template?['content'] ?? '';
    });
  }
  
  // テンプレートを保存
  Future<void> _saveTemplate() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('タイトルと内容は必須です')),
      );
      return;
    }
    
    final templateData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'content': _contentController.text,
      'fortune_type': '全般', // 後で選択できるようにする
    };
    
    try {
      // 保存処理（仮）
      setState(() {
        if (_currentTemplateId != null) {
          // 既存テンプレートの更新
          final index = _templates.indexWhere((t) => t['id'] == _currentTemplateId);
          if (index != -1) {
            templateData['id'] = _currentTemplateId;
            _templates[index] = templateData;
          }
        } else {
          // 新規テンプレートの追加
          final newId = _templates.isNotEmpty ? _templates.map((t) => t['id']).reduce((a, b) => a > b ? a : b) + 1 : 1;
          templateData['id'] = newId;
          _templates.add(templateData);
        }
      });
      
      // 成功メッセージ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('テンプレートを保存しました')),
      );
      
      // フォームをリセット
      setState(() {
        _isEditing = false;
        _currentTemplateId = null;
        _titleController.clear();
        _descriptionController.clear();
        _contentController.clear();
      });
      
      // SharedPreferencesに保存（モック）
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('templates', _templates.toString());
    } catch (e) {
      print('Error saving template: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('テンプレートの保存に失敗しました: $e')),
      );
    }
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
      customAppBar: FortuneTellerTabBar(
        currentTabIndex: _selectedTabIndex,
        parentContext: context,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _isEditing
              ? _buildEditForm()
              : _buildTemplateList(),
    );
  }
  
  // テンプレート一覧を表示
  Widget _buildTemplateList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 説明文
          Row(
            children: [
              const Expanded(
                child: Text(
                  'テンプレートを編集して、チャット相談で素早く返信できます。',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // サンプル表示（未実装）
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('サンプル表示は開発中です')),
                  );
                },
                child: const Text(
                  'サンプルを見る',
                  style: TextStyle(
                    color: Color(0xFF3bcfd4),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // テンプレート追加ボタン
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => _showEditForm(null),
              child: Row(
                children: const [
                  Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF3bcfd4),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '新しいテンプレートを追加',
                    style: TextStyle(
                      color: Color(0xFF3bcfd4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // テンプレートリスト
          Expanded(
            child: ListView.builder(
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      template['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          template['fortune_type'],
                          style: TextStyle(
                            color: Colors.pink[300],
                            fontSize: 12,
                          ),
                        ),
                        if (template['description'] != null &&
                            template['description'].isNotEmpty)
                          Text(
                            template['description'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xFF3bcfd4),
                      ),
                      onPressed: () => _showEditForm(template),
                    ),
                    onTap: () => _showEditForm(template),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // テンプレート編集フォーム
  Widget _buildEditForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // フォームタイトル
          Text(
            _currentTemplateId != null ? 'テンプレートを編集' : '新しいテンプレート',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // タイトル入力
          const Text(
            'タイトル',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'テンプレートの名前を入力',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: const TextStyle(fontSize: 14),
            maxLength: 20,
          ),
          
          const SizedBox(height: 16),
          
          // 説明入力
          const Text(
            '説明（任意）',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'テンプレートの説明を入力',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            style: const TextStyle(fontSize: 14),
            maxLength: 50,
          ),
          
          const SizedBox(height: 16),
          
          // 内容入力
          const Text(
            '内容',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'テンプレートの内容を入力',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              style: const TextStyle(fontSize: 14),
              maxLines: null,
              expands: true,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // ボタン
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                      _currentTemplateId = null;
                      _titleController.clear();
                      _descriptionController.clear();
                      _contentController.clear();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'キャンセル',
                    style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveTemplate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3bcfd4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '保存',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
