const { environment } = require('@rails/webpacker')

const aliasConfig = require("./alias")
const webpack = require('webpack')

environment.config.merge(aliasConfig)

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)


module.exports = environment
