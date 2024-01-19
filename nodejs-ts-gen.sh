mkdir -p ${PRJ_PATH}
cd ${PRJ_PATH}
cat <<EOF >>package.json
{
  "name": "${PRJ_NAME}",
  "version": "1.0.0",
  "description": "",
  "main": "./dist/index.js",
  "module": "./lib/index.js",
  "files": [
    "lib/"
  ],
  "scripts": {
    "start": "NODE_PATH=dist/ node dist/index.js",
    "prebuild": "rm -rf dist",
    "build": "tsc",
    "watch": "tsc -w",
    "server": "tsc && NODE_PATH=dist/ node dist/index.js",
    "libbuild": "rm -rf lib && tsc -p tsconfig.module.json",
    "lint": "eslint --ext .ts .",
    "lintfix": "eslint --fix --ext .ts .",
    "test": "npm run unit-test && npm run integration-test",
    "unit-test": "NODE_PATH=dist/ mocha \"dist/test/**/*.test.js\"",
    "integration-test": "NODE_PATH=dist/ mocha \"dist/test/**/*.spec.js\""
  },
  "author": "shadow-walker811",
  "license": "ISC"
}
EOF

npm install --save-dev @types/node @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint eslint-config-prettier eslint-plugin-prettier prettier typescript source-map-support mocha chai @types/mocha @types/chai
npm install --save dotenv

cat <<EOF >>.env
ENV=local
EOF

cat <<EOF >> start.sh
#/bin/bash
export \$(cat .env | xargs)
npm run build && npm run start
EOF

cat <<EOF >> .prettierrc
{
  "semi": false,
  "singleQuote": true
}
EOF

cat <<EOF >> .eslintrc.js
module.exports = {
  parser: '@typescript-eslint/parser', // Specifies the ESLint parser
  parserOptions: {
    ecmaVersion: 2020, // Allows for the parsing of modern ECMAScript features
    sourceType: 'module', // Allows for the use of imports
  },
  extends: [
    'plugin:@typescript-eslint/recommended', // Uses the recommended rules from the @typescript-eslint/eslint-plugin
    'plugin:prettier/recommended', // Enables eslint-plugin-prettier and eslint-config-prettier. This will display prettier errors as ESLint errors. Make sure this is always the last configuration in the extends array.
  ],
  rules: {
    // Place to specify ESLint rules. Can be used to overwrite rules specified from the extended configs
    // e.g. "@typescript-eslint/explicit-function-return-type": "off",
    '@typescript-eslint/no-var-requires': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
  },
}
EOF

cat <<EOF >> .eslintignore
dist
**/*.min.js
node_modules/
lib
!src/lib
EOF

cat <<EOF >> .gitignore
node_modules
dist
.vscode
sample
**/.DS_Store
tmp
package-lock.json
.env
lib
!src/lib
EOF

