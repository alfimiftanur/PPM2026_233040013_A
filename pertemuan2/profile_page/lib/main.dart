import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7B61FF)),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

// ===================== MODEL =====================

class Experience {
  String title;
  String description;
  Uint8List? image;
  Experience({required this.title, required this.description, this.image});
}

// ===================== PROFILE PAGE =====================

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _profileImage;
  String _name = 'Alfi Mifta Nurhakim';
  String _about = 'Mahasiswa Teknik Informatika';
  String _education = 'Universitas Pasundan - Semester 6';
  String _location = 'Bandung, Jawa Barat';
  String _contact = 'alfi@unpas.ac.id.com';
  final List<String> _skills = ['Flutter', 'Dart', 'Java', 'Python', 'Git', 'laravel'];
  final List<Experience> _experiences = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Row(
              children: const [
                Expanded(child: _StatBox(label: 'Post', value: '1')),
                Expanded(child: _StatBox(label: 'Teman', value: '128')),
                Expanded(child: _StatBox(label: 'Like', value: '999K')),
              ],
            ),
            const SizedBox(height: 24),
            _SectionCard(icon: Icons.info_outline, title: 'Tentang', content: _about),
            _SectionCard(icon: Icons.school, title: 'Pendidikan', content: _education),
            _SectionCard(icon: Icons.location_on, title: 'Lokasi', content: _location),
            _SectionCard(icon: Icons.email, title: 'Kontak', content: _contact),
            _buildSkillsCard(),
            if (_experiences.isNotEmpty) _buildExperiencesCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToEditProfile,
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profil'),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5C4EE5), Color(0xFF9C85FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Menu Utama',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: const Text('Widget Gallery'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Upload Pengalaman'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UploadPengalamanPage(
                    onSave: (exp) => setState(() => _experiences.add(exp)),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: _profileImage != null ? MemoryImage(_profileImage!) : null,
          backgroundColor: Colors.grey.shade300,
          child: _profileImage == null
              ? const Icon(Icons.person, size: 50, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 12),
        Text(_name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(_about,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSkillsCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Skills',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _skills.map((s) => Chip(label: Text(s))).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExperiencesCard() {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.work_outline, color: Colors.blue, size: 28),
                const SizedBox(width: 16),
                const Text('Pengalaman',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_experiences.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._experiences.map((exp) => _ExperienceItem(experience: exp)),
          ],
        ),
      ),
    );
  }

  Future<void> _goToEditProfile() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: _name,
          about: _about,
          education: _education,
          location: _location,
          contact: _contact,
          profileImage: _profileImage,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _name = result['name'] as String? ?? _name;
        _about = result['about'] as String? ?? _about;
        _education = result['education'] as String? ?? _education;
        _location = result['location'] as String? ?? _location;
        _contact = result['contact'] as String? ?? _contact;
        if (result.containsKey('image')) {
          _profileImage = result['image'] as Uint8List?;
        }
      });
    }
  }
}

// ===================== EDIT PROFILE PAGE =====================

