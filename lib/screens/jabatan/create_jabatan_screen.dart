import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/jabatan.dart';
import '../../providers/jabatan_provider.dart';

class CreateJabatanScreen extends StatefulWidget {
  const CreateJabatanScreen({super.key});

  @override
  State<CreateJabatanScreen> createState() => _CreateJabatanScreenState();
}

class _CreateJabatanScreenState extends State<CreateJabatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaJabatanController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _namaJabatanController.dispose();
    super.dispose();
  }

  Future<void> _createJabatan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final request = CreateJabatanRequest(
        namaJabatan: _namaJabatanController.text.trim(),
      );

      final jabatanProvider =
          Provider.of<JabatanProvider>(context, listen: false);
      final success = await jabatanProvider.createJabatan(request);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Jabatan berhasil dibuat'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Gagal membuat jabatan: ${jabatanProvider.errorMessage}'),
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
        title: const Text('Tambah Jabatan'),
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
                onFieldSubmitted: (_) => _createJabatan(),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _createJabatan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
                          'Simpan',
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
