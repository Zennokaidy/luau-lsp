#ifndef __EMSCRIPTEN__
#include "Thread.hpp"
#endif

#ifdef __EMSCRIPTEN__
    void processMessage(const std::string& jsonString);
#endif

#ifndef __EMSCRIPTEN__
    Thread messageProcessorThread;
#endif