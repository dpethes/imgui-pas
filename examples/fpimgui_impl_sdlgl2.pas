{
Translation of "ImGui SDL2 binding with OpenGL" example, using SDL2 headers provided by https://github.com/ev1313/Pascal-SDL-2-Headers

In this binding, ImTextureID is used to store an OpenGL 'GLuint' texture identifier. Read the FAQ about ImTextureID in imgui.cpp.

You can copy and use unmodified imgui_impl_* files in your project.
If you use this binding you'll need to call 4 functions: ImGui_ImplXXXX_Init(), ImGui_ImplXXXX_NewFrame(), Imgui_ImplSdlGL2_RenderDrawLists() and ImGui_ImplXXXX_Shutdown().
If you are new to ImGui, see examples/README.txt and documentation at the top of imgui.cpp.
https://github.com/ocornut/imgui
}

unit fpimgui_impl_sdlgl2;
{$mode objfpc}{$H+}

interface

uses
  sdl2, glad_gl,
  fpimgui;

procedure ImGui_ImplSdlGL2_Init();
procedure ImGui_ImplSdlGL2_Shutdown();
procedure ImGui_ImplSdlGL2_NewFrame(window: PSDL_Window);
procedure Imgui_ImplSdlGL2_RenderDrawLists(draw_data: PImDrawData); cdecl;
function  ImGui_ImplSdlGL2_ProcessEvent(event: PSDL_Event): boolean; 

implementation

// Data
var
  g_Time: double = 0.0;
  g_MousePressed: array[0..2] of bool = ( false, false, false );
  g_MouseWheel: single = 0.0;
  g_FontTexture: GLuint = 0;

function ImGui_ImplSdlGL2_ProcessEvent(event: PSDL_Event): boolean;
var
  key: TSDL_KeyCode;
  io: PImGuiIO;
begin
  result := false;
  io := igGetIO();
  case event^.type_ of
  SDL_MOUSEWHEEL: begin
      if (event^.wheel.y > 0) then
          g_MouseWheel := 1;
      if (event^.wheel.y < 0) then
          g_MouseWheel := -1;
      result := true;
      end;
  SDL_MOUSEBUTTONDOWN: begin
      if (event^.button.button = SDL_BUTTON_LEFT)   then g_MousePressed[0] := true;
      if (event^.button.button = SDL_BUTTON_RIGHT)  then g_MousePressed[1] := true;
      if (event^.button.button = SDL_BUTTON_MIDDLE) then g_MousePressed[2] := true;
      result := true;
  end;
  SDL_TEXTINPUT: begin
      ImGuiIO_AddInputCharactersUTF8(event^.text.text);
      result := true;
  end;
  SDL_KEYDOWN, SDL_KEYUP: begin
      key := event^.key.keysym.sym and (not SDLK_SCANCODE_MASK);
      io^.KeysDown[key] := event^.type_ = SDL_KEYDOWN;
      io^.KeyShift := (SDL_GetModState() and KMOD_SHIFT) <> 0;
      io^.KeyCtrl  := (SDL_GetModState() and KMOD_CTRL)  <> 0;
      io^.KeyAlt   := (SDL_GetModState() and KMOD_ALT)   <> 0;
      io^.KeySuper := (SDL_GetModState() and KMOD_GUI)   <> 0;
      result := true;
  end;
  end;
end;


procedure ImGui_ImplSdlGL2_CreateDeviceObjects();
var
  io: PImGuiIO;
  pixels: pbyte;
  width, height: integer;
  font_atlas: PImFontAtlas;
  last_texture: GLint;
begin
  // Build texture atlas
  io := igGetIO();
  font_atlas := io^.Fonts;
  //ImFontAtlas_AddFontDefault(font_atlas);
  ImFontAtlas_GetTexDataAsAlpha8(font_atlas, @pixels, @width, @height);

  // Upload texture to graphics system
  glGetIntegerv(GL_TEXTURE_BINDING_2D, @last_texture);
  glGenTextures(1, @g_FontTexture);
  glBindTexture(GL_TEXTURE_2D, g_FontTexture);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_ALPHA, width, height, 0, GL_ALPHA, GL_UNSIGNED_BYTE, pixels);

  // Store our identifier
  ImFontAtlas_SetTexID(font_atlas, ImTextureID(g_FontTexture));

  // Restore state
  glBindTexture(GL_TEXTURE_2D, last_texture);
end;

procedure ImGui_ImplSdlGL2_InvalidateDeviceObjects();
begin
  if (g_FontTexture <> 0) then begin
      glDeleteTextures(1, @g_FontTexture);
      ImFontAtlas_SetTexID(igGetIO()^.Fonts, nil);
      g_FontTexture := 0;
  end;
end;

function ImGui_MemAlloc(sz:size_t): pointer; cdecl;
begin
  result := Getmem(sz);
end;

procedure ImGui_MemFree(ptr:pointer); cdecl;
begin
  Freemem(ptr);
end;

