import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_application/App/data/providers/api_services.dart';
import '../../../data/models/ticket.dart';
import '../../../data/services/token_service.dart';
import '../../login/views/login_view.dart';

class DashboardController extends GetxController {
  final ApiService _apiService = ApiService();

  // --- STATE (Data Real) ---
  var isLoading = true.obs;
  var totalTickets = 0.obs;    // Total semua tiket
  var scannedTickets = 0.obs;  // Tiket yang statusnya 'redeemed'
  var adminName = "Admin".obs; // Bisa diambil dari SharedPrefs jika ada

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); // Ambil data saat dashboard dibuka
  }

  // --- LOGIC MENGAMBIL DATA ---
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      
      // 1. Panggil API getTickets
      final List<Ticket> tickets = await _apiService.getTickets();
      
      // 2. Hitung Statistik
      totalTickets.value = tickets.length;
      
      // Hitung yang statusnya 'redeemed' (huruf kecil/besar tidak masalah)
      scannedTickets.value = tickets.where((t) => 
        t.status.toLowerCase() == 'redeemed'
      ).length;

    } catch (e) {
      print("Error fetch dashboard: $e");
      // Opsional: Tampilkan snackbar jika gagal koneksi
    } finally {
      isLoading.value = false;
    }
  }

  // --- LOGOUT ---
  void logout() async {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Apakah Anda yakin ingin keluar?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () async {
        await TokenService.removeToken();
        Get.offAll(() => const LoginView());
      }
    );
  }
}