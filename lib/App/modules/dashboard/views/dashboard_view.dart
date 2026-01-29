import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../scan/views/scan_view.dart';
import '../../ticket_list/views/ticket_list_view.dart';
import '../../generate_qr/views/generate_qr_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject Controller
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dashboard Admin", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => Text("Halo, ${controller.adminName}", 
              style: const TextStyle(fontSize: 12))),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => controller.logout(),
          )
        ],
      ),
      // FITUR PENTING: Pull to Refresh
      body: RefreshIndicator(
        onRefresh: () => controller.fetchDashboardData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Agar bisa di-refresh meski konten sedikit
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. STATISTIK CARD (REAL DATA) ---
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: LinearProgressIndicator());
                }
                return Row(
                  children: [
                    _buildStatCard(
                      "Total Tiket", 
                      "${controller.totalTickets.value}", 
                      Colors.blue.shade700,
                      Icons.confirmation_number
                    ),
                    const SizedBox(width: 15),
                    _buildStatCard(
                      "Sudah Scan", 
                      "${controller.scannedTickets.value}", 
                      Colors.green.shade600,
                      Icons.qr_code_scanner
                    ),
                  ],
                );
              }),
              
              const SizedBox(height: 30),
              const Text("Menu Utama", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              // --- 2. GRID MENU ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildMenuCard(
                    icon: Icons.qr_code_scanner,
                    title: "Scan Tiket",
                    color: Colors.blue,
                    onTap: () async {
                      // Saat kembali dari scan, update data dashboard otomatis
                      await Get.to(() => const ScanView());
                      controller.fetchDashboardData();
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.list_alt,
                    title: "List Tiket",
                    color: Colors.orange,
                    onTap: () async {
                      // Saat kembali dari list (mungkin ada yg dihapus), update data
                      await Get.to(() => const TicketListView());
                      controller.fetchDashboardData();
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.add_circle_outline,
                    title: "Buat Tiket",
                    color: Colors.purple,
                    onTap: () async {
                      // Saat kembali dari buat tiket, update data
                      await Get.to(() => const GenerateQrView());
                      controller.fetchDashboardData();
                    },
                  ),
                  _buildMenuCard(
                    icon: Icons.settings,
                    title: "Pengaturan",
                    color: Colors.grey,
                    onTap: () => Get.snackbar("Info", "Fitur belum tersedia"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.white70, size: 24),
                Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 1)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}