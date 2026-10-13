#include <stdio.h>
#include <string>
#include <memory>
#include <algorithm>
#include <functional>

#include <emscripten/emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>

#include "include/LSP/ServerIOWasm.hpp"
#include "include/LSP/LanguageServer.hpp"
#include "include/LSP/Client.hpp"
#include "include/Platform/LSPPlatform.hpp"
#include "include/Platform/MonacoPlatform.hpp"

using emscripten::val;

// Globais para manter o client e o server vivos durante toda a execução
static std::shared_ptr<LSPClient> g_client;
static std::shared_ptr<LanguageServer> g_server;

std::shared_ptr<LanguageServer> createWasmLanguageServer(
    const val& output,
    const std::string& packageName,
    const val& definitionsFiles,
    const val& documentationFiles)
{
    // Cria o ServerIO específico pra WASM (que envia mensagens pro JS via callback)
    auto io = std::make_unique<ServerIOWasm>(output);

    // Cria o LSPClient que usa esse ServerIO como Transport
    g_client = std::make_shared<LSPClient>(std::move(io));

    // Converte as definições e docs que vieram do JS
    auto defs = emscripten::vecFromJSArray<std::string>(definitionsFiles);
    auto docs = emscripten::vecFromJSArray<std::string>(documentationFiles);

    // Registra os arquivos de definição e documentação
    for (const auto& d : defs)
        g_client->definitionsFiles["globalTypes"] = d;
    g_client->documentationFiles = docs;

    // Força a plataforma a ser Monaco em vez da padrão (LSPPlatform ou RobloxPlatform)
    LSPPlatform::forcedPlatformFactory = [](const ClientConfiguration&, WorkspaceFileResolver* fr, WorkspaceFolder* wf) {
        return std::make_unique<MonacoPlatform>(fr, wf);
    };

    // Cria o LanguageServer
    g_server = std::make_shared<LanguageServer>(g_client.get(), std::nullopt);
    return g_server;
}

EMSCRIPTEN_BINDINGS(languageServerBindings) {
    emscripten::function("createWasmLanguageServer", &createWasmLanguageServer,
        emscripten::return_value_policy::take_ownership());

    emscripten::class_<LanguageServer>("LanguageServer")
        .smart_ptr<std::shared_ptr<LanguageServer>>("LanguageServer")
        .function("processInput", &LanguageServer::processInputLoop);
}