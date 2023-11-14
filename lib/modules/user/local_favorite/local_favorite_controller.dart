import 'package:wanime/app/app_constant.dart';
import 'package:wanime/app/controller/base_controller.dart';
import 'package:wanime/models/db/local_favorite.dart';
import 'package:wanime/services/db_service.dart';
import 'package:get/get.dart';

class LocalFavoriteController extends BasePageController<LocalFavorite> {
  var editMode = false.obs;
  @override
  Future<List<LocalFavorite>> getData(int page, int pageSize) async {
    if (page > 1) {
      return [];
    }
    return DBService.instance.localFavoriteBox.values
        .where((x) => x.type == AppConstant.kTypeComic)
        .toList();
  }

  void cancelEdit() {
    for (var item in list) {
      item.isChecked.value = false;
    }
    editMode.value = false;
  }

  void cancelFavorite() async {
    var items = list.where((x) => x.isChecked.value).toList();
    if (items.isEmpty) {
      cancelEdit();
      return;
    }
    cancelEdit();
    for (var item in items) {
      DBService.instance.removeComicFavorite(comicId: item.objId);
    }

    refreshData();
  }
}
