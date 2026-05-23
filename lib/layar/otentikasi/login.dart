import 'package:flutter/material.dart';
import '../../utilitas/tema_warna.dart';
import '../beranda/beranda.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({Key? key}) : super(key: key);

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  style: TemaTeks.poppins(40, FontWeight.bold, TemaWarna.putih),
                ),
                Text(
                  'The Art of Perfect Brewing',
                  style: TemaTeks.montserrat(
                    14,
                    FontWeight.w300,
                    TemaWarna.abuAbu,
                  ),
                ),
                const SizedBox(height: 60),
                _buildTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  hint: 'Password',
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TemaTeks.montserrat(
                      12,
                      FontWeight.w500,
                      TemaWarna.emasKopi,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Beranda(),
                        ),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: TemaTeks.poppins(
                        18,
                        FontWeight.w600,
                        TemaWarna.putih,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TemaTeks.montserrat(
                        14,
                        FontWeight.w400,
                        TemaWarna.abuAbu,
                      ),
                    ),
                    Text(
                      'Register',
                      style: TemaTeks.montserrat(
                        14,
                        FontWeight.bold,
                        TemaWarna.emasKopi,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: TemaWarna.kartuGelap,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TemaWarna.putih.withOpacity(0.05)),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: TemaWarna.putih),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TemaTeks.montserrat(14, FontWeight.w400, TemaWarna.abuAbu),
          prefixIcon: Icon(icon, color: TemaWarna.emasKopi, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
