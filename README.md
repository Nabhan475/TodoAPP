# todoapp


## A. Nama

Franklin Jonathan

## B. judul project
Aplikasi To-Do List dengan Fitur Autentikasi dan Manajemen Tugas

## C.Deskripsi Fungsionalitas Aplikasi
Aplikasi To-Do List ini dikembangkan menggunakan Flutter dan terintegrasi dengan Firebase. Aplikasi ini memungkinkan pengguna untuk:

- Registrasi dan login menggunakan email dan password

- Menambahkan tugas baru

- Memberikan deskripsi dan tanggal deadline pada setiap tugas

- Mengedit dan menghapus tugas

- Menandai tugas sebagai selesai
  
Semua data tugas disimpan secara real-time di Firebase Firestore, sehingga pengguna bisa mengakses data dari berbagai perangkat yang login dengan akun yang sama.

## D. Teknologi yang Digunakan
- Flutter – untuk pengembangan UI/UX aplikasi mobile

- Dart – bahasa pemrograman utama

- Firebase Authentication – untuk login dan register

- Firebase Firestore – sebagai database cloud untuk menyimpan data tugas pengguna
## E. Teknologi yang Digunakan
- Clone repository
- Buka folder project di Visual Studio Code
- Install semua dependencies Flutter : "flutter pub get"
- Integrasikan Firebase ke Project
    - Buka Firebase Console dan buat project baru.

    - Tambahkan aplikasi Android:

    - Ambil package name dari android/app/src/main/AndroidManifest.xml

    - Download file google-services.json dan letakkan di:
    android/app/google-services.json
  
    - Aktifkan Authentication > Sign-in method > Email/Password

    - Buka Firestore Database dan buat koleksi
- Setup Firebase di Flutter

  - Gunakan Firebase CLI atau FlutterFire CLI untuk menghasilkan file firebase_options.dart

  - Pastikan di main.dart sudah ada inisialisasi Firebase:

      void main() async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        runApp(MyApp());
      }
- Jalankan Emulator atau Hubungkan Perangkat
- Jalankan App dengan run di terminal "flutter run"
  ## UI dan Tampilan
  ![Screenshot (621)](https://github.com/user-attachments/assets/ae08125a-d355-41ea-8785-29cf9e3e51a7)
![Screenshot (622)](https://github.com/user-attachments/assets/0fe03e71-3aa1-4ee7-8cbf-7695021fa3ae)
![Screenshot (618)](https://github.com/user-attachments/assets/b3c0d433-d764-4292-a04a-cd4e7556e6f3)
![Screenshot (619)](https://github.com/user-attachments/assets/bb995ab4-4290-4909-8aa5-65baa73b8744)
![Screenshot (620)](https://github.com/user-attachments/assets/62890469-22f7-406b-8627-187239cc88b0)


