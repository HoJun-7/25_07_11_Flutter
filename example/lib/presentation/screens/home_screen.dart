import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // kIsWeb 임포트

class HomeScreen extends StatelessWidget {
  final String baseUrl; // baseUrl 매개번수 추가
  final String userId;   // userId 매개번수 추가

  const HomeScreen({
    super.key,
    required this.baseUrl, // 생성자에 baseUrl 추가
    required this.userId,   // 생성자에 userId 추가
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MediTooth', // 앱 이름으로 변경 또는 더 멋있는 제목
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // 앱바 제목 색상
          ),
        ),
        centerTitle: true, // 제목을 중앙에 배치
        backgroundColor: Theme.of(context).primaryColor, // 앱바 배경색
        elevation: 0, // 앱바 그림자 제거
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white), // 아이콘 색상
            onPressed: () => context.push('/mypage'), // 마이페이지로 이동
          ),
        ],
      ),
      body: Container(
        // 전체 배경색 또는 그래데이션 추가
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8), // 상단은 주 색상
              Colors.white, // 하단은 흔색
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView( // 내용이 많아지는 경우 스크롤 가능하도록
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch, // 버튼 노블의 너비를 최대로 확장
              children: [
                Column(
                  children: [
                    const Icon(Icons.health_and_safety, size: 80, color: Colors.white), // 임시 아이콘
                    const SizedBox(height: 10),
                    const Text(
                      '건강한 치아, MediTooth와 함께!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),

                _buildActionButton(
                  context,
                  label: '사진으로 예측하기',
                  icon: Icons.photo_camera,
                  onPressed: () => context.push(
                    '/upload',
                    extra: {
                      'baseUrl': baseUrl,
                      'userId': userId,
                    },
                  ),
                  buttonColor: Colors.blueAccent, // 버튼 색상 변경
                ),
                const SizedBox(height: 20),

                Tooltip(
                  message: kIsWeb ? '웹에서는 이용할 수 없습니다.' : '',
                  triggerMode: kIsWeb ? TooltipTriggerMode.longPress : TooltipTriggerMode.manual,
                  child: _buildActionButton(
                    context,
                    label: '실시간 예측하기',
                    icon: Icons.videocam,
                    onPressed: kIsWeb
                      ? null
                      : () => context.push(
                        '/diagnosis/realtime',
                        extra: {
                          'baseUrl': baseUrl,
                          'userId': userId,
                        },
                      ),
                    buttonColor: kIsWeb ? Colors.grey[400]! : Colors.greenAccent,
                    textColor: kIsWeb ? Colors.black54 : Colors.white,
                    iconColor: kIsWeb ? Colors.black54 : Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                _buildActionButton(
                  context,
                  label: '이전결과 보기',
                  icon: Icons.history,
                  onPressed: () => context.push('/history'),
                  buttonColor: Colors.orangeAccent, // 버튼 색상 변경
                ),
                const SizedBox(height: 20),

                _buildActionButton(
                  context,
                  label: '주변 치과',
                  icon: Icons.local_hospital, // 병원 관련 아이콘
                  onPressed: () => context.push('/clinics'),
                  buttonColor: Colors.purpleAccent, // 새로운 버튼 색상
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    required Color buttonColor,
    Color textColor = Colors.white, // 기본 텍스트 색상
    Color iconColor = Colors.white, // 기본 아이콘 색상
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28, color: iconColor),
      label: Text(
        label,
        style: TextStyle(fontSize: 20, color: textColor),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8, // 그림자 효과 강화
        shadowColor: buttonColor.withOpacity(0.5), // 그림자 색상
      ),
    );
  }
}
