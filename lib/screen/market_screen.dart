// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, unnecessary_string_interpolations
import 'package:crypto_price/models/coins_model.dart';
import 'package:crypto_price/screen/asset_item.dart';
import 'package:crypto_price/screen/candle_screen.dart';
import 'package:crypto_price/viewmodels/asset_price_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssetPriceProvider(),
      child: Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(
          child: Container(
            child: Consumer<AssetPriceProvider>(
              builder: (context, priceProv, _) => RefreshIndicator(
                onRefresh: () async {
                  await priceProv.getAsset();
                  return;
                },
                child: Column(
                  children: [
                    Expanded(
                      child: priceProv.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : priceProv.listAsset.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Data Tidak Ditemukan"),
                                      MaterialButton(
                                        color: Colors.grey.shade400,
                                        textColor: Colors.white,
                                        child: Text("Refresh"),
                                        onPressed: priceProv.initRefresh,
                                      )
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  child: ListView.builder(
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      backgroundColor: Color(0xFF1B1C21),
      leading: isSearch
          ? null
          : IconButton(
              onPressed: () => setState(() {
                isSearch = !isSearch;
              }),
              icon: Icon(Icons.search, color: Colors.white),
            ),
      title: !isSearch
          ? Text("Crypto Prices", style: TextStyle(color: Colors.white))
          : Consumer<AssetPriceProvider>(
              builder: (context, priceProv, _) => CupertinoSearchTextField(
                backgroundColor: Colors.white,
                onChanged: (query) {
                  priceProv.search(query);
                },
                onSuffixTap: () => setState(() {
                  priceProv.search('');
                  isSearch = !isSearch;
                }),
              ),
            ),
    );
  }
}
