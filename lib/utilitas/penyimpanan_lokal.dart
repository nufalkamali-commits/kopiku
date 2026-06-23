import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service penyimpanan lokal — pengganti database seperti phpMyAdmin.
class PenyimpananLokal {
  static const _keyNamaUser = 'nama_user';
  static const _keyEmailUser = 'email_user';
  static const _keyPasswordUser = 'password_user';
  static const _keySudahLogin = 'sudah_login';
  static const _keyDaftarPesanan = 'daftar_pesanan';
  static const _keyRiwayatLogin = 'riwayat_login';
  static const _keyPoin = 'poin_user';
  static const _keyAlamatList = 'daftar_alamat';
  static const _keyAlamatAktif = 'alamat_aktif';
  static const _keyFavorit = 'menu_favorit';

  // Daftar voucher valid (kode -> diskon persen)
  static const Map<String, int> daftarVoucher = {
    'KOPIKITA10': 10,
    'HEMAT20': 20,
    'WELCOME15': 15,
    'NEWUSER': 25,
  };

  // ── AKUN / PROFIL ───────────────────────────────────
  static Future<bool> daftarAkun({
    required String nama,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_keyEmailUser) == email) return false;
    await prefs.setString(_keyNamaUser, nama);
    await prefs.setString(_keyEmailUser, email);
    await prefs.setString(_keyPasswordUser, password);
    await prefs.setInt(_keyPoin, 0);
    return true;
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final emailOk = prefs.getString(_keyEmailUser) ?? '';
    final passOk = prefs.getString(_keyPasswordUser) ?? '';
    if (email == emailOk && password == passOk) {
      await prefs.setBool(_keySudahLogin, true);
      await _catatRiwayatLogin(prefs, email);
      return true;
    }
    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySudahLogin, false);
  }

  static Future<bool> sudahLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySudahLogin) ?? false;
  }

  static Future<String> getNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNamaUser) ?? '';
  }

  static Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmailUser) ?? '';
  }

  static Future<void> updateProfil({
    required String nama,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyNamaUser, nama);
    await prefs.setString(_keyEmailUser, email);
  }

  static Future<bool> gantiPassword({
    required String passwordLama,
    required String passwordBaru,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final passOk = prefs.getString(_keyPasswordUser) ?? '';
    if (passwordLama != passOk) return false;
    await prefs.setString(_keyPasswordUser, passwordBaru);
    return true;
  }

  static Future<int> getPoin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPoin) ?? 0;
  }

  static Future<void> tambahPoin(int jumlah) async {
    final prefs = await SharedPreferences.getInstance();
    final now = prefs.getInt(_keyPoin) ?? 0;
    await prefs.setInt(_keyPoin, now + jumlah);
  }

  // ── PESANAN ────────────────────────────────────────
  static Future<void> simpanPesanan(Map<String, String> pesanan) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyDaftarPesanan) ?? [];
    list.insert(0, json.encode(pesanan));
    await prefs.setStringList(_keyDaftarPesanan, list);
  }

  static Future<List<Map<String, String>>> getDaftarPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyDaftarPesanan) ?? [];
    return list.map((s) {
      final d = json.decode(s) as Map<String, dynamic>;
      return d.map((k, v) => MapEntry(k, v.toString()));
    }).toList();
  }

  static Future<void> updateStatusPesanan(String id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyDaftarPesanan) ?? [];
    final updated = list.map((s) {
      final d = json.decode(s) as Map<String, dynamic>;
      if (d['id'] == id) d['status'] = status;
      return json.encode(d);
    }).toList();
    await prefs.setStringList(_keyDaftarPesanan, updated);
  }

  static Future<int> jumlahPesanan() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_keyDaftarPesanan) ?? []).length;
  }

  // ── RIWAYAT LOGIN ──────────────────────────────────
  static Future<void> _catatRiwayatLogin(
      SharedPreferences prefs, String email) async {
    final list = prefs.getStringList(_keyRiwayatLogin) ?? [];
    list.insert(0,
        json.encode({'email': email, 'waktu': DateTime.now().toIso8601String()}));
    if (list.length > 20) list.removeLast();
    await prefs.setStringList(_keyRiwayatLogin, list);
  }

  static Future<List<Map<String, String>>> getRiwayatLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyRiwayatLogin) ?? [];
    return list.map((s) {
      final d = json.decode(s) as Map<String, dynamic>;
      return d.map((k, v) => MapEntry(k, v.toString()));
    }).toList();
  }

  // ── ALAMAT PENGIRIMAN ──────────────────────────────
  static Future<List<Map<String, String>>> getDaftarAlamat() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyAlamatList) ?? [];
    return list.map((s) {
      final d = json.decode(s) as Map<String, dynamic>;
      return d.map((k, v) => MapEntry(k, v.toString()));
    }).toList();
  }

  static Future<void> simpanAlamat(Map<String, String> alamat) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyAlamatList) ?? [];
    list.add(json.encode(alamat));
    await prefs.setStringList(_keyAlamatList, list);
  }

  static Future<void> setAlamatAktif(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyAlamatAktif, index);
  }

  static Future<int> getAlamatAktif() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyAlamatAktif) ?? 0;
  }

  // ── FAVORIT MENU ──────────────────────────────────
  static Future<List<String>> getFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyFavorit) ?? [];
  }

  static Future<bool> isFavorit(String namaMenu) async {
    final list = await getFavorit();
    return list.contains(namaMenu);
  }

  static Future<void> toggleFavorit(String namaMenu) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyFavorit) ?? [];
    if (list.contains(namaMenu)) {
      list.remove(namaMenu);
    } else {
      list.add(namaMenu);
    }
    await prefs.setStringList(_keyFavorit, list);
  }

  // ── HAPUS SEMUA ────────────────────────────────────
  static Future<void> hapusSemua() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
