const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery'
  })
)

environment.loaders.append('handlebars-loader', {
  test: /\.handlebars$/,
  use: 'handlebars-loader'
})

module.exports = environment
