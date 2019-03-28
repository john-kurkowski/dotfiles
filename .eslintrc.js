module.exports = {
  'env': {
    'browser': true,
    'es6': true,
    'node': true,
  },
  'extends': 'eslint:recommended',
  'parser': 'babel-eslint',
  'parserOptions': {
    'sourceType': 'module',
  },
  'rules': {
    'comma-dangle': [
      'error',
      'always-multiline',
    ],
    'indent': [
      'error',
      2,
      {
        'MemberExpression': 1,
        'SwitchCase': 1,
      },
    ],
    'linebreak-style': [
      'error',
      'unix',
    ],
    'quotes': [
      'error',
      'single',
    ],
    'semi': [
      'error',
      'always',
    ],
  },
};
