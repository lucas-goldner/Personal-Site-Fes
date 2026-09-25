/*
 * Glue for the two third-party libraries the site uses.
 *
 * The option objects are kept here, verbatim from the previous React site
 * (<Particles params={...}> in src/sections/about and <Tilt options={...}> in
 * src/sections/portfolio), so the visual result is unchanged.
 */
(function () {
  'use strict';

  var resizeHandlers = {};
  var nextHandlerId = 1;

  /*
   * The Rive runtime and the file it plays come to about three and a half
   * megabytes, which nobody should pay for before they have scrolled to the
   * section that uses them. The script tag is injected on first use and the
   * instance is built once it has run.
   */
  var riveScript = null;

  function loadRiveScript(callback) {
    if (window.rive) {
      callback();
      return;
    }
    if (riveScript) {
      riveScript.addEventListener('load', callback);
      return;
    }
    riveScript = document.createElement('script');
    riveScript.src = 'js/rive.js';
    riveScript.addEventListener('load', callback);
    document.head.appendChild(riveScript);
  }

  window.siteInterop = {
    /*
     * Registers a resize listener and returns a token to remove it with, so
     * Dart can detach the exact same function again on dispose.
     */
    addResizeListener: function (callback) {
      var id = nextHandlerId++;
      resizeHandlers[id] = callback;
      window.addEventListener('resize', callback);
      return id;
    },

    /** Removes a listener previously registered with addResizeListener. */
    removeResizeListener: function (id) {
      var handler = resizeHandlers[id];
      if (handler) {
        window.removeEventListener('resize', handler);
        delete resizeHandlers[id];
      }
    },

    /*
     * Plays a .riv file on a canvas, fetching the runtime the first time it is
     * asked for. Returns nothing; the instance is parked on the canvas so
     * stopRive can find it again.
     */
    startRive: function (canvas, src, artboard, stateMachine) {
      if (!canvas || canvas.riveInstance) {
        return;
      }
      loadRiveScript(function () {
        if (!window.rive || canvas.riveInstance) {
          return;
        }
        // Both wasm builds are served from this site, so nothing here reaches
        // for the CDN the runtime would otherwise default to.
        window.rive.RuntimeLoader.setWasmUrl('js/rive.wasm');
        window.rive.RuntimeLoader.setWasmFallbackUrl('js/rive_fallback.wasm');

        var instance = new window.rive.Rive({
          src: src,
          canvas: canvas,
          artboard: artboard,
          autoplay: true,
          stateMachines: stateMachine,
          layout: new window.rive.Layout({
            // The screen is cut to the artboard's own proportions below, so
            // there is nothing left for a fit mode to crop or letterbox.
            fit: window.rive.Fit.Contain,
            alignment: window.rive.Alignment.Center
          }),
          onLoad: function () {
            // Hand the artboard's shape to the frame, so the phone wraps the
            // drawing rather than the drawing being squeezed into the phone.
            var b = instance.bounds;
            var shell = canvas.closest('.rive_phone');
            if (shell && b && b.maxX > b.minX && b.maxY > b.minY) {
              shell.style.setProperty(
                '--screen-ratio',
                (b.maxX - b.minX) + ' / ' + (b.maxY - b.minY)
              );
            }
            // After the ratio, so the backing store matches the box the canvas
            // actually ends up with.
            instance.resizeDrawingSurfaceToCanvas();
          }
        });
        canvas.riveInstance = instance;
      });
    },

    /** Matches the drawing surface to the canvas box again after a resize. */
    resizeRive: function (canvas) {
      if (canvas && canvas.riveInstance) {
        canvas.riveInstance.resizeDrawingSurfaceToCanvas();
      }
    },

    /** Tears the instance down when the section leaves the tree. */
    stopRive: function (canvas) {
      if (canvas && canvas.riveInstance) {
        canvas.riveInstance.cleanup();
        canvas.riveInstance = null;
      }
    },

    /** True once particles.js has been evaluated. */
    particlesReady: function () {
      return typeof window.particlesJS === 'function';
    },

    /** Starts the particle network inside the element with the given id. */
    initParticles: function (elementId) {
      window.particlesJS(elementId, {
        particles: {
          number: {
            value: 50,
            density: {
              enable: false,
              value_area: 5000
            }
          },
          line_linked: {
            enable: true,
            opacity: 0.5
          },
          size: {
            value: 1
          }
        },
        retina_detect: true
      });
    },

    /** True once vanilla-tilt has been evaluated. */
    tiltReady: function () {
      return typeof window.VanillaTilt !== 'undefined';
    },

    /** Applies the hover tilt to a portfolio tile. */
    initTilt: function (element) {
      if (!element || element.vanillaTilt) {
        return;
      }
      window.VanillaTilt.init(element, { scale: 1, max: 50 });
    },

    /** Removes the tilt handlers again when a tile is filtered out. */
    destroyTilt: function (element) {
      if (element && element.vanillaTilt) {
        element.vanillaTilt.destroy();
      }
    },

    /*
     * Calls back the first time an element scrolls into view, replacing
     * react-in-viewport. The observer disconnects itself after firing, which
     * matches the one-shot `animation_complete` flag of the React components.
     */
    observeInViewport: function (element, callback) {
      if (!element) {
        return;
      }
      if (typeof window.IntersectionObserver !== 'function') {
        callback();
        return;
      }
      var observer = new window.IntersectionObserver(function (entries) {
        for (var i = 0; i < entries.length; i++) {
          if (entries[i].isIntersecting) {
            observer.disconnect();
            callback();
            return;
          }
        }
      });
      observer.observe(element);
    }
  };
})();
