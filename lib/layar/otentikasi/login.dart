import 'package:flutter/material.dart';
import '../../utilitas/tema_warna.dart';
import '../../utilitas/penyimpanan_lokal.dart';
import '../beranda/beranda.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key? key}) : super(key: key);

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin>
    with SingleTickerProviderStateMixin {
  bool _tampilkanDaftar = false;
  bool _sedangMemuat = false;
  bool _sembunyikanPassword = true;
  bool _sembunyikanPasswordDaftar = true;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _namaController = TextEditingController();
  final _emailDaftarController = TextEditingController();
  final _passwordDaftarController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    // Cek apakah sudah login sebelumnya
    _cekSudahLogin();
  }

  Future<void> _cekSudahLogin() async {
    final sudahLogin = await PenyimpananLokal.sudahLogin();
    if (sudahLogin && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Beranda()),
      );
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _namaController.dispose();
    _emailDaftarController.dispose();
    _passwordDaftarController.dispose();
    super.dispose();
  }

  Future<void> _prosesLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _tampilkanPesan('Email dan password tidak boleh kosong!', isError: true);
      return;
    }

    setState(() => _sedangMemuat = true);

    final berhasil = await PenyimpananLokal.login(
      email: email,
      password: password,
    );

    setState(() => _sedangMemuat = false);

    if (berhasil) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Beranda()),
        );
      }
    } else {
      _tampilkanPesan('Email atau password salah!', isError: true);
    }
  }

  Future<void> _prosesDaftar() async {
    final nama = _namaController.text.trim();
    final email = _emailDaftarController.text.trim();
    final password = _passwordDaftarController.text.trim();

    if (nama.isEmpty || email.isEmpty || password.isEmpty) {
      _tampilkanPesan('Semua kolom harus diisi!', isError: true);
      return;
    }
    if (!email.contains('@')) {
      _tampilkanPesan('Format email tidak valid!', isError: true);
      return;
    }
    if (password.length < 6) {
      _tampilkanPesan('Password minimal 6 karakter!', isError: true);
      return;
    }

    setState(() => _sedangMemuat = true);

    final berhasil = await PenyimpananLokal.daftarAkun(
      nama: nama,
      email: email,
      password: password,
    );

    setState(() => _sedangMemuat = false);

    if (berhasil) {
      _tampilkanPesan('Akun berhasil dibuat! Silakan login.', isError: false);
      setState(() {
        _tampilkanDaftar = false;
        _emailController.text = email;
      });
    } else {
      _tampilkanPesan('Email sudah terdaftar!', isError: true);
    }
  }

  void _tampilkanPesan(String pesan, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [TemaWarna.coklatTua, TemaWarna.latarGelap],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: TemaWarna.emasKopi.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.coffee_maker_rounded,
                          size: 80,
                          color: TemaWarna.emasKopi,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'KopiKita',
                        style: TemaTeks.poppins(
                          40,
                          FontWeight.bold,
                          TemaWarna.putih,
                        ),
                      ),
                      Text(
                        'The Art of Perfect Brewing',
                        style: TemaTeks.montserrat(
                          14,
                          FontWeight.w300,
                          TemaWarna.abuAbu,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Toggle Login / Daftar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            _tabToggle('Masuk', !_tampilkanDaftar, () {
                              setState(() => _tampilkanDaftar = false);
                            }),
                            _tabToggle('Daftar', _tampilkanDaftar, () {
                              setState(() => _tampilkanDaftar = true);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Form
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _tampilkanDaftar
                            ? _buildFormDaftar()
                            : _buildFormLogin(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabToggle(String label, bool aktif, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: aktif ? TemaWarna.emasKopi : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TemaTeks.poppins(
              14,
              FontWeight.w600,
              aktif ? TemaWarna.putih : TemaWarna.abuAbu,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLogin() {
    return Column(
      key: const ValueKey('login'),
      children: [
        _buildTextField(
          controller: _emailController,
          hint: 'Email',
          icon: Icons.email_outlined,
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordController,
          hint: 'Password',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          sembunyikan: _sembunyikanPassword,
          onTogglePassword: () =>
              setState(() => _sembunyikanPassword = !_sembunyikanPassword),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TemaWarna.emasKopi,
              foregroundColor: TemaWarna.putih,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _sedangMemuat ? null : _prosesLogin,
            child: _sedangMemuat
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Masuk',
                    style: TemaTeks.poppins(18, FontWeight.w600, TemaWarna.putih),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _tampilkanDaftar = true),
          child: Text(
            'Belum punya akun? Daftar sekarang',
            style: TemaTeks.montserrat(13, FontWeight.w500, TemaWarna.emasKopi),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFormDaftar() {
    return Column(
      key: const ValueKey('daftar'),
      children: [
        _buildTextField(
          controller: _namaController,
          hint: 'Nama Lengkap',
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emailDaftarController,
          hint: 'Email',
          icon: Icons.email_outlined,
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _passwordDaftarController,
          hint: 'Password (min. 6 karakter)',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          sembunyikan: _sembunyikanPasswordDaftar,
          onTogglePassword: () => setState(
              () => _sembunyikanPasswordDaftar = !_sembunyikanPasswordDaftar),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: TemaWarna.emasKopi,
              foregroundColor: TemaWarna.putih,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _sedangMemuat ? null : _prosesDaftar,
            child: _sedangMemuat
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Buat Akun',
                    style: TemaTeks.poppins(18, FontWeight.w600, TemaWarna.putih),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _tampilkanDaftar = false),
          child: Text(
            'Sudah punya akun? Masuk di sini',
            style: TemaTeks.montserrat(13, FontWeight.w500, TemaWarna.emasKopi),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool sembunyikan = false,
    VoidCallback? onTogglePassword,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TemaWarna.kartuGelap,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TemaWarna.putih.withOpacity(0.05)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && sembunyikan,
        keyboardType: keyboard,
        style: const TextStyle(color: TemaWarna.putih),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TemaTeks.montserrat(14, FontWeight.w400, TemaWarna.abuAbu),
          prefixIcon: Icon(icon, color: TemaWarna.emasKopi, size: 22),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    sembunyikan ? Icons.visibility_off : Icons.visibility,
                    color: TemaWarna.abuAbu,
                    size: 20,
                  ),
                  onPressed: onTogglePassword,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
