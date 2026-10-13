#include <stdio.h>
#include <string>
#include <memory>
#include <algorithm>
#include <functional>
#include <queue>

#include <emscripten/emscripten.h>
#include <emscripten/bind.h>
#include <emscripten/val.h>

#include "include/LSP/ServerIOWasm.hpp"
#include "include/LSP/LanguageServer.hpp"
#include "include/LSP/Client.hpp"
#include "include/Platform/LSPPlatform.hpp"
#include "include/Platform/MonacoPlatform.hpp"

using emscripten::val;

static std::shared_ptr<LSPClient> g_client;
static std::shared_ptr<LanguageServer> g_server;

// Chamado pelo JS pra empurrar uma mensagem pra fila
void pushMessage(const std::string& msg) {
    getIncomingQueue().push(msg);
}

std::shared_ptr<LanguageServer> createWasmLanguageServer(
    const val& output,
    const std::string& packageName,
    const val& definitionsFiles,
    const val& documentationFiles)
{
    auto io = std::make_unique<ServerIOWasm>(output);
    g_client = std::make_shared<LSPClient>(std::move(io));

    auto defs = emscripten::vecFromJSArray<std::string>(definitionsFiles);
    auto docs = emscripten::vecFromJSArray<std::string>(documentationFiles);
    for (const auto& d : defs) g_client->definitionsFiles["globalTypes"] = d;
    g_client->documentationFiles = docs;

    LSPPlatform::forcedPlatformFactory = [](const ClientConfiguration&, WorkspaceFileResolver* fr, WorkspaceFolder* wf) {
        return std::make_unique<MonacoPlatform>(fr, wf);
    };

    g_server = std::make_shared<LanguageServer>(g_client.get(), std::nullopt);
    return g_server;
}

EMSCRIPTEN_BINDINGS(languageServerBindings) {
    emscripten::function("pushMessage", &pushMessage);
    emscripten::function("createWasmLanguageServer", &createWasmLanguageServer,
        emscripten::return_value_policy::take_ownership());

    emscripten::class_<LanguageServer>("LanguageServer")
        .smart_ptr<std::shared_ptr<LanguageServer>>("LanguageServer")
        .function("processInput", &LanguageServer::processInputLoop);
}