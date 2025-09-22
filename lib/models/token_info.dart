class TokenInfo {
  final String name;
  final double price;
  final double prevPrice;
  final double change;
  final double changePercent;
  final String logoUrl;

  TokenInfo({
    required this.name,
    required this.price,
    required this.prevPrice,
    required this.change,
    required this.changePercent,
    required this.logoUrl,
  });
}
