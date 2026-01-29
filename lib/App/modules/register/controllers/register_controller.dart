import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../login/views/login_view.dart';

class RegisterController extends GetxController {
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  var isLoading = false.obs;
  var isObscure = true.obs;
  var isObscureConfirm = true.obs;

  Future<void> register() async {
    if (nameC.text.isEmpty || emailC.text.isEmpty || passwordC.text.isEmpty) {
      Get.snackbar("Error", "Semua kolom harus diisi",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (passwordC.text != confirmPasswordC.text) {
      Get.snackbar("Error", "Password tidak cocok",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    
    // Simulasi delay
    await Future.delayed(const Duration(seconds: 2));

    // Karena ini lokal, kita anggap sukses saja
    // (Di real app, data ini disimpan ke SQLite/Local DB)
    
    isLoading.value = false;
    
    Get.snackbar("Sukses", "Akun Local Berhasil Dibuat. Silakan Login dengan akun admin.",
        backgroundColor: Colors.green, colorText: Colors.white);

    // Balik ke Login
    Get.offAll(() => const LoginView());
  }
}