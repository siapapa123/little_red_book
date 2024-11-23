import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'R.dart';
import 'views/red_book_tab.dart';
import 'views/red_book_user_header_content.dart';
import 'views/red_book_user_home_header_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: R.appName,
      theme: ThemeData(
        // 赢藏 TabBar 底部的分割线
        tabBarTheme: const TabBarTheme(
          dividerColor: Colors.transparent,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  final _tabTitles = [R.noteTab, R.collectTab, R.likeTab];
  final _refreshController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );
  final _expandedHeight = ValueNotifier<double>(R.userProfileHeaderMaxHeight);

  @override
  void initState() {
    _tabController = TabController(length: _tabTitles.length, vsync: this,);

    // 添加 header 发生偏移量的监听
    bool haveAddListener = false;
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      if (!haveAddListener && _refreshController.headerState != null) {
        haveAddListener = true;
        _refreshController.headerState?.notifier.addListener(() {
          final offset = _refreshController.headerState?.offset ?? 0;
          _expandedHeight.value = R.userProfileHeaderMaxHeight + offset;
          print('onHeaderState $offset');
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: EasyRefresh(
        isNested: true,
        controller: _refreshController,
        header: const ClassicHeader(
          clamping: true,
        ),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1), (){});
          _refreshController.finishRefresh();
          return IndicatorResult.success;
        },
        onLoad: () async {
          await Future.delayed(const Duration(milliseconds: 1500), (){});
          _refreshController.finishLoad();
          return IndicatorResult.success;
        },
        child: NotificationListener(
          onNotification: (ScrollNotification scrollInfo) {
            print('onNotification ${scrollInfo.metrics.pixels}');
            return true;
          },
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                ValueListenableBuilder(
                  valueListenable: _expandedHeight,
                  builder: (_, double height, child) {
                    // 计算图片的缩放大小
                    final scale = height / R.userProfileHeaderMaxHeight;

                    return SliverPersistentHeader(
                      pinned: true,
                      delegate: RedBookUserHomeHeaderDelegate(
                        topPadding: topPadding,
                        expandedHeight: height,
                        background: Transform.scale(
                          scale: scale,
                          child: Image.asset(
                            R.backgroundIcon,
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                          ),
                        ),
                        content: const RedBookUserHeaderContent(),
                        bottom: Container(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            controller: _tabController,
                            labelStyle: const TextStyle(
                              fontSize: R.fontSize18,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontSize: R.fontSize18,
                              fontWeight: FontWeight.normal,
                            ),
                            labelColor: R.tabSelectColor,
                            unselectedLabelColor: R.tabSelectColor,
                            // 设置 Tab 左对齐
                            tabAlignment: TabAlignment.start,
                            // 紧贴布局，设置下面两个属性
                            isScrollable: true,
                            physics: const NeverScrollableScrollPhysics(),
                            indicator: const RedBookUnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 2,
                                color: R.appRedBrand,
                              ),
                              isRound: true,
                              indicatorWidth: 20,
                              indicatorBottom: 6,
                            ),
                            tabs: _tabTitles
                                .map(
                                  (e) => RedBookTab(text: e),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    );
                  }
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: _tabTitles
                  .map(
                    (e) => ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (_, index) {
                        return ListTile(
                          title: Text('$e, #$index'),
                        );
                      },
                      itemCount: 100,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
