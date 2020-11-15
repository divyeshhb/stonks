import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:stonks/widgets/portfolio_list.dart';

class Portfolio extends StatefulWidget {
  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  initState() {
    getFolioTotal();
    super.initState();
  }

  double folioTotal;
  double totalBP = 0;
  double totalCP = 0;

  Future getFolioTotal() async {
    var docs = await FirebaseFirestore.instance.collection('portfolio').get();
    List bp = [];
    List cp = [];

    if (docs.docs.isNotEmpty) {
      for (int i = 0; i < docs.docs.length; i++) {
        final response = await http.get(
            'https://finnhub.io/api/v1/quote?symbol=${docs.docs[i]["symbol"]}&token=bunc3mn48v6svkfr0650');
        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          cp.add(result["c"]);
        }
        bp.add(docs.docs[i]["buyPrice"]);
      }

      setState(() {
        bp.forEach((e) => totalBP += e);
        cp.forEach((e) => totalCP += e);
        folioTotal = totalCP - totalBP;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: mediaQuery.height * 0.15,
          ),
          Container(
            padding: EdgeInsets.only(
              left: mediaQuery.height * 0.02,
            ),
            //width: mediaQuery.width * 0.587,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaQuery.width * 0.15,
                    fontFamily: 'CircularBook',
                  ),
                ),
                Text(
                  'Portfolio',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaQuery.width * 0.15,
                    fontFamily: 'CircularBook',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.02,
          ),
          Container(
            padding: EdgeInsets.only(
              left: mediaQuery.height * 0.02,
              right: mediaQuery.height * 0.02,
            ),
            child: Text(
              'This is your portfolio. You can find all equities here you had added previously. Keep track and sell at the right time!',
              style: TextStyle(
                color: Colors.black,
                fontSize: mediaQuery.width * 0.03,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.02,
          ),
          Container(
            padding: EdgeInsets.only(
                left: mediaQuery.height * 0.02,
                right: mediaQuery.height * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Profit/Loss: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaQuery.width * 0.04,
                    fontFamily: 'OpenSans',
                  ),
                ),
                folioTotal == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : folioTotal >= 0
                        ? Text(
                            '+\$${folioTotal.toStringAsFixed(2)} (${(folioTotal / totalBP * 100).toStringAsFixed(2)}%)',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: mediaQuery.width * 0.04,
                              fontFamily: 'OpenSans',
                            ),
                          )
                        : Text(
                            '-\$${folioTotal.toStringAsFixed(2).substring(1)}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: mediaQuery.width * 0.04,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {
                      folioTotal = null;
                      totalBP = 0;
                      totalCP = 0;
                    });
                    getFolioTotal();
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          Container(
            child: PortfolioList(),
            height: mediaQuery.height * 0.5,
          ),
        ],
      ),
    );
  }
}
