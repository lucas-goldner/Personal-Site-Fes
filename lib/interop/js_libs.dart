/// Access to the two vendored JavaScript libraries, particles.js and
/// vanilla-tilt, through `web/js/site-interop.js`.
///
/// The VM implementation is a no-op so the same widgets can be pre-rendered
/// during static generation.
library;

export 'js_libs_web.dart' if (dart.library.io) 'js_libs_vm.dart';
