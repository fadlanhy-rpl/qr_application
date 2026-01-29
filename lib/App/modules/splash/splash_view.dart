import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Pastikan sudah install GetX
import 'package:qr_application/App/modules/dashboard/views/dashboard_view.dart';
import 'package:qr_application/App/modules/login/views/login_view.dart';
import '../../data/services/token_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    // Tunggu 2 detik biar logo terlihat
    await Future.delayed(const Duration(seconds: 2));

    final token = await TokenService.getToken();

    if (token != null) {
      // Jika ada token, langsung ke Dashboard/Scan
      Get.offAll(() => const DashboardView());
    } else {
      // Jika tidak ada token, lempar ke Login
      Get.offAll(() => const LoginView()); 
      
      // SEMENTARA ke ScanView dulu sampai Login jadi
      // Get.offAll(() => const ScanView());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Ganti warna brand
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "QR EVENT SCANNER",
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}