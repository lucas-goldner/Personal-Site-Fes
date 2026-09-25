import 'package:universal_web/web.dart' as web;

// Server-side no-ops; the browser implementations live in `js_libs_web.dart`.
// Nothing here ever runs during static generation, it only keeps the shared
// widget code compiling for the VM target.

void startRive(
  web.Element canvas,
  String src,
  String artboard,
  String stateMachine,
  List<String> deathSignals,
  void Function() onDeath,
) {}

void restartRive(web.Element canvas) {}

void resizeRive(web.Element canvas) {}

void stopRive(web.Element canvas) {}

bool particlesReady() => false;

void initParticles(String elementId) {}

bool tiltReady() => false;

void initTilt(web.Element element) {}

void destroyTilt(web.Element element) {}

void observeInViewport(web.Element element, void Function() onEnter) {}

int addResizeListener(void Function() onResize) => 0;

void removeResizeListener(int token) {}
