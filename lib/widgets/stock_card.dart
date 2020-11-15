import 'package:stonks/models/stock_model.dart';

class StockCard {
  StockModel _stockModel;

  StockCard({StockModel stock}) : _stockModel = stock;

  String get symbol {
    return _stockModel.symbol;
  }
}
