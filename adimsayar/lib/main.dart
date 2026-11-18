import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const AdimSayarApp());
}

class AdimSayarApp extends StatelessWidget {
  const AdimSayarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const AdimSayarEkrani(),
    );
  }
}

class AdimSayarEkrani extends StatefulWidget {
  const AdimSayarEkrani({super.key});

  @override
  State<AdimSayarEkrani> createState() => _AdimSayarEkraniState();
}

class _AdimSayarEkraniState extends State<AdimSayarEkrani> {
  String _adimSayisi = '0';
  String _durum = 'Bekleniyor...';

  @override
  void initState() {
    super.initState();
    _izinVeSensorBaslat();
  }

  Future<void> _izinVeSensorBaslat() async {
    var durum = await Permission.activityRecognition.request();
    if (durum.isGranted) {
      Pedometer.stepCountStream.listen(
        (StepCount event) {
          setState(() {
            _adimSayisi = event.steps.toString();
            _durum = 'Yürüyüş Algılanıyor';
          });
        },
        onError: (error) {
          setState(() {
            _durum = 'Sensör Hatası: $error';
          });
        },
      );
    } else {
      setState(() {
        _durum = 'Fiziksel aktivite izni verilmedi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adım Takip Uygulaması')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_walk, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            const Text('Atılan Adım', style: TextStyle(fontSize: 22)),
            Text(
              _adimSayisi,
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(_durum, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
