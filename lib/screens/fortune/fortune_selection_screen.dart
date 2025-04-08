import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/fortune_type.dart';
import '../../theme/app_theme.dart';
import '../../services/database_service.dart';
import 'fortune_result_screen.dart';

class FortuneSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const FortuneSelectionScreen({Key? key, required this.userData}) : super(key: key);

  @override
  _FortuneSelectionScreenState createState() => _FortuneSelectionScreenState();
}

class _FortuneSelectionScreenState extends State<FortuneSelectionScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '占いを選ぶ',
          style: TextStyle(
            color: Color(0xFF1a237e),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // 背景デザイン要素
          Positioned(
            top: -50,
            left: -20,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Color(0xFFf8bbd0).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          // メインコンテンツ
          SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildFortuneTypeGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildFortuneTypeGrid() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'どの占いを試してみますか？',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a237e),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '以下から占いの種類を選んでください。',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: FortuneTypes.all.length,
              itemBuilder: (context, index) {
                final fortuneType = FortuneTypes.all[index];
                return _buildFortuneTypeCard(fortuneType);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFortuneTypeCard(FortuneType fortuneType) {
    return GestureDetector(
      onTap: () => _selectFortuneType(fortuneType),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 占いタイプのアイコン（実際のアイコンがない場合はプレースホルダーを使用）
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _getColorForFortuneType(fortuneType.id).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForFortuneType(fortuneType.id),
                size: 40,
                color: _getColorForFortuneType(fortuneType.id),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              fortuneType.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1a237e),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                fortuneType.description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 占いタイプに応じたアイコンを取得
  IconData _getIconForFortuneType(String fortuneTypeId) {
    switch (fortuneTypeId) {
      case 'tarot':
        return Icons.style;
      case 'horoscope':
        return Icons.star;
      case 'palmistry':
        return Icons.pan_tool;
      case 'onmyoji':
        return Icons.brightness_4;
      case 'compatibility':
        return Icons.favorite;
      default:
        return Icons.star;
    }
  }

  // 占いタイプに応じた色を取得
  Color _getColorForFortuneType(String fortuneTypeId) {
    switch (fortuneTypeId) {
      case 'tarot':
        return Colors.purple;
      case 'horoscope':
        return Colors.blue;
      case 'palmistry':
        return Colors.orange;
      case 'onmyoji':
        return Colors.indigo;
      case 'compatibility':
        return Colors.pink;
      default:
        return AppTheme.primaryColor;
    }
  }

  // 占いタイプを選択したときの処理
  void _selectFortuneType(FortuneType fortuneType) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // ユーザーIDを取得
      final userId = widget.userData['id'];
      
      if (userId == null) {
        throw Exception('ユーザーIDが見つかりません');
      }

      // 占い結果を生成（実際のアプリでは占い師のテンプレートを使用するか、アルゴリズムで生成）
      final resultContent = _generateFortuneResult(fortuneType.id);
      
      // 占い結果をデータベースに保存
      final dbService = DatabaseService();
      await dbService.connect();
      
      final resultData = {
        'user_id': userId,
        'fortune_teller_id': null, // 自動生成の場合は占い師IDはnull
        'template_id': null, // 自動生成の場合はテンプレートIDはnull
        'fortune_type': fortuneType.id,
        'question': null,
        'result_content': resultContent,
      };
      
      final saveResult = await dbService.saveFortuneResult(resultData);
      
      setState(() {
        _isLoading = false;
      });
      
      if (saveResult['success']) {
        // 占い結果画面に遷移
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FortuneResultScreen(
              userData: widget.userData,
              fortuneType: fortuneType,
              resultContent: resultContent,
              resultId: saveResult['id'],
            ),
          ),
        );
      } else {
        throw Exception(saveResult['message']);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('占い結果の生成に失敗しました: $e')),
      );
    }
  }

  // 占い結果を生成するメソッド（実際のアプリではより複雑なロジックになる）
  String _generateFortuneResult(String fortuneTypeId) {
    // 実際のアプリでは、ユーザーの誕生日や質問内容に基づいて結果を生成する
    // ここではサンプルの結果を返す
    switch (fortuneTypeId) {
      case 'tarot':
        return '''
【タロット占い結果】

あなたが引いたカードは「太陽」です。

このカードは成功と幸福を表しています。現在のあなたは、明るいエネルギーに満ち溢れ、周囲の人々にも良い影響を与えています。

近い将来、あなたの努力が実を結び、大きな成功を収めるでしょう。自信を持って前に進んでください。

人間関係においても、あなたの明るさが人々を引き寄せ、新しい出会いがあるかもしれません。

健康面では、活力に満ちた時期です。外に出て太陽の光を浴びることで、さらに運気が上昇するでしょう。
''';
      case 'horoscope':
        return '''
【星座占い結果】

今週のあなたの運勢は上昇傾向にあります。

仕事運：★★★★☆
新しいプロジェクトや挑戦に恵まれる時期です。積極的に意見を出すことで、周囲からの評価が高まるでしょう。

恋愛運：★★★★★
素晴らしい出会いの予感があります。既に恋人がいる方は、関係がさらに深まる時期です。

金運：★★★☆☆
無駄遣いに注意すれば、安定した金運が続きます。投資は慎重に。

健康運：★★★★☆
体調は良好ですが、睡眠時間を確保することで、さらにパフォーマンスが上がるでしょう。
''';
      case 'palmistry':
        return '''
【手相占い結果】

あなたの手相からは、以下のことが読み取れます。

生命線：長く深い線が見られ、健康と活力に恵まれています。ただし、30代半ばで一時的な健康上の問題が生じる可能性があるため、定期的な健康チェックを心がけましょう。

知能線：複数の分岐が見られ、創造性と多才さを持っていることを示しています。様々な分野に興味を持ち、学び続けることであなたの才能が開花するでしょう。

感情線：安定した線が見られ、感情のコントロールが上手な方です。人間関係においても、冷静な判断ができるでしょう。

結婚線：はっきりとした線が2本見られます。人生において重要な出会いが2回あることを示しています。
''';
      case 'onmyoji':
        return '''
【陰陽道占い結果】

現在のあなたは、陰の気が強まっている時期です。

内省と準備の時期として、新しいことを始めるよりも、これまでの経験を振り返り、次の行動の準備をすることが吉となるでしょう。

特に、水に関連する事柄（感情、直感、創造性）に注目すると、新たな気づきがあるかもしれません。

方位的には、北方位が吉となります。北に関連する行動や場所に足を運ぶことで、運気が上昇するでしょう。

忌むべき方位は南西です。この方向への重要な行動は、しばらく控えることをお勧めします。

守護の神獣は玄武（亀蛇）です。知恵と長寿の象徴である玄武があなたを守護しています。
''';
      case 'compatibility':
        return '''
【相性占い結果】

あなたとパートナーの相性は80%です。

精神的な繋がりが強く、お互いの考えを理解し合える関係です。特に、価値観や将来の展望において共通点が多いようです。

ただし、コミュニケーションスタイルに若干の違いがあり、時に誤解が生じる可能性があります。お互いの話をしっかりと聞き、確認することで、さらに関係が深まるでしょう。

相性を高めるためのアドバイス：
1. 共通の趣味や活動を見つけて一緒に楽しむ時間を作りましょう
2. 小さな感謝の気持ちを言葉で伝えることを習慣にしましょう
3. 意見の相違があっても、相手の立場を尊重する姿勢を持ちましょう

二人の関係は、努力次第でさらに素晴らしいものになる可能性を秘めています。
''';
      default:
        return '占い結果を生成できませんでした。';
    }
  }
}
