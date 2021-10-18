// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:candlesticks/candlesticks.dart';
import 'package:crypto_price/models/coins_model.dart';
import 'package:crypto_price/viewmodels/asset_chart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CandleScreen extends StatefulWidget {
  final CoinsModel coinData;
  const CandleScreen({Key? key, required this.coinData}) : super(key: key);

  @override
  _CandleScreenState createState() => _CandleScreenState();
}

class _CandleScreenState extends State<CandleScreen> {
  @override
  void initState() {
    init();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    // TODO: implement initState
    super.initState();
  }

  void init() {
    final candleProv = Provider.of<AssetChartProvider>(context, listen: false);
    candleProv.candles = [];
    candleProv.interval = "m1";
    candleProv.coinData = widget.coinData;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.coinData.symbol} / USDT"),
        ),
        body: Center(
          child: StreamBuilder(
            stream: Provider.of<AssetChartProvider>(context, listen: true)
                .candleStream,
            builder: (context, snapshot) {
              Provider.of<AssetChartProvider>(context, listen: false)
                  .updateCandlesFromSnapshot(snapshot, widget.coinData);
              return Consumer<AssetChartProvider>(
                builder: (context, candleProv, _) => Candlesticks(
                  intervals: candleProv.listInterval,
                  onIntervalChange: (String value) async {
                    /// reset data
                    setState(() {
                      candleProv.candles = [];
                      candleProv.interval = value;
                    });
                  },
                  candles: candleProv.candles,
                  interval: candleProv.interval,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
