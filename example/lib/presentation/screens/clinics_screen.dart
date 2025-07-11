import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClinicsScreen extends StatefulWidget {
  const ClinicsScreen({super.key});

  @override
  State<ClinicsScreen> createState() => _ClinicsScreenState();
}

class _ClinicsScreenState extends State<ClinicsScreen> {
  String _sortOption = '거리순';

  final List<Map<String, String>> _clinics = [
    {
      'name': '서울 밝은 치과',
      'distance': '300m',
      'rating': '4.8',
    },
    {
      'name': '연세 치과',
      'distance': '700m',
      'rating': '4.5',
    },
    {
      'name': '예쁜 미소 치과',
      'distance': '1.2km',
      'rating': '4.9',
    },
  ];

  void _sortClinics(String option) {
    setState(() {
      _sortOption = option;
      if (option == '거리순') {
        _clinics.sort((a, b) => a['distance']!.compareTo(b['distance']!));
      } else if (option == '인기순') {
        _clinics.sort((b, a) => a['rating']!.compareTo(b['rating']!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주변 치과'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            tooltip: '지도로 보기',
            onPressed: () {
              context.push('/clinics/map');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _sortClinics('거리순'),
                    icon: const Icon(Icons.directions_walk),
                    label: const Text('거리순'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _sortOption == '거리순'
                          ? Colors.blue
                          : Colors.grey.shade300,
                      foregroundColor:
                          _sortOption == '거리순' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _sortClinics('인기순'),
                    icon: const Icon(Icons.star),
                    label: const Text('인기순'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _sortOption == '인기순'
                          ? Colors.blue
                          : Colors.grey.shade300,
                      foregroundColor:
                          _sortOption == '인기순' ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _clinics.length,
              itemBuilder: (context, index) {
                final clinic = _clinics[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.local_hospital, size: 40),
                    title: Text(clinic['name'] ?? ''),
                    subtitle: Text(
                        '거리: ${clinic['distance']}, 평점: ${clinic['rating']}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: 상세 페이지 연결
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
