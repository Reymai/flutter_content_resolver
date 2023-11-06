import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_content_resolver_platform_interface.dart';

/// An implementation of [FlutterContentResolverPlatform] that uses method channels.
class MethodChannelFlutterContentResolver
    extends FlutterContentResolverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_content_resolver');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> resolveContent(String contentUri) async {
    final String? result =
        await methodChannel.invokeMethod<String>('resolveContent', contentUri);
    return result;
  }
}
