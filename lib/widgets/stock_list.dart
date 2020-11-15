// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:stonks/models/stock_detail.dart';
import 'package:stonks/models/stock_model.dart';
import 'package:stonks/services/list_service.dart';
import 'package:stonks/widgets/dialog_dets.dart';
import 'package:stonks/widgets/stock_card.dart';
// import 'package:http/http.dart' as http;

class StockList extends StatefulWidget {
  @override
  _StockListState createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  dynamic stockList;

  bool isLoading = true;

  Future getList() async {
    List<StockModel> stocks = await Webservice().fetchTopHeadlines();
    // List<StockDetail> stockDetail = await Webservice().fetchDetails();
    setState(() {
      stockList = stocks.map((stocks) => StockCard(stock: stocks)).toList();
    });
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size mediaQuery = MediaQuery.of(context).size;
    return stockList != null
        ? ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: stockList.length,
            itemBuilder: (context, index) {
              final article = stockList[index];
              return Card(
                //elevation: 1,
                child: ListTile(
                  leading: Icon(
                    Icons.monetization_on,
                    color: Colors.indigoAccent,
                  ),
                  subtitle: Text('NASDAQ 100'),
                  title: Text(article.symbol),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () async {
                    // getDets(article.symbol);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DetailsDialogBox(
                            symbol: article.symbol,
                            isBought: false,
                          );
                        });
                  },
                ),
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }
}
