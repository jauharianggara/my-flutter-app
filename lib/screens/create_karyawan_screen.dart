import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/karyawan.dart';
import '../providers/karyawan_provider.dart';
import '../services/dropdown_service.dart';
import '../services/karyawan_service.dart';

class CreateKaryawanScreen extends StatefulWidget {
  const CreateKaryawanScreen({super.key});

  @override
  State<CreateKaryawanScreen> createState() => _CreateKaryawanScreenState();
}

class _CreateKaryawanScreenState extends State<CreateKaryawanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonController = TextEditingController();
  final _gajiController = TextEditingController();

  List<Kantor> _kantors = [];
  List<Jabatan> _jabatans = [];
  int? _selectedKantorId;
  int? _selectedJabatanId;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    try {
      print('DEBUG: Loading dropdown data for create form');

      // Load dropdown data
      final kantorResponse = await KantorService.getAllKantors();
      print('DEBUG: Kantor response success: ${kantorResponse.success}');
      if (!kantorResponse.success) {
        print('DEBUG: Kantor error: ${kantorResponse.message}');
      }

      final jabatanResponse = await JabatanService.getAllJabatans();
      print('DEBUG: Jabatan response success: ${jabatanResponse.success}');
      if (!jabatanResponse.success) {
        print('DEBUG: Jabatan error: ${jabatanResponse.message}');
      }

      if (kantorResponse.success && jabatanResponse.success) {
        print('DEBUG: All API calls successful, setting state');
        setState(() {
          _kantors = kantorResponse.data ?? [];
          _jabatans = jabatanResponse.data ?? [];
          print(
              'DEBUG: Loaded ${_kantors.length} kantors and ${_jabatans.length} jabatans');
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        String errorDetails = '';
        if (!kantorResponse.success) {
          errorDetails += 'Kantor: ${kantorResponse.message}. ';
        }
        if (!jabatanResponse.success) {
          errorDetails += 'Jabatan: ${jabatanResponse.message}. ';
        }

        print('DEBUG: Some API calls failed: $errorDetails');
        _showErrorSnackBar('Gagal memuat data: $errorDetails');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('DEBUG: Exception in _loadDropdownData: $e');
      _showErrorSnackBar('Error: $e');
    }
  }

  Future<void> _createKaryawan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedKantorId == null || _selectedJabatanId == null) {
      _showErrorSnackBar('Pilih kantor dan jabatan');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final request = CreateKaryawanRequest(
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
        telefon: _telefonController.text.trim().isEmpty
            ? null
            : _telefonController.text.trim(),
        gaji: _gajiController.text.trim().isEmpty
            ? "0"
            : _gajiController.text.trim(), // Just use the raw string value
        kantorId: _selectedKantorId!.toString(), // Convert to String
        jabatanId: _selectedJabatanId!.toString(), // Convert to String
      );

      // Debug logging
      print('DEBUG: Create form data before sending:');
      print('DEBUG: Nama: ${_namaController.text.trim()}');
      print('DEBUG: Email: ${_emailController.text.trim()}');
      print(
          'DEBUG: Telefon: ${_telefonController.text.trim().isEmpty ? "null" : _telefonController.text.trim()}');
      print(
          'DEBUG: Gaji: ${_gajiController.text.trim().isEmpty ? "0" : _gajiController.text.trim()}');
      print('DEBUG: KantorId: $_selectedKantorId');
      print('DEBUG: JabatanId: $_selectedJabatanId');
      print('DEBUG: Request object: $request');

      final response = await KaryawanService.createKaryawan(request);

      if (response.success) {
        if (mounted) {
          // Refresh data di provider
          Provider.of<KaryawanProvider>(context, listen: false).loadKaryawans();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Karyawan berhasil ditambahkan'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pop(true); // Return true untuk indicate success
        }
      } else {
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      print('DEBUG: Exception in _createKaryawan: $e');
      _showErrorSnackBar('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _telefonController.dispose();
    _gajiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Karyawan'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Info
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tambah Karyawan Baru',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Isi semua data karyawan dengan lengkap',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Form Fields
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        if (value.trim().length < 2) {
                          return 'Nama minimal 2 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        hintText: 'contoh@email.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value.trim())) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _telefonController,
                      decoration: const InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                        hintText: '+62812345678',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          if (value.trim().length < 10) {
                            return 'Nomor telepon minimal 10 digit';
                          }
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _gajiController,
                      decoration: const InputDecoration(
                        labelText: 'Gaji',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.monetization_on),
                        hintText: '5000000',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final gaji = double.tryParse(value.trim());
                          if (gaji == null || gaji < 0) {
                            return 'Gaji harus berupa angka positif';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Kantor Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedKantorId,
                      decoration: const InputDecoration(
                        labelText: 'Kantor',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: _kantors.map((kantor) {
                        return DropdownMenuItem<int>(
                          value: kantor.id,
                          child: Text(kantor.nama),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedKantorId = value;
                        });
                      },
                      validator: (value) {
                        // Kantor tidak wajib untuk create
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Jabatan Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedJabatanId,
                      decoration: const InputDecoration(
                        labelText: 'Jabatan *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                      ),
                      items: _jabatans.map((jabatan) {
                        return DropdownMenuItem<int>(
                          value: jabatan.id,
                          child: Text(jabatan.nama),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedJabatanId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih jabatan';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isSaving
                                ? null
                                : () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.cancel),
                            label: const Text('Batal'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              foregroundColor: Colors.grey[600],
                              side: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isSaving ? null : _createKaryawan,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Icon(Icons.add),
                            label: Text(_isSaving ? 'Menyimpan...' : 'Tambah'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Info Text
                    Text(
                      '* Field wajib diisi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
