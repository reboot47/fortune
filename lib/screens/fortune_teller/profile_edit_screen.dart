import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import '../../widgets/fortune_teller_base_screen.dart';
import '../../widgets/fortune_teller_tab_bar.dart';
import '../../services/database_service.dart';

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
  final ImagePicker _picker = ImagePicker();
  
  // プロフィール画像
  File? _profileImage;
  String? _networkImageUrl;

  // ユーザーデータ
  Map<String, dynamic>? _userData;
  
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
  
  // データベースサービス
  final DatabaseService _databaseService = DatabaseService();
  
  // ユーザーID
  int? _userId;
  
  // 音声録音関連
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordedVoicePath;
  bool _isRecorderInitialized = false;
  
  // ローディング状態
  bool _isLoading = false;
  bool _isSaving = false;
  
  @override
  void initState() {
    super.initState();
    _initRecorder();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _sampleVoiceController.dispose();
    _nameController.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }
  
  // レコーダーの初期化
  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('マイクの使用許可が必要です');
    }
    
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }
  
  // ユーザープロフィールの読み込み
  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // ユーザーIDを取得
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');
      final userEmail = prefs.getString('userEmail');
      
      if (userId == null || userEmail == null) {
        throw Exception('ユーザー情報が見つかりません');
      }
      
      _userId = userId;
      
      // データベース接続
      await _databaseService.connect();
      
      // プロフィール情報を取得
      final result = await _databaseService.getUserProfile(userEmail);
      
      if (result['success']) {
        final profileData = result['profile'];
        
        setState(() {
          _nameController.text = profileData['display_name'] ?? '';
          
          // プロフィール詳細情報を取得
          if (profileData.containsKey('profile_details')) {
            final details = profileData['profile_details'];
            
            if (details != null) {
              // 性別
              _selectedGender = details['gender'] ?? '女性';
              
              // 自己紹介
              _introductionController.text = details['introduction'] ?? '';
              
              // サンプルボイス用テキスト
              _sampleVoiceController.text = details['voice_text'] ?? '';
              
              // 得意ジャンル
              if (details.containsKey('genres') && details['genres'] != null) {
                final genres = Map<String, bool>.from(details['genres']);
                _genres.forEach((key, value) {
                  if (genres.containsKey(key)) {
                    _genres[key] = genres[key]!;
                  }
                });
              }
              
              // 得意占術
              if (details.containsKey('fortune_telling_types') && details['fortune_telling_types'] != null) {
                final types = Map<String, bool>.from(details['fortune_telling_types']);
                _fortuneTellingTypes.forEach((key, value) {
                  if (types.containsKey(key)) {
                    _fortuneTellingTypes[key] = types[key]!;
                  }
                });
              }
              
              // 相談スタイル
              if (details.containsKey('consultation_styles') && details['consultation_styles'] != null) {
                final styles = Map<String, bool>.from(details['consultation_styles']);
                _consultationStyles.forEach((key, value) {
                  if (styles.containsKey(key)) {
                    _consultationStyles[key] = styles[key]!;
                  }
                });
              }
              
              // 録音済みの音声パス
              _recordedVoicePath = details['voice_path'];
            }
          }
        });
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
  
  // プロフィール画像の選択
  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('画像の選択に失敗しました: $e')),
      );
    }
  }
  
  // 音声録音の開始
  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('録音機能の初期化に失敗しました')),
      );
      return;
    }
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/voice_sample_${DateTime.now().millisecondsSinceEpoch}.aac';
      
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );
      
      setState(() {
        _isRecording = true;
        _recordedVoicePath = path;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('録音の開始に失敗しました: $e')),
      );
    }
  }
  
  // 音声録音の停止
  Future<void> _stopRecording() async {
    try {
      await _recorder.stopRecorder();
      
      setState(() {
        _isRecording = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('録音が完了しました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('録音の停止に失敗しました: $e')),
      );
    }
  }
  
  // プロフィールの保存
  Future<void> _saveProfile() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ユーザー情報が見つかりません')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // ユーザーメールアドレスを取得
      final prefs = await SharedPreferences.getInstance();
      final userEmail = prefs.getString('userEmail');
      
      if (userEmail == null) {
        throw Exception('ユーザーメールアドレスが見つかりません');
      }
      
      // プロフィール詳細情報を準備
      final profileDetails = {
        'gender': _selectedGender,
        'introduction': _introductionController.text,
        'voice_text': _sampleVoiceController.text,
        'genres': _genres,
        'fortune_telling_types': _fortuneTellingTypes,
        'consultation_styles': _consultationStyles,
        'voice_path': _recordedVoicePath,
      };
      
      // 更新データを準備
      final updateData = {
        'display_name': _nameController.text,
        'profile_details': profileDetails,
      };
      
      // プロフィール画像がある場合は追加
      if (_profileImage != null) {
        // 実際のアプリでは、ここで画像をサーバーにアップロードし、
        // そのURLをprofile_imageフィールドに設定します
        // このサンプルでは、ローカルパスを保存します
        updateData['profile_image'] = _profileImage!.path;
      }
      
      // データベース接続
      await _databaseService.connect();
      
      // プロフィール情報を更新
      final result = await _databaseService.updateUserProfile(userEmail, updateData);
      
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('プロフィールを保存しました')),
        );
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('プロフィールの保存に失敗しました: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
  
  // プロフィール画像をユーザーデータから取得するヘルパーメソッド
  ImageProvider? _getProfileImageFromUserData() {
    if (_userData == null) return null;
    if (_userData!['profile_image'] == null) return null;
    if (_userData!['profile_image'].toString().isEmpty) return null;
    
    return NetworkImage(_userData!['profile_image'].toString());
  }
  
  // デフォルトのプロフィールアイコンを表示すべきか判断するヘルパーメソッド
  bool _shouldShowDefaultProfileIcon() {
    if (_profileImage != null) return false;
    if (_userData == null) return true;
    if (_userData!['profile_image'] == null) return true;
    if (_userData!['profile_image'].toString().isEmpty) return true;
    
    return false;
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
                                          : _getProfileImageFromUserData(),
                                      backgroundColor: Colors.grey[200],
                                      child: _shouldShowDefaultProfileIcon()
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
                                        icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                                        label: Text(_isRecording ? '録音停止' : '録音する'),
                                        onPressed: () {
                                          if (_isRecording) {
                                            _stopRecording();
                                          } else {
                                            _startRecording();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _isRecording ? Colors.red : const Color(0xFF3bcfd4),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                      ),
                                    ),
                                    if (_recordedVoicePath != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          '録音済み: ${_recordedVoicePath!.split('/').last}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
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
                                  onPressed: _isLoading ? null : _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3bcfd4),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    disabledBackgroundColor: Colors.grey,
                                  ),
                                  child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
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
