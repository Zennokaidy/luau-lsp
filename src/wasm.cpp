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
    try {
        EM_ASM({ self.postMessage({ type: "info", msg: "[C++] inicio" }); });
        auto io = std::make_unique<ServerIOWasm>(output);

        EM_ASM({ self.postMessage({ type: "info", msg: "[C++] ServerIOWasm criado" }); });
        g_client = std::make_shared<LSPClient>(std::move(io));

        EM_ASM({ self.postMessage({ type: "info", msg: "[C++] LSPClient criado" }); });
        auto defs = emscripten::vecFromJSArray<std::string>(definitionsFiles);
        auto docs = emscripten::vecFromJSArray<std::string>(documentationFiles);

        EM_ASM({ self.postMessage({ type: "info", msg: "[C++] defs/docs convertidos" }); });
        for (const auto& d : defs) g_client->definitionsFiles["globalTypes"] = d;
        g_client->documentationFiles = docs;

        EM_ASM({ self.postMessage({ type: "info", msg: "[C++] defs/docs atribuidos" }); });
        LSPPlatform::forcedPlatformFactory = [](const ClientConfiguration&, WorkspaceFileResolver* fr, WorkspaceFolder* wf) {
            return std::make_unique<MonacoPlatform>(fr, wf);
        };

        EM_ASM({ self.postMessage({ type: "info", msg: "[C++] platform factory setada" }); });
        g_server = std::make_shared<LanguageServer>(g_client.get(), std::nullopt);

        EM_ASM({ self.postMessage({ type: "info", msg: "[C++] LanguageServer criado" }); });
        return g_server;
    } catch (const std::exception& e) {
        std::string msg = std::string("exception: ") + e.what();
        EM_ASM({ self.postMessage({ type: "error", msg: "[C++] CAUGHT: " + UTF8ToString($0) }); }, msg.c_str());
        throw std::runtime_error(msg);
    } catch (...) {
        EM_ASM({ self.postMessage({ type: "error", msg: "[C++] CAUGHT: exception desconhecida" }); });
        throw std::runtime_error("exception desconhecida");
    }
}

EMSCRIPTEN_BINDINGS(languageServerBindings) {
    emscripten::function("pushMessage", &pushMessage);
    emscripten::function("createWasmLanguageServer", &createWasmLanguageServer,
        emscripten::return_value_policy::take_ownership());

    emscripten::class_<LanguageServer>("LanguageServer")
        .smart_ptr<std::shared_ptr<LanguageServer>>("LanguageServer")
        .function("processInput", &LanguageServer::processInputLoop);
}
