#pragma once
#include "LSP/Transport/Transport.hpp"
#include <queue>
#include <string>

using emscripten::val;

inline std::queue<std::string>& getIncomingQueue() {
    static std::queue<std::string> q;
    return q;
}

class ServerIOWasm : public Transport {
protected:
    const val output;

public:
    explicit ServerIOWasm(const val& output_) : output(output_) {}

    void send(const std::string& data) override { output(data); }
    void read(char* /*buffer*/, unsigned int /*length*/) override {}
    bool readLine(std::string& /*out*/) override { return false; }
};