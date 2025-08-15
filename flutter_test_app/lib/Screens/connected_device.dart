import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart' show FilePicker, FilePickerResult, FileType;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/Backend/bluetooth_logic.dart';
import 'package:flutter_test_app/UI_Generics/ui_generics.dart';
import 'package:flutter_test_app/navigation/app_routing.dart';
import 'package:go_router/go_router.dart';



class Devicewidget extends ConsumerStatefulWidget {
  final int deviceIndex;
  const Devicewidget({super.key, required this.deviceIndex});

  @override
  ConsumerState<Devicewidget> createState() => _DevicewidgetState();
}

class _DevicewidgetState extends ConsumerState<Devicewidget> {
    List<int> filedata = [];
    String filename = "";
    String updatestate = "";


  @override
  Widget build(BuildContext context) {
    var deviceConnectionState = ref.watch(connecToDeviceProvider(index: widget.deviceIndex));
    //var connectedDevice = ref.read(foundBleDevicesProvider.notifier).deviceFromIndex(index : deviceIndex);
    //var mm = ref.watch(bleStatusProvider);
    //log(filedata.toString());


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

      getFile() async{
        filedata = [];
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['bin', 'hex', 'txt'],
          withData: true,
        );
        

        if (result != null) {

          final file = File(result.files.single.path!);
          var lines  = await file.readAsLines();
          //final filedata = <int>[];

          for (final line in lines) {
            if (line.startsWith('@') || line.trim().isEmpty) continue;
            if (line.trim().toLowerCase() == 'q') break;

            final bytes = line.split(' ')
                .where((b) => b.isNotEmpty)
                .map((b) => int.parse(b, radix: 16));
              filedata.addAll(bytes);
              /* setState(() {

              }); */
          }
          filename = result.files.first.name;
          setState(() { });


        }
      }

      uploadFile() async{
        var deviceId = deviceConnectionState.value!.deviceId;
        var serviceId = Uuid.parse("222c444c-8fc9-4318-b4a6-3214cf2200c0");
        var characteristicId = Uuid.parse("85342c44-a1ac-43fd-8610-f4bec833e11d");
        var qCharacteristic = QualifiedCharacteristic(characteristicId: characteristicId, serviceId: serviceId, deviceId: deviceId);
        var chunkSize = await bleInst.requestMtu(deviceId: deviceConnectionState.value!.deviceId, mtu: 244);

        log("MTU : $chunkSize");
        
      await bleInst.writeCharacteristicWithoutResponse(
            qCharacteristic,
            value: [103,],
      );
      return;

      for (var i = 0; i < filedata.length; i += chunkSize) {
        final chunk = filedata.sublist(
            i, i + chunkSize > filedata.length ? filedata.length : i + chunkSize);

        await bleInst.writeCharacteristicWithResponse(
          qCharacteristic,
          value: chunk,
        );

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
                body: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //crossAxisAlignment:,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          filename,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    //SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

                    ElevatedButton.icon(
                                onPressed: (filedata.isNotEmpty) ? 
                                 uploadFile:
                                 (){},
                              icon: Icon(Icons.file_upload_sharp,
                                  size: MediaQuery.of(context).size.height * 0.1,
                                  color: (filedata.isNotEmpty) ? 
                                      Theme.of(context).colorScheme.inversePrimary.withOpacity(0.9):
                                      Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
                                  semanticLabel: "Upload"),
                    
                                  label: Text("Upload"),
                        ),
                      //SizedBox(height: MediaQuery.of(context).size.height * 0.05,),

                      ElevatedButton.icon(
                                onPressed: getFile,
                                icon: Icon(Icons.folder_outlined,
                                    size: MediaQuery.of(context).size.height * 0.1,
                                    color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.9),
                                    semanticLabel:"Select File"),
                                    label: Text("Select File"),
                        ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                      Text(updatestate),
                  ],
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
          log("Obj : $obj \n stack: $stack");
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