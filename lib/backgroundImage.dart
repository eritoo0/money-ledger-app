import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;
  const BackgroundImage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.darken,
            ),
            child: Image.asset(
              'assets/images/e-wallet-6368676_1280.webp',
              fit: BoxFit.cover,
            ),
          ),
        ),
        child,
      ],
    );
  }
}

//'assets/images/e-wallet-6368676_1280.webp',

