import 'dart:js_interop';

import 'package:universal_web/web.dart' as web;

/// Plays [src] on [canvas], calling [onDeath] the first time the run ends.
void startRive(
  web.Element canvas,
  String src,
  String artboard,
  String stateMachine,
  List<String> deathSignals,
  void Function() onDeath,
) {
  _startRive(
    canvas,
    src,
    artboard,
    stateMachine,
    deathSignals.map((name) => name.toJS).toList().toJS,
    onDeath.toJS,
  );
}

@JS('siteInterop.startRive')
external void _startRive(
  web.Element canvas,
  String src,
  String artboard,
  String stateMachine,
  JSArray<JSString> deathSignals,
  JSFunction onDeath,
);

@JS('siteInterop.restartRive')
external void restartRive(web.Element canvas);

@JS('siteInterop.resizeRive')
external void resizeRive(web.Element canvas);

@JS('siteInterop.stopRive')
external void stopRive(web.Element canvas);

@JS('siteInterop.particlesReady')
external bool particlesReady();

@JS('siteInterop.initParticles')
external void initParticles(String elementId);

@JS('siteInterop.tiltReady')
external bool tiltReady();

@JS('siteInterop.initTilt')
external void initTilt(web.Element element);

@JS('siteInterop.destroyTilt')
external void destroyTilt(web.Element element);

/// Calls [onEnter] the first time [element] scrolls into view.
void observeInViewport(web.Element element, void Function() onEnter) {
  _observeInViewport(element, onEnter.toJS);
}

@JS('siteInterop.observeInViewport')
external void _observeInViewport(web.Element element, JSFunction callback);

/// Registers a window resize listener, returning a token for [removeResizeListener].
int addResizeListener(void Function() onResize) => _addResizeListener(onResize.toJS);

@JS('siteInterop.addResizeListener')
external int _addResizeListener(JSFunction callback);

@JS('siteInterop.removeResizeListener')
external void removeResizeListener(int token);
