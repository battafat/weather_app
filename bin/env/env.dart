import 'package:envied/envied.dart';


part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'googleMapsApiKey', obfuscate: true)
  static final String googleMapsApiKey = _Env.googleMapsApiKey;
}
