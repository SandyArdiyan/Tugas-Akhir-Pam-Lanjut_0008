import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  bool _isLoading = false;
  Position? _currentPosition;

  // 1. Fungsi SENSOR: Membaca GPS Device
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'GPS di HP kamu sedang mati. Tolong nyalakan dulu!';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak permanen. Buka pengaturan HP.';
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
      setState(() {
        _currentPosition = position;
      });
      
      _openMapsForLibraries(position.latitude, position.longitude);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 2. Fungsi MAPS: Membuka Google Maps mencari Perpustakaan terdekat
  Future<void> _openMapsForLibraries(double lat, double lng) async {
    // URL ini otomatis membuka aplikasi Google Maps dan mencari "Perpustakaan terdekat" dari titik koordinat GPS
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/perpustakaan+terdekat/@$lat,$lng,15z');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka Google Maps.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Terdekat'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.map_outlined, size: 100, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Temukan Sumber Literasi Fisik',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'PustakaSiswa akan menggunakan sensor GPS untuk melacak lokasi Anda saat ini dan menampilkan perpustakaan terdekat melalui Google Maps.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Lacak Lokasi Saya Sekarang', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
              if (_currentPosition != null) ...[
                const SizedBox(height: 20),
                Text(
                  'Koordinat Terakhir:\nLat: ${_currentPosition!.latitude}\nLng: ${_currentPosition!.longitude}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}