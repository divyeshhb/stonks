import 'dart:convert';
import 'package:stonks/models/stock_model.dart';
import 'package:http/http.dart' as http;

class Webservice {
  List<StockModel> list1 = [];
  Future<List<StockModel>> fetchTopHeadlines() async {
    final response = await http.get(
        'https://finnhub.io/api/v1/index/constituents?symbol=^NDX&token=bunc3mn48v6svkfr0650');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      List nasdaq = result["constituents"] as List;
      for (int i = 0; i < nasdaq.length; i++) {
        list1.add(StockModel.fromJSON(nasdaq[i]));
      }
      return list1;
    } else {
      print("failed, ${response.statusCode}");
      return null;
    }
  }
}

// 08Z3FGEROM9EHVPX

// bunc3mn48v6svkfr0650
