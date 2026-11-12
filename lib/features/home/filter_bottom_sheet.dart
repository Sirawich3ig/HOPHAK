import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _priceRange = const RangeValues(2500, 6000);
  bool _hasWifi = true;
  bool _hasAirCon = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('ตัวกรองการค้นหา (Filter)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Text('ช่วงราคา: ฿${_priceRange.start.round()} - ฿${_priceRange.end.round()}'),
          RangeSlider(
            values: _priceRange,
            min: 1500,
            max: 15000,
            divisions: 27,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _priceRange = val),
          ),
          SwitchListTile(
            title: const Text('เครื่องปรับอากาศ (แอร์)'),
            value: _hasAirCon,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _hasAirCon = val),
          ),
          SwitchListTile(
            title: const Text('อินเทอร์เน็ต Wi-Fi ฟรี'),
            value: _hasWifi,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _hasWifi = val),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('แสดงผลลัพธ์', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}