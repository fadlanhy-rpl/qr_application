import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Jangan lupa: flutter pub add intl
import '../controllers/ticket_list_controller.dart';
import '../../../data/models/ticket.dart';

class TicketListView extends StatelessWidget {
  const TicketListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TicketListController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manajemen Tiket"),
        centerTitle: true,
      ),
      // Tombol Tambah di Pojok Kanan Bawah
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, controller),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchTickets(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.ticketList.isEmpty) {
            return ListView(
              children: const [
                SizedBox(height: 100),
                Center(child: Text("Belum ada tiket. Buat baru yuk!")),
              ],
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.ticketList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final ticket = controller.ticketList[index];
              return _buildTicketCard(ticket, controller);
            },
          );
        }),
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket, TicketListController controller) {
    // Format Tanggal (Opsional, perlu package intl)
    final dateString = DateFormat('dd MMM yyyy, HH:mm').format(ticket.createdAt);
    final isRedeemed = ticket.status.toLowerCase() == 'redeemed';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isRedeemed ? Colors.grey.shade300 : Colors.blue.shade100,
          child: Icon(
            isRedeemed ? Icons.check : Icons.confirmation_number,
            color: isRedeemed ? Colors.grey : Colors.blue,
          ),
        ),
        title: Text(ticket.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("Dibuat: $dateString", style: const TextStyle(fontSize: 12)),
            Text(
              isRedeemed ? "Sudah Dipakai" : "Belum Dipakai",
              style: TextStyle(
                color: isRedeemed ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 12
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            // Konfirmasi Hapus
            Get.defaultDialog(
              title: "Hapus Tiket?",
              middleText: "Tiket '${ticket.name}' akan dihapus permanen.",
              textConfirm: "Hapus",
              textCancel: "Batal",
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () {
                Get.back(); // Tutup dialog
                controller.deleteTicket(ticket.id);
              }
            );
          },
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext context, TicketListController controller) {
    final TextEditingController nameC = TextEditingController();
    
    Get.defaultDialog(
      title: "Buat Tiket Baru",
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: nameC,
          decoration: const InputDecoration(
            labelText: "Nama Peserta",
            border: OutlineInputBorder(),
            hintText: "Contoh: Budi Santoso"
          ),
        ),
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      onConfirm: () => controller.addTicket(nameC.text),
    );
  }
}