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
  
  List<Map<String, dynamic>> _itemKeranjang = [];

  // State Profil
  String _namaUser = 'Pecinta Kopi';
  String _emailUser = 'pecinta.kopi@email.com';

  // Data dummy pesanan
  final List<Map<String, String>> _daftarPesanan = [
    {'id': '#KP-001', 'item': 'Kopi Susu Gula Aren (x1)', 'status': 'Sedang Diproses', 'total': 'Rp 25.000', 'tanggal': '17 Mei 2026'},
    {'id': '#KP-002', 'item': 'Matcha Latte (x2)', 'status': 'Selesai', 'total': 'Rp 56.000', 'tanggal': '15 Mei 2026'},
  ];

  int _parseHarga(String harga) {
    return int.parse(harga.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  String _formatHarga(int harga) {
    String hasil = harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
    return 'Rp $hasil';
  }

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
            const SizedBox(height: 12),
            _buildMenuCard('Pisang Goreng', 'Rp 12.000', Icons.fastfood),
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
                  leading: Icon(_itemKeranjang[index]['ikon'], color: TemaWarna.coklatTua),
                  title: Text(_itemKeranjang[index]['nama'], style: TemaTeks.poppins(14, FontWeight.w500, TemaWarna.hitam)),
                  subtitle: Text(_itemKeranjang[index]['harga'], style: TemaTeks.montserrat(12, FontWeight.w400, TemaWarna.coklatTua)),
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
                _tampilkanDialogCheckout();
              },
              child: Text('Checkout (${_itemKeranjang.length} item)', style: TemaTeks.poppins(16, FontWeight.bold, TemaWarna.putih)),
            ),
          ),
        )
      ],
    );
  }

  void _tampilkanDialogCheckout() {
    if (_itemKeranjang.isEmpty) return;

    int total = 0;
    Map<String, int> hitungItem = {};
    
    for (var item in _itemKeranjang) {
      total += _parseHarga(item['harga']);
      String nama = item['nama'];
      hitungItem[nama] = (hitungItem[nama] ?? 0) + 1;
    }

    String ringkasanItem = hitungItem.entries.map((e) => '${e.key} (x${e.value})').join(', ');
    if (ringkasanItem.length > 35) {
      ringkasanItem = ringkasanItem.substring(0, 35) + '...';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Konfirmasi Pesanan', style: TemaTeks.poppins(18, FontWeight.bold, TemaWarna.coklatTua)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Item: ${_itemKeranjang.length}', style: TemaTeks.montserrat(14, FontWeight.w500, TemaWarna.hitam)),
              const SizedBox(height: 8),
              Text('Total Harga: ${_formatHarga(total)}', style: TemaTeks.montserrat(16, FontWeight.bold, TemaWarna.orangeKopi)),
              const SizedBox(height: 16),
              Text('Apakah Anda yakin ingin melakukan pesanan ini?', style: TemaTeks.montserrat(14, FontWeight.w400, TemaWarna.hitam)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TemaTeks.poppins(14, FontWeight.w600, Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: TemaWarna.coklatTua,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _daftarPesanan.insert(0, {
                    'id': '#KP-00${_daftarPesanan.length + 1}',
                    'item': ringkasanItem,
                    'status': 'Sedang Diproses',
                    'total': _formatHarga(total),
                    'tanggal': 'Hari Ini',
                  });
                  _itemKeranjang.clear();
                  _currentIndex = 1; // Pindah ke tab Pesanan
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pesanan berhasil dibuat!')),
                );
              },
              child: Text('Bayar', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.putih)),
            ),
          ],
        );
      },
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
                    GestureDetector(
                      onTap: _tampilkanEditProfil,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: TemaWarna.emasKopi,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: TemaWarna.putih),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Text(_namaUser, style: TemaTeks.poppins(22, FontWeight.bold, TemaWarna.putih)),
                Text(_emailUser, style: TemaTeks.montserrat(14, FontWeight.w400, TemaWarna.putih.withOpacity(0.8))),
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
                _buildProfileMenu(Icons.person_outline, 'Edit Profil', _tampilkanEditProfil),
                _buildProfileMenu(Icons.location_on_outlined, 'Alamat Pengiriman', _tampilkanAlamatPengiriman),
                _buildProfileMenu(Icons.payment_outlined, 'Metode Pembayaran', _tampilkanMetodePembayaran),
                _buildProfileMenu(Icons.help_outline, 'Pusat Bantuan', _tampilkanPusatBantuan),
                const SizedBox(height: 16),
                _buildProfileMenu(Icons.logout, 'Keluar', _tampilkanDialogKeluar, isDestructive: true),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _tampilkanEditProfil() {
    TextEditingController namaController = TextEditingController(text: _namaUser);
    TextEditingController emailController = TextEditingController(text: _emailUser);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24, left: 24, right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Edit Profil', style: TemaTeks.poppins(18, FontWeight.bold, TemaWarna.coklatTua)),
              const SizedBox(height: 16),
              TextField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  labelStyle: TemaTeks.montserrat(14, FontWeight.w500, Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TemaTeks.montserrat(14, FontWeight.w500, Colors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TemaWarna.coklatTua,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    setState(() {
                      _namaUser = namaController.text;
                      _emailUser = emailController.text;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
                  },
                  child: Text('Simpan Perubahan', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.putih)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _tampilkanAlamatPengiriman() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Alamat Pengiriman', style: TemaTeks.poppins(18, FontWeight.bold, TemaWarna.coklatTua)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on, color: TemaWarna.orangeKopi),
                title: Text('Rumah', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.hitam)),
                subtitle: Text('Jl. Kopi Susu No. 123, Jakarta Selatan', style: TemaTeks.montserrat(12, FontWeight.w400, Colors.grey)),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
                title: Text('Kantor', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.hitam)),
                subtitle: Text('Gedung Espresso Tower Lt. 5, Jakarta Pusat', style: TemaTeks.montserrat(12, FontWeight.w400, Colors.grey)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: TemaWarna.coklatTua),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fitur Tambah Alamat akan segera hadir!')));
                  },
                  child: Text('+ Tambah Alamat Baru', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.coklatTua)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _tampilkanMetodePembayaran() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Metode Pembayaran', style: TemaTeks.poppins(18, FontWeight.bold, TemaWarna.coklatTua)),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.account_balance_wallet, color: TemaWarna.emasKopi),
                title: Text('Saldo KopiKita', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.hitam)),
                subtitle: Text('Rp 150.000', style: TemaTeks.montserrat(12, FontWeight.w400, Colors.grey)),
                trailing: const Icon(Icons.check_circle, color: Colors.green),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.qr_code_scanner, color: Colors.blue),
                title: Text('QRIS / E-Wallet', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.hitam)),
                subtitle: Text('GoPay, OVO, Dana, LinkAja', style: TemaTeks.montserrat(12, FontWeight.w400, Colors.grey)),
              ),
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.credit_card, color: Colors.orange),
                title: Text('Kartu Kredit / Debit', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.hitam)),
                subtitle: Text('Visa, Mastercard, JCB', style: TemaTeks.montserrat(12, FontWeight.w400, Colors.grey)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _tampilkanPusatBantuan() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Pusat Bantuan', style: TemaTeks.poppins(18, FontWeight.bold, TemaWarna.coklatTua)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.chat, color: Colors.green),
                title: Text('Chat via WhatsApp', style: TemaTeks.poppins(14, FontWeight.w500, TemaWarna.hitam)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.email, color: Colors.blue),
                title: Text('Kirim Email', style: TemaTeks.poppins(14, FontWeight.w500, TemaWarna.hitam)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.book, color: TemaWarna.orangeKopi),
                title: Text('FAQ (Pertanyaan Umum)', style: TemaTeks.poppins(14, FontWeight.w500, TemaWarna.hitam)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tutup', style: TemaTeks.poppins(14, FontWeight.w600, Colors.grey)),
            )
          ],
        );
      },
    );
  }

  void _tampilkanDialogKeluar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Konfirmasi Keluar', style: TemaTeks.poppins(18, FontWeight.bold, Colors.red)),
          content: Text('Apakah Anda yakin ingin keluar dari akun ini?', style: TemaTeks.montserrat(14, FontWeight.w400, TemaWarna.hitam)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TemaTeks.poppins(14, FontWeight.w600, Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                setState(() {
                  _currentIndex = 0; // Kembali ke beranda setelah logout (simulasi)
                });
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anda telah berhasil keluar.')));
              },
              child: Text('Keluar', style: TemaTeks.poppins(14, FontWeight.bold, TemaWarna.putih)),
            ),
          ],
        );
      },
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
              _itemKeranjang.add({
                'nama': nama,
                'harga': harga,
                'ikon': ikon,
              });
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
