import 'package:flutter/material.dart';
import '../../utilitas/tema_warna.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _currentIndex = 0;
  String _kategoriTerpilih = 'Coffee';
  
  List<String> _itemKeranjang = [];

  // Data dummy pesanan
  final List<Map<String, String>> _daftarPesanan = [
    {'id': '#KP-001', 'item': 'Kopi Susu Gula Aren (x1)', 'status': 'Sedang Diproses', 'total': 'Rp 25.000', 'tanggal': '17 Mei 2026'},
    {'id': '#KP-002', 'item': 'Matcha Latte (x2)', 'status': 'Selesai', 'total': 'Rp 56.000', 'tanggal': '15 Mei 2026'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TemaWarna.cream,
      appBar: AppBar(
        backgroundColor: TemaWarna.coklatTua,
        title: Text(
          'KopiKita',
          style: TemaTeks.poppins(20, FontWeight.bold, TemaWarna.putih),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: TemaWarna.putih),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tidak ada notifikasi baru.')),
              );
            },
          )
        ],
      ),
      body: _buildBodyContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: TemaWarna.coklatTua,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          const BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: _itemKeranjang.isNotEmpty,
              label: Text('${_itemKeranjang.length}'),
              child: const Icon(Icons.shopping_cart),
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_currentIndex == 1) {
      return _buildHalamanPesanan();
    } else if (_currentIndex == 2) {
      return _buildHalamanKeranjang();
    } else if (_currentIndex == 3) {
      return _buildHalamanProfil();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Promo
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: TemaWarna.orangeKopi,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Promo Hari Ini: Diskon 20%!',
                  style: TemaTeks.montserrat(18, FontWeight.bold, TemaWarna.putih),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Kategori Menu
            Text(
              'Kategori',
              style: TemaTeks.poppins(18, FontWeight.w600, TemaWarna.coklatTua),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _kategoriCard(Icons.local_cafe, 'Coffee'),
                _kategoriCard(Icons.emoji_food_beverage, 'Non Coffee'),
                _kategoriCard(Icons.cake, 'Dessert'),
                _kategoriCard(Icons.fastfood, 'Snack'),
              ],
            ),
            const SizedBox(height: 24),
            // Menu Populer
            Text(
              'Menu Populer',
              style: TemaTeks.poppins(18, FontWeight.w600, TemaWarna.coklatTua),
            ),
            const SizedBox(height: 12),
            // Daftar Menu
            _buildMenuCard('Kopi Susu Gula Aren', 'Rp 25.000', Icons.local_cafe),
            const SizedBox(height: 12),
            _buildMenuCard('Matcha Latte', 'Rp 28.000', Icons.emoji_food_beverage),
            const SizedBox(height: 12),
            _buildMenuCard('Americano', 'Rp 20.000', Icons.coffee),
            const SizedBox(height: 12),
            _buildMenuCard('Caramel Macchiato', 'Rp 32.000', Icons.local_cafe),
            const SizedBox(height: 12),
            _buildMenuCard('Brownies Coklat', 'Rp 15.000', Icons.cake),
            const SizedBox(height: 12),
            _buildMenuCard('Kentang Goreng', 'Rp 18.000', Icons.fastfood),
          ],
        ),
      ),
    );
  }

  Widget _buildHalamanPesanan() {
    if (_daftarPesanan.isEmpty) {
      return Center(child: Text('Belum ada pesanan.', style: TemaTeks.poppins(16, FontWeight.w500, TemaWarna.hitam)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _daftarPesanan.length,
      itemBuilder: (context, index) {
        final pesanan = _daftarPesanan[index];
        bool isSelesai = pesanan['status'] == 'Selesai';
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pesanan['id']!, style: TemaTeks.poppins(16, FontWeight.bold, TemaWarna.coklatTua)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelesai ? Colors.green.withOpacity(0.1) : TemaWarna.orangeKopi.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        pesanan['status']!, 
                        style: TemaTeks.montserrat(12, FontWeight.w600, isSelesai ? Colors.green : TemaWarna.orangeKopi)
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(pesanan['item']!, style: TemaTeks.poppins(14, FontWeight.w500, TemaWarna.hitam)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pesanan['tanggal']!, style: TemaTeks.montserrat(12, FontWeight.w400, Colors.grey)),
                    Text(pesanan['total']!, style: TemaTeks.montserrat(14, FontWeight.bold, TemaWarna.hitam)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHalamanKeranjang() {
    if (_itemKeranjang.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text('Keranjang Anda Kosong', style: TemaTeks.poppins(18, FontWeight.w600, TemaWarna.coklatTua)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _itemKeranjang.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.coffee, color: TemaWarna.coklatTua),
                  title: Text(_itemKeranjang[index], style: TemaTeks.poppins(14, FontWeight.w500, TemaWarna.hitam)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _itemKeranjang.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: TemaWarna.putih,
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 10, offset: const Offset(0, -2))
            ]
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TemaWarna.coklatTua,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur Checkout akan segera hadir!')),
                );
              },
              child: Text('Checkout (${_itemKeranjang.length} item)', style: TemaTeks.poppins(16, FontWeight.bold, TemaWarna.putih)),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildHalamanProfil() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header Profile
          Container(
            padding: const EdgeInsets.only(top: 16, bottom: 32, left: 24, right: 24),
            decoration: const BoxDecoration(
              color: TemaWarna.coklatTua,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: TemaWarna.cream,
                      child: Icon(Icons.person, size: 60, color: TemaWarna.coklatTua),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: TemaWarna.emasKopi,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 20, color: TemaWarna.putih),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text('Pecinta Kopi', style: TemaTeks.poppins(22, FontWeight.bold, TemaWarna.putih)),
                Text('pecinta.kopi@email.com', style: TemaTeks.montserrat(14, FontWeight.w400, TemaWarna.putih.withOpacity(0.8))),
                const SizedBox(height: 24),
                // Stats
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: TemaWarna.putih.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildProfileStat('Poin', '125', Icons.stars),
                      Container(height: 40, width: 1, color: TemaWarna.putih.withOpacity(0.3)),
                      _buildProfileStat('Status', 'Gold', Icons.workspace_premium),
                      Container(height: 40, width: 1, color: TemaWarna.putih.withOpacity(0.3)),
                      _buildProfileStat('Pesanan', '12', Icons.receipt_long),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Menu Options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pengaturan Akun', style: TemaTeks.poppins(16, FontWeight.bold, TemaWarna.coklatTua)),
                const SizedBox(height: 12),
                _buildProfileMenu(Icons.person_outline, 'Edit Profil', () {}),
                _buildProfileMenu(Icons.location_on_outlined, 'Alamat Pengiriman', () {}),
                _buildProfileMenu(Icons.payment_outlined, 'Metode Pembayaran', () {}),
                _buildProfileMenu(Icons.help_outline, 'Pusat Bantuan', () {}),
                const SizedBox(height: 16),
                _buildProfileMenu(Icons.logout, 'Keluar', () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anda telah keluar dari sesi.')),
                  );
                }, isDestructive: true),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TemaWarna.emasKopi, size: 28),
        const SizedBox(height: 4),
        Text(value, style: TemaTeks.poppins(16, FontWeight.bold, TemaWarna.putih)),
        Text(label, style: TemaTeks.montserrat(12, FontWeight.w400, TemaWarna.putih.withOpacity(0.8))),
      ],
    );
  }

  Widget _buildProfileMenu(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Card(
      elevation: 0,
      color: TemaWarna.putih,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: isDestructive ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : TemaWarna.cream,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : TemaWarna.coklatTua),
        ),
        title: Text(title, style: TemaTeks.poppins(14, FontWeight.w600, isDestructive ? Colors.red : TemaWarna.hitam)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMenuCard(String nama, String harga, IconData ikon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: TemaWarna.coklatTua.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(ikon, color: TemaWarna.coklatTua),
        ),
        title: Text(nama, style: TemaTeks.poppins(16, FontWeight.w600, TemaWarna.hitam)),
        subtitle: Text(harga, style: TemaTeks.montserrat(14, FontWeight.bold, TemaWarna.orangeKopi)),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: TemaWarna.coklatTua, size: 30),
          onPressed: () {
            setState(() {
              _itemKeranjang.add(nama);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$nama ditambahkan ke keranjang!'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'LIHAT',
                  textColor: TemaWarna.emasKopi,
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2; // Pindah ke tab keranjang
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _kategoriCard(IconData icon, String judul) {
    bool isSelected = _kategoriTerpilih == judul;
    return GestureDetector(
      onTap: () {
        setState(() {
          _kategoriTerpilih = judul;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? TemaWarna.coklatTua : TemaWarna.putih,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                )
              ]
            ),
            child: Icon(icon, color: isSelected ? TemaWarna.putih : TemaWarna.coklatTua, size: 30),
          ),
          const SizedBox(height: 8),
          Text(judul, style: TemaTeks.montserrat(12, isSelected ? FontWeight.bold : FontWeight.w500, TemaWarna.hitam)),
        ],
      ),
    );
  }
}
