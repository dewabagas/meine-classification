// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meine_classification/presentation/views/page_image_classification.dart';
import 'injection_container.dart' as di;
import 'presentation/viewmodel/classification_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Memastikan Flutter binding siap
  await di.setup(); // Memanggil setup dan menunggu hingga selesai
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => ClassificationCubit(di.sl()),
        child: PageImageClassification(),
      ),
    );
  }
}
