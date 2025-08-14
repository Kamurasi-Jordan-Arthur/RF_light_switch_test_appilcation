import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key,
  required this.message, required this.body,
  this.floatingActionButton,
  this.postbuildcallback });

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String message;
  final Widget body;
  final Widget? floatingActionButton;
  final VoidCallback? postbuildcallback;



  @override
  Widget build(BuildContext context, WidgetRef ref) {

      WidgetsBinding.instance.addPostFrameCallback((_){
        postbuildcallback?.call();
        
      }
    );
    
    return Scaffold(
      appBar:AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              elevation: 0, // Removes shadow for a flat look
              centerTitle: true, // Centers the title for symmetry
              toolbarHeight: MediaQuery.of(context).size.height * 0.2,
              title: Text(
                message,
                style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(
                            //fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                            //letterSpacing: 2.0,
                          ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(5), // Soft curve at the bottom
                ),
              ),
            ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
