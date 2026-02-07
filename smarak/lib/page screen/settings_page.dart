import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tools = [
      {
        'name': 'Gerinda Potong',
        'description': 'Alat untuk mengalirkan dan mendistribusikan air dalam sistem industri',
        'image': 'assets/alat/alat1.png',
        'icon': Icons.settings,
      },
      {
        'name': 'Bor Tangan',
        'description': 'Alat untuk mengompresi udara dan gas dalam proses manufaktur',
        'image': 'assets/alat/alat2.png',
        'icon': Icons.settings,
      },
      {
        'name': 'Mesin Amplas',
        'description': 'Alat pembangkit listrik untuk mendukung operasional industri',
        'image': 'assets/alat/alat3.png',
        'icon': Icons.settings,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Alat-alat'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFF8E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tools.length,
          itemBuilder: (context, index) {
            final tool = tools[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      color: Colors.orange.withOpacity(0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        tool['image'],
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stack) {
                          return Center(
                            child: Icon(
                              tool['icon'],
                              size: 80,
                              color: Colors.orange,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(tool['icon'], color: Colors.orange, size: 24),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                tool['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tool['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
