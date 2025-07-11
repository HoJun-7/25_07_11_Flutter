import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String baseUrl;
  final String imageUrl;
  final Map<String, dynamic> inferenceData;

  const ResultScreen({
    super.key,
    required this.baseUrl,
    required this.imageUrl,
    required this.inferenceData,
  });

  @override
  Widget build(BuildContext context) {
    final fullImageUrl = '$baseUrl$imageUrl';
    final prediction = inferenceData['prediction'] ?? '결과 없음';
    final List<dynamic> details = inferenceData['details'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 결과'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // ⬅️ UploadScreen으로 돌아감
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                fullImageUrl,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Text("이미지를 불러올 수 없습니다."),
              ),
            ),
            const SizedBox(height: 24),
            Text('🧠 AI 예측 결과:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(prediction, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('🔍 세부 진단:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            ...details.map((item) => Text('- $item')).toList(),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.upload),
              label: const Text('다시 업로드하기'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
