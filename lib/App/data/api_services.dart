import 'package:dio/dio.dart';

class ApiService {
  // Setup dasar Dio tanpa Interceptor Token
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://event-ticketing-ruddy.vercel.app/api",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // // --- EVENTS (Daftar Acara) ---
  // Future<Response> getEvents() async {
  //   try {
  //     final response = await _dio.get('/events');
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // --- SCAN QR (Validasi Tiket) ---
  Future<Response> validateTicket(String uuid) async {
    try {
      // Mengirim data QR (UUID) ke server
      final response = await _dio.post('/scan', data: {"qr_data": uuid});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
