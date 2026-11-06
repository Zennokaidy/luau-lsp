#include <emscripten/bind.h>
#include <emscripten/val.h>
#include <memory>

#include "LSP/ServerIOWasm.hpp"
#include "LSP/LanguageServer.hpp"
#include "LSP/Client.hpp"
#include "Platform/LSPPlatform.hpp"

using emscripten::val;

static std::shared_ptr<LSPClient> g_client;
static std::shared_ptr<LanguageServer> g_server;

std::shared_ptr<LanguageServer> createWasmLanguageServer(
    const val& output,
    const val& definitionsFiles,
    const val& documentationFiles)
{
    auto io = std::make_unique<ServerIOWasm>(output);
    g_client = std::make_shared<LSPClient>(std::move(io));

    auto defs = emscripten::vecFromJSArray<std::string>(definitionsFiles);
    auto docs = emscripten::vecFromJSArray<std::string>(documentationFiles);

    for (const auto& d : defs) g_client->definitionsFiles["globalTypes"] = d;
    g_client->documentationFiles = docs;

    g_server = std::make_shared<LanguageServer>(g_client.get(), std::nullopt);
    return g_server;
}

EMSCRIPTEN_BINDINGS(languageServerBindings) {
    emscripten::function("createWasmLanguageServer", &createWasmLanguageServer,
        emscripten::return_value_policy::take_ownership());

    emscripten::class_<LanguageServer>("LanguageServer")
        .smart_ptr<std::shared_ptr<LanguageServer>>("LanguageServer")
        .function("processInput", &LanguageServer::processMessage);
}