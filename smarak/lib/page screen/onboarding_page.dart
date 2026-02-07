  import 'package:flutter/material.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  final Function(bool)? onThemeChange;
  final bool isDarkMode;

  const OnboardingPage({
    super.key,
    this.onThemeChange,
    this.isDarkMode = false,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> texts = [
    "Aplikasi ini mempermudah anda\nmemantau alat yang ada di industri\nada dimana & ada atau tidak.",
    "Pantau status alat secara real-time\ndan akurat langsung dari aplikasi.",
    "Kelola dan kontrol alat industri\ndengan lebih efisien."
  ];

  // one image per slide
  final List<String> images = [
    'assets/alat/1.png',
    'assets/alat/2.png',
    'assets/alat/3.png',
  ];
  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (mounted && _controller.hasClients) {
          if (_currentIndex == texts.length - 1) {
            goToLogin();
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            ).then((_) {
              _startAutoScroll();
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPage(
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFF8E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: texts.length,
                      onPageChanged: (index) => setState(() => _currentIndex = index),
                      itemBuilder: (context, index) {
                        final image = images[index % images.length];
                        final isLast = index == texts.length - 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [Color(0xFFFFF3E0), Color(0x00FF9800)],
                                    center: Alignment(-0.2, -0.2),
                                    radius: 0.9,
                                  ),
                                  boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.06), blurRadius: 20)],
                                ),
                                child: Center(
                                  child: Image.asset(
                                    image,
                                    fit: BoxFit.cover,
                                    semanticLabel: 'Onboarding image ${index + 1}',
                                    errorBuilder: (context, error, stack) {
                                      // ignore: avoid_print
                                      print('Failed to load asset: $image -> $error');
                                      return Container(
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.broken_image, size: 56, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                texts[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.6),
                              ),
                              const SizedBox(height: 22),
                              if (isLast)
                                SizedBox(
                                  width: 160,
                                  child: ElevatedButton(
                                    onPressed: goToLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Get Started'),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28, left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        texts.length,
                        (i) => GestureDetector(
                          onTap: () {
                            _controller.animateToPage(i, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            width: _currentIndex == i ? 28 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == i ? Colors.orange : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Skip button top-right
              Positioned(
                right: 12,
                top: 12,
                child: TextButton(
                  onPressed: goToLogin,
                  style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6)),
                  child: const Text('Skip', style: TextStyle(color: Colors.black54)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
