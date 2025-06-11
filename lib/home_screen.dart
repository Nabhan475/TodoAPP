import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

/// Halaman utama aplikasi To-Do yang menampilkan dan mengelola daftar tugas pengguna.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _selectedDate;
  int updateIndex =
      -1; // Menyimpan indeks item yang sedang diedit, -1 jika tidak ada.
  String? currentDocId; // ID dokumen Firestore untuk item yang sedang diedit.

  /// Menambahkan tugas baru ke Firestore
  Future<void> addList(String task) async {
    if (task.trim().isEmpty) {
      _showSnackBar('Tugas tidak boleh kosong', Colors.red);
      return;
    }
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('todos').add({
          'task': task,
          'description': _descController.text.trim(),
          'dueDate': _selectedDate,
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user.uid,
          'isCompleted': false,
        });
        _resetState(); // Reset input form setelah berhasil menambah
      }
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  /// Memperbarui item tugas yang sudah ada di Firestore
  Future<void> updateListItem(String task, String docId) async {
    if (task.trim().isEmpty) {
      _showSnackBar('Tugas tidak boleh kosong', Colors.red);
      return;
    }
    try {
      await _firestore.collection('todos').doc(docId).update({
        'task': task,
        'description': _descController.text.trim(),
        'dueDate': _selectedDate,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _resetState();
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  /// Menghapus item dari Firestore
  Future<void> deleteItem(String docId) async {
    try {
      await _firestore.collection('todos').doc(docId).delete();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  /// Mengubah status selesai/tidak selesai dari suatu tugas
  Future<void> toggleTaskStatus(String docId, bool currentStatus) async {
    try {
      await _firestore.collection('todos').doc(docId).update({
        'isCompleted': !currentStatus,
      });
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  /// Reset seluruh input dan mode edit
  void _resetState() {
    setState(() {
      updateIndex = -1;
      currentDocId = null;
      _controller.clear();
      _descController.clear();
      _selectedDate = null;
    });
  }

  /// Menampilkan snackbar untuk pesan kesalahan atau info
  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: bgColor));
  }

  /// Logout dari aplikasi dan kembali ke halaman login
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print('Error logging out: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal melakukan logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To-Do List",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Bagian daftar tugas dari Firestore
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('todos')
                        .where('userId', isEqualTo: user?.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Terjadi kesalahan'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'Belum ada tugas',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // Tampilkan daftar tugas
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final isCompleted = data['isCompleted'] ?? false;

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Checkbox(
                            value: isCompleted,
                            onChanged: (value) {
                              toggleTaskStatus(doc.id, isCompleted);
                            },
                            activeColor: Colors.blueAccent,
                          ),
                          title: Text(
                            data['task'] ?? '',
                            style: TextStyle(
                              decoration:
                                  isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                              color: isCompleted ? Colors.grey : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if ((data['description'] ?? '').isNotEmpty)
                                Text(data['description']),
                              if (data['dueDate'] != null)
                                Text(
                                  "Tenggat: ${data['dueDate'].toDate().toLocal().toString().split(' ')[0]}",
                                  style: const TextStyle(fontSize: 13),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Mengisi form dengan data item yang akan diedit
                                  setState(() {
                                    _controller.text = data['task'] ?? '';
                                    _descController.text =
                                        data['description'] ?? '';
                                    _selectedDate = data['dueDate']?.toDate();
                                    updateIndex = index;
                                    currentDocId = doc.id;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => deleteItem(doc.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Form input tugas baru atau edit tugas
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
              ),
              child: Column(
                children: [
                  // Input nama tugas
                  TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nama tugas',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Input deskripsi tugas
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      hintText: 'Deskripsi tugas (opsional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),

                  // Pilih tanggal tenggat
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Pilih tanggal'
                              : 'Tanggal: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        child: const Text('Pilih Tanggal'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Tombol tambah atau update
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(updateIndex != -1 ? Icons.edit : Icons.add),
                      label: Text(
                        updateIndex != -1 ? 'Update Tugas' : 'Tambah Tugas',
                      ),
                      onPressed: () {
                        if (updateIndex != -1 && currentDocId != null) {
                          updateListItem(_controller.text, currentDocId!);
                        } else {
                          addList(_controller.text);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
