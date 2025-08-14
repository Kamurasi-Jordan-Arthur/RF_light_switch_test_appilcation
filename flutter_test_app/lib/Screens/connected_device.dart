import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart' show FilePicker, FilePickerResult, custom, FileType, PlatformFile;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/Backend/bluetooth_logic.dart';
import 'package:flutter_test_app/UI_Generics/ui_generics.dart';
import 'package:flutter_test_app/navigation/app_routing.dart';
import 'package:go_router/go_router.dart';
class Devicewidget extends ConsumerWidget {
  final int deviceIndex;
  const Devicewidget({super.key, required this.deviceIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var deviceConnectionState = ref.watch(connecToDeviceProvider(index: deviceIndex));
    late FilePickerResult? result;
    //var connectedDevice = ref.read(foundBleDevicesProvider.notifier).deviceFromIndex(index : deviceIndex);
    //var mm = ref.watch(bleStatusProvider);


    void connectionErrorPostBuild(){
      switch (deviceConnectionState.value?.connectionState) {
        case DeviceConnectionState.connecting:
        
          break;
        case DeviceConnectionState.connected:
          break;
        case DeviceConnectionState.disconnecting:
          break;
        case DeviceConnectionState.disconnected:
            String disconnectedMsg = "Disconnected";

            if(deviceConnectionState.value?.failure != null){
              disconnectedMsg = deviceConnectionState.value!.failure!.message;
            }

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Center(child: Text(disconnectedMsg)),
                  ),
              );

            context.goNamed(AppRouting.onPathName);

          break;
        default:
        break;
      }
    }
        
    Widget connectionWidget({required ConnectionStateUpdate state}){
          switch (state.connectionState) {
            case DeviceConnectionState.connecting:
            return MyHomePage(
                        message: deviceConnectionState.value?.deviceId ?? "Unkown device",
                        body: Center(
                          child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                      strokeWidth: 3,
                                    ),
                        ),
                      );
                        /* 
            case DeviceConnectionState.connected:
            case DeviceConnectionState.disconnecting:
            case DeviceConnectionState.disconnected:
              return MyHomePage(
                  message: deviceConnectionState.value?.deviceId ?? "Unkown device",
                  body: Center(child: Text(state.toString())),
                  postbuildcallback: connectionErrorPostBuild,

                  );
 */
            default:
              
              return MyHomePage(
                message: deviceConnectionState.value?.deviceId ?? "Unkown device",
                body: Center(child: ElevatedButton.icon(
                            onPressed: (result != null) ? 
                             (){}:
                             () async{
                                    result = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['bin', 'hex', 'txt'],
                                      withData: true,
                                    );

                                    if (result != null) {
                                      PlatformFile file1 = result!.files.first;
                                      log(file1.name);
                                      log(file1.bytes?.toString() ?? "Bytes");
                                      log("${file1.size}");
                                      log(file1.extension ?? "Ext");
                                      log(file1.path.toString());
                                    }
                            },
                          icon: Icon((result != null) ? 
                              Icons.file_upload_sharp:
                              Icons.folder_outlined,
                              size: MediaQuery.of(context).size.height * 0.1,
                              color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.9),
                              semanticLabel: (result != null) ? 
                              "Upload":
                              "Select File",
                                ),
                                label: Text("Select File"),
                    )
                  ),
                postbuildcallback: connectionErrorPostBuild,

                );

          }
        }

    return deviceConnectionState.when(
      data: (state) { 
        //ConnectionStateUpdate 
          log(state.failure?.message ?? "Null");
          return connectionWidget(state: state);
        },
      error: (obj, stack){

          return Center(child: Text("Error"));
        },
      loading: () =>  MyHomePage(
                        message: deviceConnectionState.value?.deviceId ?? "Unkown device",
                        body: Center(
                          child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                      strokeWidth: 3,
                                    ),
                        ),
                      ),
      );
  }
}