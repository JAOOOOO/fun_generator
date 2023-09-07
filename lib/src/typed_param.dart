import 'package:analyzer/dart/element/type.dart';

class TypedParam {
  const TypedParam(
    this.type,
    this.name,
  );

  final DartType type;
  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return super == other;
  }

  @override
  int get hashCode => super.hashCode ^ type.hashCode ^ name.hashCode;
}
