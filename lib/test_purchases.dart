import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  try {
    final loginRes = await http.post(
      Uri.parse('http://127.0.0.1:3000/api/v1/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': 'buyer@flowmarket.local', 'password': 'password123'})
    );
    final token = jsonDecode(loginRes.body)['accessToken'];
    print("Token: $token");

    final purchasesRes = await http.get(
      Uri.parse('http://127.0.0.1:3000/api/v1/purchases?page=1&limit=20'),
      headers: {'Authorization': 'Bearer $token'}
    );
    print("Purchases HTTP ${purchasesRes.statusCode}: ${purchasesRes.body}");
  } catch (e) {
    print("Error: $e");
  }
}
