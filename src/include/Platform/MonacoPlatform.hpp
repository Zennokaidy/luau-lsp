#pragma once

#include "LSP/LuauExt.hpp"
#include "Platform/LSPPlatform.hpp"

class WorkspaceFolder;
struct WorkspaceFileResolver;

class MonacoPlatform : public LSPPlatform
{
public:
    MonacoPlatform(WorkspaceFileResolver* fileResolver = nullptr, WorkspaceFolder* workspaceFolder = nullptr)
        : LSPPlatform(fileResolver, workspaceFolder)
    {
    }
    ~MonacoPlatform() = default;

    [[nodiscard]] bool isVirtualPath(const Luau::ModuleName& name) const override
    {
        return true;
    }

    [[nodiscard]] std::optional<Luau::ModuleName> resolveToVirtualPath(const Uri& name) const override
    {
        return name.fsPath();
    }

    [[nodiscard]] std::optional<Uri> resolveToRealPath(const Luau::ModuleName& name) const override
    {
        return Uri::file(name);
    }

    [[nodiscard]] Luau::SourceCode::Type sourceCodeTypeFromPath(const Uri& path) const override
    {
        return Luau::SourceCode::Type::Script;
    }

    std::string getName() override { return "MonacoPlatform"; }
};
