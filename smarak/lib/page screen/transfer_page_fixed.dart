import 'package:flutter/material.dart';

import '../service/cacatan_service.dart';
import 'histori_catatan.dart';


class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final NoteService _noteService = NoteService();

  List<Map<String, dynamic>> notes = [];

  String _selectedAlat = 'Bor Tangan';
  String _selectedStatus = 'Baik';

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'baik':
        return Colors.green;
      case 'perlu perawatan':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _getFormattedDate(DateTime date) {
    final months = [
      'Januari','Februari','Maret','April','Mei','Juni',
      'Juli','Agustus','September','Oktober','November','Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getFormattedTime(DateTime date) {
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Alat'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HistoryPagee()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFFFF8E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note['alatName'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${note['date']} - ${note['time']}'),
                    const SizedBox(height: 8),
                    Text(note['note']),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          note['status'],
                          style: TextStyle(
                            color: note['statusColor'],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          note['recordedBy'],
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () => _addNewNote(context),
      ),
    );
  }

  void _addNewNote(BuildContext context) {
    final noteC = TextEditingController();
    final byC = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final now = DateTime.now();

        return AlertDialog(
          title: const Text('Tambah Catatan Alat'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                /// NAMA ALAT (3 PILIHAN)
                DropdownButtonFormField<String>(
                  value: _selectedAlat,
                  decoration: const InputDecoration(
                    labelText: 'Nama Alat',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'Bor Tangan',
                        child: Text('Bor Tangan')),
                    DropdownMenuItem(
                        value: 'Gerinda',
                        child: Text('Gerinda')),
                    DropdownMenuItem(
                        value: 'Mesin Amplas',
                        child: Text('Mesin Amplas')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedAlat = value!);
                  },
                ),
                const SizedBox(height: 12),

                /// CATATAN
                TextField(
                  controller: noteC,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                /// STATUS (2 PILIHAN)
                DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status Alat',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'Baik', child: Text('Baik')),
                    DropdownMenuItem(
                        value: 'Perlu Perawatan',
                        child: Text('Perlu Perawatan')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedStatus = value!);
                  },
                ),
                const SizedBox(height: 12),

                /// PENCATAT
                TextField(
                  controller: byC,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pencatat',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                if (noteC.text.isEmpty || byC.text.isEmpty) return;

                final statusColor =
                    _getStatusColor(_selectedStatus);

                setState(() {
                  notes.insert(0, {
                    'alatName': _selectedAlat,
                    'date': _getFormattedDate(now),
                    'time': _getFormattedTime(now),
                    'note': noteC.text,
                    'status': _selectedStatus,
                    'statusColor': statusColor,
                    'recordedBy': byC.text,
                  });
                });

                await _noteService.addNote({
                  'alatName': _selectedAlat,
                  'date': _getFormattedDate(now),
                  'time': _getFormattedTime(now),
                  'note': noteC.text,
                  'status': _selectedStatus,
                  'statusColor': statusColor.value,
                  'recordedBy': byC.text,
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
