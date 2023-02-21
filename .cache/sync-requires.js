const { hot } = require("react-hot-loader/root")

// prefer default export if available
const preferDefault = m => (m && m.default) || m


exports.components = {
  "component---cache-dev-404-page-js": hot(preferDefault(require("/Users/lucasgoldner/Developer/React/Personal-Site-Fes/.cache/dev-404-page.js"))),
  "component---src-pages-404-js": hot(preferDefault(require("/Users/lucasgoldner/Developer/React/Personal-Site-Fes/src/pages/404.js"))),
  "component---src-pages-index-js": hot(preferDefault(require("/Users/lucasgoldner/Developer/React/Personal-Site-Fes/src/pages/index.js"))),
  "component---src-pages-privacy-js": hot(preferDefault(require("/Users/lucasgoldner/Developer/React/Personal-Site-Fes/src/pages/privacy.js"))),
  "component---src-pages-tos-js": hot(preferDefault(require("/Users/lucasgoldner/Developer/React/Personal-Site-Fes/src/pages/tos.js")))
}

