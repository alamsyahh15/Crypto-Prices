// To parse this JSON data, do
//
//     final coinsModel = coinsModelFromJson(jsonString);

import 'dart:convert';

List<CoinsModel> coinsModelFromJson(String str) =>
    List<CoinsModel>.from(json.decode(str).map((x) => CoinsModel.fromJson(x)));

String coinsModelToJson(List<CoinsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CoinsModel {
  CoinsModel({
    required this.id,
    required this.rank,
    required this.symbol,
    required this.name,
    required this.supply,
    required this.maxSupply,
    required this.marketCapUsd,
    required this.volumeUsd24Hr,
    required this.priceUsd,
    required this.changePercent24Hr,
    required this.vwap24Hr,
    required this.gain,
  });

  String id;
  String rank;
  String symbol;
  String name;
  String supply;
  String? maxSupply;
  String marketCapUsd;
  String volumeUsd24Hr;
  String priceUsd;
  String changePercent24Hr;
  String vwap24Hr;
  bool? gain;

  factory CoinsModel.fromJson(Map<String, dynamic> json) => CoinsModel(
        id: json["id"],
        rank: json["rank"],
        symbol: json["symbol"],
        name: json["name"],
        supply: json["supply"],
        maxSupply: json["maxSupply"],
        marketCapUsd: json["marketCapUsd"],
        volumeUsd24Hr: json["volumeUsd24Hr"],
        priceUsd: json["priceUsd"],
        changePercent24Hr: json["changePercent24Hr"],
        vwap24Hr: json["vwap24Hr"],
        gain: null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "rank": rank,
        "symbol": symbol,
        "name": name,
        "supply": supply,
        "maxSupply": maxSupply,
        "marketCapUsd": marketCapUsd,
        "volumeUsd24Hr": volumeUsd24Hr,
        "priceUsd": priceUsd,
        "changePercent24Hr": changePercent24Hr,
        "vwap24Hr": vwap24Hr,
      };
}
