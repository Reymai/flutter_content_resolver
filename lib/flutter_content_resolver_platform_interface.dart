import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_content_resolver_method_channel.dart';

abstract class FlutterContentResolverPlatform extends PlatformInterface {
  /// Constructs a FlutterContentResolverPlatform.
  FlutterContentResolverPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterContentResolverPlatform _instance =
      MethodChannelFlutterContentResolver();

  /// The default instance of [FlutterContentResolverPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterContentResolver].
  static FlutterContentResolverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterContentResolverPlatform] when
  /// they register themselves.
  static set instance(FlutterContentResolverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> resolveContent(String contentUri) {
    throw UnimplementedError('resolveContent() has not been implemented.');
  }
}
