import 'package:mockito/mockito.dart';

class MockStream extends Mock implements Stream<int> {}

void main() async {
  var stream = MockStream();
  when(stream.first).thenAnswer((_) => Future.value(7));
  print(await stream.first);

  when(stream.listen(any)).thenAnswer((Invocation invocation) {
    var callback = invocation.positionalArguments.single;
    callback(1);
    callback(2);
    callback(3);
    return callback;
  });

  stream.listen((e) async => print(await e));
}