cat <<EOF >> tsconfig.json
{
  "compilerOptions": {
    /* Visit https://aka.ms/tsconfig.json to read more about this file */
    /* Basic Options */
    // "incremental": true,                   /* Enable incremental compilation */
    "target": "ES2019", /* Specify ECMAScript target version: 'ES3' (default), 'ES5', 'ES2015', 'ES2016', 'ES2017', 'ES2018', 'ES2019', 'ES2020', or 'ESNEXT'. */
    "module": "commonjs", /* Specify module code generation: 'none', 'commonjs', 'amd', 'system', 'umd', 'es2015', 'es2020', or 'ESNext'. */
    "lib": [
      "es6"
    ], /* Specify library files to be included in the compilation. */
    "allowJs": true, /* Allow javascript files to be compiled. */
    // "checkJs": true,                       /* Report errors in .js files. */
    // "jsx": "preserve",                     /* Specify JSX code generation: 'preserve', 'react-native', or 'react'. */
    // "declaration": true,                   /* Generates corresponding '.d.ts' file. */
    // "declarationMap": true,                /* Generates a sourcemap for each corresponding '.d.ts' file. */
    // "sourceMap": true,                     /* Generates corresponding '.map' file. */
    // "outFile": "./",                       /* Concatenate and emit output to single file. */
    "outDir": "dist", /* Redirect output structure to the directory. */
    "rootDir": "src", /* Specify the root directory of input files. Use to control the output directory structure with --outDir. */
    // "composite": true,                     /* Enable project compilation */
    // "tsBuildInfoFile": "./",               /* Specify file to store incremental compilation information */
    // "removeComments": true,                /* Do not emit comments to output. */
    // "noEmit": true,                        /* Do not emit outputs. */
    // "importHelpers": true,                 /* Import emit helpers from 'tslib'. */
    // "downlevelIteration": true,            /* Provide full support for iterables in 'for-of', spread, and destructuring when targeting 'ES5' or 'ES3'. */
    // "isolatedModules": true,               /* Transpile each file as a separate module (similar to 'ts.transpileModule'). */
    /* Strict Type-Checking Options */
    "strict": true, /* Enable all strict type-checking options. */
    "noImplicitAny": true, /* Raise error on expressions and declarations with an implied 'any' type. */
    // "strictNullChecks": true,              /* Enable strict null checks. */
    // "strictFunctionTypes": true,           /* Enable strict checking of function types. */
    // "strictBindCallApply": true,           /* Enable strict 'bind', 'call', and 'apply' methods on functions. */
    // "strictPropertyInitialization": true,  /* Enable strict checking of property initialization in classes. */
    // "noImplicitThis": true,                /* Raise error on 'this' expressions with an implied 'any' type. */
    // "alwaysStrict": true,                  /* Parse in strict mode and emit "use strict" for each source file. */
    /* Additional Checks */
    // "noUnusedLocals": true,                /* Report errors on unused locals. */
    // "noUnusedParameters": true,            /* Report errors on unused parameters. */
    // "noImplicitReturns": true,             /* Report error when not all code paths in function return a value. */
    // "noFallthroughCasesInSwitch": true,    /* Report errors for fallthrough cases in switch statement. */
    /* Module Resolution Options */
    // "moduleResolution": "node",            /* Specify module resolution strategy: 'node' (Node.js) or 'classic' (TypeScript pre-1.6). */
    "baseUrl": "src",                       /* Base directory to resolve non-absolute module names. */
    // "paths": {},                           /* A series of entries which re-map imports to lookup locations relative to the 'baseUrl'. */
    // "rootDirs": [],                        /* List of root folders whose combined content represents the structure of the project at runtime. */
    // "typeRoots": [],                       /* List of folders to include type definitions from. */
    // "types": [],                           /* Type declaration files to be included in compilation. */
    // "allowSyntheticDefaultImports": true,  /* Allow default imports from modules with no default export. This does not affect code emit, just typechecking. */
    "esModuleInterop": true, /* Enables emit interoperability between CommonJS and ES Modules via creation of namespace objects for all imports. Implies 'allowSyntheticDefaultImports'. */
    // "preserveSymlinks": true,              /* Do not resolve the real path of symlinks. */
    // "allowUmdGlobalAccess": true,          /* Allow accessing UMD globals from modules. */
    /* Source Map Options */
    // "sourceRoot": "",                      /* Specify the location where debugger should locate TypeScript files instead of source locations. */
    // "mapRoot": "",                         /* Specify the location where debugger should locate map files instead of generated locations. */
    // "inlineSourceMap": true,               /* Emit a single file with source maps instead of having a separate file. */
    // "inlineSources": true,                 /* Emit the source alongside the sourcemaps within a single file; requires '--inlineSourceMap' or '--sourceMap' to be set. */
    /* Experimental Options */
    "experimentalDecorators": true,        /* Enables experimental support for ES7 decorators. */
    "emitDecoratorMetadata": true,         /* Enables experimental support for emitting type metadata for decorators. */
    /* Advanced Options */
    "resolveJsonModule": true, /* Include modules imported with '.json' extension */
    "skipLibCheck": true, /* Skip type checking of declaration files. */
    "forceConsistentCasingInFileNames": true /* Disallow inconsistently-cased references to the same file. */
  },
  "include": [
    "src/**/*"
  ],
  "exclude": [
    "node_modules"
  ]
}
EOF

cat <<EOF >> tsconfig.module.json
{
    "extends": "./tsconfig.json",
    "compilerOptions": {
        "module": "CommonJS",
        "outDir": "./lib",
        "declaration": true,
        "moduleResolution": "node"
    },
    "exclude": [
        "src/test"
    ]
}
EOF

mkdir src 
cat <<EOF >> src/index.ts
import http from 'http'

http
  .createServer((req, res) => {
    res.write('hello world')
    res.end()
  })
  .listen(8080)

EOF

cat <<EOF >> src/config.ts
import path from 'path'
import * as dotenv from 'dotenv'

const envPath = path.join(process.cwd(), '.env')
dotenv.config({
  path: envPath,
  override: true,
})

export const ENV = process.env.ENV || 'develop'
EOF

if [[ -n $DOCKER && $DOCKER == "true" ]]; then 

cat <<EOF >> Dockerfile
FROM node:18.18-alpine as builder
WORKDIR /usr/app
COPY package.json ./
COPY package-lock.json ./
RUN npm install --frozen-lockfile
COPY . .
RUN npm run build

FROM node:18.18-alpine
WORKDIR /usr/app
ENV NODE_ENV production
ENV NODE_PATH dist/
COPY package.json ./
COPY package-lock.json ./
RUN npm install --frozen-lockfile --production
COPY --from=builder /usr/app/dist ./dist
CMD ["node", "dist/index.js"]
EOF

cat <<EOF >> docker-build.sh
DOCKER_TAG=\$IMAGE:\$VERSION
docker build -t \$DOCKER_TAG -f Dockerfile .
if [[ -n \$DOCKER_PUSH && \$DOCKER_PUSH == "true" ]]; then 
docker push \$DOCKER_TAG
fi

EOF

cat <<EOF >> .dockerignore
node_modules
dist
.vscode
sample
**/.DS_Store
EOF

fi