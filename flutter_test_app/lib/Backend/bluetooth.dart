import 'dart:developer';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/* import  'package:flutter_riverpod/flutter_riverpod.dart';
 */
import 'package:flutter_test_app/navigation/app_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bluetooth.g.dart';

final bleInst = FlutterReactiveBle();


//Stream<BleStatus> get getstatestream => flutterReactiveBle.statusStream;

/* final bleStatusProvider = StreamProvider<BleStatus>((ref) {
  return bleInst.statusStream;
});  */

@riverpod
Stream<BleStatus> bleStatus(Ref ref) {
  return bleInst.statusStream;
}


/* final bleStatus = StreamProvider.autoDispose<BleStatus>((ref) {
  return bleInst.statusStream;
});  */

String initialBleStatus() {
  log(bleInst.status.toString());

  if (bleInst.status == BleStatus.ready) {
    return "/${AppRouting.onPathName}";
  }
  return "/";
}
