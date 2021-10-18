// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_string_interpolations
import 'package:crypto_price/models/coins_model.dart';
import 'package:crypto_price/screen/candle_screen.dart';
import 'package:crypto_price/viewmodels/asset_price_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetPriceProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text("Crypto Price")),
        body: SafeArea(
          child: Container(
            child: Consumer<AssetPriceProvider>(
              builder: (context, priceProv, _) => RefreshIndicator(
                onRefresh: () async {
                  await priceProv.getAsset();
                  return;
                },
                child: priceProv.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: priceProv.listAsset.isEmpty
                            ? Center(child: Text(" Server Has Many Request"))
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: priceProv.listAsset.length,
                                itemBuilder: (contex, index) {
                                  final data = priceProv.listAsset[index];
                                  return AssetItem(data: data);
                                },
                              ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AssetItem extends StatelessWidget {
  final CoinsModel data;
  const AssetItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${data.symbol}"),
      subtitle: Text("${data.priceUsd}"),
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
