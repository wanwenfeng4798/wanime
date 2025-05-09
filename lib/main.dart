import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanime/app/app_style.dart';
import 'package:wanime/models/db/comic_download_info.dart';
import 'package:wanime/models/db/download_status.dart';
import 'package:wanime/models/db/local_favorite.dart';
import 'package:wanime/models/db/novel_download_info.dart';
import 'package:wanime/services/app_settings_service.dart';
import 'package:wanime/app/log.dart';
import 'package:wanime/app/utils.dart';
import 'package:wanime/models/db/comic_history.dart';
import 'package:wanime/models/db/novel_history.dart';
import 'package:wanime/services/comic_download_service.dart';
import 'package:wanime/services/novel_download_service.dart';
import 'package:wanime/services/db_service.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:wanime/routes/app_pages.dart';
import 'package:wanime/services/local_storage_service.dart';
import 'package:wanime/services/user_service.dart';
import 'package:wanime/widgets/status/app_loadding_widget.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:windows_single_instance/windows_single_instance.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      if (Platform.isWindows) {
        await WindowsSingleInstance.ensureSingleInstance(
          [],
          "com.xycz.dmzjx",
          onSecondWindow: (args) {
            Log.logPrint(args);
          },
        );
      }
      await Hive.initFlutter();
      //初始化服务
      await initServices();
      //设置状态栏为透明
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      runApp(const DMZJApp());
    },
    (error, stackTrace) {
      //全局异常
      Log.e(error.toString(), stackTrace);
    },
  );
}

Future initServices() async {
  //包信息
  Utils.packageInfo = await PackageInfo.fromPlatform();
  //本地存储
  Log.d("Init LocalStorage Service");
  await Get.put(LocalStorageService()).init();

  //用户信息
  Log.d("Init User Service");
  Get.put(UserService()).init();

  //注册Hive适配器
  Hive.registerAdapter(ComicHistoryAdapter());
  Hive.registerAdapter(NovelHistoryAdapter());
  Hive.registerAdapter(DownloadStatusAdapter());
  Hive.registerAdapter(ComicDownloadInfoAdapter());
  Hive.registerAdapter(NovelDownloadInfoAdapter());
  Hive.registerAdapter(LocalFavoriteAdapter());
  await Get.put(DBService()).init();

  //初始化设置服务
  Get.put(AppSettingsService());

  //初始化漫画下载服务
  Get.put(ComicDownloadService()).init();
  //初始化小说下载服务
  Get.put(NovelDownloadService()).init();
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}

class DMZJApp extends StatelessWidget {
  const DMZJApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '动漫之家 X',
      scrollBehavior: AppScrollBehavior(),
      theme: AppStyle.lightTheme,
      darkTheme: AppStyle.darkTheme,
      themeMode:
          ThemeMode.values[Get.find<AppSettingsService>().themeMode.value],
      initialRoute: AppPages.kIndex,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale("zh", "CN"),
      supportedLocales: const [Locale("zh", "CN")],
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
        loadingBuilder: ((msg) => const AppLoaddingWidget()),
        //字体大小不跟随系统变化
        builder: (context, child) => Obx(
          () => MediaQuery(
            data: AppSettingsService.instance.useSystemFontSize.value
                ? MediaQuery.of(context)
                : MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          ),
        ),
      ),
    );
  }
}
