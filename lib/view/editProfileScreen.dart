import 'package:flutter/material.dart';
import 'package:e_commerce/controller/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController bioController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController birthDateController;

  final List<String> genderOptions = ['Pria', 'Wanita', 'Lainnya'];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    bioController = TextEditingController();
    phoneController = TextEditingController();
    genderController = TextEditingController();
    birthDateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context).user;

    nameController.text = user.name;
    bioController.text = user.bio;
    phoneController.text = user.phoneNumber;
    genderController.text = user.gender;
    birthDateController.text = _formatDateForDisplay(user.birthDate);
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    genderController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  String _formatDateForDisplay(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return "${dt.day.toString().padLeft(2, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.year}";
    } catch (e) {
      return isoDate;
    }
  }

  String _formatDateForSave(String displayDate) {
    try {
      final parts = displayDate.split('-');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final dt = DateTime(year, month, day);
        return dt.toIso8601String().split('T').first;
      }
      return displayDate;
    } catch (e) {
      return displayDate;
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal lahir wajib diisi';
    }
    final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!regex.hasMatch(value)) {
      return 'Format tanggal harus dd-MM-yyyy';
    }
    try {
      final parts = value.split('-');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      final dt = DateTime(year, month, day);
      if (dt.year != year || dt.month != month || dt.day != day) {
        return 'Tanggal lahir tidak valid';
      }
      if (dt.isAfter(DateTime.now())) {
        return 'Tanggal lahir tidak boleh di masa depan';
      }
    } catch (e) {
      return 'Tanggal lahir tidak valid';
    }
    return null;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<UserProvider>(context, listen: false);
      final updatedUser = provider.user.copyWith(
        name: nameController.text.trim(),
        bio: bioController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        gender: genderController.text.trim(),
        birthDate: _formatDateForSave(birthDateController.text.trim()),
      );

      provider.updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );

      Navigator.pop(context);
    }
  }

  Future<void> _selectDate() async {
    DateTime initialDate;

    try {
      initialDate = DateTime.parse(
        _formatDateForSave(birthDateController.text),
      );
    } catch (_) {
      initialDate = DateTime(2000, 1, 1);
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthDateController.text =
            "${pickedDate.day.toString().padLeft(2, '0')}-"
            "${pickedDate.month.toString().padLeft(2, '0')}-"
            "${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nama wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Bio wajib diisi'
                            : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Nomor HP'),
                keyboardType: TextInputType.phone,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Nomor HP wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value:
                    genderController.text.isNotEmpty
                        ? genderController.text
                        : null,
                items:
                    genderOptions
                        .map(
                          (gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ),
                        )
                        .toList(),
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      genderController.text = value;
                    });
                  }
                },
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Pilih jenis kelamin'
                            : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: birthDateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: _selectDate,
                validator: _validateDate,
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
