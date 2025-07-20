import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MatCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat datang,',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const Text(
              'Jacob Dom',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/logo.png', // Replace with your logo asset
              width: 100,
              height: 40,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kartu Saya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Card(
                color: Colors.blue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PROVINSI/TEMPAT ANDA',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'NIK : 452564338900738',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Nama : Kota Lahir',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Tempat/Tgl Lahir : 07-1987',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Jenis Kelamin : Wanita',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Alamat : Jalan Lerican',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'RT/RWeesa : Kelurahan Anda',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Kecamatan : Pecamatan Anda',
                            style: TextStyle(color: Colors.white),
                          ),
                          const Text(
                            'Status Kawinan : Seumur Hidup',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                              'assets/logo.png',
                            ), // Replace with asset
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'KOTA ANDA',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Icon(Icons.edit, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryIcon(Icons.favorite, 'Personal', Colors.red),
                  _buildCategoryIcon(
                    Icons.medical_services,
                    'Kesehatan',
                    Colors.red,
                  ),
                  _buildCategoryIcon(Icons.work, 'Bisnis', Colors.red),
                  _buildCategoryIcon(
                    Icons.attach_money,
                    'Keuangan',
                    Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Layanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildServiceIcon(
                    Icons.local_hospital,
                    'JMO',
                    Colors.red,
                  ), // Placeholder icons
                  _buildServiceIcon(
                    Icons.health_and_safety,
                    'Satu Sehat',
                    Colors.red,
                  ),
                  _buildServiceIcon(
                    Icons.phone_android,
                    'Mobile JKN',
                    Colors.red,
                  ),
                  _buildServiceIcon(Icons.card_travel, 'M-Paspor', Colors.red),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavItem(Icons.home, 'Beranda', 0),
            _buildBottomNavItem(Icons.assignment, 'Sertifikat', 1),
            const SizedBox(width: 48), // Space for FAB
            _buildBottomNavItem(Icons.inbox, 'Inbox', 2),
            _buildBottomNavItem(Icons.person, 'Profil', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildServiceIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Icon(icon, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? Colors.red : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
