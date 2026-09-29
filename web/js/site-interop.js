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

  /*
   * Puts the drawing surface back when a re-render wipes it.
   *
   * The canvas is described in Dart without a width or a height; the runtime
   * sets both itself, to the box it has been given. Anything that re-renders
   * the component around it — the game-over panel appearing, the restart, a
   * language switch changing the canvas label — makes the framework apply the
   * attributes it knows about, and the runtime's two are not among them, so
   * they go. A canvas with neither is 300x150, and CSS then stretches that
   * over a screen three times as tall as it is wide, which is what a finished
   * run looked like: a blurred, enormous crop of the scene behind the panel.
   *
   * Watching the attributes and restoring them costs nothing while nothing
   * touches them, and it covers every such re-render rather than the one that
   * was noticed. Setting them again fires the observer a second time, where
   * both are present and there is nothing to do.
   */
  function keepRiveSurface(canvas) {
    if (canvas.riveSurfaceObserver || typeof window.MutationObserver !== 'function') {
      return;
    }
    var observer = new window.MutationObserver(function () {
      if (!canvas.hasAttribute('width') || !canvas.hasAttribute('height')) {
        fitRiveSurface(canvas);
      }
    });
    observer.observe(canvas, {
      attributes: true,
      attributeFilter: ['width', 'height']
    });
    canvas.riveSurfaceObserver = observer;
  }

  /*
   * particles.js and vanilla-tilt are decoration: a drifting background behind
   * the about section, and a tilt on the portfolio tiles under the pointer.
   * Fifty kilobytes of script for that has no business competing with the hero
   * image, so neither is in the document head any more. The first time Dart
   * asks whether one is ready the fetch is queued for after the page has
   * finished loading, and the answer stays false until the library has run.
   */
  var deferredScripts = {};

  function loadWhenIdle(src) {
    if (deferredScripts[src]) {
      return;
    }
    deferredScripts[src] = true;
    var inject = function () {
      var script = document.createElement('script');
      script.src = src;
      script.async = true;
      document.head.appendChild(script);
    };
    var soon = function () {
      if (typeof window.requestIdleCallback === 'function') {
        // The timeout matters more than the idle moment: on a busy main thread
        // an idle callback can be a long time coming, and this should not wait
        // for one to arrive.
        window.requestIdleCallback(inject, { timeout: 2000 });
      } else {
        window.setTimeout(inject, 200);
      }
    };
    if (document.readyState === 'complete') {
      soon();
    } else {
      window.addEventListener('load', soon);
    }
  }

  /*
   * Holds pointer events off the canvas until the file's opening iris has
   * played out.
   *
   * The game opens behind a circular mask that widens until the screen is
   * clear. A tap while that is running sends the state machine straight into
   * play and the mask stops where it is, leaving the corners black for the
   * rest of the run. A second of nothing happening is a cheaper price than a
   * game played through a keyhole.
   *
   * Counted by advance rather than by clock: the runtime only advances on a
   * frame it draws, so a tab switched away mid-intro comes back with the mask
   * exactly where it left it, while a timer would have run on without it.
   *
   * The clock is still there, but only to catch a runtime that reports no
   * advances at all, which would otherwise leave the canvas permanently dead.
   * Once even one has arrived the count is trusted and the timer stands down:
   * a stalled intro is a mask that has stopped moving, and opening the gate on
   * it is the very thing this exists to prevent.
   *
   * The count starts when the machine enters its opening state, not when the
   * instance does. There is about a fifth of a second between the two, and
   * counting the file's second from the wrong end of it released the tap with
   * the mask still closing — which is the whole bug, just a fifth of a second
   * of it. If that state change never arrives the count starts anyway, after
   * waiting the same length again, so the gate can only ever open late.
   */
  function holdPointerUntilOpen(canvas, seconds) {
    var instance = canvas.riveInstance;
    if (!(seconds > 0) || !instance || instance === 'pending' || !window.rive) {
      return;
    }
    if (canvas.riveReleaseIntro) {
      canvas.riveReleaseIntro();
    }
    var remaining = seconds;
    var advances = 0;
    var opening = false;
    var beforeOpening = 0;
    canvas.style.pointerEvents = 'none';

    function release() {
      if (!canvas.riveReleaseIntro) {
        return;
      }
      canvas.riveReleaseIntro = null;
      window.clearTimeout(backstop);
      instance.off(window.rive.EventType.Advance, onAdvance);
      instance.off(window.rive.EventType.StateChange, onStateChange);
      canvas.style.pointerEvents = '';
    }

    function onStateChange() {
      if (!opening) {
        opening = true;
        remaining = seconds;
      }
    }

    function onAdvance(event) {
      advances++;
      var elapsed = (event && event.data) || 0;
      if (!opening) {
        beforeOpening += elapsed;
        if (beforeOpening < seconds) {
          return;
        }
      }
      remaining -= elapsed;
      if (remaining <= 0) {
        release();
      }
    }

    var backstop = window.setTimeout(function () {
      if (advances === 0) {
        release();
      }
    }, seconds * 1000 * 4);
    canvas.riveReleaseIntro = release;
    instance.on(window.rive.EventType.StateChange, onStateChange);
    instance.on(window.rive.EventType.Advance, onAdvance);
  }

  /*
   * Runs the callback once a reloaded file has rebuilt its state machine.
   *
   * load() does not hand one back, and the machine is not there on the next
   * line, so this waits on frames rather than a timer and gives up rather than
   * spinning if it never appears.
   */
  function whenMachineReady(canvas, done) {
    var tries = 0;
    (function check() {
      if (riveMachine(canvas)) {
        done();
        return;
      }
      if (++tries > 60) {
        return;
      }
      window.requestAnimationFrame(check);
    })();
  }

  function riveMachine(canvas) {
    var instance = canvas.riveInstance;
    return (
      instance &&
      instance !== 'pending' &&
      instance.animator &&
      instance.animator.stateMachines &&
      instance.animator.stateMachines[0]
    );
  }

  /*
   * Drives a freshly reloaded file past its opening iris.
   *
   * Play Again reloads the file, and the file opens on a second of black that
   * irises outwards. That is worth watching the first time; on a retry it is a
   * second of nothing between wanting to play again and playing again. Stepping
   * the state machine forward by hand, a frame at a time, puts the scene
   * straight into the state the reveal ends in.
   *
   * Says whether it worked, so a runtime that will not be driven falls back to
   * waiting the reveal out instead of starting the game behind a black screen.
   */
  function skipRiveIntro(canvas, seconds) {
    var machine = riveMachine(canvas);
    if (!machine || typeof machine.advanceAndApply !== 'function' || !(seconds > 0)) {
      return false;
    }
    var step = 1 / 60;
    try {
      for (var elapsed = 0; elapsed < seconds; elapsed += step) {
        machine.advanceAndApply(step);
      }
    } catch (error) {
      return false;
    }
    return true;
  }

  /** Whether the device has a pointer that can hover over things. */
  function canHover() {
    return (
      typeof window.matchMedia !== 'function' ||
      window.matchMedia('(hover: hover)').matches
    );
  }

  /*
   * Matches the canvas's backing store to the box CSS has given it.
   *
   * On a frame of its own rather than straight away: the runtime can call
   * onLoad before the constructor has returned, so the instance is read back
   * off the canvas instead of closed over, and by the next frame the layout
   * the surface is being measured against has settled.
   */
  function fitRiveSurface(canvas) {
    window.requestAnimationFrame(function () {
      var instance = canvas.riveInstance;
      if (instance && instance !== 'pending') {
        instance.resizeDrawingSurfaceToCanvas();
      }
    });
  }

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
    startRive: function (canvas, src, artboard, stateMachine, deathNames, onDeath, introSeconds) {
      if (!canvas || canvas.riveInstance) {
        return;
      }
      // Marks the canvas as taken before either fetch resolves, so a second
      // call cannot build a second instance on it.
      canvas.riveInstance = 'pending';
      Promise.all([
        new Promise(loadRiveScript),
        fetch(src).then(function (res) { return res.arrayBuffer(); })
      ]).then(function (both) {
        if (!window.rive) {
          canvas.riveInstance = null;
          return;
        }
        // Kept for restartRive, which has to rebuild the same thing.
        canvas.riveSetup = {
          buffer: both[1],
          artboard: artboard,
          stateMachine: stateMachine
        };

        // The file says nothing directly when the bird dies; it enters a state
        // and fires a sound event. Either one standing in for "dead" is enough,
        // and taking both means renaming one in the editor does not go silent.
        var dead = false;
        function died(name) {
          if (dead || deathNames.indexOf(name) < 0) {
            return;
          }
          dead = true;
          onDeath();
        }
        canvas.riveClearDeath = function () { dead = false; };
        // Both wasm builds are served from this site, so nothing here reaches
        // for the CDN the runtime would otherwise default to.
        window.rive.RuntimeLoader.setWasmUrl('js/rive.wasm');
        window.rive.RuntimeLoader.setWasmFallbackUrl('js/rive_fallback.wasm');

        var instance = new window.rive.Rive({
          // The bytes rather than the url: restarting reloads the file, and
          // going back to the network for a megabyte and a half every time
          // somebody presses play again would be a waste of their data.
          buffer: canvas.riveSetup.buffer,
          canvas: canvas,
          artboard: artboard,
          autoplay: true,
          stateMachines: stateMachine,
          layout: new window.rive.Layout({
            fit: window.rive.Fit.Cover,
            alignment: window.rive.Alignment.Center
          }),
          onLoad: function () {
            fitRiveSurface(canvas);
          }
        });
        instance.on(window.rive.EventType.StateChange, function (e) {
          (e.data || []).forEach(died);
        });
        instance.on(window.rive.EventType.RiveEvent, function (e) {
          died(e.data && e.data.name);
        });
        canvas.riveInstance = instance;
        canvas.riveIntroSeconds = introSeconds;
        holdPointerUntilOpen(canvas, introSeconds);
        keepRiveSurface(canvas);
      });
    },

    /*
     * Puts the file back to its first frame and starts it playing again.
     *
     * load() rather than reset(): reset tears the pointer handling down with
     * everything else and does not put it back, so the restarted game ignored
     * every tap and sat in its loading state. load re-runs the setup and keeps
     * the subscriptions, and the file is already in the browser's cache by the
     * time anyone can have died.
     */
    restartRive: function (canvas) {
      if (!canvas || !canvas.riveInstance || canvas.riveInstance === 'pending') {
        return;
      }
      canvas.riveInstance.load({
        buffer: canvas.riveSetup.buffer,
        artboard: canvas.riveSetup.artboard,
        stateMachines: canvas.riveSetup.stateMachine,
        autoplay: true
      });
      // load() rebuilds the surface at the default size, so it is measured
      // against the canvas box again.
      fitRiveSurface(canvas);
      // The reload plays the opening iris from the start. Hold the tap as on
      // the first load, then jump the iris as soon as the reloaded machine can
      // be driven and let the tap straight back through: a retry should put
      // the player back in the game, not back in front of the reveal. If the
      // jump does not take, the hold runs its normal course and the reveal
      // plays as before.
      holdPointerUntilOpen(canvas, canvas.riveIntroSeconds);
      whenMachineReady(canvas, function () {
        if (skipRiveIntro(canvas, canvas.riveIntroSeconds) && canvas.riveReleaseIntro) {
          canvas.riveReleaseIntro();
        }
      });
      if (canvas.riveClearDeath) {
        canvas.riveClearDeath();
      }
    },

    /** Matches the drawing surface to the canvas box again after a resize. */
    resizeRive: function (canvas) {
      if (canvas && canvas.riveInstance && canvas.riveInstance !== 'pending') {
        canvas.riveInstance.resizeDrawingSurfaceToCanvas();
      }
    },

    /** Tears the instance down when the section leaves the tree. */
    stopRive: function (canvas) {
      if (canvas && canvas.riveInstance && canvas.riveInstance !== 'pending') {
        // Before cleanup, so the intro hold takes its advance listener and its
        // timer back off an instance that is about to go away.
        if (canvas.riveReleaseIntro) {
          canvas.riveReleaseIntro();
        }
        if (canvas.riveSurfaceObserver) {
          canvas.riveSurfaceObserver.disconnect();
          canvas.riveSurfaceObserver = null;
        }
        canvas.riveInstance.cleanup();
        canvas.riveInstance = null;
      }
    },

    /** True once particles.js has been evaluated; asks for it on first call. */
    particlesReady: function () {
      if (typeof window.particlesJS === 'function') {
        return true;
      }
      loadWhenIdle('js/particles.js');
      return false;
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

    /*
     * True once vanilla-tilt has been evaluated, and straight away on a device
     * that cannot hover: the effect needs a pointer, so there is nothing worth
     * fetching and initTilt below has nothing to do. Saying yes rather than
     * never lets the caller stop waiting instead of polling to its limit.
     */
    tiltReady: function () {
      if (!canHover() || typeof window.VanillaTilt !== 'undefined') {
        return true;
      }
      loadWhenIdle('js/vanilla-tilt.min.js');
      return false;
    },

    /** Applies the hover tilt to a portfolio tile. */
    initTilt: function (element) {
      if (!element || element.vanillaTilt || !canHover()) {
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
    observeInViewport: function (element, callback, threshold) {
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
      }, { threshold: threshold || 0 });
      observer.observe(element);
    }
  };
})();
