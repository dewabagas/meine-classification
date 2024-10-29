// presentation/view/image_classification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:meine_classification/domain/models/classification_result.dart';
import 'package:meine_classification/presentation/viewmodel/classification_cubit.dart';

class PageImageClassification extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<ClassificationCubit>().classify(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Image Classification')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _pickImage(context),
            child: Text("Pick Image"),
          ),
          Expanded(
            child: BlocBuilder<ClassificationCubit, List<ClassificationResult>>(
              builder: (context, results) {
                if (results.isEmpty) {
                  return Center(child: Text("No classifications yet"));
                }
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(results[index].label),
                      subtitle: Text(
                          "Confidence: ${results[index].confidence.toStringAsFixed(2)}"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
