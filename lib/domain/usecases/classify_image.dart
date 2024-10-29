import 'dart:io';

import 'package:meine_classification/domain/models/classification_result.dart';

abstract class ClassifyImage {
  Future<List<ClassificationResult>> classify(File image);
}
