// Conditional import picks the web implementation when compiled for web.
export 'pwa_service_stub.dart'
    if (dart.library.html) 'pwa_service_web.dart';