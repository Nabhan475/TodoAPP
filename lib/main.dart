import 'package:flutter/material.dart';
// Untuk membuat tampilan aplikasi.

import 'package:firebase_core/firebase_core.dart';
// Untuk menghubungkan aplikasi ke Firebase.

import 'package:firebase_auth/firebase_auth.dart';
// Untuk fitur login/logout dari Firebase.

import 'package:google_fonts/google_fonts.dart';
// Untuk mengganti font jadi Poppins.

import 'login_screen.dart'; // Halaman login
import 'firebase_options.dart'; // Konfigurasi Firebase
import 'home_screen.dart'; // Halaman utama setelah login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Pastikan Flutter siap sebelum Firebase dijalankan.

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Inisialisasi Firebase.

  runApp(const MyApp());
  // Jalankan aplikasi utama.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan label debug

      theme: ThemeData(
        useMaterial3: true, // Pakai desain Material 3
        colorSchemeSeed: Colors.blueAccent, // Warna utama aplikasi
        textTheme: GoogleFonts.poppinsTextTheme(), // Font jadi Poppins
        scaffoldBackgroundColor: Colors.grey[100], // Latar belakang terang
      ),

      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),

        // Cek apakah user sedang login atau tidak
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
            // Tampilkan loading saat mengecek login
          }

          if (snapshot.hasData) return const HomeScreen();
          // Kalau sudah login, masuk ke halaman utama

          return const LoginScreen();
          // Kalau belum login, tampilkan halaman login
        },
      ),
    );
  }
}
