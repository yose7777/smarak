import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPagesState();
}

class _SosPagesState extends State<SosPage> {
  bool _sosActive = false;

  // Nomor Darurat Pihak Berwajib
  final emergencyContacts = [
    {
      'name': 'Polisi',
      'number': '110',
      'icon': Icons.local_police,
      'color': Colors.blue,
    },
    {
      'name': 'Ambulans',
      'number': '118',
      'icon': Icons.health_and_safety,
      'color': Colors.red,
    },
    {
      'name': 'Pemadam Kebakaran',
      'number': '113',
      'icon': Icons.fire_truck,
      'color': Colors.orange,
    },
    {
      'name': 'SAR',
      'number': '115',
      'icon': Icons.search,
      'color': Colors.teal,
    },
  ];

  // Fungsi untuk menelepon
  Future<void> _makeCall(String number) async {
    final url = 'tel:$number';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuat panggilan')),
      );
    }
  }

  // Aktivasi SOS
  void _activateSOS() {
    setState(() {
      _sosActive = true;
    });
    // Panggil polisi secara otomatis
    _makeCall('110');
    
    // Tampilkan dialog konfirmasi
    _showSOSDialog();
  }

  // Dialog konfirmasi SOS
  void _showSOSDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SOS Diaktifkan'),
          content: const Text(
            'Panggilan darurat telah diinisiasi ke Polisi.\n\n'
            'Lokasi Anda akan dibagikan dengan pihak berwajib.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _sosActive = false;
                });
              },
              child: const Text('Batalkan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS - Darurat'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Informasi
              Card(
                color: Colors.red[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 48,
                        color: Colors.red[700],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Panggil Pihak Berwajib',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tekan tombol di bawah untuk menghubungi layanan darurat',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol SOS Besar (Red Emergency Button)
              GestureDetector(
                onLongPress: _activateSOS,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _sosActive ? Colors.red[700] : Colors.red[600],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      onLongPress: _activateSOS,
                      customBorder: const CircleBorder(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_in_talk,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _sosActive ? 'SOS AKTIF' : 'TAHAN UNTUK SOS',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Layanan Darurat Lainnya
              Text(
                'Layanan Darurat Cepat',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = emergencyContacts[index];
                  return _buildEmergencyContactCard(
                    name: contact['name'] as String,
                    number: contact['number'] as String,
                    icon: contact['icon'] as IconData,
                    color: contact['color'] as Color,
                  );
                },
              ),
              const SizedBox(height: 24),

              // Informasi Keselamatan
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tips Keselamatan:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTipItem('Tetap tenang dan jelaskan situasi Anda'),
                      _buildTipItem('Berikan lokasi spesifik Anda'),
                      _buildTipItem('Ikuti instruksi dari operator darurat'),
                      _buildTipItem('Tetap terhubung sampai bantuan tiba'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard({
    required String name,
    required String number,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _makeCall(number),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                number,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
