import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../controllers/generate_qr_controller.dart';
import 'package:intl/intl.dart'; // Optional: untuk format tanggal

class GenerateQrView extends StatelessWidget {
  const GenerateQrView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GenerateQrController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Buat Tiket Baru"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // --- FORM INPUT ---
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200)
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nama Peserta", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        hintText: "Contoh: Budi Santoso",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // TOMBOL
                    Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value 
                            ? null 
                            : () => controller.createTicket(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("GENERATE TIKET & QR", 
                                style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 30),

            // --- HASIL QR CODE ---
            Obx(() {
              final ticket = controller.createdTicket.value;

              // Jika tiket belum jadi, sembunyikan area ini
              if (ticket == null) return const SizedBox.shrink();

              return Column(
                children: [
                  const Text("Tiket Berhasil Dibuat ✅", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                  const SizedBox(height: 15),
                  
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 5))
                      ],
                    ),
                    child: Column(
                      children: [
                        // Nama User
                        Text(ticket.name, 
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),

                        // QR CODE (Menggunakan Ticket ID)
                        QrImageView(
                          data: ticket.id, // ID dari API
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Detail ID
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Text("ID: ${ticket.id}", 
                            style: TextStyle(color: Colors.grey[700], fontFamily: "monospace")),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}