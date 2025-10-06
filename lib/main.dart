import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFEECE2),
              Color(0xFFF9D7D7),
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
                Text(
                  'I',
                  style: GoogleFonts.lora(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFD95C5C),
                  ),
                ),
                const SizedBox(height: 16),
                ShaderMask(
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
                const Spacer(),
                GlassmorphicContainer(
                  width: double.infinity,
                  height: 350,
                  borderRadius: 20,
                  blur: 10,
                  alignment: Alignment.center,
                  border: 2,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                    stops: const [0.1, 1],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.white.withOpacity(0.5),
                    ],
                  ),
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
                        Expanded(
                          child: Center(
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
                  child: Stack(
                    children: List.generate(4, (index) {
                      return Positioned(
                        left: index * 40.0,
                        child: _buildAvatarCard(index),
                      );
                    }),
                  ),
                ),
                const Spacer(flex: 3),
                const _Footer(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarCard(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SvgPicture.asset(
          'assets/images/avatar${index + 1}.svg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 70,
          height: 50,
          decoration: const ShapeDecoration(
            shape: StadiumBorder(
              side: BorderSide(color: Colors.white, width: 2),
            ),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('https://p19-pu-sign-useast8.tiktokcdn-us.com/tos-useast8-avt-0068-tx/04620b72b3884b65a52f55169f20305d~c5_100x100.jpeg?lk3s=a5d48078&x-expires=1744158000&x-signature=8bL%2F3Y133lF1s8uS16k5A5aYl2k%3D'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Kingsley Orji',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        const FaIcon(FontAwesomeIcons.twitter, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          '@Desgnwitkinsly',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(width: 16),
        const FaIcon(FontAwesomeIcons.instagram, size: 18, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          '@Designwithkingsley',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}