import 'dart:io';

class StringBufferSink implements Sink<String> {
  final StringBuffer buffer;
  const StringBufferSink(this.buffer);

  @override
  void add(String data) {
    buffer.write(data);
  }

  @override
  void close() {}
}

class FileSink implements Sink<String> {
  final String path;
  late IOSink _sink;
  FileSink(this.path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    _sink = file.openWrite();
  }

  @override
  void add(String data) {
    _sink.write(data);
  }

  @override
  void close() {
    _sink.close();
  }
}
