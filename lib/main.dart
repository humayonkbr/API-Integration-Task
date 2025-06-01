import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Carbaz API Demo',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> sliders = [];
  List<dynamic> latestCars = [];
  final baseUrl = 'https://carbaz.mamunuiux.com/';

  @override
  void initState() {
    super.initState();
    fetchRemoteData();
  }

  Future<void> fetchRemoteData() async {
    final response = await http.get(Uri.parse('${baseUrl}api'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        sliders = data['sliders'];
        latestCars = data['latest_cars'];
      });
    } else {
      debugPrint("Failed to load slider");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carbaz Viewer')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Slider',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: sliders.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : PageView.builder(
                      itemCount: sliders.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          baseUrl + sliders[index]['image'],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Latest Cars',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            latestCars.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: latestCars.length,
                    itemBuilder: (context, index) {
                      final car = latestCars[index];
                      return ListTile(
                        leading: Image.network(
                          baseUrl + car['thumb_image'],
                          width: 80,
                        ),
                        title: Text(car['title']),
                        subtitle: Text("Price: ${car['regular_price']}"),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
