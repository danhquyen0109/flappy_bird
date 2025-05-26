import 'package:galaxy_bird/utils/utils.dart';
import 'package:flutter/material.dart';

class TriangleButton extends StatelessWidget {
  const TriangleButton({
    super.key,
    this.onTap,
    required this.child,
    required this.path,
  });

  final Function? onTap;
  final Widget child;
  final Path path;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TriangleClipper(path: path),
      child: GestureDetector(
        onTap: () => onTap?.call(),
        // child: triangle,
        child: child,
      ),
    );
  }
}
