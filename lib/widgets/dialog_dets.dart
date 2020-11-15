import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DetailsDialogBox extends StatefulWidget {
  final String symbol;
  bool isBought = false;
  final double myPrice;

  DetailsDialogBox({
    this.symbol,
    this.isBought,
    this.myPrice,
  });

  @override
  _DetailsDialogBoxState createState() => _DetailsDialogBoxState();
}

class _DetailsDialogBoxState extends State<DetailsDialogBox> {
  dynamic stockList;
  var currentPrice;
  var dayHigh;
  var dayLow;
  var openPrice;
  var prevClose;
  var percentChange;
  var change;
  String name;
  String imageUrl;
  bool isLoading = true;

  Future getDets(String symbol) async {
    final response = await http.get(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=bunc3mn48v6svkfr0650');
    final response2 = await http.get(
        'https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=bunc3mn48v6svkfr0650');
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      currentPrice = result["c"].toStringAsFixed(2);
      dayHigh = result["h"].toStringAsFixed(2);
      dayLow = result["l"].toStringAsFixed(2);
      openPrice = result["o"].toStringAsFixed(2);
      prevClose = result["pc"].toStringAsFixed(2);
      change = ((result["c"] - result["pc"]));
      percentChange = (change / result["pc"] * 100).toStringAsFixed(2);
      if (response2.statusCode == 200) {
        var result2 = jsonDecode(response2.body);
        name = result2["name"];
        imageUrl = result2["logo"];
      }
      print(
          '$currentPrice, $dayHigh, $dayLow, $openPrice, $prevClose, $isLoading');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('error');
    }
  }

  @override
  void initState() {
    getDets(widget.symbol);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return StatefulBuilder(builder: (context, setState) {
      if (mounted) {
        setState(() {});
      }
      return Container(
        color: Color.fromRGBO(1, 1, 1, 0),
        height: mediaQuery.height * 0.3,
        child: AlertDialog(
          actions: [
            MaterialButton(
              onPressed: () {
                currentPrice = null;
                dayHigh = null;
                dayLow = null;
                openPrice = null;
                prevClose = null;
                isLoading = true;
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            widget.isBought
                ? MaterialButton(
                    onPressed: () async {
                      var docs = await FirebaseFirestore.instance
                          .collection('portfolio')
                          .where('symbol', isEqualTo: widget.symbol)
                          .get();
                      FirebaseFirestore.instance
                          .collection('portfolio')
                          .doc(docs.docs[0].id)
                          .delete();
                      Fluttertoast.showToast(msg: 'Removed from Portfolio!');
                      Navigator.of(context).pop();
                    },
                    child: Text('Sell'),
                  )
                : MaterialButton(
                    onPressed: () async {
                      var docs = await FirebaseFirestore.instance
                          .collection('portfolio')
                          .where('symbol', isEqualTo: widget.symbol)
                          .get();
                      if (docs.docs.isEmpty) {
                        FirebaseFirestore.instance.collection('portfolio').add({
                          "symbol": widget.symbol,
                          "buyPrice": double.parse(currentPrice),
                        });
                        Fluttertoast.showToast(msg: 'Added to Portfolio!');
                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(msg: 'Already in Portfolio!');
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Buy'),
                  ),
          ],
          title: Text(
            'Details',
            style: TextStyle(
              fontFamily: 'CircularBook',
              fontWeight: FontWeight.bold,
            ),
            // textAlign: TextAlign.center,
          ),
          content: isLoading
              ? Container(
                  height: mediaQuery.height * 0.15,
                  width: mediaQuery.width * 0.8,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: mediaQuery.height * 0.2,
                  width: mediaQuery.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            // borderRadius: BorderRadius.circular(100),
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              height: mediaQuery.height * 0.1,
                              width: mediaQuery.height * 0.1,
                              child: Image.network(
                                imageUrl != null
                                    ? imageUrl
                                    : 'https://images.vexels.com/media/users/3/144882/isolated/preview/a98fa07f09c1d45d26405fa48c344428-company-building-silhouette-by-vexels.png',
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                      'https://images.vexels.com/media/users/3/144882/isolated/preview/a98fa07f09c1d45d26405fa48c344428-company-building-silhouette-by-vexels.png');
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height * 0.01,
                          ),
                          Container(
                            width: mediaQuery.height * 0.1,
                            child: Text(
                              name == null ? widget.symbol : '$name',
                              style: TextStyle(
                                fontFamily: 'CircularBook',
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.myPrice != null
                              ? Text(
                                  'Bought At: \$${widget.myPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Container(),
                          Text('Price: \$$currentPrice'),
                          Row(
                            children: [
                              Text(
                                  'Change: ${change.toStringAsFixed(3)} ($percentChange%)'),
                              percentChange.contains('-')
                                  ? Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.red,
                                    )
                                  : Icon(
                                      Icons.arrow_drop_up,
                                      color: Colors.green,
                                    )
                            ],
                          ),
                          Text('Open: \$$openPrice'),
                          Text('Last Close: \$$prevClose'),
                          Text('High: \$$dayHigh'),
                          Text('Low: \$$dayLow'),
                        ],
                      )
                    ],
                  ),
                ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      );
    });
  }
}
