# imgui-pas 1.53
Pascal bindings for dear imgui (AKA ImGui)
https://github.com/ocornut/imgui
> ImGui is a bloat-free graphical user interface library for C++. It outputs vertex buffers that you can render in your 3D-pipeline enabled application. It is portable, renderer agnostic and self-contained (no external dependencies). It is based on an "immediate mode" graphical user interface paradigm which enables you to build user interfaces with ease.

## Building
Builds with Freepascal 3.0.0 and later, other compilers are untested (it should support 2.6.0 and higher though).
Both 32 and 64bit builds work.

## Usage
These bindings wrap the C functions exported from cimgui library, so you need a recent cimgui build to use them. The current version is based on ImGui 1.51.

Copy sources and cimgui binary to your project folder. See the examples for how to integrate it with your rendering pipeline and the "getting started" section in imgui.cpp.
There's also a very basic demo program that draws some ImGui windows in a SDL2 window with OpenGL context.
It includes pre-build versions of cimgui, if you don't want to build it on your own.

## Issues/Todo
* translate more structs, enums
* translate most of ImGui::ShowTestWindow() function
* re-add default parameter values from imgui.h
* add class wrappers around IO/FontAtlas and such to make it more convenient to use / better match original C++ versions
* function address parameters are ignored for now
* added types for fixed size array parameters - should be replaced with pointers?
* no tests on linux/macOS yet

Other:
* va_args functions are ignored, use native Format() instead

## See Also

https://github.com/Extrawurst/cimgui
> This is a thin c-api wrapper for the excellent C++ intermediate gui imgui. This library is intended as a intermediate layer to be able to use imgui from other languages that can interface with C .

https://github.com/mellinoe/ImGui.NET
> An ImGui wrapper for .NET Core. 