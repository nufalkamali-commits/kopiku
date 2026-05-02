import 'package:flutter/material.dart';
import '../../utilitas/tema_warna.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _currentIndex = 0;

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
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
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
              // Contoh Card Menu
              Card(
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
                    child: const Icon(Icons.local_cafe, color: TemaWarna.coklatTua),
                  ),
                  title: Text('Kopi Susu Gula Aren', style: TemaTeks.poppins(16, FontWeight.w600, TemaWarna.hitam)),
                  subtitle: Text('Rp 25.000', style: TemaTeks.montserrat(14, FontWeight.bold, TemaWarna.orangeKopi)),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle, color: TemaWarna.coklatTua, size: 30),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _kategoriCard(IconData icon, String judul) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: TemaWarna.putih,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
              )
            ]
          ),
          child: Icon(icon, color: TemaWarna.coklatTua, size: 30),
        ),
        const SizedBox(height: 8),
        Text(judul, style: TemaTeks.montserrat(12, FontWeight.w500, TemaWarna.hitam)),
      ],
    );
  }
}
