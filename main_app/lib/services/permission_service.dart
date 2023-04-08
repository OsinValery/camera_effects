import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// returns null if permission is permanently denied
  /// returns true if permitted else false
  Future<bool?> requestPermission(Permission permission) async {
    var status = await permission.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }
    if (status.isPermanentlyDenied) return null;

    var newStatus = await permission.request();
    if (newStatus.isGranted || newStatus.isLimited) {
      return true;
    }
    if (newStatus.isPermanentlyDenied) return null;
    return false;
  }

  Future<bool?> havePermission(Permission permission) async {
    var status = await permission.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }
    if (status.isPermanentlyDenied) return null;
    return false;
  }
}
