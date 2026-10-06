name: Build Luau LSP WASM

on:
  push:
    branches: [ main, master ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout (com submódulos)
        uses: actions/checkout@v4
        with:
          submodules: recursive

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Rodar build.sh
        run: bash web/build.sh

      - name: Upload dos arquivos gerados
        uses: actions/upload-artifact@v4
        with:
          name: luau-lsp-wasm
          path: |
            web/public/Luau.LanguageServer.Web.js
            web/public/Luau.LanguageServer.Web.wasm
          if-no-files-found: error