class EditProfilePage extends StatefulWidget {
  final String name;
  final String about;
  final String education;
  final String location;
  final String contact;
  final Uint8List? profileImage;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.about,
    required this.education,
    required this.location,
    required this.contact,
    this.profileImage,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _aboutCtrl;
  late final TextEditingController _educationCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _contactCtrl;
  Uint8List? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _aboutCtrl = TextEditingController(text: widget.about);
    _educationCtrl = TextEditingController(text: widget.education);
    _locationCtrl = TextEditingController(text: widget.location);
    _contactCtrl = TextEditingController(text: widget.contact);
    _profileImage = widget.profileImage;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _aboutCtrl.dispose();
    _educationCtrl.dispose();
    _locationCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _profileImage = bytes);
    }
  }

  void _save() {
    Navigator.pop(context, {
      'name': _nameCtrl.text.trim(),
      'about': _aboutCtrl.text.trim(),
      'education': _educationCtrl.text.trim(),
      'location': _locationCtrl.text.trim(),
      'contact': _contactCtrl.text.trim(),
      'image': _profileImage,
    });
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF5C4EE5);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.check),
            label: const Text('Simpan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Foto Profil',
              style: TextStyle(
                  fontSize: 16, color: accent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? MemoryImage(_profileImage!)
                        : null,
                    backgroundColor: Colors.grey.shade300,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Ganti Foto dari Galeri'),
            ),
            const Divider(height: 32),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Informasi Profil',
                style: TextStyle(
                    fontSize: 16, color: accent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _aboutCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio / Tentang',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.info_outline),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _educationCtrl,
              decoration: const InputDecoration(
                labelText: 'Pendidikan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _locationCtrl,
              decoration: const InputDecoration(
                labelText: 'Lokasi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contactCtrl,
              decoration: const InputDecoration(
                labelText: 'Kontak',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Perubahan'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3D3D8F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== UPLOAD PENGALAMAN PAGE =====================

class UploadPengalamanPage extends StatefulWidget {
  final void Function(Experience) onSave;

  const UploadPengalamanPage({super.key, required this.onSave});

  @override
  State<UploadPengalamanPage> createState() => _UploadPengalamanPageState();
}

class _UploadPengalamanPageState extends State<UploadPengalamanPage> {
  Uint8List? _image;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _image = bytes);
    }
  }

  void _save() {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }
    widget.onSave(Experience(
      title: title,
      description: _descCtrl.text.trim(),
      image: _image,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF5C4EE5);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Pengalaman'),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Simpan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EEFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: accent.withOpacity(0.3)),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(_image!, fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 48, color: accent),
                          SizedBox(height: 8),
                          Text('Ketuk untuk pilih gambar',
                              style: TextStyle(color: accent)),
                          SizedBox(height: 4),
                          Text('dari galeri perangkat kamu',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Informasi Pengalaman',
              style: TextStyle(
                  fontSize: 16, color: accent, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Pengalaman'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF3D3D8F),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== SHARED WIDGETS =====================

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _SectionCard(
      {required this.icon, required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceItem extends StatelessWidget {
  final Experience experience;
  const _ExperienceItem({required this.experience});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: experience.image != null
                ? Image.memory(experience.image!,
                    width: 60, height: 60, fit: BoxFit.cover)
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(experience.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                if (experience.description.isNotEmpty)
                  Text(
                    experience.description,
                    style: TextStyle(
                        color: Colors.grey.shade600, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== GALLERY HOME (existing) =====================

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CategoryPage(name: name))),
            ),
          );
        },
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  final String name;
  const CategoryPage({super.key, required this.name});
  @override
  Widget build(BuildContext context) {
    final body = switch (name) {
      'Display' => const _DisplayDemo(),
      'Input' => const _InputDemo(),
      'Button' => const _ButtonDemo(),
      'Feedback' => const _FeedbackDemo(),
      'Layout' => const _LayoutDemo(),
      _ => const Center(child: Text('?')),
    };
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(
          child: ListTile(
            leading: Icon(Icons.album),
            title: Text('Judul Item'),
            subtitle: Text('Sub-judul'),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: const [
            Chip(label: Text('Flutter')),
            Chip(label: Text('Dart')),
            Chip(label: Text('Mobile')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
        const Divider(thickness: 2),
        const SizedBox(height: 16),
        const Text('CircleAvatar & Icon',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Row(children: const [
          CircleAvatar(child: Text('A')),
          SizedBox(width: 12),
          CircleAvatar(
              backgroundColor: Colors.green, child: Icon(Icons.check)),
          SizedBox(width: 12),
          Icon(Icons.star, color: Colors.amber, size: 40),
        ]),
      ],
    );
  }
}

class _InputDemo extends StatefulWidget {
  const _InputDemo();
  @override
  State<_InputDemo> createState() => _InputDemoState();
}

class _InputDemoState extends State<_InputDemo> {
  bool _checked = false;
  bool _switched = true;
  double _slider = 0.5;
  String? _dropdown = 'Apel';
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TextField'),
        const SizedBox(height: 4),
        const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nama',
            hintText: 'Ketik nama Anda',
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Checkbox'),
          value: _checked,
          onChanged: (v) => setState(() => _checked = v ?? false),
        ),
        SwitchListTile(
          title: const Text('Switch'),
          value: _switched,
          onChanged: (v) => setState(() => _switched = v),
        ),
        const Text('Slider'),
        Slider(value: _slider, onChanged: (v) => setState(() => _slider = v)),
        const SizedBox(height: 8),
        const Text('Dropdown'),
        DropdownButton<String>(
          value: _dropdown,
          items: ['Apel', 'Jeruk', 'Mangga']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => setState(() => _dropdown = v),
        ),
      ],
    );
  }
}

class _ButtonDemo extends StatelessWidget {
  const _ButtonDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
        const SizedBox(height: 8),
        FilledButton(onPressed: () {}, child: const Text('Filled')),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text('Text Button')),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.send),
          label: const Text('Dengan Icon'),
        ),
        const SizedBox(height: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite, color: Colors.red),
        ),
      ],
    );
  }
}

class _FeedbackDemo extends StatelessWidget {
  const _FeedbackDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Halo dari SnackBar!')),
            );
          },
          child: const Text('Tampilkan SnackBar'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text('Yakin ingin lanjut?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ya'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Tampilkan Dialog'),
        ),
        const SizedBox(height: 16),
        const Text('Progress Indicator:'),
        const SizedBox(height: 8),
        const LinearProgressIndicator(value: 0.6),
        const SizedBox(height: 12),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _LayoutDemo extends StatelessWidget {
  const _LayoutDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Stack — widget bertumpuk'),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: Stack(
            children: [
              Container(width: double.infinity, color: Colors.blue.shade100),
              Positioned(
                top: 12,
                left: 12,
                child: Container(width: 50, height: 50, color: Colors.red),
              ),
              const Positioned(
                bottom: 12,
                right: 12,
                child: Icon(Icons.star, size: 40, color: Colors.amber),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text('Wrap — auto-pindah baris saat penuh'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(
            8,
            (i) => Container(
              padding: const EdgeInsets.all(12),
              color: Colors.teal.shade100,
              child: Text('Item ${i + 1}'),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('GridView (count: 3)'),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: List.generate(
              6,
              (i) => Container(
                color: Colors.purple.shade100,
                alignment: Alignment.center,
                child: Text('${i + 1}'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
