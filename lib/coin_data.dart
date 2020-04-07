import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = '0F089977-A3E7-44B6-8674-7331DAC71879';

const apiURL = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<double> getCoinData() async {
    // From https://pub.dev/packages/http#-example-tab-
    
    var url = '$apiURL/BTC/USD?apiKey=$apiKey';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      return jsonResponse['rate'];
    } else {
      print('Error: ${response.statusCode}');
      return null;
    }
  }
}
