import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:fun_generator/fun_generator.dart';
import 'package:fun_generator/src/typed_param.dart';
import 'package:source_gen/source_gen.dart';

class CopierGenerator extends GeneratorForAnnotation<Copier> {
  @override
  generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw 'Copier annotation can only be used on classes';
    }

    final defaultConstructor = element.constructors.firstWhere(
      (element) => element.name.isEmpty,
      orElse: () => throw 'Class must have a default constructor',
    );

    final defaultConstructorParameters = defaultConstructor.parameters.map(
      (e) => TypedParam(
        e.type,
        e.name,
      ),
    );

    final classFields = element.fields.map(
      (e) => TypedParam(
        e.type,
        e.name,
      ),
    );

    /// We'll require that the default constructor parameters match the class fields
    /// exactly. This is a limitation of the this implementation.
    if (defaultConstructorParameters.length != classFields.length) {
      final bool isFieldsMore =
          defaultConstructorParameters.length < classFields.length;
      if (isFieldsMore) {
        throw "Class has more fields. Default constructor parameters must match class fields exactly";
      } else {
        throw 'Default constructor parameters must match class fields exactly';
      }
    }

    final methodName = annotation.read('name').stringValue;

    if (methodName.isEmpty) {
      throw 'Copier method must have a name ';
    }

    final method = Method(
      (m) => m
        ..name = methodName
        ..returns = refer(element.displayName)
        ..optionalParameters.addAll(
          defaultConstructorParameters.map(
            (e) => Parameter(
              (p) => p
                ..name = e.name
                ..type = refer(
                  '${e.type.getDisplayString(withNullability: false)}?',
                )
                ..named = true,
            ),
          ),
        )
        ..body = Code(
          'return ${element.displayName}(${defaultConstructorParameters.map((e) => '${e.name}: ${e.name} ?? this.${e.name}').join(', ')});',
        ),
    );

    final Extension ex = Extension(
      (e) => e
        ..name = '${element.name}Copier'
        ..on = refer(element.displayName)
        ..methods.add(method),
    );

    final emitter = DartEmitter();

    return DartFormatter().format('${ex.accept(emitter)}');
  }
}
