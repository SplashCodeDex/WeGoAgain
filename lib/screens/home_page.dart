import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/widgets/avatar_card.dart';
import 'package:myapp/widgets/footer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.5 + index * 0.1,
            0.8 + index * 0.1,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFEF6F1),
              Color(0xFFF9E9E9),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'I',
                    style: GoogleFonts.lora(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD95C5C),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFF97C2D), Color(0xFFF95B5B)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: Text(
                      'Portfolio Building',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '“',
                          style: GoogleFonts.lora(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF97C2D),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            'Act as a design mentor. Help me structure a beginner-friendly UX/UI design portfolio with 3 projects that showcase research, wireframes, and high-fidelity designs. Suggest how I can present each project clearly and compellingly.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '”',
                            style: GoogleFonts.lora(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFF97C2D),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 60,
                  width: 220,
                  child: Stack(
                    children: List.generate(4, (index) {
                      return Positioned(
                        left: index * 40.0,
                        child: SlideTransition(
                          position: _slideAnimations[index],
                          child: AvatarCard(index: index),
                        ),
                      );
                    }),
                  ),
                ),
                const Spacer(flex: 3),
                const Footer(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
