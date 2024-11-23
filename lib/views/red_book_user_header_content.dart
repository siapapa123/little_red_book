import 'package:flutter/material.dart';

import '../R.dart';

class RedBookUserHeaderContent extends StatelessWidget {
  const RedBookUserHeaderContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: R.padding12),
      child: Column(
        children: [
          Row(
            children: [
              // 头像
              Stack(
                children: [
                  // 头像
                  Container(
                    width: R.size80,
                    height: R.size80,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(R.size80 / 2),
                      ),
                      border: Border.all(
                        color: Colors.white,
                        width: 0.5,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Image.asset(
                      R.userAvatar,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      child: Image.asset(
                        R.addIcon,
                        width: R.size20,
                        height: R.size20,
                      ),
                      onTap: () {
                        print('头像的 + 号被点击');
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: R.padding12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      R.userName,
                      style: TextStyle(
                        fontSize: R.fontSize20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: R.padding8,
                    ),
                    Row(
                      children: [
                        const Text(
                          '${R.userIdName}：${R.userId}',
                          style: TextStyle(
                            fontSize: R.fontSize10,
                            color: R.tabUnselectColor,
                          ),
                        ),
                        const SizedBox(width: R.padding4,),
                        Image.asset(
                          R.qrCodeIcon,
                          width: R.size12,
                          height: R.size12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: R.padding14),
            alignment: Alignment.centerLeft,
            child: const Text(
              R.userDescription,
              style: TextStyle(
                fontSize: R.fontSize14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}