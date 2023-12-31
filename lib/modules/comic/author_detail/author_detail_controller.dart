import 'package:wanime/app/app_constant.dart';
import 'package:wanime/app/controller/base_controller.dart';
import 'package:wanime/models/comic/author_model.dart';
import 'package:wanime/requests/comic_request.dart';
import 'package:wanime/services/user_service.dart';
import 'package:get/get.dart';

class ComicAuthorDetailController extends BaseController {
  final int id;
  ComicAuthorDetailController(this.id);

  final ComicRequest request = ComicRequest();

  Rx<ComicAuthorModel?> detail = Rx<ComicAuthorModel?>(null);

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  void loadData() async {
    try {
      pageLoadding.value = true;
      pageError.value = false;
      var result = await request.authorDetail(id: id);
      detail.value = result;
    } catch (e) {
      pageError.value = true;
      errorMsg.value = e.toString();
    } finally {
      pageLoadding.value = false;
    }
  }

  void subscribeAll() {
    if (detail.value == null) {
      return;
    }
    UserService.instance.addSubscribe(
      detail.value!.data.map((e) => e.id).toList(),
      AppConstant.kTypeComic,
    );
  }
}
