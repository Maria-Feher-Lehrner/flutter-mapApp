import 'package:logger/logger.dart';

class BetterLogger implements Logger{

  int count = 2;
  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  void d(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement d
  }

  @override
  void e(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement e
  }

  @override
  void f(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement f
  }

  @override
  void i(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    count++;
    print(message);
  }

  @override
  // TODO: implement init
  Future<void> get init => throw UnimplementedError();

  @override
  bool isClosed() {
    // TODO: implement isClosed
    throw UnimplementedError();
  }

  @override
  void log(Level level, message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement log
  }

  @override
  void t(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement t
  }

  @override
  void v(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement v
  }

  @override
  void w(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement w
  }

  @override
  void wtf(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement wtf
  }

}

//2.5: better logger hier implementieren
//2.6: class BetterLogger erstellen mit implements Logger --> Logger package importieren --> 12 methods overriden
//2.7: log.i Methode ein bisschen abändern.
//2.8.: jetzt kann man im service_locator easy den alten Logger durch den BetterLogger austauschen