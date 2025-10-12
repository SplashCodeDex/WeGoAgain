import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: FAvatar.raw(
        size: 60,
        child: SvgPicture.asset(
          'assets/images/avatar${index + 1}.svg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
