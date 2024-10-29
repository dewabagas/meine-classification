import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meine_classification/domain/models/classification_result.dart';
import 'package:meine_classification/domain/usecases/classify_image.dart';

class ClassificationCubit extends Cubit<List<ClassificationResult>> {
  final ClassifyImage classifyImage;

  ClassificationCubit(this.classifyImage) : super([]);

  void classify(File image) async {
    final results = await classifyImage.classify(image);
    emit(results);
  }
}
