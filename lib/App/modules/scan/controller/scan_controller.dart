import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dio/dio.dart';
import 'package:qr_application/App/data/providers/api_services.dart'; // Import Dio untuk error handling

class ScanController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final MobileScannerController scannerController = MobileScannerController();
  
  bool isLoading = false;
  bool isSuccess = false;
  String? errorMessage;

  // Fungsi yang dipanggil saat QR terdeteksi
  Future<void> onDetect(BarcodeCapture capture) async {
    // 1. Ambil data QR
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    
    final String? code = barcodes.last.rawValue;
    if (code == null || isLoading) return; // Cegah scan ganda saat loading

    // 2. Mulai Loading & Pause Kamera
    isLoading = true;
    notifyListeners(); // Update UI jadi loading
    
    // Stop scanning sementara agar tidak scan berulang-ulang
    scannerController.stop(); 

    try {
      print("🔍 QR Terdeteksi: $code");
      
      // 3. Kirim ke API
      final response = await _apiService.validateTicket(code);
      
      // 4. Sukses
      print("✅ Validasi Sukses: ${response.data}");
      isSuccess = true;
      errorMessage = null;
      
    } on DioException catch (e) {
      // 5. Gagal (Error dari API)
      print("❌ Validasi Gagal: ${e.response?.data}");
      isSuccess = false;
      errorMessage = e.response?.data['message'] ?? "Tiket tidak valid atau error koneksi.";
    } catch (e) {
      // Error lain
      isSuccess = false;
      errorMessage = "Terjadi kesalahan sistem.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk reset dan scan lagi
  void resetScan() {
    isSuccess = false;
    errorMessage = null;
    isLoading = false;
    scannerController.start(); // Nyalakan kamera lagi
    notifyListeners();
  }
}