procedure ImGui_ImplSdlGL2_Init();
var
  io: PImGuiIO;
begin
  io := igGetIO();

  // Keyboard mapping. ImGui will use those indices to peek into the io.KeyDown[] array.
  io^.KeyMap[ImGuiKey_Tab] := SDLK_TAB;
  io^.KeyMap[ImGuiKey_LeftArrow] := SDL_SCANCODE_LEFT;
  io^.KeyMap[ImGuiKey_RightArrow] := SDL_SCANCODE_RIGHT;
  io^.KeyMap[ImGuiKey_UpArrow] := SDL_SCANCODE_UP;
  io^.KeyMap[ImGuiKey_DownArrow] := SDL_SCANCODE_DOWN;
  io^.KeyMap[ImGuiKey_PageUp] := SDL_SCANCODE_PAGEUP;
  io^.KeyMap[ImGuiKey_PageDown] := SDL_SCANCODE_PAGEDOWN;
  io^.KeyMap[ImGuiKey_Home] := SDL_SCANCODE_HOME;
  io^.KeyMap[ImGuiKey_End] := SDL_SCANCODE_END;
  io^.KeyMap[ImGuiKey_Delete] := SDLK_DELETE;
  io^.KeyMap[ImGuiKey_Backspace] := SDLK_BACKSPACE;
  io^.KeyMap[ImGuiKey_Enter] := SDLK_RETURN;
  io^.KeyMap[ImGuiKey_Escape] := SDLK_ESCAPE;
  io^.KeyMap[ImGuiKey_A] := SDLK_a;
  io^.KeyMap[ImGuiKey_C] := SDLK_c;
  io^.KeyMap[ImGuiKey_V] := SDLK_v;
  io^.KeyMap[ImGuiKey_X] := SDLK_x;
  io^.KeyMap[ImGuiKey_Y] := SDLK_y;
  io^.KeyMap[ImGuiKey_Z] := SDLK_z;

  io^.RenderDrawListsFn := @Imgui_ImplSdlGL2_RenderDrawLists;
  io^.SetClipboardTextFn := nil;
  io^.GetClipboardTextFn := nil;
  io^.ClipboardUserData := nil;

  // Allocate memory through pascal's memory allocator.
  // This is optional, for example for seeing the number of memory allocations through HeapTrc
  io^.MemAllocFn := @ImGui_MemAlloc;
  io^.MemFreeFn :=  @ImGui_MemFree;
end;

procedure ImGui_ImplSdlGL2_Shutdown();
begin
  ImGui_ImplSdlGL2_InvalidateDeviceObjects();
  igShutdown();
end;

procedure ImGui_ImplSdlGL2_NewFrame(window: PSDL_Window);
var
  w, h: integer;
  display_w, display_h: integer;
  io: PImGuiIO;
  time, mouseMask: UInt32;
  current_time: double;
  mx, my: Integer;
begin
  if g_FontTexture = 0 then
      ImGui_ImplSdlGL2_CreateDeviceObjects();

  io := igGetIO();

  // Setup display size (every frame to accommodate for window resizing)
  SDL_GetWindowSize(window, @w, @h);
  io^.DisplaySize := ImVec2Init(w, h);
  io^.DisplayFramebufferScale := ImVec2Init(1, 1);

  // SDL_GL_GetDrawableSize might be missing in pascal sdl2 headers - remove the next 3 lines in that case
  SDL_GL_GetDrawableSize(window, @display_w, @display_h);
  if (w <> 0) and (h <> 0) and ((w <> display_w) or (h <> display_h)) then
      io^.DisplayFramebufferScale := ImVec2Init(display_w/w, display_h/h);

  // Setup time step
  time := SDL_GetTicks();
  current_time := time / 1000.0;
  if (g_Time > 0.0) then
      io^.DeltaTime := current_time - g_Time
  else
      io^.DeltaTime := 1.0/60.0;
  g_Time := current_time;

  // Setup inputs
  // (we already got mouse wheel, keyboard keys & characters from SDL_PollEvent())
  mouseMask := SDL_GetMouseState(@mx, @my);
  if ((SDL_GetWindowFlags(window) and SDL_WINDOW_INPUT_FOCUS) <> 0) then
      io^.MousePos := ImVec2Init(mx, my)   // Mouse position, in pixels (set to -1,-1 if no mouse / on another screen, etc.)
  else
      io^.MousePos := ImVec2Init(-FLT_MAX, -FLT_MAX);

  // If a mouse press event came, always pass it as "mouse held this frame", so we don't miss click-release events that are shorter than 1 frame.
  io^.MouseDown[0] := g_MousePressed[0] or (mouseMask and SDL_BUTTON(SDL_BUTTON_LEFT) <> 0);
  io^.MouseDown[1] := g_MousePressed[1] or (mouseMask and SDL_BUTTON(SDL_BUTTON_RIGHT) <> 0);
  io^.MouseDown[2] := g_MousePressed[2] or (mouseMask and SDL_BUTTON(SDL_BUTTON_MIDDLE) <> 0);
  g_MousePressed[0] := false;
  g_MousePressed[1] := false;
  g_MousePressed[2] := false;

  io^.MouseWheel := g_MouseWheel;
  g_MouseWheel := 0.0;

  // Hide OS mouse cursor if ImGui is drawing it
  if io^.MouseDrawCursor then SDL_ShowCursor(SDL_DISABLE) else SDL_ShowCursor(SDL_ENABLE);

  // Start the frame
  igNewFrame();
