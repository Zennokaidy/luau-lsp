#pragma once
#include "LSP/Transport/Transport.hpp"
#include <stdexcept>
#include <string>
#include <queue>
#include <emscripten/bind.h>
#include <emscripten/console.h>
#include <emscripten/val.h>

using emscripten::val;

// Fila global — o JS empurra, o C++ lê no loop
inline std::queue<std::string>& getIncomingQueue() {
    static std::queue<std::string> q;
    return q;
}

class ServerIOWasm : public Transport {
protected:
    const val output;

public:
    ServerIOWasm(const val& output_) : output(output_) {}

    void send(const std::string& data) override {
        output(data);
    }

    void read(char* buffer, unsigned int length) override {
        // não usado
    }

    bool readLine(std::string& out) override {
        auto& q = getIncomingQueue();
        if (q.empty()) return false;
        out = q.front();
        q.pop();
        return true;
    }
};