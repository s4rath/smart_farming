class CropPrediction {
  final String predictedCrop;
  final List<String> top5Crops;
  final Map<String, List<Map<String, double>>> nutrientRequirements;

  CropPrediction({
    required this.predictedCrop,
    required this.top5Crops,
    required this.nutrientRequirements,
  });

  factory CropPrediction.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> nutrientRequirementsJson = json['nutrient_requirements'];
    Map<String, List<Map<String, double>>> nutrientRequirements = {};

   
    nutrientRequirementsJson.forEach((crop, requirements) {
      List<Map<String, double>> cropRequirements = [];
      for (var req in requirements) {
        cropRequirements.add(Map<String, double>.from(req));
      }
      nutrientRequirements[crop] = cropRequirements;
    });

    return CropPrediction(
      predictedCrop: json['predicted_crop'],
      top5Crops: List<String>.from(json['top_5_crops']),
      nutrientRequirements: nutrientRequirements,
    );
  }
}
