import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/utils/frpc/process_manager.dart';

/// 控制台 GetX 状态控制器
class ConsoleController extends GetxController {
  var widgets = <DataRow>[].obs;

  /// UI组件列表
  var processList = <Map<String, dynamic>>[].obs;

  /// 进程管理列表

  /// 添加进程
  addProcess(Map<String, dynamic> pMap) {
    processList.add(pMap);
    processList.refresh();
  }

  /// 移除进程
  removeProcess(Map<String, dynamic> pMap) {
    processList.remove(pMap);
    processList.refresh();
  }

  /// 清空进程
  clearProcess() {
    processList.clear();
    processList.refresh();
    load();
  }

  /// 加载进程管理信息
  load() {
    widgets.value = <DataRow>[];
    for (Map<String, dynamic> element in processList) {
      final Process process = element['process'];
      final int proxyId = element['proxy_id'];

      /// 添加进程管理信息至UI组件列表
      widgets.add(DataRow(cells: <DataCell>[
        DataCell(Text(process.pid.toString())),

        /// 进程ID
        DataCell(Text(proxyId.toString())),

        /// 代理ID
        DataCell(
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              /// 杀死进程
              FrpcProcessManager().kill(element);
              load();
            },
          ),
        ),
      ]));
      widgets.refresh();
    }
  }
}
