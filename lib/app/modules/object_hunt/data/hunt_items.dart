/// Data model dan daftar benda target untuk fitur Detektif Benda
class HuntItem {
  final String id;
  final String nameId;     // Nama dalam Bahasa Indonesia
  final String nameEn;     // Label YOLO (bahasa Inggris, harus cocok dengan nama kelas COCO)
  final String emoji;
  final String description; // Petunjuk untuk anak
  final int xpReward;

  const HuntItem({
    required this.id,
    required this.nameId,
    required this.nameEn,
    required this.emoji,
    required this.description,
    this.xpReward = 20,
  });
}

/// Daftar 10 benda target yang bisa ditemukan di sekitar kelas/rumah
/// nameEn HARUS sesuai dengan nama kelas di model COCO YOLOv8
const List<HuntItem> huntItems = [
  HuntItem(
    id: 'chair',
    nameId: 'Kursi',
    nameEn: 'chair',
    emoji: '🪑',
    description: 'Tempat duduk yang ada di kelas atau ruang makan',
  ),
  HuntItem(
    id: 'bottle',
    nameId: 'Botol',
    nameEn: 'bottle',
    emoji: '🍶',
    description: 'Wadah minuman yang biasanya terbuat dari plastik atau kaca',
  ),
  HuntItem(
    id: 'book',
    nameId: 'Buku',
    nameEn: 'book',
    emoji: '📚',
    description: 'Benda untuk membaca dan belajar',
  ),
  HuntItem(
    id: 'cup',
    nameId: 'Cangkir / Gelas',
    nameEn: 'cup',
    emoji: '🥤',
    description: 'Tempat minum yang biasanya ada di dapur',
  ),
  HuntItem(
    id: 'backpack',
    nameId: 'Tas',
    nameEn: 'backpack',
    emoji: '🎒',
    description: 'Tas yang bisa dipakai di punggung',
  ),
  HuntItem(
    id: 'clock',
    nameId: 'Jam',
    nameEn: 'clock',
    emoji: '🕐',
    description: 'Alat untuk melihat waktu yang biasanya ada di dinding',
  ),
  HuntItem(
    id: 'laptop',
    nameId: 'Laptop',
    nameEn: 'laptop',
    emoji: '💻',
    description: 'Komputer tipis yang bisa dibawa ke mana-mana',
  ),
  HuntItem(
    id: 'scissors',
    nameId: 'Gunting',
    nameEn: 'scissors',
    emoji: '✂️',
    description: 'Alat untuk memotong kertas atau kain',
  ),
  HuntItem(
    id: 'dining table',
    nameId: 'Meja',
    nameEn: 'dining table',
    emoji: '🍽️',
    description: 'Tempat belajar, makan, atau bekerja',
  ),
  HuntItem(
    id: 'cell phone',
    nameId: 'Handphone',
    nameEn: 'cell phone',
    emoji: '📱',
    description: 'Alat komunikasi yang bisa digunakan untuk menelepon',
  ),
];
