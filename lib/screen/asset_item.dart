// ignore_for_file: unnecessary_string_interpolations, prefer_const_constructors

import 'package:crypto_price/models/coins_model.dart';
import 'package:crypto_price/screen/candle_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetItem extends StatelessWidget {
  final CoinsModel data;
  const AssetItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${data.symbol} / USD"),
      subtitle: Text("${data.priceUsd} USD"),
      trailing: Container(
        alignment: Alignment.center,
        width: 80,
        height: 30,
        color: () {
          if (data.gain != null) {
            return data.gain == true ? Colors.green : Colors.red;
          }
          return Colors.grey.shade400;
        }(),
        child: Text(
          "${double.parse(data.changePercent24Hr).toStringAsFixed(1)} %",
          style: TextStyle(color: Colors.white),
        ),
      ),
      onTap: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(builder: (_) => CandleScreen(coinData: data)),
        )
            .then((value) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        });
      },
    );
  }
}
