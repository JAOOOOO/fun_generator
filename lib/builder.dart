import 'package:build/build.dart';
import 'package:fun_generator/src/copier_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder funBuilder(BuilderOptions options) => PartBuilder(
      [CopierGenerator()],
      ".fun.dart",
      options: options,
    );
