import 'package:flutter/material.dart';
import 'package:wanime/modules/comic/home/category/comic_category_view.dart';
import 'package:wanime/modules/comic/home/comic_home_controller.dart';
import 'package:wanime/modules/comic/home/latest/comic_latest_view.dart';
import 'package:wanime/modules/comic/home/rank/comic_rank_view.dart';
import 'package:wanime/modules/comic/home/recommend/comic_recommend_view.dart';
import 'package:wanime/modules/comic/home/special/comic_special_view.dart';
import 'package:wanime/widgets/tab_appbar.dart';
import 'package:get/get.dart';

class ComicHomePage extends GetView<ComicHomeController> {
  const ComicHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        tabs: const [
          Tab(text: "推荐"),
          Tab(text: "更新"),
          Tab(text: "分类"),
          Tab(text: "排行"),
          Tab(text: "专题"),
        ],
        controller: controller.tabController,
        action: IconButton(
          onPressed: controller.search,
          icon: const Icon(
            Icons.search,
          ),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [
          ComicRecommendView(),
          ComicLatestView(),
          ComicCategoryView(),
          ComicRankView(),
          ComicSpecialView(),
        ],
      ),
    );
  }
}
