import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/karyawan.dart';
import '../providers/karyawan_provider.dart';
import '../services/dropdown_service.dart';
import '../services/karyawan_service.dart';

class EditKaryawanScreen extends StatefulWidget {
  final KaryawanWithKantor karyawan;

  const EditKaryawanScreen({
    super.key,
    required this.karyawan,
  });

  @override
  State<EditKaryawanScreen> createState() => _EditKaryawanScreenState();
}

class _EditKaryawanScreenState extends State<EditKaryawanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonController = TextEditingController();
  final _gajiController = TextEditingController(); // Add gaji controller

  List<Kantor> _kantors = [];
  List<Jabatan> _jabatans = [];
  int? _selectedKantorId;
  int? _selectedJabatanId;
  bool _isLoading = true;
  bool _isSaving = false;
  Karyawan? _karyawanDetail;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Set initial data dari KaryawanWithKantor
    _namaController.text = widget.karyawan.nama;
    _selectedKantorId = widget.karyawan.kantorId;
    _selectedJabatanId = widget.karyawan.jabatanId;

    _loadData();
  }

  Future<void> _loadData() async {
    try {
      print('DEBUG: Starting _loadData for karyawan ID: ${widget.karyawan.id}');

      // Load karyawan detail untuk mendapatkan email dan telepon
      final karyawanResponse =
          await KaryawanService.getKaryawanById(widget.karyawan.id);
      print('DEBUG: Karyawan response success: ${karyawanResponse.success}');
      if (!karyawanResponse.success) {
        print('DEBUG: Karyawan error: ${karyawanResponse.message}');
      }

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

      if (karyawanResponse.success &&
          kantorResponse.success &&
          jabatanResponse.success) {
        print('DEBUG: All API calls successful, setting state');
        setState(() {
          _karyawanDetail = karyawanResponse.data;
          _kantors = kantorResponse.data ?? [];
          _jabatans = jabatanResponse.data ?? [];

          print(
              'DEBUG: Loaded ${_kantors.length} kantors and ${_jabatans.length} jabatans');

          // Set email dan telepon dari detail data
          if (_karyawanDetail != null) {
            _emailController.text = _karyawanDetail!.email ?? '';
            _telefonController.text = _karyawanDetail!.telefon ?? '';
            _gajiController.text =
                _karyawanDetail!.gaji?.toString() ?? '0'; // Set gaji
            print('DEBUG: Set email: ${_karyawanDetail!.email ?? ""}');
            print(
                'DEBUG: Set gaji: ${_karyawanDetail!.gaji?.toString() ?? "0"}');
          }

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        String errorDetails = '';
        if (!karyawanResponse.success)
          errorDetails += 'Karyawan: ${karyawanResponse.message}. ';
        if (!kantorResponse.success)
          errorDetails += 'Kantor: ${kantorResponse.message}. ';
        if (!jabatanResponse.success)
          errorDetails += 'Jabatan: ${jabatanResponse.message}. ';

        print('DEBUG: Some API calls failed: $errorDetails');
        _showErrorSnackBar('Gagal memuat data: $errorDetails');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('DEBUG: Exception in _loadData: $e');
      _showErrorSnackBar('Error: $e');
    }
  }

  Future<void> _updateKaryawan() async {
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
      final request = UpdateKaryawanRequest(
        nama: _namaController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        telefon: _telefonController.text.trim().isEmpty
            ? null
            : _telefonController.text.trim(),
        gaji: _gajiController.text.trim().isEmpty
            ? null
            : double.tryParse(_gajiController.text.trim())
                ?.toInt()
                .toString(), // Convert to int string
        kantorId: _selectedKantorId!.toString(), // Convert to string
        jabatanId: _selectedJabatanId!.toString(), // Convert to string
      );

      // Debug logging
      print('DEBUG: Form data before sending:');
      print('DEBUG: Nama: ${_namaController.text.trim()}');
      print(
          'DEBUG: Email: ${_emailController.text.trim().isEmpty ? "null" : _emailController.text.trim()}');
      print(
          'DEBUG: Telefon: ${_telefonController.text.trim().isEmpty ? "null" : _telefonController.text.trim()}');
      print(
          'DEBUG: Gaji: ${_gajiController.text.trim().isEmpty ? "null" : _gajiController.text.trim()}');
      print('DEBUG: KantorId: $_selectedKantorId');
      print('DEBUG: JabatanId: $_selectedJabatanId');
      print('DEBUG: Request object: $request');

      final response = await KaryawanService.updateKaryawan(
        widget.karyawan.id,
        request,
      );

      if (response.success) {
        if (mounted) {
          // Refresh data di provider
          Provider.of<KaryawanProvider>(context, listen: false).loadKaryawans();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Karyawan berhasil diupdate'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pop(true); // Return true untuk indicate success
        }
      } else {
        _showErrorSnackBar(response.message);
      }
    } catch (e) {
      print('DEBUG: Exception in _updateKaryawan: $e');
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
    _gajiController.dispose(); // Add gaji controller dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Karyawan'),
        backgroundColor: Colors.blue[600],
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
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Edit Data Karyawan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${widget.karyawan.id}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
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
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        hintText: 'contoh@email.com',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value.trim())) {
                            return 'Format email tidak valid';
                          }
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
                        labelText: 'Gaji *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        hintText: 'Masukkan gaji karyawan',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Gaji tidak boleh kosong';
                        }
                        final gaji = double.tryParse(value.trim());
                        if (gaji == null || gaji <= 0) {
                          return 'Gaji harus berupa angka yang valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Kantor Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedKantorId,
                      decoration: const InputDecoration(
                        labelText: 'Kantor *',
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
                        if (value == null) {
                          return 'Pilih kantor';
                        }
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
                            onPressed: _isSaving ? null : _updateKaryawan,
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
                                : const Icon(Icons.save),
                            label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
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
