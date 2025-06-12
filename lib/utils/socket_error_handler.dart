import 'package:flutter/material.dart';

class SocketErrorHandler {
  void handle(BuildContext context, dynamic error) {
    if (error.toString().contains('Connection refused')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.withOpacity(0.8), // สีแดงจาง
          duration: const Duration(days: 1),
          behavior: SnackBarBehavior.floating,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // โค้งมน
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          content: Row(
            children: const [
              Icon(Icons.wifi_off, color: Colors.white, size: 30),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'ไม่พบการเชื่อมต่อ RabbitMQ',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
