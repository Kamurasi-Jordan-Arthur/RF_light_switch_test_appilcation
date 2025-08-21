//import 'dart:developer';

import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test_app/UI_Generics/ui_generics.dart';
import 'package:device_info_plus/device_info_plus.dart';

//import 'dart:developer';
import 'package:flutter_test_app/Backend/bluetooth_logic.dart';
import 'package:flutter_test_app/navigation/app_routing.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';


class BtOnWidget extends ConsumerStatefulWidget {
  const BtOnWidget({super.key});


  @override
  ConsumerState<BtOnWidget> createState() => _BtOnWidgetState();
}

class _BtOnWidgetState extends ConsumerState<BtOnWidget> {
  bool isdiscovring = true;
  late List<DiscoveredDevice> spc5xDevices;
  late BleStatus? blestatus ;


/*   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_){

          if(blestatus != BleStatus.ready){
            log("Setting state");
            ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(child: Text('Device is unconnectable!')),
                        ),
                      );
          }
      }
    );
  } */


  @override
  Widget build(BuildContext context) {
    
    spc5xDevices = ref.watch(foundBleDevicesProvider);
    blestatus = ref.watch(bleStatusProvider).value;

    final rowspacing = MediaQuery.of(context).size.height * 0.01; 

    if(ref.read(foundBleDevicesProvider).isEmpty && isdiscovring){
      //workAround for cases when the scan ends and no device found
        log("Timer Armed.");

        Future.delayed(const Duration(seconds: scanseconds), () {
           //  if(ref.read(foundBleDevicesProvider).isEmpty){
              setState(() {
                log("setting state.");
                isdiscovring = false;
              });
            // }

          });
    }




    return MyHomePage(
    message: (ref.read(foundBleDevicesProvider).isEmpty) ? 
              (isdiscovring) ? 
              "Discovering ..." : "No Devices in visinity" :
              (isdiscovring) ? 
              "Discovering ..." : "Dicovered Devices",

    body: (spc5xDevices.isEmpty) 
          ?  (!isdiscovring) ? 
          SizedBox() : 
          Center(
            child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  strokeWidth: 3,
                ),
          ) : 
          Padding(
          padding: EdgeInsets.only(
            top: rowspacing,
            left: rowspacing,
            right: rowspacing,
          ),
          child: Column(
            children: [
              (!isdiscovring) ? SizedBox() :
              Center(
                child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      strokeWidth: 3,
                    ),
              ) 
              ,Expanded(
              child: ListView.builder(
                itemCount: spc5xDevices.length,
                itemBuilder: (context, index) {
                  final device = spc5xDevices[index];
              
                  return ListTile(
                    leading: Icon(
                      Icons.bluetooth_connected_outlined,
                      size: rowspacing * 4,
                      color: (device.connectable == Connectable.available)
                          ? Colors.blue
                          : Colors.grey,
                    ),

                    title: Text(
                      device.name.isNotEmpty ? device.name : "N/A",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.blue,
                        letterSpacing: 1.5,
                        fontSize: rowspacing * 2.5,
                      ),
                    ),
                    subtitle: Text(device.id.toString()),
                    trailing: ElevatedButton(onPressed: (){
                      if (blestatus != BleStatus.ready) {
                        log("Back to Offstate.");
                        context.goNamed(AppRouting.offPathName);
                        return;
                      }
              
                      if (device.connectable == Connectable.available) {
                        log("Connecting to ${device.id}");
                        context.goNamed(AppRouting.connectedDevice, pathParameters: {"deviceIndex" : index.toString()});
                        //connecToDevice(index: index);
                        //ref.read(foundBleDevicesProvider.notifier).connecto(index);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Center(child: Text('Device is unconnectable!')),
                          ),
                        );
                      }
                    }, child: Text("Select")),
                    onTap: () {
                      if (blestatus != BleStatus.ready) {
                        log("Back to Offstate.");
                        context.goNamed(AppRouting.offPathName);
                      }
                    },
                  );
                },
              ),
            ),
            ]
          ),
        ),

    floatingActionButton: FloatingActionButton(
      child: Text("SCAN"),
      onPressed: (){
        if (blestatus == BleStatus.ready) {
            if(!isdiscovring){
                isdiscovring = true;
                ref.read(foundBleDevicesProvider.notifier).rescan();
              
            }
        }else{
          context.goNamed(AppRouting.offPathName);
        }

    }),

    );

  }
}







class BtOffWidget extends ConsumerWidget {
  const BtOffWidget({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final blestatus = ref.watch(bleStatusProvider).value;

    final IconData diplayicon;

    GestureTapCallback? ontap;

    String? aidText;

    String feedbackText = "";

    log(blestatus.toString());

    switch (blestatus) {
      case BleStatus.ready:
        diplayicon = Icons.search;
        aidText = "Tap to scan devices";
        feedbackText = "Powered & ready";

        ontap = (){
          // Need to enable bluetooth
          context.goNamed(AppRouting.onPathName);
        };
        break;

        case BleStatus.poweredOff:
        diplayicon = Icons.bluetooth_disabled;
        aidText = "Tap to Enable";
        feedbackText = "Powered Off";

        ontap = () async{
          // Need to enable bluetooth
          await AppSettings.openAppSettings(type: AppSettingsType.bluetooth, asAnotherTask: false);
        };
        break;
      case BleStatus.unauthorized:
        diplayicon = Icons.do_not_disturb_alt;
        aidText = "Tap to grant permission.";
        feedbackText = "Missing Permisions!";
        late Map<Permission, PermissionStatus> status;

        ontap = () async{
          if (Platform.isAndroid) {
            final androidInfo = await DeviceInfoPlugin().androidInfo;
            final sdkInt = androidInfo.version.sdkInt;
            if (sdkInt >= 31) {
              status = await [
                Permission.bluetoothScan,
                Permission.bluetoothConnect,
              ].request();
            } else {
              status = await [
                Permission.bluetooth,
                Permission.locationWhenInUse,
              ].request();
            }
          }else{
              status = await [
                Permission.bluetooth,
              ].request();
          }

          if (status.values.any((value) => !value.isGranted )){
              log(status.toString());
              /* await openAppSettings(); */
              await AppSettings.openAppSettings(type: AppSettingsType.settings, asAnotherTask: true);
              log(status.toString());
            }
        };

        break;

      case BleStatus.unknown:
        diplayicon = Icons.do_not_disturb_alt;
        aidText = "Tap to grant permission.";
        feedbackText = "Missing Permisions!";

        ontap = () async{
          await openAppSettings();

          //bool type =  await openAppSettings();
          //log(type.toString());

        };

        break;

      case BleStatus.unsupported:
        diplayicon = Icons.disabled_by_default;
        feedbackText = "Unsuppotted!";

        aidText = "Device has no blutooth support.";

      default:
          diplayicon = Icons.disabled_by_default;
          ontap = (){
          // Need to Inform user of inability to help them out
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Center(child: Text('We are unable to help you out here.')),
            ),
          );

        };
        break;
    }



    return MyHomePage( 
    message: "RF Light Switch Test App",

    body:  GestureDetector(
      onTap: ontap,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Grouped Icon + Status Text
            Column(
              children: [
                Opacity(
                  opacity: 0.3,
                  child: Icon(
                    diplayicon,
                    size: MediaQuery.of(context).size.height * 0.35,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                //SizedBox(height: 7), // spacing between icon and text
                Text(
                  feedbackText,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
              
            ),
              
            // Feedback Text
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                aidText ?? "",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    )
      );
  }
}