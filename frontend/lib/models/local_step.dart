class LocalStep {

  int stepNumber;

  String instruction;

  List<String> imageUrls;

  LocalStep({
    required this.stepNumber,
    this.instruction = '',
    required this.imageUrls,
  });
}