import 'package:flutter/material.dart';
import 'package:warisan_nusantara/app/modules/continue/controllers/continue_controller.dart';
import 'package:warisan_nusantara/app/modules/daily_quiz/controllers/daily_quiz_controller.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class HalamanQuizController extends GetxController {
  // Data soal
  final soalList = <Map<String, dynamic>>[].obs;
  final currentIndex = 0.obs;
  final selectedAnswer = ''.obs;
  final isAnswered = false.obs;

  // Skor & level
  final totalSoal = 3.obs;
  final score = 0.obs;
  final poin = 100.obs;
  final currentLevel = 1.obs;

  // Data kategori
  final kategoriNama = ''.obs;
  final kategoriDeskripsi = ''.obs;
  final kategoriImage = ''.obs;
  final kategoriWarna = 0xFF6A5041.obs;

  // Timer
  final timeLeft = 30.obs;
  Timer? _timer;

  // Power up
  final is5050Used = false.obs;
  final isDoublePointUsed = false.obs;
  final hiddenOptions = <String>[].obs;

  // Statistik
  final jumlahBenar = 0.obs;
  final streak = 0.obs;
  final maxStreak = 0.obs;
  final totalWaktu = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      currentLevel.value = (args['level'] ?? 1) as int;
      kategoriNama.value = args['kategoriNama'] ?? '';
      kategoriDeskripsi.value = args['kategoriDeskripsi'] ?? '';
      kategoriImage.value = args['kategoriImage'] ?? '';
      kategoriWarna.value = (args['kategoriWarna'] as int?) ?? 0xFF6A5041;
    }
    _loadSoal();
    _startTimer();
  }

  static const _soalPerKategori = {
    'Rumah Adat': [
      // ── Level 1: Rumah Gadang (Sumatera Barat) ──
      [
        {
          'soal': 'Rumah adat dari Sumatera Barat adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumah Joglo',
            'Rumah Tongkonan',
            'Rumah Honai',
          ],
          'jawaban': 'Rumah Gadang',
        },
        {
          'soal': 'Rumah Gadang adalah rumah adat suku?',
          'gambar': null,
          'pilihan': [
            'Suku Batak',
            'Suku Minangkabau',
            'Suku Dayak',
            'Suku Bugis',
          ],
          'jawaban': 'Suku Minangkabau',
        },
        {
          'soal': 'Atap Rumah Gadang berbentuk menyerupai?',
          'gambar': null,
          'pilihan': [
            'Segitiga lancip',
            'Tanduk kerbau',
            'Setengah lingkaran',
            'Pelana kuda',
          ],
          'jawaban': 'Tanduk kerbau',
        },
      ],

      // ── Level 2: Rumah Joglo (Jawa Tengah) ──
      [
        {
          'soal': 'Rumah adat dari Jawa Tengah adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumah Joglo',
            'Rumah Tongkonan',
            'Rumah Honai',
          ],
          'jawaban': 'Rumah Joglo',
        },
        {
          'soal':
              'Bagian utama Rumah Joglo yang menjadi ruang pertemuan disebut?',
          'gambar': null,
          'pilihan': ['Pendopo', 'Serambi', 'Dalem', 'Gandhok'],
          'jawaban': 'Pendopo',
        },
        {
          'soal': 'Material utama pembuatan Rumah Joglo adalah?',
          'gambar': null,
          'pilihan': ['Bambu', 'Kayu jati', 'Batu bata', 'Rotan'],
          'jawaban': 'Kayu jati',
        },
      ],

      // ── Level 3: Rumah Honai (Papua) ──
      [
        {
          'soal': 'Rumah adat dari Papua adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumah Joglo',
            'Rumah Tongkonan',
            'Rumah Honai',
          ],
          'jawaban': 'Rumah Honai',
        },
        {
          'soal': 'Rumah Honai merupakan rumah adat suku?',
          'gambar': null,
          'pilihan': ['Asmat', 'Dani', 'Biak', 'Sentani'],
          'jawaban': 'Dani',
        },
        {
          'soal': 'Bentuk atap Rumah Honai adalah?',
          'gambar': null,
          'pilihan': [
            'Kerucut dari jerami',
            'Datar dari seng',
            'Melengkung dari bambu',
            'Segitiga dari kayu',
          ],
          'jawaban': 'Kerucut dari jerami',
        },
      ],

      // ── Level 4: Rumah Tongkonan (Sulawesi Selatan / Toraja) ──
      [
        {
          'soal': 'Rumah adat dari Sulawesi Selatan adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumah Joglo',
            'Rumah Tongkonan',
            'Rumah Honai',
          ],
          'jawaban': 'Rumah Tongkonan',
        },
        {
          'soal': 'Rumah Tongkonan merupakan rumah adat suku?',
          'gambar': null,
          'pilihan': ['Toraja', 'Bugis', 'Makassar', 'Mandar'],
          'jawaban': 'Toraja',
        },
        {
          'soal': 'Ciri khas atap Rumah Tongkonan adalah?',
          'gambar': null,
          'pilihan': [
            'Melengkung ke atas',
            'Datar',
            'Melengkung ke bawah',
            'Berbentuk piramida',
          ],
          'jawaban': 'Melengkung ke atas',
        },
      ],

      // ── Level 5: Rumah Sasadu (Maluku Utara) ──
      [
        {
          'soal': 'Rumah adat dari Maluku Utara adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Sasadu',
            'Rumah Baileo',
            'Rumah Betang',
            'Rumah Honai',
          ],
          'jawaban': 'Rumah Sasadu',
        },
        {
          'soal': 'Rumah Sasadu merupakan rumah adat suku?',
          'gambar': null,
          'pilihan': ['Ternate', 'Sahu', 'Tidore', 'Bacan'],
          'jawaban': 'Sahu',
        },
        {
          'soal': 'Fungsi utama Rumah Sasadu adalah?',
          'gambar': null,
          'pilihan': [
            'Tempat tinggal raja',
            'Balai pertemuan adat',
            'Gudang padi',
            'Tempat ibadah',
          ],
          'jawaban': 'Balai pertemuan adat',
        },
      ],

      // ── Level 6: Rumah Krong Bade (Aceh) ──
      [
        {
          'soal': 'Rumah adat dari Aceh juga dikenal dengan nama?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumoh Aceh / Krong Bade',
            'Rumah Limas',
            'Rumah Bolon',
          ],
          'jawaban': 'Rumoh Aceh / Krong Bade',
        },
        {
          'soal': 'Rumah Krong Bade dibangun di atas?',
          'gambar': null,
          'pilihan': [
            'Tanah langsung',
            'Tiang-tiang kayu',
            'Batu pondasi',
            'Rakit bambu',
          ],
          'jawaban': 'Tiang-tiang kayu',
        },
        {
          'soal': 'Orientasi bangunan Rumah Krong Bade menghadap ke arah?',
          'gambar': null,
          'pilihan': ['Utara', 'Selatan', 'Timur', 'Barat'],
          'jawaban': 'Timur',
        },
      ],

      // ── Level 7: Rumah Limas (Sumatera Selatan) ──
      [
        {
          'soal': 'Rumah adat dari Sumatera Selatan adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumah Limas',
            'Rumah Tongkonan',
            'Rumah Joglo',
          ],
          'jawaban': 'Rumah Limas',
        },
        {
          'soal': 'Ciri khas atap Rumah Limas adalah?',
          'gambar': null,
          'pilihan': [
            'Berbentuk limas bersusun',
            'Berbentuk tanduk',
            'Berbentuk kerucut',
            'Berbentuk datar',
          ],
          'jawaban': 'Berbentuk limas bersusun',
        },
        {
          'soal': 'Lantai Rumah Limas memiliki tingkatan yang berbeda disebut?',
          'gambar': null,
          'pilihan': ['Kekijing', 'Pendopo', 'Serambi', 'Dapur'],
          'jawaban': 'Kekijing',
        },
      ],

      // ── Level 8: Rumah Bolon (Sumatera Utara / Batak) ──
      [
        {
          'soal': 'Rumah adat dari Sumatera Utara adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumah Joglo',
            'Rumah Bolon',
            'Rumah Honai',
          ],
          'jawaban': 'Rumah Bolon',
        },
        {
          'soal': 'Rumah Bolon merupakan rumah adat suku?',
          'gambar': null,
          'pilihan': ['Melayu', 'Batak', 'Minangkabau', 'Aceh'],
          'jawaban': 'Batak',
        },
        {
          'soal': 'Rumah Bolon dibangun tanpa menggunakan?',
          'gambar': null,
          'pilihan': ['Kayu', 'Bambu', 'Paku besi', 'Atap ijuk'],
          'jawaban': 'Paku besi',
        },
      ],

      // ── Level 9: Rumah Kebaya (DKI Jakarta / Betawi) ──
      [
        {
          'soal': 'Rumah adat dari DKI Jakarta adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Gadang',
            'Rumah Kebaya',
            'Rumah Joglo',
            'Rumah Betang',
          ],
          'jawaban': 'Rumah Kebaya',
        },
        {
          'soal': 'Rumah Kebaya merupakan rumah adat suku?',
          'gambar': null,
          'pilihan': ['Sunda', 'Jawa', 'Betawi', 'Melayu'],
          'jawaban': 'Betawi',
        },
        {
          'soal':
              'Nama Rumah Kebaya diambil dari bentuk atapnya yang menyerupai?',
          'gambar': null,
          'pilihan': [
            'Kebaya yang dilipat',
            'Kain sarung',
            'Payung terbuka',
            'Topi caping',
          ],
          'jawaban': 'Kebaya yang dilipat',
        },
      ],

      // ── Level 10: Rumah Betang (Kalimantan) ──
      [
        {
          'soal': 'Rumah adat dari Kalimantan adalah?',
          'gambar': null,
          'pilihan': [
            'Rumah Betang',
            'Rumah Joglo',
            'Rumah Tongkonan',
            'Rumah Honai',
          ],
          'jawaban': 'Rumah Betang',
        },
        {
          'soal': 'Rumah Betang adalah rumah adat suku?',
          'gambar': null,
          'pilihan': ['Banjar', 'Dayak', 'Kutai', 'Melayu'],
          'jawaban': 'Dayak',
        },
        {
          'soal': 'Rumah Betang terkenal karena ukurannya yang?',
          'gambar': null,
          'pilihan': [
            'Sangat kecil',
            'Sangat panjang',
            'Sangat tinggi',
            'Sangat bulat',
          ],
          'jawaban': 'Sangat panjang',
        },
      ],
    ],
    'Baju Adat': [
      // ── Level 1: Kebaya Jawa ──
      [
        {
          'soal': 'Kebaya Jawa berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Jawa', 'Papua', 'Bali', 'Aceh'],
          'jawaban': 'Jawa',
        },
        {
          'soal': 'Kebaya Jawa identik dengan kesan?',
          'gambar': null,
          'pilihan': ['Elegan dan anggun', 'Sporty', 'Kasual', 'Bebas'],
          'jawaban': 'Elegan dan anggun',
        },
        {
          'soal': 'Kebaya Jawa biasanya dipadukan dengan?',
          'gambar': null,
          'pilihan': ['Sarung batik', 'Jeans', 'Celana pendek', 'Jaket kulit'],
          'jawaban': 'Sarung batik',
        },
      ],

      // ── Level 2: Kebaya Encim ──
      [
        {
          'soal': 'Kebaya Encim berasal dari budaya?',
          'gambar': null,
          'pilihan': ['Betawi', 'Toraja', 'Bugis', 'Aceh'],
          'jawaban': 'Betawi',
        },
        {
          'soal': 'Kebaya Encim mendapat pengaruh budaya?',
          'gambar': null,
          'pilihan': ['Arab', 'India', 'Tionghoa', 'Jepang'],
          'jawaban': 'Tionghoa',
        },
        {
          'soal': 'Ciri khas Kebaya Encim adalah?',
          'gambar': null,
          'pilihan': [
            'Bordir berwarna cerah',
            'Berwarna hitam polos',
            'Terbuat dari kulit kayu',
            'Menggunakan bulu burung',
          ],
          'jawaban': 'Bordir berwarna cerah',
        },
      ],

      // ── Level 3: Payas Agung ──
      [
        {
          'soal': 'Payas Agung berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Bali', 'Papua', 'Riau', 'Bengkulu'],
          'jawaban': 'Bali',
        },
        {
          'soal': 'Payas Agung biasanya digunakan pada acara?',
          'gambar': null,
          'pilihan': [
            'Pernikahan adat Bali',
            'Olahraga',
            'Sekolah',
            'Berkebun',
          ],
          'jawaban': 'Pernikahan adat Bali',
        },
        {
          'soal': 'Ciri khas Payas Agung adalah?',
          'gambar': null,
          'pilihan': [
            'Banyak hiasan emas',
            'Berwarna hitam polos',
            'Terbuat dari daun',
            'Menggunakan topi jerami',
          ],
          'jawaban': 'Banyak hiasan emas',
        },
      ],

      // ── Level 4: Ulos ──
      [
        {
          'soal': 'Ulos berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Sumatera Utara', 'Sulawesi Selatan', 'Papua', 'Bali'],
          'jawaban': 'Sumatera Utara',
        },
        {
          'soal': 'Ulos biasanya berbentuk?',
          'gambar': null,
          'pilihan': [
            'Kain tenun tradisional',
            'Topi adat',
            'Sepatu adat',
            'Celana adat',
          ],
          'jawaban': 'Kain tenun tradisional',
        },
        {
          'soal': 'Ulos sering digunakan dalam acara?',
          'gambar': null,
          'pilihan': ['Adat Batak', 'Olahraga', 'Panen raya', 'Perlombaan'],
          'jawaban': 'Adat Batak',
        },
      ],

      // ── Level 5: Baju Bodo ──
      [
        {
          'soal': 'Baju Bodo berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Sulawesi Selatan', 'Papua', 'Bali', 'Riau'],
          'jawaban': 'Sulawesi Selatan',
        },
        {
          'soal': 'Baju Bodo biasanya dikenakan oleh suku?',
          'gambar': null,
          'pilihan': ['Bugis', 'Batak', 'Asmat', 'Dayak'],
          'jawaban': 'Bugis',
        },
        {
          'soal': 'Bentuk lengan Baju Bodo adalah?',
          'gambar': null,
          'pilihan': [
            'Pendek dan lebar',
            'Panjang ketat',
            'Tanpa lengan',
            'Berumbai',
          ],
          'jawaban': 'Pendek dan lebar',
        },
      ],

      // ── Level 6: Koteka ──
      [
        {
          'soal': 'Koteka merupakan pakaian adat dari daerah?',
          'gambar': null,
          'pilihan': ['Papua', 'Aceh', 'Jawa Barat', 'Maluku'],
          'jawaban': 'Papua',
        },
        {
          'soal': 'Koteka dibuat dari bahan?',
          'gambar': null,
          'pilihan': ['Labu air kering', 'Kulit sapi', 'Bambu', 'Daun pisang'],
          'jawaban': 'Labu air kering',
        },
        {
          'soal': 'Koteka digunakan oleh suku pedalaman di?',
          'gambar': null,
          'pilihan': ['Papua', 'Sulawesi', 'Sumatera', 'Jawa'],
          'jawaban': 'Papua',
        },
      ],

      // ── Level 7: Cele ──
      [
        {
          'soal': 'Pakaian adat Cele berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Maluku', 'Aceh', 'Kalimantan', 'Lampung'],
          'jawaban': 'Maluku',
        },
        {
          'soal': 'Motif pakaian Cele biasanya berbentuk?',
          'gambar': null,
          'pilihan': [
            'Kotak-kotak kecil',
            'Polos',
            'Motif hewan',
            'Garis panjang',
          ],
          'jawaban': 'Kotak-kotak kecil',
        },
        {
          'soal': 'Cele sering digunakan saat?',
          'gambar': null,
          'pilihan': ['Upacara adat', 'Tidur', 'Bertani', 'Memancing'],
          'jawaban': 'Upacara adat',
        },
      ],

      // ── Level 8: Baju Kurung ──
      [
        {
          'soal': 'Baju Kurung berasal dari budaya?',
          'gambar': null,
          'pilihan': ['Melayu', 'Papua', 'Dayak', 'Bali'],
          'jawaban': 'Melayu',
        },
        {
          'soal': 'Baju Kurung memiliki bentuk yang?',
          'gambar': null,
          'pilihan': ['Longgar dan sopan', 'Ketat', 'Pendek', 'Tanpa lengan'],
          'jawaban': 'Longgar dan sopan',
        },
        {
          'soal': 'Baju Kurung sering digunakan dalam acara?',
          'gambar': null,
          'pilihan': ['Adat Melayu', 'Balapan', 'Renang', 'Mendaki gunung'],
          'jawaban': 'Adat Melayu',
        },
      ],

      // ── Level 9: Ulee Balang ──
      [
        {
          'soal': 'Ulee Balang berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Aceh', 'Jawa Tengah', 'Bali', 'Papua'],
          'jawaban': 'Aceh',
        },
        {
          'soal': 'Ulee Balang biasanya digunakan pada acara?',
          'gambar': null,
          'pilihan': [
            'Olahraga',
            'Upacara adat dan pernikahan',
            'Tidur',
            'Berkebun',
          ],
          'jawaban': 'Upacara adat dan pernikahan',
        },
        {
          'soal': 'Warna yang sering digunakan pada Ulee Balang adalah?',
          'gambar': null,
          'pilihan': ['Hitam dan emas', 'Hijau neon', 'Abu-abu', 'Putih polos'],
          'jawaban': 'Hitam dan emas',
        },
      ],

      // ── Level 10: Bundo Kanduang ──
      [
        {
          'soal': 'Bundo Kanduang berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Papua', 'Sumatera Barat', 'Kalimantan', 'Maluku'],
          'jawaban': 'Sumatera Barat',
        },
        {
          'soal': 'Bundo Kanduang identik dengan budaya?',
          'gambar': null,
          'pilihan': ['Betawi', 'Minangkabau', 'Dayak', 'Bugis'],
          'jawaban': 'Minangkabau',
        },
        {
          'soal': 'Ciri khas Bundo Kanduang adalah penggunaan?',
          'gambar': null,
          'pilihan': [
            'Penutup kepala khas Minang',
            'Topi jerami',
            'Mahkota bulu',
            'Rompi kulit',
          ],
          'jawaban': 'Penutup kepala khas Minang',
        },
      ],
    ],
    'Alat Musik Tradisional': [
      // ── Level 1: Angklung ──
      [
        {
          'soal': 'Angklung berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Jawa Barat', 'Bali', 'Papua', 'Aceh'],
          'jawaban': 'Jawa Barat',
        },
        {
          'soal': 'Angklung dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Digesek', 'Ditiup', 'Digoyangkan'],
          'jawaban': 'Digoyangkan',
        },
        {
          'soal': 'Angklung terbuat dari bahan?',
          'gambar': null,
          'pilihan': ['Kayu jati', 'Bambu', 'Kulit hewan', 'Logam'],
          'jawaban': 'Bambu',
        },
      ],

      // ── Level 2: Gamelan ──
      [
        {
          'soal': 'Gamelan berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Jawa dan Bali', 'Papua', 'Aceh', 'Maluku'],
          'jawaban': 'Jawa dan Bali',
        },
        {
          'soal': 'Gamelan dimainkan secara?',
          'gambar': null,
          'pilihan': ['Perorangan', 'Kelompok', 'Sendiri', 'Bergantian'],
          'jawaban': 'Kelompok',
        },
        {
          'soal': 'Alat musik gamelan banyak terbuat dari?',
          'gambar': null,
          'pilihan': ['Bambu', 'Kulit', 'Logam', 'Kaca'],
          'jawaban': 'Logam',
        },
      ],

      // ── Level 3: Sasando ──
      [
        {
          'soal': 'Sasando berasal dari daerah?',
          'gambar': null,
          'pilihan': ['NTT', 'Papua', 'Jawa Timur', 'Aceh'],
          'jawaban': 'NTT',
        },
        {
          'soal': 'Sasando dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Dipetik', 'Ditiup', 'Digesek'],
          'jawaban': 'Dipetik',
        },
        {
          'soal': 'Bagian khas Sasando terbuat dari?',
          'gambar': null,
          'pilihan': ['Daun lontar', 'Bambu', 'Kulit kayu', 'Tanah liat'],
          'jawaban': 'Daun lontar',
        },
      ],

      // ── Level 4: Kolintang ──
      [
        {
          'soal': 'Kolintang berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Sulawesi Utara', 'Maluku', 'Papua', 'Sumatera Barat'],
          'jawaban': 'Sulawesi Utara',
        },
        {
          'soal': 'Kolintang dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Dipetik', 'Ditiup', 'Digesek'],
          'jawaban': 'Dipukul',
        },
        {
          'soal': 'Kolintang biasanya terbuat dari?',
          'gambar': null,
          'pilihan': ['Besi', 'Bambu', 'Kayu', 'Kulit'],
          'jawaban': 'Kayu',
        },
      ],

      // ── Level 5: Tifa ──
      [
        {
          'soal': 'Tifa berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Papua', 'Jawa Barat', 'Bali', 'Aceh'],
          'jawaban': 'Papua',
        },
        {
          'soal': 'Tifa dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Dipetik', 'Digoyangkan', 'Ditiup'],
          'jawaban': 'Dipukul',
        },
        {
          'soal': 'Tifa termasuk jenis alat musik?',
          'gambar': null,
          'pilihan': ['Petik', 'Tiup', 'Perkusi', 'Gesek'],
          'jawaban': 'Perkusi',
        },
      ],

      // ── Level 6: Serunai ──
      [
        {
          'soal': 'Serunai berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Sumatera Barat', 'Papua', 'Banten', 'Maluku'],
          'jawaban': 'Sumatera Barat',
        },
        {
          'soal': 'Serunai dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Dipetik', 'Ditiup', 'Digoyangkan'],
          'jawaban': 'Ditiup',
        },
        {
          'soal': 'Serunai termasuk alat musik?',
          'gambar': null,
          'pilihan': ['Tiup', 'Petik', 'Gesek', 'Perkusi'],
          'jawaban': 'Tiup',
        },
      ],

      // ── Level 7: Gendang ──
      [
        {
          'soal': 'Gendang dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Dipetik', 'Ditiup', 'Digesek'],
          'jawaban': 'Dipukul',
        },
        {
          'soal': 'Gendang termasuk alat musik?',
          'gambar': null,
          'pilihan': ['Petik', 'Tiup', 'Perkusi', 'Gesek'],
          'jawaban': 'Perkusi',
        },
        {
          'soal': 'Bagian permukaan gendang biasanya terbuat dari?',
          'gambar': null,
          'pilihan': ['Kulit hewan', 'Bambu', 'Besi', 'Kaca'],
          'jawaban': 'Kulit hewan',
        },
      ],

      // ── Level 8: Celempung ──
      [
        {
          'soal': 'Celempung berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Jawa Barat', 'Papua', 'Maluku', 'Aceh'],
          'jawaban': 'Jawa Barat',
        },
        {
          'soal': 'Celempung dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipetik', 'Dipukul', 'Ditiup', 'Digesek'],
          'jawaban': 'Dipetik',
        },
        {
          'soal': 'Celempung termasuk alat musik?',
          'gambar': null,
          'pilihan': ['Petik', 'Tiup', 'Perkusi', 'Gesek'],
          'jawaban': 'Petik',
        },
      ],

      // ── Level 9: Talempong ──
      [
        {
          'soal': 'Talempong berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Sumatera Barat', 'Papua', 'Bali', 'Aceh'],
          'jawaban': 'Sumatera Barat',
        },
        {
          'soal': 'Talempong dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Dipetik', 'Ditiup', 'Digesek'],
          'jawaban': 'Dipukul',
        },
        {
          'soal': 'Talempong banyak digunakan dalam budaya?',
          'gambar': null,
          'pilihan': ['Minangkabau', 'Batak', 'Dayak', 'Bugis'],
          'jawaban': 'Minangkabau',
        },
      ],

      // ── Level 10: Saluang ──
      [
        {
          'soal': 'Saluang berasal dari daerah?',
          'gambar': null,
          'pilihan': ['Sumatera Barat', 'Papua', 'Aceh', 'Maluku'],
          'jawaban': 'Sumatera Barat',
        },
        {
          'soal': 'Saluang dimainkan dengan cara?',
          'gambar': null,
          'pilihan': ['Dipukul', 'Dipetik', 'Ditiup', 'Digesek'],
          'jawaban': 'Ditiup',
        },
        {
          'soal': 'Saluang terbuat dari bahan?',
          'gambar': null,
          'pilihan': ['Bambu', 'Logam', 'Kulit', 'Kaca'],
          'jawaban': 'Bambu',
        },
      ],
    ],
  };

  /// Total level yang tersedia — digunakan untuk cek level terakhir
  static int get totalLevel => _soalPerKategori.length;

  void _loadSoal() {
    final soalKategori = _soalPerKategori[kategoriNama.value] ?? [];
    final index = currentLevel.value - 1;
    if (index >= 0 && index < soalKategori.length) {
      soalList.value = soalKategori[index]
          .map((s) => Map<String, dynamic>.from(s as Map))
          .toList();
      totalSoal.value = soalList.length;
    }
  }

  void _startTimer() {
    timeLeft.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        _timer?.cancel();
        answerSoal(''); // waktu habis = jawaban salah
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void answerSoal(String jawaban) {
    if (isAnswered.value) return;

    _stopTimer();
    isAnswered.value = true;
    selectedAnswer.value = jawaban;

    final waktuMenjawab = 30 - timeLeft.value;
    totalWaktu.value += waktuMenjawab;

    final benar =
        jawaban.isNotEmpty &&
        soalList[currentIndex.value]['jawaban'] == jawaban;

    final jawabanBenar = soalList[currentIndex.value]['jawaban'] as String;

    if (benar) {
      jumlahBenar.value++;
      streak.value++;
      if (streak.value > maxStreak.value) {
        maxStreak.value = streak.value;
      }
      int poinSoal = _hitungPoinSoal(waktuMenjawab);
      if (isDoublePointUsed.value) poinSoal *= 2;
      score.value += poinSoal;
    } else {
      streak.value = 0;
    }

    Future.delayed(const Duration(milliseconds: 1500), () {
      _showResult(benar, jawabanBenar);
    });
  }

  int _hitungPoinSoal(int waktu) {
    if (waktu <= 5) return 100;
    if (waktu <= 10) return 80;
    if (waktu <= 15) return 60;
    if (waktu <= 20) return 40;
    return 20;
  }

  int _hitungBintang() {
    final rataWaktu = totalWaktu.value / totalSoal.value;
    if (rataWaktu <= 8) return 3;
    if (rataWaktu <= 15) return 2;
    return 1;
  }

  void nextSoal() {
    _stopTimer();
    if (currentIndex.value < soalList.length - 1) {
      currentIndex.value++;
      isAnswered.value = false;
      selectedAnswer.value = '';
      hiddenOptions.clear();
      isDoublePointUsed.value = false;
      _startTimer();
    } else {
      _showStatistik();
    }
  }

  void use5050() {
    if (is5050Used.value || isAnswered.value) return;
    is5050Used.value = true;
    final jawaban = soalList[currentIndex.value]['jawaban'];
    final pilihan = List<String>.from(soalList[currentIndex.value]['pilihan']);
    final salah = pilihan.where((p) => p != jawaban).toList();
    salah.shuffle();
    hiddenOptions.value = [salah[0], salah[1]];
  }

  void useDoublePoint() {
    if (isDoublePointUsed.value || isAnswered.value) return;
    isDoublePointUsed.value = true;
  }

  void _showResult(bool benar, String jawabanBenar) {
    _stopTimer();

    // Tentukan label tombol: soal terakhir di level → "Lihat Hasil"
    final isLastSoal = currentIndex.value >= soalList.length - 1;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                benar ? Icons.check_circle : Icons.cancel,
                color: benar ? Colors.green : Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                benar ? 'Benar!' : 'Salah!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: benar ? Colors.green : Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                benar
                    ? 'Jawaban kamu tepat!'
                    : selectedAnswer.value.isEmpty
                    ? 'Waktu habis! Jawaban: $jawabanBenar'
                    : 'Jawaban yang benar:\n$jawabanBenar',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 6),
              // Indikator soal ke-berapa
              Text(
                'Soal ${currentIndex.value + 1} dari ${soalList.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    nextSoal();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: benar
                        ? Colors.green
                        : const Color(0xFF6A5041),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isLastSoal ? 'Lihat Hasil' : 'Soal Berikutnya',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showStatistik() async {
    final bintang = _hitungBintang();
    await _dataQuiz();
    await _dataStatistik();

    try {
  final dailyQuizController = Get.find<DailyQuizController>();
  await dailyQuizController.refreshQuestProgress();
} catch (_) {

}

    final prefs = await SharedPreferences.getInstance();
    final key = 'levelData_${kategoriNama.value}';
    final saved = prefs.getString(key);

    if (saved != null) {
      final list = List<Map<String, dynamic>>.from(
        (jsonDecode(saved) as List).map((e) => Map<String, dynamic>.from(e)),
      );

      final index = list.indexWhere((l) => l['level'] == currentLevel.value);
      if (index != -1) {
        // Simpan bintang terbaik (tidak overwrite kalau sebelumnya lebih tinggi)
        final bintangLama = (list[index]['bintang'] as int?) ?? 0;
        list[index] = {
          ...list[index],
          'selesai': true,
          'bintang': bintang > bintangLama ? bintang : bintangLama,
          'unlocked': true,
        };
        // Unlock level berikutnya
        if (index + 1 < list.length) {
          list[index + 1] = {...list[index + 1], 'unlocked': true};
        }
      }
      await prefs.setString(key, jsonEncode(list));
      print('=== Saved to SharedPreferences: $key');
    } else {
      print('=== saved null, tidak bisa update');
    }

    final isLastLevel = currentLevel.value >= totalLevel;

    await ContinueController.saveLastPlay(
      kategoriNama: kategoriNama.value,
      kategoriDeskripsi: kategoriDeskripsi.value,
      kategoriImage: kategoriImage.value,
      kategoriWarna: kategoriWarna.value,
      level: currentLevel.value,
      levelNama: soalList.isNotEmpty
          ? (soalList[0]['jawaban'] as String? ?? '')
          : '',
      bintang: bintang,
      selesai: true,
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bintang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return Icon(
                    Icons.star,
                    size: 40,
                    color: i < bintang ? Colors.amber : Colors.grey.shade300,
                  );
                }),
              ),
              const SizedBox(height: 16),
              Text(
                isLastLevel ? 'Semua Level Selesai!' : 'Level Selesai!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),

              // Statistik
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildStatRow(
                      Icons.star,
                      'Total Poin',
                      '${score.value} Poin',
                      Colors.amber,
                    ),
                    const Divider(),
                    _buildStatRow(
                      Icons.check_circle,
                      'Jawaban Benar',
                      '${jumlahBenar.value} / ${soalList.length}',
                      Colors.green,
                    ),
                    const Divider(),
                    _buildStatRow(
                      Icons.timer,
                      'Rata-rata Waktu',
                      '${(totalWaktu.value / totalSoal.value).toStringAsFixed(1)} detik',
                      Colors.blue,
                    ),
                    const Divider(),
                    _buildStatRow(
                      Icons.local_fire_department,
                      'Max Streak',
                      '${maxStreak.value}x berturutan',
                      Colors.orange,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed(
                          '/game-level',
                          arguments: {
                            'nama': kategoriNama.value,
                            'deskripsi': kategoriDeskripsi.value,
                            'image': kategoriImage.value,
                            'warna': kategoriWarna.value,
                          },
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6A5041)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          color: Color(0xFF6A5041),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();

                        if (isLastLevel) {
                          // Level terakhir → kembali ke halaman level
                          Get.offAllNamed(
                            '/game-level',
                            arguments: {
                              'nama': kategoriNama.value,
                              'deskripsi': kategoriDeskripsi.value,
                              'image': kategoriImage.value,
                              'warna': kategoriWarna.value,
                            },
                          );
                        } else {
                          // Reset state & muat level berikutnya
                          currentLevel.value++;
                          currentIndex.value = 0;
                          selectedAnswer.value = '';
                          isAnswered.value = false;
                          hiddenOptions.clear();
                          isDoublePointUsed.value = false;
                          is5050Used.value = false;
                          score.value = 0;
                          jumlahBenar.value = 0;
                          streak.value = 0;
                          maxStreak.value = 0;
                          totalWaktu.value = 0;
                          _loadSoal();
                          _startTimer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A5041),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isLastLevel ? 'Selesai' : 'Level Berikutnya',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _dataQuiz() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      final doc = await docRef.get();

      if (doc.exists) {
        final poinLama = (doc.data()?['points'] ?? 0) as int;
        await docRef.update({'points': poinLama + score.value});
      } else {
        // Kalau dokumen belum ada, buat baru
        await docRef.set({
          'name': user.displayName ?? 'Pengguna',
          'email': user.email ?? '',
          'points': score.value,
        });
      }
      print('=== Poin berhasil disimpan: ${score.value}');
    } catch (e) {
      print('=== Error simpan poin: $e');
    }
  }

  Future<void> _dataStatistik() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final prefs = await SharedPreferences.getInstance();

      // Akumulasi lokal saja
      final totalBenarLama = prefs.getInt('total_benar') ?? 0;
      final totalSoalLama = prefs.getInt('total_soal') ?? 0;
      final totalWaktuLama = prefs.getInt('total_waktu') ?? 0;
      final totalQuizLama = prefs.getInt('total_quiz') ?? 0;
      final maxStreakLama = prefs.getInt('max_streak') ?? 0;

      await prefs.setInt(
        'stat_total_benar',
        totalBenarLama + jumlahBenar.value,
      );
      await prefs.setInt('stat_total_soal', totalSoalLama + soalList.length);
      await prefs.setInt('stat_total_waktu', totalWaktuLama + totalWaktu.value);
      await prefs.setInt('stat_total_quiz', totalQuizLama + 1);
      await prefs.setInt(
        'stat_max_streak',
        maxStreak.value > maxStreakLama ? maxStreak.value : maxStreakLama,
      );

      // Streak harian (lokal)
      final today = DateTime.now();
      final todayStr = '${today.year}-${today.month}-${today.day}';
      final lastDateStr = prefs.getString('last_play_date');
      int currentStreak = prefs.getInt('current_streak') ?? 0;
      int longestStreak = prefs.getInt('longest_streak') ?? 0;

      if (lastDateStr == null) {
        currentStreak = 1;
      } else if (lastDateStr != todayStr) {
        final lastDate = DateTime.parse(lastDateStr);
        final diff = today.difference(lastDate).inDays;
        currentStreak = diff == 1 ? currentStreak + 1 : 1;
      }

      if (currentStreak > longestStreak) longestStreak = currentStreak;

      await prefs.setString('last_play_date', todayStr);
      await prefs.setInt('current_streak', currentStreak);
      await prefs.setInt('longest_streak', longestStreak);

      // Firestore — hanya field yang kamu mau
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      await docRef.update({'last_play_date': todayStr});

      print('=== Statistik lokal & last_play_date Firestore tersimpan');
    } catch (e) {
      print('=== Error simpan statistik: $e');
    }
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }
}
