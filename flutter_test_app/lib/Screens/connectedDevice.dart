import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/Backend/bluetooth_logic.dart';
import 'package:flutter_test_app/UI_Generics/ui_generics.dart';
class Devicewidget extends ConsumerWidget {
  final int deviceIndex;
  const Devicewidget({super.key, required this.deviceIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var deviceConnectionState = ref.watch(connecToDeviceProvider(index: deviceIndex));
    var connectedDevice = ref.read(foundBleDevicesProvider.notifier).deviceFromIndex(index : deviceIndex);

    deviceConnectionState;
    return MyHomePage(
      message: connectedDevice.id,
      body: Placeholder(),
    );
  }
}