import 'package:flutter/material.dart';
import 'package:stonks/widgets/stock_list.dart';

class WelcomeHome extends StatelessWidget {
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
                  'Welcome',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: mediaQuery.width * 0.15,
                    fontFamily: 'CircularBook',
                  ),
                ),
                Text(
                  'to Stonks!',
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
              'NASDAQ 100 is made up of 103 equity securities issued by 100 largest non-financial companies listed on the Nasdaq Stock Market. ',
              style: TextStyle(
                color: Colors.black,
                fontSize: mediaQuery.width * 0.03,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          // SizedBox(
          //   height: mediaQuery.height * 0.02,
          // ),
          Container(
            padding: EdgeInsets.only(
              left: mediaQuery.height * 0.02,
              right: mediaQuery.height * 0.02,
            ),
            child: Text(
              'Select upto 10 equity stocks from this list. You can track your portfolio status in the \'My Portfolio\' section.',
              style: TextStyle(
                color: Colors.black,
                fontSize: mediaQuery.width * 0.03,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.01,
          ),
          // Padding(
          //   padding: EdgeInsets.only(
          //     left: mediaQuery.height * 0.02,
          //     right: mediaQuery.height * 0.02,
          //   ),
          //   child: SizedBox(
          //     height: mediaQuery.height * 0.05,
          //     child: TextField(
          //       decoration: InputDecoration(
          //         prefixIcon: Icon(
          //           Icons.search,
          //           color: Colors.black,
          //         ),
          //         //hintText: 'Search...',
          //         fillColor: Colors.grey[400],
          //         filled: true,
          //         border: OutlineInputBorder(
          //           borderSide: BorderSide(
          //             width: 0,
          //             style: BorderStyle.none,
          //           ),
          //           borderRadius: BorderRadius.all(
          //             Radius.circular(
          //               mediaQuery.height * 0.01,
          //             ),
          //           ),
          //         ),
          //         alignLabelWithHint: true,
          //       ),
          //       textAlignVertical: TextAlignVertical.center,
          //     ),
          //   ),
          // ),
          Container(
            child: StockList(),
            height: mediaQuery.height * 0.55,
          ),
        ],
      ),
    );
  }
}
