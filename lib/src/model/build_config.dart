class BuildConfig {
  final String outputPath;

  BuildConfig({this.outputPath = ""});

  static BuildConfig fromJson(Map<String, dynamic> json) {
    return BuildConfig(outputPath: json["output_path"] ?? "");
  }
}
