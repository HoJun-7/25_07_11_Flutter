import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ClinicsMapScreen extends StatelessWidget {
  const ClinicsMapScreen({super.key});

  List<Map<String, dynamic>> get clinicData => [
        {
          'name': '서울 스마일 치과',
          'lat': 37.5665,
          'lng': 126.9780,
        },
        {
          'name': '강남 화이트 치과',
          'lat': 37.4979,
          'lng': 127.0276,
        },
        {
          'name': '홍대 예쁨 치과',
          'lat': 37.5575,
          'lng': 126.9238,
        },
      ];

  @override
  Widget build(BuildContext context) {
    final markers = clinicData.map((clinic) {
      return Marker(
        width: 60,
        height: 60,
        point: LatLng(clinic['lat'], clinic['lng']),
        child: Tooltip(
          message: clinic['name'],
          child: const Icon(Icons.location_on, color: Colors.red, size: 36),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("주변 치과 지도 보기"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FlutterMap(
        options: const MapOptions(
          center: LatLng(37.5665, 126.9780),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.toothapp',
          ),
          MarkerLayer(markers: markers), // ✅ 마커는 여기서 직접 사용 가능
        ],
      ),
    );
  }
}
