import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nyalcf/main_tray.dart';
import 'package:nyalcf/protocol_activation.dart';
import 'package:nyalcf/utils/Logger.dart';
import 'package:nyalcf/utils/frpc/ProcessManager.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class MainWindow {
  /// 启动操作
  static void doWhenWindowReady() async {
    // 禁用系统窗口操作（主要适配MacOS）
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    // 设置主窗体参数
    const initialSize = Size(800, 500);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = 'Nya LoCyanFrp! - 乐青映射启动器';

    // 设置托盘菜单
    await trayManager.setToolTip('Nya~');
    await trayManager.setIcon(
      Platform.isWindows ? 'asset/icon/icon.ico' : 'asset/icon/icon.png',
    );
    trayManager.setContextMenu(MainTray.menu);

    // Protocol Channel
    void callback(deepLink) {
      Logger.debug(deepLink);
    }
    await ProtocolActivation.registerProtocolActivation(callback);

    // 显示主窗体
    appWindow.show();
  }

  /// 关闭拦截
  static void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      appWindow.restore();
      await Get.dialog(AlertDialog(
        title: Text('关闭 Nya LoCyanFrp!'),
        content: Text('确定要关闭 Nya LoCyanFrp! 吗，要是 Frpc 没关掉猫猫会生气把 Frpc 一脚踹翻的哦！'),
        actions: <Widget>[
          TextButton(
              child: Text(
                '取消',
              ),
              onPressed: () async {
                Get.close(0);
              }),
          TextButton(
            child: Text(
              '确定',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              try {
                FrpcProcessManager().killAll();
              } catch (e) {
                Logger.error('Failed to close all process: ${e}');
              }
              appWindow.close();
              windowManager.destroy();
            },
          ),
        ],
      ));
    }
  }
}
