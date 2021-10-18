// ignore_for_file: prefer_final_fields, prefer_collection_literals

import 'dart:async';
import 'dart:developer';

import 'package:candlesticks/candlesticks.dart';
import 'package:crypto_price/models/candles_model.dart';
import 'package:crypto_price/models/coins_model.dart';
import 'package:crypto_price/repository/coins_repository.dart';
import 'package:flutter/material.dart';

class AssetChartProvider extends ChangeNotifier {
  /// ===== Property =====
  StreamController<Map<dynamic, dynamic>> streamController =
      StreamController<Map<dynamic, dynamic>>.broadcast();
  Stream<Map<dynamic, dynamic>> get candleStream => streamController.stream;

  CoinsModel? coinData;
  List<Candle> candles = [];
  List<String> listInterval = [
    "m1",
    "m5",
    "m15",
    "m30",
    "h1",
    "h2",
    "h4",
    "h8",
    "h12",
    "d1",
    "w1"
  ];
  String interval = "m1";

  ///  ===== Method Setup to update candle =====
  void updateCandlesFromSnapshot(
      AsyncSnapshot<Object?> snapshot, CoinsModel coinData) {
    CoinsRepository.getCandle(interval, coinData.id, null).then((value) {
      if (value is List<CandlesModel>) {
        List<Candle> tempCandles = [];
        value.forEach((e) {
          tempCandles.add(
            Candle(
                date: DateTime.fromMillisecondsSinceEpoch(e.period),
                high: e.high,
                low: e.low,
                open: e.open,
                close: e.close,
                volume: e.volume),
          );
        });
        candles = tempCandles;
        notifyListeners();
      }
    });
  }
}
