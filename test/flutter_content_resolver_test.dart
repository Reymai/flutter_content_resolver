import 'package:flutter_content_resolver/flutter_content_resolver.dart';
import 'package:flutter_content_resolver/flutter_content_resolver_method_channel.dart';
import 'package:flutter_content_resolver/flutter_content_resolver_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterContentResolverPlatform
    with MockPlatformInterfaceMixin
    implements FlutterContentResolverPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> resolveContent(String contentUri) {
    throw UnimplementedError('resolveContent() has not been implemented.');
  }
}

void main() {
  final FlutterContentResolverPlatform initialPlatform =
      FlutterContentResolverPlatform.instance;

  test('$MethodChannelFlutterContentResolver is the default instance', () {
    expect(
        initialPlatform, isInstanceOf<MethodChannelFlutterContentResolver>());
  });

  test('getPlatformVersion', () async {
    FlutterContentResolver flutterContentResolverPlugin =
        FlutterContentResolver();
    MockFlutterContentResolverPlatform fakePlatform =
        MockFlutterContentResolverPlatform();
    FlutterContentResolverPlatform.instance = fakePlatform;

    expect(await flutterContentResolverPlugin.getPlatformVersion(), '42');
  });
}
