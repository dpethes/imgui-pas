# imgui-pas
Pascal bindings for dear imgui (AKA ImGui) - a bloat-free graphical user interface library for C++

These bindings wrap the C functions exported from cimgui library, so you need
a recent cimgui build to use them. Current version is for ImGui 1.49.

## Issues/Todo
* re-add default parameter values from imgui.h
* add class wrappers around IO/FontAtlas and such  to make it more convenient to use / better match original C++ versions
* va_args functions ignored
* function address parameters ignored
* added types for fixed size array parameters (should be replaced with pointers?)
* no tests on linux yet

## Building
Builds with Freepascal 3.0.0 and later, other compilers are untested (it should support 2.6.0 and higher though).

## Usage
Copy imgui.pas and cimgui binary to your project folder. See the examples for how to integrate it with your rendering pipeline (work in progress) and the "getting started" section in imgui.cpp.

## See Also
https://github.com/ocornut/imgui
> ImGui is a bloat-free graphical user interface library for C++. It outputs vertex buffers that you can render in your 3D-pipeline enabled application. It is portable, renderer agnostic and self-contained (no external dependencies). It is based on an "immediate mode" graphical user interface paradigm which enables you to build user interfaces with ease.

https://github.com/Extrawurst/cimgui
> This is a thin c-api wrapper for the excellent C++ intermediate gui imgui. This library is intended as a intermediate layer to be able to use imgui from other languages that can interface with C .