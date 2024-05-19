import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_core/models/update_info_model.dart';
import 'package:nyalcf_core/utils/logger.dart';
import 'package:nyalcf_core/utils/network/dio/launcher/launcher.dart';
import 'package:nyalcf_core/utils/universe.dart';
import 'package:url_launcher/url_launcher.dart';

class Updater {
  static late final UpdateInfoModel uIf;

  static void startUp() async {
    Logger.info('Checking update...');

    // 获取远程源版本
    final remote = await UpdateLauncher().getUpdate();
    if (remote.status) {
      // 远程源版本获取到的时候才检测
      uIf = remote.data['update_info'];
      if (check()) {
        showDialog();
      } else {
        Logger.info('You are running latest version.');
        // 计划下一次检查
        Future.delayed(const Duration(hours: 1), () {
          startUp();
        });
      }
    } else {
      Logger.warn('Get remote version info failed.');
    }
  }

  static bool check() {
    Logger.debug('${uIf.version}, ${uIf.buildNumber} | v${Universe.appVersion}, ${Universe.appBuildNumber}');

    // 比对是否一致
    // 先判断大版本号，大版本号不一致就不检查构建号了
    // 大版本号一致再检查构建号
    if ('v${Universe.appVersion}' != uIf.version) {
      Logger.info('New version: ${uIf.version}');
      return true;
    } else if (uIf.buildNumber != Universe.appBuildNumber) {
      Logger.info('New version: ${uIf.version}');
      return true;
    } else {
      return false;
    }
  }

  static void showDialog() {
    Get.dialog(AlertDialog(
      icon: const Icon(Icons.update),
      title: const Text('好耶！是新版本！'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('当前版本：v${Universe.appVersion} (+${Universe.appBuildNumber})'),
          Text('更新版本：${uIf.version} (+${uIf.buildNumber})'),
          const Text('是否打开下载界面喵？'),
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: const Text(
              '取消',
            ),
            onPressed: () async {
              Get.close(0);
            }),
        TextButton(
          child: const Text(
            '确定',
          ),
          onPressed: () async {
            const url = 'https://nyalcf.1l1.icu/download';
            if (!await launchUrl(Uri.parse(url))) {
              Get.snackbar(
                '发生错误',
                '无法打开网页，请检查设备是否存在WebView',
                snackPosition: SnackPosition.BOTTOM,
                animationDuration: const Duration(milliseconds: 300),
              );
            } else {
              Get.close(0);
            }
          },
        ),
      ],
    ));
  }
}
