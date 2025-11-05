import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/jabatan.dart';
import '../../providers/jabatan_provider.dart';

class EditJabatanScreen extends StatefulWidget {
  final Jabatan jabatan;

  const EditJabatanScreen({super.key, required this.jabatan});

  @override
  State<EditJabatanScreen> createState() => _EditJabatanScreenState();
}

class _EditJabatanScreenState extends State<EditJabatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaJabatanController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadJabatanData();
  }

  void _loadJabatanData() {
    _namaJabatanController.text = widget.jabatan.namaJabatan;
  }

  @override
  void dispose() {
    _namaJabatanController.dispose();
    super.dispose();
  }

  Future<void> _updateJabatan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final request = UpdateJabatanRequest(
        namaJabatan: _namaJabatanController.text.trim(),
      );

      final jabatanProvider =
          Provider.of<JabatanProvider>(context, listen: false);
      final success =
          await jabatanProvider.updateJabatan(widget.jabatan.id, request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jabatan berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Gagal memperbarui jabatan: ${jabatanProvider.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Jabatan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Jabatan
              TextFormField(
                controller: _namaJabatanController,
                decoration: const InputDecoration(
                  labelText: 'Nama Jabatan *',
                  hintText: 'Masukkan nama jabatan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama jabatan tidak boleh kosong';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _updateJabatan(),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _updateJabatan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
