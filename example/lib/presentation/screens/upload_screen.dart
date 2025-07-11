import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadScreen extends StatefulWidget {
  final String userId;
  final String baseUrl;

  const UploadScreen({
    super.key,
    required this.userId,
    required this.baseUrl,
  });

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedImage;
  bool _loading = false;

  Future<void> _selectImage() async {
    print("🖼 이미지 선택창 열기");
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('갤러리에서 선택'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('카메라로 촬영'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      print("✅ 이미지 선택됨: ${pickedFile.path}");
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      print("⚠️ 이미지 선택 취소됨");
    }
  }

  Future<void> _submitDiagnosis() async {
    if (_selectedImage == null) {
      print("❗ 이미지가 선택되지 않았습니다.");
      return;
    }

    print("📤 진단 요청 시작");
    setState(() {
      _loading = true;
    });

    try {
      final uri = Uri.parse("${widget.baseUrl}/predict");
      final request = http.MultipartRequest('POST', uri);

      print("📁 선택된 이미지 경로: ${_selectedImage!.path}");
      request.files.add(await http.MultipartFile.fromPath('file', _selectedImage!.path));

      final response = await request.send();
      print("⏳ 서버 응답 대기 중...");
      final resBody = await response.stream.bytesToString();

      print("📥 서버 응답 수신 완료: $resBody");

      final decoded = json.decode(resBody);

      final originalUrl = decoded['original_url'];
      final masks = decoded['masks'] ?? {};

      final diseaseMaskUrl = masks['disease_model'];
      final hygieneMaskUrl = masks['hygiene_model'];
      final toothNumberMaskUrl = masks['tooth_number_model'];

      print("🖼 originalUrl: $originalUrl");
      print("🧪 diseaseMaskUrl: $diseaseMaskUrl");
      print("🧪 hygieneMaskUrl: $hygieneMaskUrl");
      print("🧪 toothNumberMaskUrl: $toothNumberMaskUrl");

      if ([originalUrl, diseaseMaskUrl, hygieneMaskUrl, toothNumberMaskUrl].contains(null)) {
        throw Exception("서버 응답 오류: 하나 이상의 이미지 URL이 없습니다.");
      }

      print("✅ 진단 결과 페이지로 이동");
      context.push('/result', extra: {
        'originalUrl': originalUrl,
        'diseaseMaskUrl': diseaseMaskUrl,
        'hygieneMaskUrl': hygieneMaskUrl,
        'toothNumberMaskUrl': toothNumberMaskUrl,
      });
    } catch (e) {
      print("❌ 진단 요청 중 에러 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("진단 요청 실패: $e")),
      );
    } finally {
      setState(() {
        _loading = false;
      });
      print("🔁 로딩 상태 종료");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 진단'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          //onPressed: () => context.go('/home'),
          onPressed: () => context.pop(), // 기존: context.go('/home') ❌
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('진단할 사진을 업로드하세요', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_selectedImage!, width: 220, height: 220, fit: BoxFit.cover),
                    )
                  : const Text('선택된 이미지 없음', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _selectImage,
                icon: const Icon(Icons.image),
                label: const Text('+ 사진 선택'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: (_selectedImage != null && !_loading) ? _submitDiagnosis : null,
                icon: const Icon(Icons.send),
                label: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('제출'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
