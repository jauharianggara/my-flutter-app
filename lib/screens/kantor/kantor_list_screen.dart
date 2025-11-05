import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/kantor_provider.dart';
import '../../models/kantor.dart';
import 'edit_kantor_screen.dart';
import 'create_kantor_screen.dart';

class KantorListScreen extends StatefulWidget {
  const KantorListScreen({super.key});

  @override
  State<KantorListScreen> createState() => _KantorListScreenState();
}

class _KantorListScreenState extends State<KantorListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<KantorProvider>(context, listen: false).loadKantors();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kantor'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<KantorProvider>(context, listen: false).loadKantors();
            },
          ),
        ],
      ),
      body: Consumer<KantorProvider>(
        builder: (context, kantorProvider, child) {
          if (kantorProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (kantorProvider.errorMessage != null) {
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
                    'Error: ${kantorProvider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      kantorProvider.loadKantors();
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (kantorProvider.kantors.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada data kantor',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan kantor pertama Anda',
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
              await kantorProvider.loadKantors();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: kantorProvider.kantors.length,
              itemBuilder: (context, index) {
                final kantor = kantorProvider.kantors[index];
                return _buildKantorCard(context, kantor);
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
              builder: (context) => const CreateKantorScreen(),
            ),
          );

          // Refresh list if kantor was created successfully
          if (result == true && mounted) {
            Provider.of<KantorProvider>(navigatorContext, listen: false)
                .loadKantors();
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildKantorCard(BuildContext context, Kantor kantor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showKantorDetail(context, kantor);
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
                  Icons.business,
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
                      kantor.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kantor.alamat,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (kantor.telefon != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        kantor.telefon!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
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
                          builder: (context) => EditKantorScreen(
                            kantor: kantor,
                          ),
                        ),
                      );

                      // Refresh data jika edit berhasil
                      if (result == true) {
                        if (mounted) {
                          Provider.of<KantorProvider>(navigatorContext,
                                  listen: false)
                              .loadKantors();
                        }
                      }
                      break;
                    case 'delete':
                      _showDeleteDialog(navigatorContext, kantor);
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

  void _showKantorDetail(BuildContext context, Kantor kantor) {
    final navigatorContext = context;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.8,
        minChildSize: 0.4,
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
                      Icons.business,
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
                          kantor.nama,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Kantor',
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
              _buildDetailItem('Alamat', kantor.alamat),
              if (kantor.telefon != null)
                _buildDetailItem('Telepon', kantor.telefon!),
              if (kantor.latitude != null && kantor.longitude != null)
                _buildDetailItem(
                    'Koordinat', '${kantor.latitude}, ${kantor.longitude}'),

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
                            builder: (context) => EditKantorScreen(
                              kantor: kantor,
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
                        _showDeleteDialog(navigatorContext, kantor);
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

  void _showDeleteDialog(BuildContext context, Kantor kantor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kantor'),
        content: Text(
          'Apakah Anda yakin ingin menghapus kantor "${kantor.nama}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final kantorProvider =
                  Provider.of<KantorProvider>(context, listen: false);

              final success = await kantorProvider.deleteKantor(kantor.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Kantor berhasil dihapus'
                          : 'Gagal menghapus kantor: ${kantorProvider.errorMessage}',
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
