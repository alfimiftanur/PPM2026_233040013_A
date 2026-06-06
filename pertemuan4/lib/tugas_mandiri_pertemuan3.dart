import 'package:flutter/material.dart';

void main() => runApp(const TugasMandiriApp());

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });
}

class TugasMandiriApp extends StatelessWidget {
  const TugasMandiriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Mandiri Pertemuan 3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            return MaterialPageRoute(
              builder: (_) => const TambahEditCatatanPage(),
            );
          case '/edit':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => TambahEditCatatanPage(catatanAwal: catatan),
            );
          case '/detail':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(
                catatan: args['catatan'] as Catatan,
                index: args['index'] as int,
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      emailPengirim: 'mahasiswa@kampus.ac.id',
      dibuatPada: DateTime.now(),
    ),
    Catatan(
      judul: 'Tugas Algoritma',
      isi: 'Kerjakan soal sorting dan searching dari buku referensi bab 5.',
      kategori: 'Tugas',
      emailPengirim: 'mahasiswa@kampus.ac.id',
      dibuatPada: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Catatan(
      judul: 'Jadwal Gym',
      isi: 'Senin, Rabu, Jumat — pukul 17.00.',
      kategori: 'Pribadi',
      emailPengirim: 'pribadi@email.com',
      dibuatPada: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  String _filterKategori = 'Semua';
  static const _filterOpsi = ['Semua', 'Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  List<Catatan> get _catatanFiltered => _filterKategori == 'Semua'
      ? _catatan
      : _catatan.where((c) => c.kategori == _filterKategori).toList();

  Future<void> _bukaTambah() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');
    if (!mounted) return;
    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan "${hasil.judul}" ditambahkan 🎉'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _bukaDetail(int index) async {
    final hasil = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: {'index': index, 'catatan': _catatan[index]},
    );
    if (!mounted) return;

    if (hasil is Map && hasil['action'] == 'edit') {
      setState(() {
        _catatan[hasil['index'] as int] = hasil['catatan'] as Catatan;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diperbarui ✏️'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _hapus(int index) {
    final judul = _catatan[index].judul;
    setState(() => _catatan.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$judul" dihapus'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatTanggal(DateTime dt) {
    const bulan = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${dt.day} ${bulan[dt.month]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _catatanFiltered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _filterKategori,
                borderRadius: BorderRadius.circular(12),
                icon: const Icon(Icons.filter_list),
                items: _filterOpsi
                    .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                    .toList(),
                onChanged: (v) => setState(() => _filterKategori = v!),
              ),
            ),
          ),
        ],
      ),
      body: filtered.isEmpty
          ? _EmptyState(isFiltered: _filterKategori != 'Semua')
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final c = filtered[i];
                final actualIndex = _catatan.indexOf(c);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      c.judul,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Chip(
                          label: Text(c.kategori),
                          padding: EdgeInsets.zero,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTanggal(c.dibuatPada),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      tooltip: 'Hapus catatan',
                      onPressed: () => _hapus(actualIndex),
                    ),
                    onTap: () => _bukaDetail(actualIndex),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _bukaTambah,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final bool isFiltered;
  const _EmptyState({this.isFiltered = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltered ? Icons.filter_list_off : Icons.inbox_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered
                ? 'Tidak ada catatan di kategori ini'
                : 'Belum ada catatan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            isFiltered
                ? 'Coba pilih kategori lain atau "Semua".'
                : 'Tekan tombol + Tambah untuk mulai mencatat.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DetailCatatanPage extends StatefulWidget {
  final Catatan catatan;
  final int index;
  const DetailCatatanPage({
    super.key,
    required this.catatan,
    required this.index,
  });

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  Future<void> _bukaEdit() async {
    final hasil = await Navigator.pushNamed(
      context,
      '/edit',
      arguments: widget.catatan,
    );
    if (!mounted) return;

    if (hasil is Catatan) {
      Navigator.pop(context, {
        'action': 'edit',
        'index': widget.index,
        'catatan': hasil,
      });
    }
  }

  String _formatTanggalLengkap(DateTime dt) {
    const namaBulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    final jam = dt.hour.toString().padLeft(2, '0');
    final menit = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${namaBulan[dt.month]} ${dt.year}, $jam:$menit';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.catatan;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit catatan ini',
            onPressed: _bukaEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.judul,
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  avatar: const Icon(Icons.label_outline, size: 16),
                  label: Text(c.kategori),
                  backgroundColor: colorScheme.secondaryContainer,
                  labelStyle:
                      TextStyle(color: colorScheme.onSecondaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatTanggalLengkap(c.dibuatPada),
                    style: textTheme.bodySmall
                        ?.copyWith(color: colorScheme.outline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email_outlined, size: 16, color: colorScheme.outline),
                const SizedBox(width: 6),
                Text(
                  c.emailPengirim,
                  style: textTheme.bodySmall
                      ?.copyWith(color: colorScheme.outline),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1),
            Text(c.isi, style: textTheme.bodyLarge?.copyWith(height: 1.6)),
            const SizedBox(height: 40),
            FilledButton.icon(
              onPressed: _bukaEdit,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Catatan'),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(48)),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48)),
            ),
          ],
        ),
      ),
    );
  }
}

class TambahEditCatatanPage extends StatefulWidget {
  final Catatan? catatanAwal;
  const TambahEditCatatanPage({super.key, this.catatanAwal});

  @override
  State<TambahEditCatatanPage> createState() => _TambahEditCatatanPageState();
}

class _TambahEditCatatanPageState extends State<TambahEditCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulCtrl;
  late final TextEditingController _isiCtrl;
  late final TextEditingController _emailCtrl;
  late String _kategori;

  bool get _isEditMode => widget.catatanAwal != null;

  static const _kategoriOpsi = ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];
  static final _emailRegex = RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w{2,}$');

  @override
  void initState() {
    super.initState();
    final c = widget.catatanAwal;
    _judulCtrl = TextEditingController(text: c?.judul ?? '');
    _isiCtrl = TextEditingController(text: c?.isi ?? '');
    _emailCtrl = TextEditingController(text: c?.emailPengirim ?? '');
    _kategori = c?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim(),
      dibuatPada:
          _isEditMode ? widget.catatanAwal!.dibuatPada : DateTime.now(),
    );

    Navigator.pop(context, catatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Catatan' : 'Tambah Catatan'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 64),
                  child: Icon(Icons.notes),
                ),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                hintText: 'contoh@email.com',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                if (!_emailRegex.hasMatch(v.trim())) {
                  return 'Format email tidak valid (contoh: nama@domain.com)';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save_outlined),
              label: Text(_isEditMode ? 'Simpan Perubahan' : 'Simpan Catatan'),
              style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52)),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close),
              label: const Text('Batal'),
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48)),
            ),
          ],
        ),
      ),
    );
  }
}
