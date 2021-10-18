// To parse this JSON data, do
//
//     final candlesModel = candlesModelFromJson(jsonString);

import 'dart:convert';

List<CandlesModel> candlesModelFromJson(String str) => List<CandlesModel>.from(
    json.decode(str).map((x) => CandlesModel.fromJson(x)));

String candlesModelToJson(List<CandlesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CandlesModel {
  CandlesModel({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.period,
  });

  double open;
  double high;
  double low;
  double close;
  double volume;
  int period;

  factory CandlesModel.fromJson(Map<String, dynamic> json) => CandlesModel(
        open: double.parse(json["open"]),
        high: double.parse(json["high"]),
        low: double.parse(json["low"]),
        close: double.parse(json["close"]),
        volume: double.parse(json["volume"]),
        period: json["period"],
      );

  Map<String, dynamic> toJson() => {
        "open": open,
        "high": high,
        "low": low,
        "close": close,
        "volume": volume,
        "period": period,
      };
}
