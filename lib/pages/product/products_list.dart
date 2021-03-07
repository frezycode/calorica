import 'package:calory_calc/design/theme.dart';
import 'package:calory_calc/pages/product/widgets/widgets.dart';
import 'package:calory_calc/providers/local_providers/productProvider.dart';

import 'package:flutter/material.dart';

import 'package:calory_calc/config/adMobConfig.dart';
import 'package:calory_calc/models/dbModels.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool isSaerching = false;
  ScrollController scrollController;
  String searchText;

  final _controller = NativeAdmobController();

  void startSearch(String text) {
    setState(() {
      isSaerching = true;
      searchText = text;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Text(
                  "Добавление \nприема пищи",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: DesignTheme.blackColor,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: DesignTheme.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15.0,
                        spreadRadius: 4.0,
                        offset: Offset(
                          0.0,
                          5.0,
                        ),
                      )
                    ],
                  ),
                  child: TextFormField(
                    onChanged: (text) {
                      startSearch(text);
                    },
                    style: DesignTheme.inputText,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      icon: Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                        ),
                        child: Icon(
                          Icons.search,
                          color: DesignTheme.mainColor,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      labelText: 'Поиск по продуктам...',
                      border: InputBorder.none,
                      labelStyle: DesignTheme.labelSearchText,
                    ),
                    onEditingComplete: () {},
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 5,
                      ),
                      child: Text(
                        "Результаты поиска:",
                        style: DesignTheme.lilGrayText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Divider(height: 1),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height),
                  child: FutureBuilder(
                    future: isSaerching
                        ? DBProductProvider.db.getAllProductsSearch(searchText)
                        : DBProductProvider.db.getAllProducts(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Product>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('Input a URL to start');
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                          return Text('');
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text(
                              '${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            // var count = snapshot.data.length;
                            // if (count > 5) {
                            //   snapshot.data.insert(4, Product(name: "Реклама"));
                            // } else if (count > 3) {
                            //   snapshot.data.insert(3, Product(name: "Реклама"));
                            // } else if (count > 1) {
                            //   snapshot.data.insert(1, Product(name: "Реклама"));
                            // } else {
                            //   snapshot.data.insert(0, Product(name: "Реклама"));
                            // }
                            return ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return snapshot.data[i].name == "Реклама"
                                    ? Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        elevation: 1.0,
                                        child: Container(
                                          height: 250,
                                          child: NativeAdmob(
                                            adUnitID: AdMobConfig
                                                .NATIVE_ADMOB_BIG_BLOCK_ID,
                                            controller: _controller,
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        child: ProductCard(
                                          product: snapshot.data[i],
                                        ),
                                        onTap: () =>
                                            _openProductPage(snapshot.data[i]),
                                      );
                              },
                            );
                          }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openProductPage(Product product) {
    Navigator.pushNamed(
      context,
      '/product/' + product.id.toString(),
    );
  }
}
