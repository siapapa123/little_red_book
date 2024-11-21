import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'R.dart';
import 'views/red_book_tab.dart';
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

  @override
  void initState() {
    _tabController = TabController(length: _tabTitles.length, vsync: this,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: EasyRefresh(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                pinned: true,
                delegate: RedBookUserHomeHeaderDelegate(
                  topPadding: topPadding,
                  background: Image.asset(
                    R.backgroundIcon,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                  ),
                  bottom: Container(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 18,
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
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: _tabTitles
                .map(
                  (e) => Container(
                    alignment: Alignment.center,
                    child: Text(e),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
