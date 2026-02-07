import 'package:flutter/material.dart';
import '../service/history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService _service = HistoryService();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onChange);
  }

  @override
  void dispose() {
    _service.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final history = _service.history;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('History', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // search + filter row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.black54),
                          SizedBox(width: 8),
                          Expanded(child: TextField(decoration: InputDecoration.collapsed(hintText: 'Cari riwayat...'))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
                    child: IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list, color: Colors.black54)),
                  )
                ],
              ),

              const SizedBox(height: 18),

              const Text('Filter berdasarkan alat', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    HistoryChip(title: 'Semua'),
                    HistoryChip(title: 'GERINDA POTONG'),
                    HistoryChip(title: 'MESIN AMPLAS'),
                    HistoryChip(title: 'BOR TANGAN'),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: history.isEmpty
                    ? const Center(child: Text('Belum ada riwayat catatan'))
                    : ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, i) {
                          final note = history[i];
                          return HistoryCard.fromNote(note: note);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= CHIP FILTER =================
class HistoryChip extends StatelessWidget {
  final String title;

  const HistoryChip({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}

// ================= HISTORY CARD =================
class HistoryCard extends StatelessWidget {
  final String title;
  final String duration;
  final String date;
  final String imagePath;

  const HistoryCard({
    super.key,
    required this.title,
    required this.duration,
    required this.date,
    required this.imagePath,
  });

  factory HistoryCard.fromNote({required Map<String, dynamic> note}) {
    return HistoryCard(
      title: note['alatName']?.toString() ?? 'Alat',
      duration: note['duration']?.toString() ?? note['time']?.toString() ?? '-',
      date: note['date']?.toString() ?? '-',
      imagePath: note['imagePath']?.toString() ?? 'assets/alat/alat1.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          // ================= ICON =================
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7E6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) {
                  // ignore: avoid_print
                  print('Failed to load asset: $imagePath -> $error');
                  return const Icon(Icons.broken_image, color: Colors.grey);
                },
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ================= TEXT =================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('Banyak Pemakaian: $duration', style: const TextStyle(color: Colors.black54)),
                const SizedBox(height: 4),
                Text('Tanggal: $date', style: const TextStyle(fontSize: 12, color: Colors.black45)),
              ],
            ),
          ),

          // ================= ACTIONS =================
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: Colors.black54),
              ),
            ],
          )
        ],
      ),
    );
  }
}
