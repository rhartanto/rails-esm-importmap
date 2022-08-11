# Use direct uploads for Active Storage (remember to import "@rails/activestorage" in your application.js)
# pin "@rails/activestorage", to: "activestorage.esm.js"

# Use npm packages from a JavaScript CDN by running ./bin/importmap

# pin all under es6 folder so we don't get 'duplicate files' errors, since we are running es6 and coffee side by side
pin_all_from 'app/javascript/esm', under: 'esm'

# to get assets digests working, "under" must be a directory under 'vendor/javascript' or 'app/javascript'
# - for example, this doesnt work -> pin_all_from 'vendor/javascript/es6', under: 'vendors' #, to: '/assets/es6'
# - but this works -> pin_all_from 'vendor/javascript/es6', under: 'es6'
# but better to explicitly pin 3rd party js, so we know what we are using
pin 'uuid', to: "esm/uuid.js"
pin "vue", to: Rails.env.development? ? "esm/vue.esm-browser.js" : "esm/vue.esm-browser.prod.js"