class StockModel {
  final String symbol;

  StockModel({
    this.symbol,
  });

  factory StockModel.fromJSON(String symbol) {
    return StockModel(
      symbol: symbol,
    );
  }
}
