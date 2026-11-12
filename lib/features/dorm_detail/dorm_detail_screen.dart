import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../favorite_chat/chat_room_screen.dart';
import '../favorite_chat/favorite_screen.dart';
import '../home/map_screen.dart';
import 'photo_gallery_screen.dart';
import 'review_list_screen.dart';

class DormDetailScreen extends StatelessWidget {
  final String dormName;
  const DormDetailScreen({super.key, this.dormName = 'หอพักสุขใจ 1'});

  @override
  Widget build(BuildContext context) {
    final dormData = MapScreen.mapDorms.firstWhere(
      (d) => d['name'] == dormName,
      orElse: () => MapScreen.mapDorms.first,
    );

    final coverImage = dormData['image'].toString();
    final locationText = dormData['location'].toString();
    final rawPrice = dormData['price'].toString().split(' ').first;
    final priceText = '฿$rawPrice / เดือน';
    final miniTop = (dormData['miniTop'] as double?) ?? 35.0;
    final miniLeft = (dormData['miniLeft'] as double?) ?? 115.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(dormName),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        actions: [
          ValueListenableBuilder<List>(
            valueListenable: FavoriteManager.savedDorms,
            builder: (context, savedList, _) {
              final isFavorite = FavoriteManager.isFavorite(dormName);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.error : null,
                ),
                onPressed: () {
                  FavoriteManager.toggleFavorite(dormName, priceText);
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(!isFavorite ? 'บันทึก "$dormName" แล้ว' : 'นำ "$dormName" ออกจากรายการโปรด'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PhotoGalleryScreen())),
              child: SizedBox(
                height: 220,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      coverImage,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: const Color(0xFFCBD5E1)),
                    ),
                    Container(color: Colors.black.withOpacity(0.35)),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_library, size: 48, color: Colors.white),
                        SizedBox(height: 8),
                        Text('แตะเพื่อดูรูปภาพทั้งหมด', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dormName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('฿$rawPrice/ด.', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('ค่าน้ำ 18 บาท/หน่วย • ค่าไฟ 7 บาท/หน่วย', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 20),

                  // การ์ดแผนที่ย่อ + ปุ่ม View on map
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MapScreen(initialDormName: dormName)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 115,
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  color: const Color(0xFFE9ECEF),
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: CustomPaint(painter: _MiniMapPainter()),
                                ),
                                Positioned(
                                  top: miniTop,
                                  left: miniLeft,
                                  child: const Icon(Icons.location_on, color: Color(0xFFD9480F), size: 32),
                                ),
                                Positioned(
                                  top: 34,
                                  right: 45,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(color: Color(0xFF1E293B), shape: BoxShape.circle),
                                        child: const Icon(Icons.school, color: Colors.white, size: 12),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('MFU', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined, color: Color(0xFFD9480F), size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    locationText,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                                  ),
                                ),
                                const Text(
                                  'View on map ›',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 32),
                  const Text('สิ่งอำนวยความสะดวก', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Wrap(
                    spacing: 8,
                    children: [
                      Chip(label: Text('เครื่องปรับอากาศ')),
                      Chip(label: Text('Wi-Fi ฟรี')),
                      Chip(label: Text('ที่จอดรถ')),
                      Chip(label: Text('กล้องวงจรปิด')),
                    ],
                  ),
                  const Divider(height: 32),

                  // หัวข้อรีวิวที่อัปเดตจำนวนอัตโนมัติและส่งชื่อหอพักไปหน้ารายการรีวิว
                  ValueListenableBuilder<int>(
                    valueListenable: ReviewManager.updated,
                    builder: (context, _, __) {
                      final reviewCount = ReviewManager.getReviews(dormName).length;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'รีวิวจากผู้พักอาศัย ($reviewCount รีวิว · 4.5 ★)',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Text('ดูทั้งหมด >', style: TextStyle(color: AppColors.primary)),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ReviewListScreen(dormName: dormName)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomScreen(dormName: dormName))),
                icon: const Icon(Icons.chat),
                label: const Text('แชทสอบถาม'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: Colors.white),
                label: const Text('โทรติดต่อ', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final greenPaint = Paint()..color = const Color(0xFFD8E8D3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-10, 18, 120, 75), const Radius.circular(12)),
      greenPaint,
    );

    final waterPaint = Paint()..color = const Color(0xFFCDE1F5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(size.width * 0.72, -15, 110, 55), const Radius.circular(24)),
      waterPaint,
    );

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 62), Offset(size.width, 48), roadPaint);
    canvas.drawLine(Offset(size.width * 0.62, 0), Offset(size.width * 0.62, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}