import 'package:wanime/app/controller/base_controller.dart';
import 'package:wanime/models/comic/special_model.dart';
import 'package:wanime/requests/comic_request.dart';
import 'package:wanime/routes/app_navigator.dart';

class ComicSpecialController extends BasePageController<ComicSpecialModel> {
  final ComicRequest request = ComicRequest();

  @override
  Future<List<ComicSpecialModel>> getData(int page, int pageSize) async {
    var ls = await request.special(page: page - 1);

    return ls;
  }

  void toDetail(ComicSpecialModel item) {
    if (item.pageType == 3) {
      AppNavigator.toSpecialDetail(item.id);
    } else {
      AppNavigator.toWebView(item.pageUrl);
    }
  }
}
