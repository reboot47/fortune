import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../../widgets/fortune_teller_base_screen.dart';
import '../../widgets/fortune_teller_tab_bar.dart';
import '../../services/fortune_teller_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

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
  
  // サービスインスタンス
  final FortuneTellerService _fortuneTellerService = FortuneTellerService();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = true;
  bool _isSaving = false;
  
  // プロフィール画像
  File? _profileImage;
  String? _networkImageUrl;
  
  // 性別選択
  String _selectedGender = '女性';
  
  // 得意ジャンルのチェックボックス状態
  final Map<String, bool> _genres = {
    '相性': false,
    '結婚': false,
    '離婚': false,
    '夫婦仲': false,
    '復縁': false,
    '不倫': false,
    '縁結び': false,
    '縁切り': false,
    '遠距離恋愛': false,
    '同性愛': false,
    '三角関係': false,
    '金運': false,
    '仕事': false,
    '起業': false,
    '転職': false,
    '対人関係': false,
    '自分の気持ち': false,
    '相手の気持ち': false,
    '家庭問題': false,
    '運勢': false,
    '開運方法': false,
  };
  
  // 得意占術のチェックボックス状態
  final Map<String, bool> _fortuneTellingTypes = {
    '透視': false,
    '霊感': false,
    '送念': false,
    '祈願': false,
    '祈祷': false,
    '波動修正': false,
    '遠隔ヒーリング': false,
    'オーラ': false,
    'ルーン': false,
    'タロット': false,
    'オラクルカード': false,
    'ルノルマンカード': false,
    'パワーストーン': false,
    '数秘術': false,
    '東洋占星術': false,
    '西洋占星術': false,
    '夢占い': false,
    '血液型': false,
    'レイキ': false,
    'ダウジング': false,
    'スピリチュアル': false,
    'チャネリング': false,
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
    'じっくり': false,
    '丁寧': false,
    '優しい': false,
    '暖かい': false,
    '癒し': false,
    'ズバッと': false,
    '論理的': false,
    'ユーモア': false,
    'フレンドリー': false,
    'ポジティブ': false,
    '頼りになる': false,
    '聞き上手': false,
    '話し上手': false,
  };
  
  // 自己紹介文
  final TextEditingController _introductionController = TextEditingController();
  
  // サンプルボイス用テキスト
  final TextEditingController _sampleVoiceController = TextEditingController();
  
  // 名前
  final TextEditingController _nameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }
  
  // プロフィールデータを読み込む
  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // プロフィール画像のパスを取得
      final imagePath = await _fortuneTellerService.getProfileImagePath();
      if (imagePath != null && imagePath.isNotEmpty) {
        if (imagePath.startsWith('http')) {
          // ネットワーク画像の場合
          setState(() {
            _networkImageUrl = imagePath;
          });
        } else {
          // ローカル画像の場合
          final file = File(imagePath);
          if (await file.exists()) {
            setState(() {
              _profileImage = file;
            });
          }
        }
      }
      
      // プロフィールデータを取得
      final result = await _fortuneTellerService.getFortuneTellerProfile();
      if (result['success'] == true && result['profile'] != null) {
        final profile = result['profile'] as Map<String, dynamic>;
        
        // 名前を設定
        if (profile['name'] != null) {
          _nameController.text = profile['name'];
        }
        
        // 性別を設定
        if (profile['gender'] != null) {
          setState(() {
            _selectedGender = profile['gender'];
          });
        }
        
        // 自己紹介文を設定
        if (profile['introduction'] != null) {
          _introductionController.text = profile['introduction'];
        }
        
        // サンプルボイステキストを設定
        if (profile['sample_voice_text'] != null) {
          _sampleVoiceController.text = profile['sample_voice_text'];
        }
        
        // 得意ジャンルを設定
        if (profile['genres'] != null && profile['genres'] is List) {
          final genres = profile['genres'] as List;
          for (var genre in genres) {
            if (_genres.containsKey(genre)) {
              _genres[genre] = true;
            }
          }
        }
        
        // 得意占術を設定
        if (profile['fortune_telling_types'] != null && profile['fortune_telling_types'] is List) {
          final types = profile['fortune_telling_types'] as List;
          for (var type in types) {
            if (_fortuneTellingTypes.containsKey(type)) {
              _fortuneTellingTypes[type] = true;
            }
          }
        }
        
        // 相談スタイルを設定
        if (profile['consultation_styles'] != null && profile['consultation_styles'] is List) {
          final styles = profile['consultation_styles'] as List;
          for (var style in styles) {
            if (_consultationStyles.containsKey(style)) {
              _consultationStyles[style] = true;
            }
          }
        }
      }
    } catch (e) {
      print('プロフィール読み込みエラー: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('プロフィールの読み込みに失敗しました: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _sampleVoiceController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  
  // メッセージを表示
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  
  // プロフィール画像を選択
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // アプリディレクトリに画像を保存
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(pickedFile.path);
        final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');
        
        // SharedPreferencesに画像パスを保存
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profileImagePath', savedImage.path);
        
        setState(() {
          _profileImage = savedImage;
          _networkImageUrl = null; // ローカル画像を使用するためネットワーク画像をクリア
        });
      }
    } catch (e) {
      print('画像選択エラー: $e');
      _showMessage('画像の選択に失敗しました: $e');
    }
  }
  
  // プロフィールを保存
  Future<void> _saveProfile() async {
    // 入力チェック
    if (_nameController.text.trim().isEmpty) {
      _showMessage('名前を入力してください');
      return;
    }
    
    // 得意ジャンルの選択数をチェック
    final selectedGenres = _genres.entries.where((e) => e.value).length;
    if (selectedGenres < 3 || selectedGenres > 9) {
      _showMessage('得意ジャンルは3〜9つ選択してください');
      return;
    }
    
    // 得意占術の選択数をチェック
    final selectedTypes = _fortuneTellingTypes.entries.where((e) => e.value).length;
    if (selectedTypes < 1 || selectedTypes > 6) {
      _showMessage('得意占術は1〜6つ選択してください');
      return;
    }
    
    // 相談スタイルの選択数をチェック
    final selectedStyles = _consultationStyles.entries.where((e) => e.value).length;
    if (selectedStyles != 3) {
      _showMessage('相談スタイルは3つ選択してください');
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      // プロフィールデータを作成
      final profileData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'gender': _selectedGender,
        'introduction': _introductionController.text,
        'sample_voice_text': _sampleVoiceController.text,
        'genres': _genres.entries.where((e) => e.value).map((e) => e.key).toList(),
        'fortune_telling_types': _fortuneTellingTypes.entries.where((e) => e.value).map((e) => e.key).toList(),
        'consultation_styles': _consultationStyles.entries.where((e) => e.value).map((e) => e.key).toList(),
      };
      
      // プロフィール画像のパスを取得してデータに追加
      final imagePath = await _fortuneTellerService.getProfileImagePath();
      if (imagePath != null && imagePath.isNotEmpty) {
        profileData['profile_image'] = imagePath;
      }
      
      // プロフィールを保存
      final result = await _fortuneTellerService.saveFortuneTellerProfile(profileData);
      
      if (result['success'] == true) {
        _showMessage('プロフィールを保存しました');
      } else {
        _showMessage('保存に失敗しました: ${result['message']}');
      }
    } catch (e) {
      print('プロフィール保存エラー: $e');
      _showMessage('プロフィールの保存に失敗しました: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF3bcfd4)))
          : Column(
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
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: _profileImage != null
                                          ? FileImage(_profileImage!)
                                          : (_networkImageUrl != null && _networkImageUrl!.isNotEmpty
                                              ? NetworkImage(_networkImageUrl!)
                                              : null) as ImageProvider?,
                                      backgroundColor: Colors.grey[200],
                                      child: (_profileImage == null && (_networkImageUrl == null || _networkImageUrl!.isEmpty))
                                          ? const Icon(Icons.person, size: 50, color: Colors.grey)
                                          : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // 写真選択ボタン
                                InkWell(
                                  onTap: _pickImage,
                                  child: Container(
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
                                ),
                                const SizedBox(height: 8),
                                // プロフィール画像のヘルプリンク
                                const Text(
                                  '【運営ブログ】→プロフィール画像を用意しよう',
                                  style: TextStyle(
                                    color: Color(0xFF3bcfd4),
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
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
                                          _showMessage('ボイス録音機能は開発中です');
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
                                    _showMessage('プレビュー機能は開発中です');
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
                                  onPressed: _saveProfile,
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
