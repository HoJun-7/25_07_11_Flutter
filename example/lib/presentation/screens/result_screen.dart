import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ResultScreen extends StatefulWidget {
  final String originalUrl;
  final String diseaseMaskUrl;
  final String hygieneMaskUrl;
  final String toothNumberMaskUrl;

  const ResultScreen({
    super.key,
    required this.originalUrl,
    required this.diseaseMaskUrl,
    required this.hygieneMaskUrl,
    required this.toothNumberMaskUrl,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showDisease = true;
  bool _showHygiene = true;
  bool _showToothNumber = true;

  static const double imageHeight = 250.0;

  Widget _buildOverlayCard(String label, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Future<void> _saveImage(String? url, String label) async {
    if (url == null || url.isEmpty) {
      print("⚠️ [$label] 저장 요청된 URL이 비어 있음");
      return;
    }

    try {
      print("📥 [$label] 저장 요청됨 (기능 비활성화 상태)");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label 이미지 저장 기능이 비활성화되어 있습니다.')),
      );
    } catch (e) {
      print('❌ [$label] 저장 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 저장 실패: $label')),
        );
      }
    }
  }

  Widget _buildCachedNetworkImage(String label, String? url, {bool overlay = false}) {
    if (url == null || url.isEmpty) {
      print("⚠️ [$label] URL 없음 → 표시 생략");
      return const SizedBox();
    }

    print("🌐 [$label] 이미지 로딩 시도: $url");
    return Opacity(
      opacity: overlay ? 0.5 : 1.0,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: imageHeight,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Container(
          width: double.infinity,
          height: imageHeight,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('진단 결과'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/upload'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '진단 요약',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '치아 21번에 충치 가능성이 의심됩니다.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        _buildOverlayCard("충치/치주염/치은염", _showDisease, (val) => setState(() => _showDisease = val)),
                        const SizedBox(height: 8),
                        _buildOverlayCard("치석/보철물", _showHygiene, (val) => setState(() => _showHygiene = val)),
                        const SizedBox(height: 8),
                        _buildOverlayCard("치아번호", _showToothNumber, (val) => setState(() => _showToothNumber = val)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildCachedNetworkImage("원본 이미지", widget.originalUrl),
                    if (_showDisease) _buildCachedNetworkImage("충치 마스크", widget.diseaseMaskUrl, overlay: true),
                    if (_showHygiene) _buildCachedNetworkImage("치석 마스크", widget.hygieneMaskUrl, overlay: true),
                    if (_showToothNumber) _buildCachedNetworkImage("치아번호 마스크", widget.toothNumberMaskUrl, overlay: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _saveImage(widget.diseaseMaskUrl, "진단 결과"),
              icon: const Icon(Icons.download),
              label: const Text('진단 결과 이미지 저장'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => _saveImage(widget.originalUrl, "원본"),
              icon: const Icon(Icons.image),
              label: const Text('원본 이미지 저장'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => print('🩺 AI 예측 기반 비대면 진단 신청'),
              icon: const Icon(Icons.medical_services),
              label: const Text('AI 예측 기반 비대면 진단 신청'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
