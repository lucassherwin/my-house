const path = require('path');
const { generateWebpackConfig, merge } = require('shakapacker');

const baseClientWebpackConfig = generateWebpackConfig();

const commonOptions = {
  resolve: {
    extensions: ['.css', '.ts', '.tsx'],
    alias: {
      '@': path.resolve(__dirname, '../../app/javascript/src'),
    },
  },
};

const commonWebpackConfig = () => merge({}, baseClientWebpackConfig, commonOptions);

module.exports = commonWebpackConfig;