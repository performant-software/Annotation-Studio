# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths += %w(app/assets/images/)

Rails.application.config.assets.precompile += %w(active_admin.css active_admin.js users.css
widget.js summernote.eot summernote.ttf summernote.woff glyphicons-halflings-regular.eot glyphicons-halflings-regular.woff2
glyphicons-halflings-regular.woff glyphicons-halflings-regular.ttf documents.css
catalog.css tiny_mce_popup.js groups.css annotations.css 
cove_footer_logo.png hs-logo-trans-horiz.png logo_mit.png neh_at_logo.png)

Rails.application.config.assets.enabled = true
Rails.application.config.assets.digest = true
Rails.application.config.assets.initialize_on_precompile = false
