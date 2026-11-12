import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../dorm_detail/dorm_detail_screen.dart';
import 'filter_bottom_sheet.dart';
import 'map_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  static final List _allDorms = [
    {
      'name': 'หอพักสุขใจ 1',
      'distance': '300 ม. จาก ม.แม่ฟ้าหลวง',
      'price': '฿3,500 / เดือน',
      'image': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=600',
    },
    {
      'name': 'หอพักสุขใจ 2',
      'distance': '500 ม. จากหน้ามอ',
      'price': '฿4,200 / เดือน',
      'image': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=600',
    },
    {
      'name': 'หอพักสุขใจ 3',
      'distance': '800 ม. จาก ม.แม่ฟ้าหลวง',
      'price': '฿3,800 / เดือน',
      'image': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=600',
    },
    {
      'name': 'หอพักสุขใจ 4',
      'distance': '1.2 กม. จากตลาด',
      'price': '฿4,500 / เดือน',
      'image': 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?w=600',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDorms = _allDorms.where((dorm) {
      final name = dorm['name'].toString().toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        title: TextField(
          autofocus: true,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: const InputDecoration(
            hintText: 'ค้นหาชื่อหอพัก...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const FilterBottomSheet(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined, color: AppColors.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapScreen()),
            ),
          ),
        ],
      ),
      body: filteredDorms.isEmpty
          ? const Center(
              child: Text(
                'ไม่พบหอพักที่ค้นหา',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredDorms.length,
              itemBuilder: (context, index) {
                final dorm = filteredDorms[index];
                final name = dorm['name'].toString();
                final distance = dorm['distance'].toString();
                final price = dorm['price'].toString();
                final imageUrl = dorm['image'].toString();

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 60,
                          height: 60,
                          color: const Color(0xFFE2E8F0),
                          child: const Icon(Icons.apartment, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(distance, style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          price,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => DormDetailScreen(dormName: name)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}