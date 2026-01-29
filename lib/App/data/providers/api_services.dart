import 'package:dio/dio.dart';
import 'package:qr_application/App/data/models/ticket.dart';
import 'package:qr_application/App/data/services/token_service.dart';

class ApiService {
  late Dio _dio;
  
  // Base URL API Anda
  final String baseUrl = "https://event-ticketing-ruddy.vercel.app/api";

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  

  // --- API ENDPOINTS ---

  // 1. Validasi Tiket (Scan)
  Future<Response> validateTicket(String uuid) async {
    try {
      // Tidak perlu kirim header manual, Interceptor yang kerjakan!
      return await _dio.post('/scan', data: {'qr_data': uuid});
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Ticket>> getTickets() async {
    final response = await _dio.get('/tickets');
    return (response.data as List).map((t) => Ticket.fromJson(t)).toList();
  }

  // Future<void> addTicket(String name) async {
  //   await _dio.post('/tickets', data: {'name': name});
  // }

  Future<Ticket> addTicket(String name) async {
    try {
      final response = await _dio.post(
        '/tickets', 
        data: {
          'name': name,
          'status': 'valid' // Default status sesuai API Anda
        }
      );
      
      // Mengubah JSON respon server menjadi object Ticket
      // Pastikan respon API Anda mengembalikan data tiket yang baru dibuat
      // Contoh asumsi response: { "id": "uuid-123", "name": "Budi", ... }
      // Jika response dibungkus data, gunakan: Ticket.fromJson(response.data['data'])
      return Ticket.fromJson(response.data); 
      
    } catch (e) {
      throw Exception('Gagal membuat tiket: $e');
    }
  }

  Future<void> deleteTicket(String id) async {
    await _dio.delete('/tickets', queryParameters: {'id': id});
  }
  
}