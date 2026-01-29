import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_application/App/data/providers/api_services.dart';
import '../../../data/models/ticket.dart'; // Import Model Ticket Anda

class GenerateQrController extends GetxController {
  final ApiService _apiService = ApiService();
  final textController = TextEditingController();
  
  var isLoading = false.obs;
  
  // Kita simpan Ticket object, bukan cuma string
  Rx<Ticket?> createdTicket = Rx<Ticket?>(null); 

  Future<void> createTicket() async {
    if (textController.text.isEmpty) {
      Get.snackbar("Error", "Nama harus diisi", 
        backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    FocusManager.instance.primaryFocus?.unfocus(); // Tutup keyboard

    try {
      // 1. Panggil API addTicket yang sudah diperbaiki
      final Ticket newTicket = await _apiService.addTicket(textController.text);
      
      // 2. Simpan hasilnya ke variable state
      createdTicket.value = newTicket;

      Get.snackbar("Sukses", "Tiket berhasil dibuat!", 
        backgroundColor: Colors.green, colorText: Colors.white);
      
      // Reset input text, tapi JANGAN reset createdTicket (biar QR tampil)
      textController.clear();

    } catch (e) {
      Get.snackbar("Gagal", "Error: ${e.toString()}", 
        backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}