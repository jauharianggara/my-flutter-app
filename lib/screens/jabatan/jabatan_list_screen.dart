import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/jabatan_provider.dart';
import '../../models/jabatan.dart';
import 'edit_jabatan_screen.dart';
import 'create_jabatan_screen.dart';

class JabatanListScreen extends StatefulWidget {
  const JabatanListScreen({super.key});

  @override
  State<JabatanListScreen> createState() => _JabatanListScreenState();
}

class _JabatanListScreenState extends State<JabatanListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JabatanProvider>(context, listen: false).loadJabatans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Jabatan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<JabatanProvider>(context, listen: false)
                  .loadJabatans();
            },
          ),
        ],
      ),
      body: Consumer<JabatanProvider>(
        builder: (context, jabatanProvider, child) {
          if (jabatanProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (jabatanProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${jabatanProvider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      jabatanProvider.loadJabatans();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (jabatanProvider.jabatans.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada data jabatan',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan jabatan pertama Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await jabatanProvider.loadJabatans();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: jabatanProvider.jabatans.length,
              itemBuilder: (context, index) {
                final jabatan = jabatanProvider.jabatans[index];
                return _buildJabatanCard(context, jabatan);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final navigatorContext = context;
          final result = await Navigator.push(
            navigatorContext,
            MaterialPageRoute(
              builder: (context) => const CreateJabatanScreen(),
            ),
          );

          // Refresh list if jabatan was created successfully
          if (result == true && mounted) {
            Provider.of<JabatanProvider>(navigatorContext, listen: false)
                .loadJabatans();
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildJabatanCard(BuildContext context, Jabatan jabatan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showJabatanDetail(context, jabatan);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[100],
                child: Icon(
                  Icons.work,
                  size: 30,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jabatan.namaJabatan,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jabatan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) async {
                  final navigatorContext = context;
                  switch (value) {
                    case 'edit':
                      final result = await Navigator.push(
                        navigatorContext,
                        MaterialPageRoute(
                          builder: (context) => EditJabatanScreen(
                            jabatan: jabatan,
                          ),
                        ),
                      );

                      // Refresh data jika edit berhasil
                      if (result == true) {
                        if (mounted) {
                          Provider.of<JabatanProvider>(navigatorContext,
                                  listen: false)
                              .loadJabatans();
                        }
                      }
                      break;
                    case 'delete':
                      _showDeleteDialog(navigatorContext, jabatan);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 18),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJabatanDetail(BuildContext context, Jabatan jabatan) {
    final navigatorContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.7,
        minChildSize: 0.3,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      Icons.work,
                      size: 40,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jabatan.namaJabatan,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Jabatan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Details
              _buildDetailItem('Nama Jabatan', jabatan.namaJabatan),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(navigatorContext);
                        // Navigate to edit
                        Navigator.push(
                          navigatorContext,
                          MaterialPageRoute(
                            builder: (context) => EditJabatanScreen(
                              jabatan: jabatan,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(navigatorContext);
                        _showDeleteDialog(navigatorContext, jabatan);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Hapus'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Jabatan jabatan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Jabatan'),
        content: Text(
          'Apakah Anda yakin ingin menghapus jabatan "${jabatan.namaJabatan}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final jabatanProvider =
                  Provider.of<JabatanProvider>(context, listen: false);

              final success = await jabatanProvider.deleteJabatan(jabatan.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Jabatan berhasil dihapus'
                          : 'Gagal menghapus jabatan: ${jabatanProvider.errorMessage}',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
