mkdir ${PRJ_PATH}
cd ${PRJ_PATH}
cat <<EOF >>package.json
{
  "name": "${PRJ_NAME}",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "build": "npx webpack"
  },
  "author": "",
  "author": "",
  "license": "ISC"
}
EOF

npm install --save-dev webpack webpack-cli @types/react @types/react-dom typescript ts-loader source-map-loader css-loader style-loader css-loader

npm install --save react react-dom

cat <<EOF >>tsconfig.json
{
    "compilerOptions": {
        "outDir": "./dist/",
        "sourceMap": true,
        "noImplicitAny": true,
        "module": "commonjs",
        "target": "ES2019",
        "jsx": "react",
        "experimentalDecorators": true
    },
    "include": [
        "src/**/*"
    ],
    "exclude": [
        "node_modules",
        "**/*.spec.ts"
    ]
}
EOF

cat <<EOF >>webpack.config.js
module.exports = {
    mode: "production",

    // Enable sourcemaps for debugging webpack's output.
    devtool: "source-map",

    resolve: {
        // Add '.ts' and '.tsx' as resolvable extensions.
        extensions: [".ts", ".tsx"]
    },

    module: {
        rules: [
            {
                test: /\.ts(x?)$/,
                exclude: /node_modules/,
                use: [
                    {
                        loader: "ts-loader"
                    }
                ]
            },
            // All output '.js' files will have any sourcemaps re-processed by 'source-map-loader'.
            {
                enforce: "pre",
                test: /\.js$/,
                loader: "source-map-loader"
            },
            {
                test: /\.css$/,
                use: [
                    'style-loader',
                    'css-loader'
                ]
            }
        ]
    },

    // When importing a module whose path matches one of the following, just
    // assume a corresponding global variable exists and use that instead.
    // This is important because it allows us to avoid bundling all of our
    // dependencies, which allows browsers to cache those libraries between builds.
    externals: {
        "react": "React",
        "react-dom": "ReactDOM"
    }
};
EOF

cat <<EOF >> index.html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8" />
        <title>Hello React!</title>
    </head>
    <body>
        <div id="example"></div>

        <!-- Dependencies -->
        <script src="./node_modules/react/umd/react.development.js"></script>
        <script src="./node_modules/react-dom/umd/react-dom.development.js"></script>

        <!-- Main -->
        <script src="./dist/main.js"></script>
    </body>
</html>
EOF

mkdir src

cat <<EOF >> src/index.tsx
import * as React from "react";
import * as ReactDOM from "react-dom";

import { Hello } from "./app";

ReactDOM.render(
    <Hello compiler="TypeScript" framework="React" />,
    document.getElementById("example")
);
EOF

echo $STATE_TYPE

if [[ $STATE_TYPE == "mobx" ]]
then
    npm install mobx mobx-react --save
    cat <<EOF >>src/app.tsx
    import * as React from "react";
    import { observable, action } from "mobx"
    import { observer } from "mobx-react"

    export interface HelloProps { compiler: string; framework: string; }

    // 'HelloProps' describes the shape of props.
    // State is never set so we use the '{}' type.
    @observer
    export class Hello extends React.Component<HelloProps, {}> {
        @observable counter = 0
        @action onClick = () => {
            console.log('onClick...', this.counter)
            this.counter++
        }
        render() {
            return (
                <div>
                    <h1>Hello from {this.props.compiler} and {this.props.framework}! Click {this.counter}</h1>
                    <button onClick={this.onClick}>Click</button>
                </div>
            )
        }
    }
EOF
else
cat <<EOF >> src/app.tsx
import * as React from "react";

export interface HelloProps { compiler: string; framework: string; }

// 'HelloProps' describes the shape of props.
// State is never set so we use the '{}' type.
export class Hello extends React.Component<HelloProps, {}> {
    render() {
        return <h1>Hello from {this.props.compiler} and {this.props.framework}!</h1>;
    }
}
EOF
fi