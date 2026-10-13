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

    // Envia dados pro JavaScript via callback
    void send(const std::string& data) override {
        output(data);
    }

    // No WASM, o JS empurra mensagens via outra função. read() não é usado.
    void read(char* buffer, unsigned int length) override {
        emscripten_console_error("ServerIOWasm::read should never be called");
    }

    // Mesma coisa: quem empurra é o JS.
    bool readLine(std::string& out) override {
        emscripten_console_error("ServerIOWasm::readLine should never be called");
        return false;
    }
};
