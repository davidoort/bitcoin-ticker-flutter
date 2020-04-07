import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  List<String> currencyRate = List.filled(cryptoList.length, '?');

  @override
  void initState() {
    super.initState();
    getCurrencyRate();
  }

  void getCurrencyRate() async {
    List<double> rates = [];

    for (int i = 0; i < cryptoList.length; i++) {
      double rate =
          await CoinData().getCoinData(selectedCurrency, cryptoList[i]);
      rates.add(rate);
    }
    setState(() {
      for (int i = 0; i < cryptoList.length; i++) {
        currencyRate[i] = rates[i] == null ? '?' : rates[i].toStringAsFixed(0);
      }
    });
  }

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropDownItemList = [];
    for (String currency in currenciesList) {
      var dropdownMenuItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItemList.add(dropdownMenuItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItemList,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            getCurrencyRate();
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> cupertinoItems = [];

    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(color: Colors.white),
      );
      cupertinoItems.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCurrencyRate();
        });
      },
      children: cupertinoItems,
    );
  }

  List<Widget> cryptoRectList() {
    List<Widget> cryptoRectList = [];

    for (int i = 0; i < cryptoList.length; i++) {
      cryptoRectList.add(cryptoRect(i));
    }

    return cryptoRectList;
  }

  Widget cryptoRect(int cryptoCurrencyIndex) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 ${cryptoList[cryptoCurrencyIndex]} = ${currencyRate[cryptoCurrencyIndex]} $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cryptoRectList() +
            <Widget>[
              Expanded(
                child: Container(),
              ),
              Container(
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
              ),
            ],
      ),
    );
  }
}
