import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 16, 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: -5,
                  )
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                        'https://p19-pu-sign-useast8.tiktokcdn-us.com/tos-useast8-avt-0068-tx/04620b72b3884b65a52f55169f20305d~c5_100x100.jpeg?lk3s=a5d48078&x-expires=1744158000&x-signature=8bL%2F3Y133lF1s8uS16k5A5aYl2k%3D'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kingsley Orji',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4A4A4A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Row(
          children: [
            Text(
              'X:@Desgnwitkinsly',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color(0xFF4A4A4A)),
            ),
            const SizedBox(width: 16),
            Text(
              'IG:@Designwithkingsley',
              style: GoogleFonts.poppins(
                  fontSize: 12, color: const Color(0xFF4A4A4A)),
            ),
          ],
        ),
      ],
    );
  }
}
