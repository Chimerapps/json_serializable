// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:test_process/test_process.dart';

void main() {
  test('valid input', () async {
    final proc = await _run('{"name": "bob", "count": 42}');

    await expectLater(
      proc.stdout,
      emitsInOrder(['Configuration: {name: bob, count: 42}']),
    );

    await proc.shouldExit(0);
  });

  test('empty map', () async {
    final proc = await _run('{}');

    await expectLater(
      proc.stderr,
      emitsInOrder(
        LineSplitter.split('''
Unhandled exception:
ParsedYamlException: line 1, column 1 of $_testYamlPath: Required keys are missing: name, count.
  ╷
1 │ {}
  │ ^^
  ╵
'''),
      ),
    );

    await proc.shouldExit(isNot(0));
  });

  test('not a map', () async {
    final proc = await _run('42');

    await expectLater(
      proc.stderr,
      emitsInOrder(
        LineSplitter.split('''
Unhandled exception:
ParsedYamlException: line 1, column 1 of $_testYamlPath: Not a map
  ╷
1 │ 42
  │ ^^
  ╵
'''),
      ),
    );

    await proc.shouldExit(isNot(0));
  });

  test('invalid yaml', () async {
    final proc = await _run('{');

    await expectLater(
      proc.stderr,
      emitsInOrder(
        LineSplitter.split('''
Unhandled exception:
ParsedYamlException: line 1, column 2 of $_testYamlPath: Expected node content.
  ╷
1 │ {
  │  ^
  ╵
'''),
      ),
    );

    await proc.shouldExit(isNot(0));
  });

  test('duplicate keys', () async {
    final proc = await _run('{"a":null, "a":null}');

    await expectLater(
      proc.stderr,
      emitsInOrder(
        LineSplitter.split('''
Unhandled exception:
ParsedYamlException: line 1, column 12 of $_testYamlPath: Duplicate mapping key.
  ╷
1 │ {"a":null, "a":null}
  │            ^^^
  ╵
'''),
      ),
    );

    await proc.shouldExit(isNot(0));
  });

  test('unexpected key', () async {
    final proc = await _run('{"bob": 42}');

    await expectLater(
      proc.stderr,
      emitsInOrder(
        LineSplitter.split('''
Unhandled exception:
ParsedYamlException: line 1, column 2 of $_testYamlPath: Unrecognized keys: [bob]; supported keys: [name, count]
  ╷
1 │ {"bob": 42}
  │  ^^^^^
  ╵
'''),
      ),
    );

    await proc.shouldExit(isNot(0));
  });

  test('bad name type', () async {
    final proc = await _run('{"name": 42, "count": 42}');

    await expectLater(
      proc.stderr,
      emitsInOrder(
        LineSplitter.split('''
Unhandled exception:
ParsedYamlException: line 1, column 10 of $_testYamlPath: Unsupported value for "name".
  ╷
1 │ {"name": 42, "count": 42}
  │          ^^
'''),
      ),
    );

    await proc.shouldExit(isNot(0));
  });
  test('bad name contents', () async {
    final proc = await _run('{"name": "", "count": 42}');

    await expectLater(
      proc.stderr,
      emitsInOrder(
        LineSplitter.split('''
Unhandled exception:
ParsedYamlException: line 1, column 10 of $_testYamlPath: Unsupported value for "name". Cannot be empty.
  ╷
1 │ {"name": "", "count": 42}
  │          ^^
'''),
      ),
    );

    await proc.shouldExit(isNot(0));
  });
}

String get _testYamlPath => p.join(d.sandbox, 'test.yaml');

Future<TestProcess> _run(String yamlContent) async {
  await d.file('test.yaml', yamlContent).create();

  return TestProcess.start(
    Platform.resolvedExecutable,
    ['example/example.dart', _testYamlPath],
  );
}
