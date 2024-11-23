import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../R.dart';

class RedBookUserHomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  RedBookUserHomeHeaderDelegate({
    required this.topPadding,
    this.collapsedHeight = R.appBarHeight,
    this.expandedHeight = R.userProfileHeaderMaxHeight,
    this.background,
    this.content,
    this.bottom,
  });

  final double topPadding;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget? background;
  final Widget? content;
  final Widget? bottom;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    print('shrinkOffset = $shrinkOffset');
    final opacity = clampDouble(shrinkOffset / R.appBarOpacityDelta, 0.0, 1.0);
    final offset = max(-shrinkOffset, minExtent - maxExtent);
    return SizedBox(
      height: maxExtent,
      width: double.infinity,
      child: Stack(
        children: [
          // 背景图
          if (background != null) Positioned(
            top: offset,
            left: 0,
            right: 0,
            child: background!,
          ),
          // 渐变蒙层
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    R.appBarBackgroundColor.withOpacity(0.3),
                    R.appBarBackgroundColor.withOpacity(0.6),
                    R.appBarBackgroundColor,
                  ],
                  stops: const [0.0, 0.4, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // 中间的内容区域
          if (content != null)
            Positioned(
              left: 0,
              right: 0,
              top: topPadding +
                  collapsedHeight +
                  R.userProfileHeaderContentSpace +
                  offset,
              child: content!,
            ),
          // 顶部 AppBar
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: topPadding + collapsedHeight,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: R.appBarBackgroundColor.withOpacity(opacity),
              ),
              child: Container(
                height: collapsedHeight,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: R.padding12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(R.menuIcon, width: 21, height: 21),
                    Row(
                      children: [
                        Image.asset(R.scanIcon, width: 24, height: 24),
                        const SizedBox(width: R.padding8),
                        Image.asset(R.shareIcon, width: 22, height: 22),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 底部 TabBar
          if (bottom != null) Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: R.tabBarHeight,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(R.tabBarRadius),
                  topLeft: Radius.circular(R.tabBarRadius),
                ),
              ),
              child: bottom,
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent =>
      topPadding + collapsedHeight + (bottom != null ? R.tabBarHeight : 0);

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}