import 'dart:convert';

import 'package:crypto_app/crypto_model.dart';
import 'package:http/http.dart' as http;

class CryptoRepository {
  Future<List<CryptoModel>> fetchCryptoData() async {
    final response = await http.get(
      Uri.parse('https://api.coinlore.net/api/tickers/'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List list = data['data'];

      return list.map((item) => CryptoModel.fromJson(item)).toList();
    } else {
      throw Exception('Ошибка API');
    }
  }
}