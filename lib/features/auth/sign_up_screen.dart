import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../navigation/main_nav_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _role = 'ผู้เช่า (Tenant)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, foregroundColor: AppColors.textPrimary),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Sign Up', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              // เลือกประเภทผู้ใช้ตามแถบด้านบนใน Figma
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'ผู้เช่า (Tenant)', label: Text('ผู้เช่า')),
                  ButtonSegment(value: 'เจ้าของหอ (Owner)', label: Text('เจ้าของหอ')),
                ],
                selected: {_role},
                onSelectionChanged: (val) => setState(() => _role = val.first),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่อ - นามสกุล', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => v!.isEmpty ? 'กรุณากรอกชื่อ-นามสกุล' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(labelText: 'อีเมล', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => !v!.contains('@') ? 'รูปแบบอีเมลไม่ถูกต้อง' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                decoration: InputDecoration(labelText: 'เบอร์โทรศัพท์', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => v!.length < 9 ? 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'รหัสผ่าน', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                validator: (v) => v!.length < 6 ? 'รหัสผ่านต้องมีอย่างน้อย 6 ตัว' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainNavScreen()), (route) => false);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}