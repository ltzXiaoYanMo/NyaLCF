import 'dart:io';

import 'package:nyalcf_core/storages/stores/frpc_storage.dart';

class FrpcPathProvider {
  final _fss = FrpcStorage();

  Future<String> get frpcWorkPath async => await _fss.getRunPath();

  Future<String?> get frpcPath async {
    final String? path;
    final String? appFrpcPath = await _fss.getFilePath();
    final String? envFrpcPath = Platform.environment['NYA_LCF_FRPC_PATH'];
    if (envFrpcPath != null) {
      path = envFrpcPath;
    } else {
      path = appFrpcPath;
    }
    return path;
  }
}
