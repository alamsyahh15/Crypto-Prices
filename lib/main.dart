// ignore_for_file: prefer_const_constructors

import 'package:crypto_price/screen/market_screen.dart';
import 'package:crypto_price/viewmodels/asset_chart_provider.dart';
import 'package:crypto_price/viewmodels/asset_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssetPriceProvider()),
        ChangeNotifierProvider(create: (_) => AssetChartProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: Center(child: MarketScreen()),
      ),
    );
  }
}
