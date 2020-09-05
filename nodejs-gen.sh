mkdir ${PRJ_PATH}
cd ${PRJ_PATH}
cat <<EOF >> package.json
{
  "name": "${PRJ_NAME}",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "boostrap": "cp config.tmp.js config.js",
    "lintfix": "eslint --fix --ext .js .",
    "lint": "eslint --ext .js ."
  },
  "author": "",
  "license": "ISC"
}
EOF
npm install --save-dev eslint eslint-config-prettier eslint-loader eslint-plugin-prettier prettier
npm install debug

cat <<EOF >> .prettierrc
{
  "semi": false,
  "singleQuote": true
}
EOF

cat <<EOF >> .eslintrc.js
module.exports = {
    root: true,
    env: {
        browser: true,
        node: true,
        es6: true,
        mocha: true
    },
    parserOptions: {
        ecmaVersion: 9
    },
    extends: [
        'eslint:recommended',
        'plugin:prettier/recommended'
    ],
    plugins: [
        'prettier'
    ],
    // add your custom rules here
    rules: {
        'no-console': process.env.NODE_ENV === 'production' ? 'error' : 'off',
        'no-debugger': process.env.NODE_ENV === 'production' ? 'error' : 'off',
        'no-param-reassign': [2, {
            props: true,
            ignorePropertyModificationsFor: ['ctx', 'state']
        }],
        "no-param-reassign": 1,
    }
}
EOF

cat <<EOF >> .eslintignore
**/*.min.js
node_modules/
EOF

cat <<EOF >> config.tmp.js
module.exports = {}
EOF