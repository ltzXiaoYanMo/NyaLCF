import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:get/get.dart';
import 'package:highlight/languages/ini.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:nyalcf/controllers/proxies_controller.dart';
import 'package:nyalcf/controllers/user_controller.dart';
import 'package:nyalcf/storages/configurations/proxies_configuration_storage.dart';

class FrpcConfigEditorDialogX {
  FrpcConfigEditorDialogX({
    required this.context,
  });

  final BuildContext context;

  final UserController uctr = Get.find();
  final ProxiesController pctr = Get.find();

  CodeController _controller(defText) => CodeController(
        text: defText,
        language: ini,
        analyzer: const DefaultLocalAnalyzer(),
      );

  Widget dialog(text, {required proxyId}) {
    final c = _controller(text);
    return AlertDialog(
      title: const Text('编辑配置文件'),
      content: SizedBox(
        width: 600.0,
        child: CodeTheme(
          data: CodeThemeData(
            styles: monokaiSublimeTheme,
          ),
          child: SingleChildScrollView(
              child: CodeField(
            controller: c,
            gutterStyle: const GutterStyle(
              showErrors: false,
              showLineNumbers: false,
            ),
            textStyle: const TextStyle(
              fontFamily: 'Droid Sans Mono',
              fontSize: 12,
            ),
          )),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('放弃'),
          onPressed: () {
            Get.close(0);
          },
        ),
        ElevatedButton(
          child: const Text('保存'),
          onPressed: () async {
            //关闭 返回true
            await ProxiesConfigurationStorage.setConfig(proxyId, c.fullText);
            pctr.reload(uctr.user, uctr.token);
            Get.close(0);
          },
        ),
      ],
    );
  }

  Widget loading() {
    return SimpleDialog(
      title: const Text('首次编辑，正在获取...'),
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              left: 40.0, right: 40.0, bottom: 10.0, top: 5.0),
          child: const Column(
            children: <Widget>[
              SizedBox(
                height: 22.0,
                width: 22.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}