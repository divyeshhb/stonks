import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stonks/widgets/dialog_dets.dart';
import 'package:http/http.dart' as http;

class PortfolioList extends StatefulWidget {
  @override
  _PortfolioListState createState() => _PortfolioListState();
}

class _PortfolioListState extends State<PortfolioList> {
  Future<double> getPrice(String symbol) async {
    final response = await http.get(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=bunc3mn48v6svkfr0650');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      double currentPrice = result["c"];
      return currentPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('portfolio').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: getPrice(snapshot.data.docs[index]['symbol']),
                  builder: (context, snapshot1) {
                    if (!snapshot1.hasData) {
                      return Container();
                    }
                    var bp = snapshot.data.docs[index]['buyPrice'];
                    var cp = snapshot1.data;
                    return Card(
                      //elevation: 1,
                      child: ListTile(
                        leading: Icon(
                          Icons.monetization_on,
                          color: bp > cp ? Colors.red : Colors.green,
                        ),
                        subtitle: Text('Buy Price: \$${bp.toStringAsFixed(2)}'),
                        title: Text(snapshot.data.docs[index]['symbol']),
                        trailing: cp - bp >= 0
                            ? Text(
                                '+${(cp - bp).toStringAsFixed(2)} (${((cp - bp) / bp * 100).toStringAsFixed(2)}%)',
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                '${(cp - bp).toStringAsFixed(2)} (${((bp - cp) / bp * 100).toStringAsFixed(2)}%)',
                                style: TextStyle(color: Colors.red),
                              ),
                        onTap: () async {
                          // getDets(article.symbol);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DetailsDialogBox(
                                  symbol: snapshot.data.docs[index]['symbol'],
                                  isBought: true,
                                  myPrice: snapshot.data.docs[index]
                                      ['buyPrice'],
                                );
                              });
                        },
                      ),
                    );
                  });
            },
          );
        });
  }
}
