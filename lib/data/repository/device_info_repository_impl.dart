import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/repository/device_info_repository.dart';

class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  @override
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
