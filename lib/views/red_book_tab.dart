import 'package:flutter/material.dart';

import '../R.dart';

class RedBookTab extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final double height;

  const RedBookTab({
    required this.text,
    this.height = R.tabBarHeight,
    super.key,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        widthFactor: 1.0,
        child: Text(text, softWrap: false, overflow: TextOverflow.fade),
      ),
    );
  }
}

class RedBookUnderlineTabIndicator extends Decoration {
  const RedBookUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.indicatorBottom = 0.0,
    this.indicatorWidth = 28,
    this.isRound = false,
  });

  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final double indicatorBottom; // 自定义指示条距离底部距离
  final double indicatorWidth; // 自定义指示条宽度
  final bool? isRound; // 自定义指示条是否是圆角

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is RedBookUnderlineTabIndicator) {
      return RedBookUnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is RedBookUnderlineTabIndicator) {
      return RedBookUnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, onChanged, isRound ?? false);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    // 取中间坐标
    double cw = (indicator.left + indicator.right) / 2;

    // 这里可以自定义指示条的宽度和底部间距
    Rect indicatorRect = Rect.fromLTWH(
      cw - indicatorWidth / 2,
      indicator.bottom - borderSide.width - indicatorBottom,
      indicatorWidth,
      borderSide.width,
    );
    return indicatorRect;
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(
    this.decoration,
    VoidCallback? onChanged,
    this.isRound,
  ) : super(onChanged);

  final RedBookUnderlineTabIndicator decoration;
  bool isRound = false;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    // 这里可以自定义指示条是否是圆角
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = isRound ? StrokeCap.round : StrokeCap.square;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
