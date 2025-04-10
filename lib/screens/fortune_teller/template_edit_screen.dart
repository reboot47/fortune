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
  String _selectedFortuneType = 'tarot';
  
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
  
  // 未実装機能のメッセージを表示
  void _showNotImplementedMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureは開発中です'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  // テンプレート一覧を読み込む
  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // ユーザーIDを取得
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        throw Exception('ユーザーIDが見つかりません');
      }
      
      // データベースサービスの初期化
      final dbService = DatabaseService();
      await dbService.connect();
      
      // テンプレート一覧を取得
      final result = await dbService.getFortuneTemplates(userId);
      
      if (result['success']) {
        setState(() {
          _templates = List<Map<String, dynamic>>.from(result['templates']);
          _isLoading = false;
        });
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('テンプレートの読み込みに失敗しました: $e')),
      );
    }
  }
  
  // 新規テンプレート作成モードに切り替え
  void _startNewTemplate() {
    setState(() {
      _isEditing = true;
      _currentTemplateId = null;
      _titleController.text = '';
      _descriptionController.text = '';
      _contentController.text = '';
      _selectedFortuneType = 'tarot';
    });
  }
  
  // テンプレート編集モードに切り替え
  void _editTemplate(Map<String, dynamic> template) {
    setState(() {
      _isEditing = true;
      _currentTemplateId = template['id'];
      _titleController.text = template['title'];
      _descriptionController.text = template['description'] ?? '';
      _contentController.text = template['content'] ?? '';
      _selectedFortuneType = template['fortune_type'];
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
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // ユーザーIDを取得
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      
      if (userId == null) {
        throw Exception('ユーザーIDが見つかりません');
      }
      
      // テンプレートデータを準備
      final templateData = {
        'id': _currentTemplateId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'content': _contentController.text,
        'fortune_type': _selectedFortuneType,
      };
      
      // データベースサービスの初期化
      final dbService = DatabaseService();
      await dbService.connect();
      
      // テンプレートを保存
      final result = await dbService.saveFortuneTemplate(templateData, userId);
      
      if (result['success']) {
        // 保存成功
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        
        // テンプレート一覧に戻る
        setState(() {
          _isEditing = false;
        });
        
        // テンプレート一覧を再読み込み
        _loadTemplates();
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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
          
          // メインコンテンツ
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isEditing
                    ? _buildTemplateEditor()
                    : _buildTemplateList(),
          ),
        ],
      ),
    );
  }
  
  // テンプレート一覧画面
  Widget _buildTemplateList() {
    return Column(
      children: [
        // 新規テンプレート作成ボタン
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _startNewTemplate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3bcfd4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  '新しい占いテンプレートを作成',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        
        // テンプレート一覧
        Expanded(
          child: _templates.isEmpty
              ? Center(
                  child: Text(
                    'テンプレートがありません\n新しいテンプレートを作成してください',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    final fortuneType = FortuneTypes.getById(template['fortune_type']);
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          template['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fortuneType?.name ?? template['fortune_type'],
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
                          onPressed: () => _editTemplate(template),
                        ),
                        onTap: () => _editTemplate(template),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
  
  // テンプレート編集画面
  Widget _buildTemplateEditor() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ヘッダー
          Text(
            _currentTemplateId == null ? '新しい占いテンプレート' : 'テンプレートを編集',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 24),
          
          // タイトル入力
          const Text(
            'タイトル',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: '例: 恋愛タロット占い',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLength: 100,
          ),
          const SizedBox(height: 16),
          
          // 説明入力
          const Text(
            '説明（任意）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: '例: 恋愛の行方を占うタロット占いです',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLength: 200,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          // 占いタイプ選択
          const Text(
            '占いタイプ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFortuneType,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Color(0xFF333333), fontSize: 16),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedFortuneType = newValue;
                    });
                  }
                },
                items: FortuneTypes.all.map<DropdownMenuItem<String>>((FortuneType type) {
                  return DropdownMenuItem<String>(
                    value: type.id,
                    child: Text(type.name),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // 内容入力
          const Text(
            'テンプレート内容',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _contentController,
            decoration: InputDecoration(
              hintText: '例: あなたの恋愛運は...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            maxLines: 10,
            minLines: 5,
          ),
          const SizedBox(height: 32),
          
          // ボタン
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
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
