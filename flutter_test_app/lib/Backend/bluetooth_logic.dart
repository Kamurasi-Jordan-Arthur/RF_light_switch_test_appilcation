import 'dart:async';
import 'dart:developer';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/* import  'package:flutter_riverpod/flutter_riverpod.dart';
 */
import 'package:flutter_test_app/navigation/app_routing.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bluetooth_logic.g.dart';


final bleInst = FlutterReactiveBle();


//Stream<BleStatus> get getstatestream => flutterReactiveBle.statusStream;

/* final bleStatusProvider = StreamProvider<BleStatus>((ref) {
  return bleInst.statusStream;
});  */

@riverpod
Stream<BleStatus> bleStatus(Ref ref) {
  return bleInst.statusStream;
}

const int scanseconds = 5;

late StreamSubscription<DiscoveredDevice> scanDevicesSub;

void scanDevices({required Ref ref}) {

  scanDevicesSub = bleInst
      .scanForDevices(withServices: [])
      .listen(
        (device) => ref
            .read(foundBleDevicesProvider.notifier)
            .appendDevice(device),
        onError: (err) => log("Scan error: $err"),
      );

    log("Scanning Started.");

  Future.delayed(const Duration(seconds: scanseconds), () {
    log("Scanning Stoped.");
    
    return scanDevicesSub.cancel();
  });
}


@riverpod
Stream<ConnectionStateUpdate>  connecToDevice(Ref ref, {required int  index}){
      var currentState = ref.read(foundBleDevicesProvider);
      
      return bleInst.connectToDevice(
          id: currentState[index].id,
          connectionTimeout: Duration(seconds: 5),
      );
  }

/* class SPC5x {
             
    final String name;
    final conn connectable;
    
    final String address;
    final List<Uuid> services;

    SPC5x({required this.name,
           required this.address,
           required this.services});


} */



@riverpod
class FoundBleDevices extends _$FoundBleDevices {
    @override
    List<DiscoveredDevice> build() {
        scanDevices(ref: ref);
        return [];
        
      }

    void appendDevice(DiscoveredDevice device){
      try {
        if (!state.any((d) =>(
          d.manufacturerData == device.manufacturerData || 
          d.serviceUuids == device.serviceUuids ||
          d.id == device.id))){
              state = [...state, device];
              log("Found: ${device.toString()}");
          }
      } catch (e) {
        log(e.toString());
        }
      }

    DiscoveredDevice deviceFromIndex({required int index}){
        return state[index];
    } 

    void rescan(){
      state = [];
      scanDevices(ref: ref);
    }

    
}



String initialBleStatus() {
  log(bleInst.status.toString());

  if (bleInst.status == BleStatus.ready) {
    return "/${AppRouting.onPathName}";
  }
  return "/";
}
