class HistoryRecord {
  final String id;
  final DateTime date;
  final String summary;
  final String details;
  final String thumbnailUrl;
  final String imageUrl;

  HistoryRecord({
    required this.id,
    required this.date,
    required this.summary,
    required this.details,
    required this.thumbnailUrl,
    required this.imageUrl,
  });

  // ✅ fromJson 생성자 추가 (선택사항: JSON 파싱용)
  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      summary: json['summary'] ?? '',
      details: json['details'] ?? '',
      thumbnailUrl: json['thumbnailUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
