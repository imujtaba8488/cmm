part of 'go_family.dart';

abstract class FoldListener {
  void _hasFolded(GoSection section);
  void _hasUnfolded(GoSection section);
}

abstract class GoWidget extends StatefulWidget {}



// class GoDecoration extends BoxDecoration {
//   final Color color;
//   final DecorationImage image;
//   final BoxBorder border;
//   final BorderRadiusGeometry borderRadius;
//   final List<BoxShadow> boxShadow;
//   final Gradient gradient;
//   final BlendMode backgroundBlendMode;
//   final BoxShape shape;

//   GoDecoration({
//     this.color,
//     this.image,
//     this.border,
//     this.borderRadius,
//     this.boxShadow,
//     this.gradient,
//     this.backgroundBlendMode,
//     this.shape = BoxShape.rectangle,
//   }) : super(
//           color: color,
//           image: image,
//           border: border,
//           borderRadius: borderRadius,
//           boxShadow: boxShadow,
//           gradient: gradient,
//           backgroundBlendMode: backgroundBlendMode,
//           shape: shape,
//         );

// }
