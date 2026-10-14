#include <optional>
#include <queue>
#include <condition_variable>

#include "LSP/JsonRpc.hpp"
#include "nlohmann/json.hpp"

#include "Protocol/Structures.hpp"
#include "Protocol/LanguageFeatures.hpp"

#include "LSP/Client.hpp"
#include "LSP/Workspace.hpp"

#ifndef __EMSCRIPTEN__
#include "Thread.hpp"
#endif

using json = nlohmann::json;
using namespace json_rpc;
using WorkspaceFolderPtr = std::shared_ptr<WorkspaceFolder>;

#define JSON_REQUIRED_PARAMS(params, method) \
    (!(params) ? throw json_rpc::JsonRpcException(lsp::ErrorCode::InvalidParams, "params not provided for " method) : (params).value())

inline lsp::PositionEncodingKind& positionEncoding()
{
    static lsp::PositionEncodingKind encoding = lsp::PositionEncodingKind::UTF16;
    return encoding;
}

struct InitializationOptions
{
    std::unordered_map<std::string, std::string> fflags{};
};
NLOHMANN_DEFINE_OPTIONAL(InitializationOptions, fflags)

class LanguageServer
{
private:
    LSPClient* client;
    std::optional<Luau::Config> defaultConfig;
    WorkspaceFolderPtr nullWorkspace;
    std::vector<WorkspaceFolderPtr> workspaceFolders;

    std::vector<json_rpc::JsonRpcMessage> configPostponedMessages;

public:
    explicit LanguageServer(LSPClient* aClient, std::optional<Luau::Config> aDefaultConfig);

    static lsp::ServerCapabilities getServerCapabilities();

    WorkspaceFolderPtr findWorkspace(const lsp::DocumentUri& file, bool shouldInitialize = true);

    void onRequest(const id_type& id, const std::string& method, std::optional<json> params);
    void onNotification(const std::string& method, std::optional<json> params);
    void processInputLoop();
    bool requestedShutdown();

    void handleMessage(const json_rpc::JsonRpcMessage& msg);

    void shutdown();

#ifdef __EMSCRIPTEN__
    void processMessage(const std::string& jsonString);
#endif

private:
    bool allWorkspacesReceivedConfiguration() const;
    void clearCancellationToken(const json_rpc::JsonRpcMessage& msg);
    std::optional<json_rpc::JsonRpcMessage> popMessage();

    lsp::InitializeResult onInitialize(const lsp::InitializeParams& params);
    void onInitialized([[maybe_unused]] const lsp::InitializedParams& params);

    void onDidOpenTextDocument(const lsp::DidOpenTextDocumentParams& params);
    void onDidChangeTextDocument(const lsp::DidChangeTextDocumentParams& params);
    void onDidSaveTextDocument(const lsp::DidSaveTextDocumentParams& params);
    void onDidCloseTextDocument(const lsp::DidCloseTextDocumentParams& params);
    void onDidChangeConfiguration(const lsp::DidChangeConfigurationParams& params);
    void onDidChangeWorkspaceFolders(const lsp::DidChangeWorkspaceFoldersParams& params);
    void onDidChangeWatchedFiles(const lsp::DidChangeWatchedFilesParams& params);

    std::vector<lsp::DocumentLink> documentLink(const lsp::DocumentLinkParams& params);
    lsp::DocumentColorResult documentColor(const lsp::DocumentColorParams& params);
    lsp::ColorPresentationResult colorPresentation(const lsp::ColorPresentationParams& params);

    std::optional<std::vector<lsp::DocumentSymbol>> documentSymbol(const lsp::DocumentSymbolParams& params);
    lsp::PartialResponse<lsp::WorkspaceDiagnosticReport> workspaceDiagnostic(const lsp::WorkspaceDiagnosticParams& params);

private:
    bool isInitialized = false;
    bool shutdownRequested = false;

    std::mutex messagesMutex;
    std::condition_variable messagesCv;
    std::queue<json_rpc::JsonRpcMessage> messages;
#ifndef __EMSCRIPTEN__
    Thread messageProcessorThread;
#endif
    std::unordered_map<id_type, LSPCancellationToken> cancellationTokens;
};