end;

procedure Imgui_ImplSdlGL2_RenderDrawLists(draw_data: PImDrawData); cdecl;
var
  last_texture: GLint;
  last_viewport: array[0..3] of GLint;
  last_scissor_box: array[0..3] of GLint;
  io: PImGuiIO;
  fb_width, fb_height, n, cmd_i: integer;
  cmd_list: PImDrawList;
  vtx_buffer: PImDrawVert;
  idx_buffer: PImDrawIdx;
  pcmd: PImDrawCmd;
begin
  // Avoid rendering when minimized, scale coordinates for retina displays (screen coordinates != framebuffer coordinates)
  io := igGetIO();
  fb_width  := trunc(io^.DisplaySize.x * io^.DisplayFramebufferScale.x);
  fb_height := trunc(io^.DisplaySize.y * io^.DisplayFramebufferScale.y);
  if (fb_width = 0) or (fb_height = 0) then
      exit;
  //draw_data->ScaleClipRects(io.DisplayFramebufferScale);

  glGetIntegerv(GL_TEXTURE_BINDING_2D, @last_texture);
  glGetIntegerv(GL_VIEWPORT, @last_viewport);
  glGetIntegerv(GL_SCISSOR_BOX, @last_scissor_box);
  glPushAttrib(GL_ENABLE_BIT or GL_COLOR_BUFFER_BIT or GL_TRANSFORM_BIT);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glDisable(GL_CULL_FACE);
  glDisable(GL_DEPTH_TEST);
  glEnable(GL_SCISSOR_TEST);
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glEnableClientState(GL_COLOR_ARRAY);
  glEnable(GL_TEXTURE_2D);
  //glUseProgram(0); // You may want this if using this code in an OpenGL 3+ context

  // Setup viewport, orthographic projection matrix
  glViewport(0, 0, fb_width, fb_height);
  glMatrixMode(GL_PROJECTION);
  glPushMatrix();
  glLoadIdentity();
  glOrtho(0.0, io^.DisplaySize.x, io^.DisplaySize.y, 0.0, -1.0, +1.0);
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glLoadIdentity();

  // Render command lists
  Assert(SizeOf(ImDrawIdx) = 2);

  for n := 0 to draw_data^.CmdListsCount - 1 do begin
      cmd_list := draw_data^.CmdLists[n];
      vtx_buffer := cmd_list^.VtxBuffer.Data;
      idx_buffer := cmd_list^.IdxBuffer.Data;

      //pos/uv/color offsets: 0, 8, 16
      glVertexPointer(2, GL_FLOAT, sizeof(ImDrawVert), Pbyte(vtx_buffer) + 0);
      glTexCoordPointer(2, GL_FLOAT, sizeof(ImDrawVert), Pbyte(vtx_buffer) + 8);
      glColorPointer(4, GL_UNSIGNED_BYTE, sizeof(ImDrawVert), Pbyte(vtx_buffer) + 16);

      for cmd_i := 0 to cmd_list^.CmdBuffer.Size - 1 do begin
          pcmd := @(cmd_list^.CmdBuffer.Data[cmd_i]);
          if pcmd^.UserCallback <> nil then begin
              pcmd^.UserCallback(cmd_list, pcmd);
          end else begin
              glBindTexture(GL_TEXTURE_2D, GLuint(pcmd^.TextureId));
              glScissor(trunc(pcmd^.ClipRect.x), trunc(fb_height - pcmd^.ClipRect.w),
                        trunc(pcmd^.ClipRect.z - pcmd^.ClipRect.x), trunc(pcmd^.ClipRect.w - pcmd^.ClipRect.y));
              glDrawElements(GL_TRIANGLES, pcmd^.ElemCount, GL_UNSIGNED_SHORT, idx_buffer);
          end;
          idx_buffer += pcmd^.ElemCount
      end;
  end;

  // Restore modified state
  glDisableClientState(GL_COLOR_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_VERTEX_ARRAY);
  glBindTexture(GL_TEXTURE_2D, last_texture);
  glMatrixMode(GL_MODELVIEW);
  glPopMatrix();
  glMatrixMode(GL_PROJECTION);
  glPopMatrix();
  glPopAttrib();
  glViewport(last_viewport[0], last_viewport[1], GLsizei(last_viewport[2]), GLsizei(last_viewport[3]));
  glScissor(last_scissor_box[0], last_scissor_box[1], GLsizei(last_scissor_box[2]), GLsizei(last_scissor_box[3]));
end;

end.

