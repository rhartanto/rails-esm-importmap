# This pin all our own es6 javascript under 'esm' folder so we don't get 'duplicate files' errors in sprockets asset compilation,
# because we are compiling both es6 and coffeescript files which may have same file names
# note: to get assets digests working, "under" must be a directory under 'vendor/javascript' or 'app/javascript'
pin_all_from 'app/javascript/esm', under: 'esm'

# Third party javascripts in /vendor/javascript/esm, are explicitly pinned so we know what we are using
# Note: for each of the third party libraries in this importmap, we need to also add to package.json
#       so when javascripts test is run via nodejs & mocha, the libraries can be found in ./node_modules/
pin 'uuid', to: "esm/uuid.js" # 8.3.2
pin "vue", to: Rails.env.development? ? "esm/vue.esm-browser.js" : "esm/vue.esm-browser.prod.js" # 3.2.37
pin "axios", to: Rails.env.development? ? "esm/axios.js" : "esm/axios.min.js" # v1.0.0-alpha.1 (support esm)

