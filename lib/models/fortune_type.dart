class FortuneType {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  
  const FortuneType({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
  });
}

// サポートされている占いタイプ
class FortuneTypes {
  static const tarot = FortuneType(
    id: 'tarot',
    name: 'タロット占い',
    description: 'カードを使った西洋の占いです。あなたの運命や未来を読み解きます。',
    iconPath: 'assets/images/fortune/tarot.png',
  );
  
  static const horoscope = FortuneType(
    id: 'horoscope',
    name: '星座占い',
    description: '誕生日から導き出される星座による占いです。あなたの性格や相性を占います。',
    iconPath: 'assets/images/fortune/horoscope.png',
  );
  
  static const palmistry = FortuneType(
    id: 'palmistry',
    name: '手相占い',
    description: '手のひらの線から運命を読み解く占いです。あなたの過去と未来がわかります。',
    iconPath: 'assets/images/fortune/palmistry.png',
  );
  
  static const onmyoji = FortuneType(
    id: 'onmyoji',
    name: '陰陽道',
    description: '日本古来の占術で、五行や陰陽の法則に基づいてあなたの運勢を占います。',
    iconPath: 'assets/images/fortune/onmyoji.png',
  );
  
  static const compatibility = FortuneType(
    id: 'compatibility',
    name: '相性占い',
    description: 'あなたとパートナーの相性を占います。恋愛や友情の行方がわかります。',
    iconPath: 'assets/images/fortune/compatibility.png',
  );
  
  // すべての占いタイプのリスト
  static List<FortuneType> all = [
    tarot,
    horoscope,
    palmistry,
    onmyoji,
    compatibility,
  ];
  
  // IDから占いタイプを取得
  static FortuneType? getById(String id) {
    try {
      return all.firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }
}
