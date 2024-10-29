import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:meine_classification/domain/models/classification_result.dart';
import 'package:meine_classification/domain/usecases/classify_image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteClassificationRepository implements ClassifyImage {
  late Interpreter _interpreter;
  final List<String> labels;

  // Gunakan factory async constructor
  TFLiteClassificationRepository._(this.labels, this._interpreter);

  static Future<TFLiteClassificationRepository> create(
      List<String> labels) async {
    final interpreter =
        await Interpreter.fromAsset('assets/mobilenet_v1_1.0_224_quant.tflite');
    return TFLiteClassificationRepository._(labels, interpreter);
  }

  @override
  Future<List<ClassificationResult>> classify(File image) async {
    // Load and preprocess image as Uint8List
    final Uint8List inputImage = _preprocessImage(image);

    // Prepare output buffer as List<List<double>>
    List<List<double>> output =
        List.generate(1, (_) => List.filled(1001, 0.0, growable: false));

    // Run inference
    log('shape : ${_interpreter.getInputTensor(0).shape}');
    _interpreter.run(inputImage, output);

    // Process and return results
    return _postprocess(output);
  }

  Uint8List _preprocessImage(File file) {
    img.Image? image = img.decodeImage(file.readAsBytesSync());
    if (image == null) throw Exception("Image decoding failed");

    // Resize to 224x224 as per model's requirement
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Prepare buffer in Uint8List
    var imageData = Uint8List(1 * 224 * 224 * 3);
    int pixelIndex = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        final pixel = resizedImage.getPixel(x, y);

        // Extract RGB values from pixel and cast to int
        final int red = pixel.r.toInt();
        final int green = pixel.g.toInt();
        final int blue = pixel.b.toInt();

        // Assign values to imageData without normalization
        imageData[pixelIndex++] = red;
        imageData[pixelIndex++] = green;
        imageData[pixelIndex++] = blue;
      }
    }

    return imageData;
  }

  List<ClassificationResult> _postprocess(List<List<double>> output) {
    final List<ClassificationResult> results = [];

    for (int i = 0; i < output[0].length; i++) {
      results.add(ClassificationResult(
        label: labels[i],
        confidence: output[0][i],
      ));
    }
    results.sort((a, b) => b.confidence.compareTo(a.confidence));
    return results.take(5).toList();
  }
}
