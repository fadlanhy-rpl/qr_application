import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_application/App/modules/scan/controller/scan_controller.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  // Panggil Controller
  final ScanController controller = ScanController();

  @override
  void initState() {
    super.initState();
    // Dengarkan perubahan state controller untuk update UI
    controller.addListener(() {
      if (mounted) setState(() {});

      // Jika selesai loading (baik sukses atau gagal), tampilkan Dialog hasil
      if (!controller.isLoading &&
          (controller.isSuccess || controller.errorMessage != null)) {
        _showResultDialog();
      }
    });
  }

  // Fungsi Menampilkan Popup Hasil
  void _showResultDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Status
              Icon(
                controller.isSuccess ? Icons.check_circle : Icons.error,
                color: controller.isSuccess ? Colors.green : Colors.red,
                size: 80,
              ),
              const SizedBox(height: 16),

              // Text Judul
              Text(
                controller.isSuccess ? "Scan Berhasil!" : "Gagal!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Pesan Error / Sukses
              Text(
                controller.errorMessage ?? "Tiket Valid. Silakan Masuk.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Tombol Scan Lagi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Tutup Dialog
                    controller.resetScan(); // Mulai scan lagi
                  },
                  child: const Text(
                    "Scan Lagi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Tiket QR"),
        centerTitle: true,
        backgroundColor: Colors.transparent, // Transparan agar terlihat modern
        elevation: 0,
        actions: [
          // Tombol Flash / Senter
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: controller.scannerController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            onPressed: () => controller.scannerController.toggleTorch(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true, // Agar kamera full screen sampai atas
      body: Stack(
        children: [
          // 1. Layar Kamera
          MobileScanner(
            controller: controller.scannerController,
            onDetect: controller.onDetect,
          ),

          // 2. Overlay Kotak Fokus (Agar user tau harus scan di mana)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // 3. Loading Indicator (Jika sedang proses API)
          if (controller.isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
