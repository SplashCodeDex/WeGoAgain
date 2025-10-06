import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
