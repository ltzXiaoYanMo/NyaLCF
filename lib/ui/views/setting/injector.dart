import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf/controllers/frpcSettingController.dart';
import 'package:nyalcf/controllers/launcherSettingController.dart';
import 'package:nyalcf/ui/models/AppbarActions.dart';
import 'package:nyalcf/ui/models/FloatingActionButton.dart';
import 'package:nyalcf/ui/views/setting/frpcSetting.dart';
import 'package:nyalcf/ui/views/setting/launcherSetting.dart';

class SettingInjector extends StatelessWidget {
  const SettingInjector({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final FrpcSettingController fsctr =
        Get.put(FrpcSettingController(context: context));
    final DSettingLauncherController dslctr =
        Get.put(DSettingLauncherController());
    fsctr.load();
    dslctr.load();

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text('$title - 设置',
                  style: const TextStyle(color: Colors.white)),
              actions:
                  AppbarActionsX(context: context, setting: false).actions(),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.launch, color: Colors.white),
                    child: Text(
                      '启动器',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Tab(
                    icon: Icon(Icons.support, color: Colors.white),
                    child: Text(
                      'FRPC',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                LauncherSetting().widget(),
                FrpcSetting(context: context).widget()
              ],
            ),
            floatingActionButton: FloatingActionButtonX().button()));
  }
}
