import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_application/App/data/providers/api_services.dart';
import '../../../data/models/ticket.dart';

class TicketListController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // State
  var isLoading = true.obs;
  var ticketList = <Ticket>[].obs; // Menggunakan model Ticket Anda

  @override
  void onInit() {
    super.onInit();
    fetchTickets();
  }

  // --- 1. GET TICKETS ---
  Future<void> fetchTickets() async {
    try {
      isLoading.value = true;
      // Memanggil fungsi yang sudah Anda buat di ApiService
      final tickets = await _apiService.getTickets();
      ticketList.assignAll(tickets);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat tiket: ${e.toString()}", 
        backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. ADD TICKET ---
  Future<void> addTicket(String name) async {
    if (name.isEmpty) return;
    
    Get.back(); // Tutup dialog
    isLoading.value = true; // Tampilkan loading

    try {
      await _apiService.addTicket(name); // Pastikan fungsi ini ada di ApiService
      Get.snackbar("Sukses", "Tiket berhasil dibuat", backgroundColor: Colors.green, colorText: Colors.white);
      fetchTickets(); // Refresh list otomatis
    } catch (e) {
      Get.snackbar("Gagal", "Tidak bisa membuat tiket: ${e.toString()}", backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // --- 3. DELETE TICKET ---
  Future<void> deleteTicket(String id) async {
    try {
      // Optimistic Update: Hapus dulu dari layar biar terasa cepat
      ticketList.removeWhere((t) => t.id == id);
      
      await _apiService.deleteTicket(id); // Request hapus ke server
      
      Get.snackbar("Terhapus", "Tiket berhasil dihapus", 
        duration: const Duration(seconds: 1), backgroundColor: Colors.black54, colorText: Colors.white);
    } catch (e) {
      // Jika gagal, balikin lagi datanya (Rollback)
      fetchTickets(); 
      Get.snackbar("Gagal", "Gagal menghapus: ${e.toString()}", backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}