import 'flutter_content_resolver_platform_interface.dart';

class FlutterContentResolver {
  Future<String?> getPlatformVersion() {
    return FlutterContentResolverPlatform.instance.getPlatformVersion();
  }

  static Future<String?> resolveContent(String contentUri) {
    return FlutterContentResolverPlatform.instance.resolveContent(contentUri);
  }
}
