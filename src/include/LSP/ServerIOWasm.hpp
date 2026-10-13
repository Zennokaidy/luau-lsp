#pragma once
#include "LSP/Transport/Transport.hpp"
#include <stdexcept>
#include <string>
#include <emscripten/bind.h>
#include <emscripten/console.h>
#include <emscripten/val.h>

using emscripten::val;

class ServerIOWasm : public Transport {
protected:
    const val output;

public:
    ServerIOWasm(const val& output_) : output(output_) {}

    void sendRawMessage(const json& message) override {
        output(message.dump());
    }

    bool readRawMessage(std::string& output) const override {
        emscripten_console_error("ServerIOWeb::readRawMessage should never be called");
        return false;
    }
};