import 'package:fun_generator/fun_generator.dart';

part 'example.fun.dart';

@copier
class Example {
  Example({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}
