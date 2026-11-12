import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../dorm_detail/dorm_detail_screen.dart';
import '../dorm_detail/review_list_screen.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: ReviewManager.updated,
      builder: (context, _, __) {
        // รวบรวมรีวิวทั้งหมดที่ผู้ใช้ ("นักศึกษา มฟล. (คุณ)") เขียนไว้จากทุกหอพัก
        final List myReviews = [];
        ReviewManager.dormReviews.forEach((dormName, reviews) {
          for (int i = 0; i < reviews.length; i++) {
            final review = reviews[i];
            if (review['user'].toString().contains('(คุณ)')) {
              myReviews.add({
                'dormName': dormName,
                'indexInDorm': i,
                'rating': review['rating'] ?? 5,
                'comment': review['comment'] ?? '',
              });
            }
          }
        });

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text('รีวิวของฉัน (${myReviews.length})'),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.textPrimary,
          ),
          body: myReviews.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_border, size: 64, color: AppColors.textSecondary),
                      SizedBox(height: 12),
                      Text('ยังไม่มีรีวิวของคุณ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('รีวิวที่คุณเขียนในหน้าหอพักจะแสดงที่นี่', style: TextStyle(color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: myReviews.length,
                  itemBuilder: (context, index) {
                    final item = myReviews[index];
                    final dormName = item['dormName'].toString();
                    final indexInDorm = item['indexInDorm'] as int;
                    final rating = item['rating'] as int;
                    final comment = item['comment'].toString();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFE0E7FF),
                          child: Icon(Icons.apartment, color: AppColors.primary),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                dormName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  i < rating ? Icons.star : Icons.star_border,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(comment),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error),
                          tooltip: 'ลบรีวิว',
                          onPressed: () {
                            ReviewManager.deleteReview(dormName, indexInDorm);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ลบรีวิวเรียบร้อยแล้ว'), duration: Duration(seconds: 1)),
                            );
                          },
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => DormDetailScreen(dormName: dormName)),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}