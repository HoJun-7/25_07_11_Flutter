import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatelessWidget {
  final String date;
  final String summary;
  final String details;
  final String imageUrl; // 진단 이미지 URL

  const HistoryDetailScreen({
    super.key,
    required this.date,
    required this.summary,
    required this.details,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 내역 상세'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ 진단 정보 카드
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '진단 날짜: $date',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text('요약: $summary', style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 6),
                      Text('상세 내용: $details', style: const TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ✅ 이미지 영역
              const Text(
                '진단 이미지',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ✅ 이미지 전체 너비 + 에러 시 대체 이미지
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 240,
                  color: Colors.grey[200],
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: double.infinity,
                          height: 240,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(Icons.broken_image, size: 60, color: Colors.grey[600]),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.broken_image, size: 60, color: Colors.grey[600]),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
