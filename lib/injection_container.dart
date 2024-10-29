import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'data/repositories/tflite_classification_repository.dart';
import 'domain/usecases/classify_image.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  final labels = await loadLabels();
  final repo = await TFLiteClassificationRepository.create(labels);
  sl.registerLazySingleton<ClassifyImage>(() => repo);
}

Future<List<String>> loadLabels() async {
  final labels = await rootBundle.loadString('assets/labels.txt');
  return labels.split('\n');
}
