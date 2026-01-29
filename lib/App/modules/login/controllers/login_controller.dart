import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_application/App/data/services/token_service.dart';
import 'package:qr_application/App/modules/dashboard/views/dashboard_view.dart';

class LoginController extends GetxController {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  
  var isLoading = false.obs;
  var isObscure = true.obs;

  // Data Dummy User (Bisa ditambah)
  final String _dummyEmail = "admin@smk.id";
  final String _dummyPass = "12345678";

  Future<void> login() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      Get.snackbar("Error", "Email dan Password harus diisi", 
        backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    // Simulasi delay network (biar terlihat seperti loading beneran)
    await Future.delayed(const Duration(seconds: 2));

    try {
      // LOGIKA LOGIN LOKAL
      // Kita cek apakah input sama dengan dummy user ATAU input dari register lokal
      // (Untuk simpelnya, kita izinkan admin default ini)
      if (emailC.text == _dummyEmail && passwordC.text == _dummyPass) {
        
        // 1. Simpan Dummy Token
        await TokenService.saveToken("DUMMY_TOKEN_LOKAL_123");
        
        // 2. Masuk ke App
        Get.offAll(() => const DashboardView());
        Get.snackbar("Sukses", "Login Lokal Berhasil!", 
          backgroundColor: Colors.green, colorText: Colors.white);
          
      } else {
        throw "Email atau Password salah! (Coba: $_dummyEmail / $_dummyPass)";
      }
    } catch (e) {
      Get.snackbar("Gagal Login", e.toString(),
        backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}