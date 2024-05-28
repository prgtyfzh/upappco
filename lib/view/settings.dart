import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildEditAccountSection(),
            const SizedBox(height: 20),
            _buildLogoutButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return const ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        radius: 40, // Mengatur ukuran CircleAvatar
      ),
      title: Text(
        'Hamada Asahi',
        style: TextStyle(
          fontSize: 20, // Mengatur ukuran teks
          fontWeight: FontWeight.bold, // Mengatur ketebalan teks
        ),
      ),
      subtitle: Text(
        'asahi@example.com',
        style: TextStyle(
          fontSize: 16, // Mengatur ukuran teks subtitle
        ),
      ),
    );
  }

  Widget _buildEditAccountSection() {
    return ListTile(
      leading: const Icon(Icons.edit),
      title: const Text('Edit Akun'),
      onTap: () {
        // Tambahkan aksi edit akun di sini
      },
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Keluar'),
      onTap: () {
        // Tambahkan aksi logout di sini
      },
    );
  }
}
