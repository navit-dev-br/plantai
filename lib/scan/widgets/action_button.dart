import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String pathImage;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.onTap,
    required this.pathImage,
  });

  factory ActionButton.changeCamera({required VoidCallback onTap}) {
    return ActionButton(
      onTap: onTap,
      pathImage: 'assets/images/change_camera.webp',
    );
  }

  factory ActionButton.gallery({required VoidCallback onTap}) {
    return ActionButton(
      onTap: onTap,
      pathImage: 'assets/images/gallery_image.webp',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EE),
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: AssetImage(pathImage),
          ),
        ),
      ),
    );
  }
}
