import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyalcf_inject/nyalcf_inject.dart';
import 'package:nyalcf_core/storages/prefs/user_info_prefs.dart';
import 'package:nyalcf_ui/models/appbar_actions.dart';
import 'package:nyalcf_ui/models/floating_action_button.dart';
import 'package:nyalcf_core/utils/network/dio/auth/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$title - 登录', style: TextStyle(color: Colors.white)),
        actions: AppbarActionsX(context: context).actions(),
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(40.0),
          constraints: const BoxConstraints(maxWidth: 400.0),
          child: Column(children: <Widget>[
            const Text(
              '登录到LoCyanFrp',
              style: TextStyle(fontSize: 30),
            ),
            Form(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: '用户名',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      controller: userController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: '密码',
                        prefixIcon: Icon(Icons.key),
                        border: OutlineInputBorder(),
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => _login(),
                      child: const Text('登录'),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButtonX().button(),
    );
  }

  void _login() async {
    loading.value = true;
    if (userController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        '无效数据',
        '请输入用户名或密码',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      return;
    }

    Get.snackbar(
      '登录中',
      '正在请求...',
      snackPosition: SnackPosition.BOTTOM,
      animationDuration: const Duration(milliseconds: 300),
    );
    final res = await LoginAuth()
        .requestLogin(userController.text, passwordController.text);
    if (res.status) {
      await UserInfoPrefs.setInfo(res.data['user_info']);
      UserInfoPrefs.saveToFile();
      Get.snackbar(
        '登录成功',
        '欢迎您，指挥官 ${res.data['user_info'].user}',
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
      Get.toNamed('/panel/home');
    } else {
      Get.snackbar(
        '登录失败',
        res.message,
        snackPosition: SnackPosition.BOTTOM,
        animationDuration: const Duration(milliseconds: 300),
      );
    }
    loading.value = false;
  }
}
