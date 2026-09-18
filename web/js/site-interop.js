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
