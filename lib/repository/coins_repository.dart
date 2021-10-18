// ignore_for_file: use_rethrow_when_possible

import 'dart:developer';
import 'package:crypto_price/models/candles_model.dart';
import 'package:crypto_price/models/coins_model.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CoinsRepository {
  static Dio dio = Dio();
  static String baseUrl = "https://api.coincap.io/v2";
  static final channel = WebSocketChannel.connect(
    Uri.parse("wss://ws.coincap.io/prices?assets=ALL"),
  );

  /// ====== Get Asset ======
  static Future getAsset() async {
    try {
      final res = await dio.get(baseUrl + "/assets");
      log("getAsset Url => ${res.realUri}");
      if (res.statusCode == 200) {
        return List<CoinsModel>.from(
          res.data['data'].map((e) => CoinsModel.fromJson(e)),
        );
      }
      return null;
    } catch (err) {
      throw err;
    }
  }

  /// ====== Get Asset ======
  static Future getCandle(
    String? interval,
    String? coinId,
    String? pairId,
  ) async {
    try {
      final res = await dio.get(
        baseUrl + "/candles",
        queryParameters: {
          'exchange': 'poloniex',
          'interval': interval ?? 'h8',
          'baseId': coinId ?? 'bitcoin',
          'quoteId': pairId ?? 'tether'
        },
      );
      log("Url Candles => ${res.realUri}");
      if (res.statusCode == 200) {
        return List<CandlesModel>.from(
          res.data['data'].map((e) => CandlesModel.fromJson(e)),
        );
      }
      return null;
    } catch (err) {
      throw err;
    }
  }

  /// ===== Get Price =====
  static Stream getPrice() async* {
    yield channel.stream;
  }
}
