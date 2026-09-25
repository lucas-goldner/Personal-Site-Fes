/// Access to the vendored JavaScript libraries — particles.js,
/// vanilla-tilt and the Rive runtime — through `web/js/site-interop.js`.
///
/// The VM implementation is a no-op so the same widgets can be pre-rendered
/// during static generation.
library;

export 'js_libs_web.dart' if (dart.library.io) 'js_libs_vm.dart';
