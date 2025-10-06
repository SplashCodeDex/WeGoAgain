import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                        'https://p19-pu-sign-useast8.tiktokcdn-us.com/tos-useast8-avt-0068-tx/04620b72b3884b65a52f55169f20305d~c5_100x100.jpeg?lk3s=a5d48078&x-expires=1744158000&x-signature=8bL%2F3Y133lF1s8uS16k5A5aYl2k%3D'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Kingsley Orji',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            const FaIcon(FontAwesomeIcons.twitter,
                size: 16, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              'X:@Desgnwitkinsly',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(width: 12),
            const FaIcon(FontAwesomeIcons.instagram,
                size: 16, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              'IG:@Designwithkingsley',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}
