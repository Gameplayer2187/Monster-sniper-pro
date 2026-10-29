import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MonsterApp());
}

class MonsterApp extends StatelessWidget {
  const MonsterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monster Sale Tracker',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SaleListPage(),
    );
  }
}

class SaleListPage extends StatefulWidget {
  const SaleListPage({super.key});

  @override
  State<SaleListPage> createState() => _SaleListPageState();
}

class _SaleListPageState extends State<SaleListPage> {
  List<dynamic> _offers = [];
  bool _isLoading = false;

  Future<void> fetchOffers() async {
    setState(() => _isLoading = true);
    try {
      // 10.0.2.2 ist die IP für den Android Emulator, um auf localhost zuzugreifen.
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/offers')); 
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() => _offers = data['offers']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Laden der Angebote: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ Monster Sale Tracker'),
        backgroundColor: Colors.green[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchOffers,
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Colors.green))
        : _offers.isEmpty 
          ? const Center(child: Text('Keine aktuellen Angebote gefunden.'))
          : ListView.builder(
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                final offer = _offers[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.local_offer, color: Colors.green),
                    title: Text(offer['store'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    trailing: Text(offer['price'], style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text('Gültig bis: ${offer['valid_until'] ?? 'Unbekannt'}'),
                  ),
                );
              },
            ),
    );
  }
}
