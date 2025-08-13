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
import 'package:flutter_test_app/Backend/bluetooths.dart';
import 'package:permission_handler/permission_handler.dart';


class BtOnWidget extends StatelessWidget {
  const BtOnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MyHomePage(
    message: "Scanning",

    body:  Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ON',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

          ],
        ),
      )
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
        diplayicon = Icons.bluetooth;
        aidText = "Tap to scan devices";
        feedbackText = "Powered ready";

        ontap = (){
          // Need to enable bluetooth
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
                Permission.bluetoothScan,
                Permission.bluetoothConnect,
              ].request();
          }

          if (status.values.any((value) => !value.isGranted )){
              log(status.toString());
              await openAppSettings();
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
    message: "Bluetooth Disconnected",

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
          )
      ,     ),
    )
      );
  }
}