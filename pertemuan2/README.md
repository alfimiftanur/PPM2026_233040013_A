# Pertemuan 2 — Layout, Navigation & Widget Lanjutan

> **Mata Kuliah:** Praktikum Pemrograman Mobile  
> **NIM:** 233040013  
> **Nama:** Alfi Mifta Nurhakim  
> **Semester:** 6

---

## 📁 Struktur Folder

```
pertemuan2/
└── profile_page/           # Project Flutter — Halaman Profil Lengkap
    ├── lib/
    │   └── main.dart       # Entry point + seluruh widget aplikasi
    └── pubspec.yaml
```

---

## 🚀 Cara Menjalankan

Pastikan Flutter SDK sudah terinstall di komputer kamu. Cek dengan:

```bash
flutter --version
```

### Menjalankan project:

```bash
cd profile_page

# Install dependencies
flutter pub get

# Jalankan aplikasi
flutter run
```

---

## 📝 Materi Pertemuan 2

- **Layout lanjutan:** `SingleChildScrollView`, `Row`, `Column`, `Stack`, `Wrap`, `GridView`
- **Navigation:** `Drawer`, `BottomNavigationBar`, `Navigator.push`, `MaterialPageRoute`
- **Widget interaktif:** `AppBar` dengan actions, `FloatingActionButton`
- **Widget input:** `TextField`, `Checkbox`, `Switch`, `Slider`, `DropdownButton`
- **Widget feedback:** `SnackBar`, `AlertDialog`, `LinearProgressIndicator`, `CircularProgressIndicator`
- **Widget display:** `Card`, `ListTile`, `Chip`, `CircleAvatar`, `Divider`

---

## 📱 Fitur Aplikasi `profile_page`

Aplikasi halaman profil lengkap dengan:

| Fitur | Keterangan |
|---|---|
| 🧑 Header Profil | Avatar, nama, dan jabatan |
| 📊 Statistik | Post, Teman, Like dalam baris |
| 📋 Info Sections | Tentang Saya, Pendidikan, Hobi, Kontak |
| 🗂️ Drawer | Menu navigasi samping |
| 🔽 Bottom Nav Bar | Navigasi bawah 4 tab |
| ➕ FAB | Floating Action Button edit |
| 🗃️ Widget Gallery | Demo 5 kategori widget Flutter |
