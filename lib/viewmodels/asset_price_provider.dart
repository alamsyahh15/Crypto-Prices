// ignore_for_file: prefer_final_fields, unnecessary_this, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:crypto_price/main.dart';
import 'package:crypto_price/models/coins_model.dart';
import 'package:crypto_price/repository/coins_repository.dart';
import 'package:crypto_price/viewmodels/asset_chart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AssetPriceProvider extends ChangeNotifier {
  /// ==== Construct =====
  AssetPriceProvider() {
    this.init();
    timer = Timer.periodic(Duration(minutes: 2), (timer) {
      log("getAsset Url ${timer.tick}");
      getAsset();
    });
  }

  /// ==== Property =====
  late Timer timer;
  bool _mounted = false;
  bool _isLoading = false;
  List<CoinsModel> listAsset = [];

  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  /// ==== Method =====
  void init() async {
    isLoading = true;
    await getAsset();
    isLoading = false;
    listenData();
  }

  Future getAsset() async {
    final result = await CoinsRepository.getAsset();
    if (result is List<CoinsModel>) {
      listAsset = result;
    }
    notifyListeners();
  }

  void listenData() {
    CoinsRepository.channel.stream.listen((event) {
      final candleProv = Provider.of<AssetChartProvider>(
          navigatorKey.currentContext!,
          listen: false);
      final data = jsonDecode(event) as Map;
      for (var key in data.keys) {
        if (key == candleProv.coinData?.id) {
          // Notify candle stream to update
          candleProv.streamController.add(data);
        }
        for (int i = 0; i < listAsset.length; i++) {
          if (listAsset[i].id == "$key") {
            double lastPrice = double.parse(listAsset[i].priceUsd) * 1000;
            double latestPrice = double.parse("${data[key]}") * 1000;

            // Compare data if Gain,Loss, or Neutral
            listAsset[i].gain = null;
            if (latestPrice != lastPrice) {
              listAsset[i].gain = latestPrice > lastPrice;
            }

            // Set Prices with new price
            log("Price $lastPrice == $latestPrice ${listAsset[i].gain}");
            listAsset[i].priceUsd = "${data[key]}";
            notifyListeners();
          }
        }
      }
    });
  }

  /// ==== Inherited =====
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    if (!_mounted) super.notifyListeners();
  }

  @override
  void dispose() {
    _mounted = true;
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }
}
