import 'package:flutter/material.dart';
import '../model/history_record.dart';

class HistoryViewModel extends ChangeNotifier {
  final List<HistoryRecord> _allRecords = [
    HistoryRecord(
      id: '1',
      date: DateTime(2024, 6, 20),
      summary: '치아 21번 초기 충치 의심',
      details: '왼쪽 위 앞니에 작은 검은 점이 관찰되었습니다.',
      thumbnailUrl: 'https://via.placeholder.com/100',
      imageUrl: 'https://via.placeholder.com/600',
    ),
    HistoryRecord(
      id: '2',
      date: DateTime(2024, 5, 15),
      summary: '잇몸 염증 소견',
      details: '잇몸이 붉게 부어오른 모습이 보입니다.',
      thumbnailUrl: 'https://via.placeholder.com/100',
      imageUrl: 'https://via.placeholder.com/600',
    ),
    HistoryRecord(
      id: '3',
      date: DateTime(2024, 4, 1),
      summary: '치아 착색 확인',
      details: '치아 표면에 갈색 착색이 다수 존재합니다.',
      thumbnailUrl: 'https://via.placeholder.com/100',
      imageUrl: 'https://via.placeholder.com/600',
    ),
  ];

  List<HistoryRecord> _filteredRecords = [];
  DateTime? _startDate;
  DateTime? _endDate;

  List<HistoryRecord> get records => _filteredRecords;

  HistoryViewModel() {
    _filteredRecords = List.from(_allRecords);
  }

  void search(String keyword) {
    _filteredRecords = _allRecords.where((record) {
      return record.summary.contains(keyword) || record.details.contains(keyword);
    }).toList();
    notifyListeners();
  }

  void filterByDate(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _filteredRecords = _allRecords.where((record) {
      final matchStart = start == null || record.date.isAfter(start.subtract(const Duration(days: 1)));
      final matchEnd = end == null || record.date.isBefore(end.add(const Duration(days: 1)));
      return matchStart && matchEnd;
    }).toList();
    notifyListeners();
  }

  void clearFilter() {
    _startDate = null;
    _endDate = null;
    _filteredRecords = List.from(_allRecords);
    notifyListeners();
  }

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
}
