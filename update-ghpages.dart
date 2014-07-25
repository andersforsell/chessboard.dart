import 'package:ghpages_generator/ghpages_generator.dart' as gh;

main() {
  new gh.Generator()
      ..withWeb = false
      ..withDocs = false
      ..withExamples = true
      ..generate();
}