#include <stdio.h>
#include <string>
#include <memory>
#include <algorithm>
#include <functional>
#include <queue>
#include <stdexcept>

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

void pushMessage(const std::string& msg) {
    getIncomingQueue().push(msg);
}

std::shared_ptr<LanguageServer> createWasmLanguageServer(
    const val& output,
    const std::string& packageName,
    const val& definitionsFiles,
    const val& documentationFiles)
{
    EM_ASM({ console.log('[C++] 1. inicio'); });

    auto io = std::make_unique<ServerIOWasm>(output);
    EM_ASM({ console.log('[C++] 2. ServerIOWasm criado'); });

    g_client = std::make_shared<LSPClient>(std::move(io));
    EM_ASM({ console.log('[C++] 3. LSPClient criado'); });

    auto defs = emscripten::vecFromJSArray<std::string>(definitionsFiles);
    EM_ASM({ console.log('[C++] 4. defs convertidos'); });
    auto docs = emscripten::vecFromJSArray<std::string>(documentationFiles);
    EM_ASM({ console.log('[C++] 5. docs convertidos'); });

    for (const auto& d : defs) g_client->definitionsFiles["globalTypes"] = d;
    EM_ASM({ console.log('[C++] 6. defs atribuidos'); });
    g_client->documentationFiles = docs;
    EM_ASM({ console.log('[C++] 7. docs atribuidos'); });

    LSPPlatform::forcedPlatformFactory = [](const ClientConfiguration&, WorkspaceFileResolver* fr, WorkspaceFolder* wf) {
        return std::make_unique<MonacoPlatform>(fr, wf);
    };
    EM_ASM({ console.log('[C++] 8. platform factory setada'); });

    g_server = std::make_shared<LanguageServer>(g_client.get(), std::nullopt);
    EM_ASM({ console.log('[C++] 9. LanguageServer criado'); });

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
