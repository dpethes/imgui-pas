(*
display.pas
*)
unit display;
{$mode objfpc}{$H+}

interface

uses
  sysutils,
  sdl2, glad_gl,
  fpimgui, fpimgui_impl_sdlgl2;
  
type
  { TDisplay }
  TDisplay = class
    public
      procedure InitDisplay(const width, height: word; fullscreen: boolean = false);
      procedure FreeDisplay;
      procedure SetWindowCaption(caption: string);

      procedure NewFrame;
      procedure PresentFrame;

    private
      window: PSDL_Window;
      context: TSDL_GLContext;
      w, h: integer;
      in_frame: boolean;

      procedure InitGui;
      procedure InitRenderingContext(const width, height: integer; fullscreen: boolean);
  end;
  
  
(*******************************************************************************
*******************************************************************************) 
implementation

function GLFuncLoad(proc: Pchar): Pointer;
begin
  result := SDL_GL_GetProcAddress(proc);
  Assert(result <> nil, 'couldn''t load ' + proc);
end;

{ TDisplay }

procedure TDisplay.InitDisplay(const width, height: word; fullscreen: boolean);
begin
  if (SDL_WasInit(SDL_INIT_VIDEO) and SDL_INIT_VIDEO) = 0 then begin
      writeln('SDL video was not init, initializing now');
      SDL_InitSubSystem(SDL_INIT_VIDEO);
  end;
  InitRenderingContext(width, height, fullscreen);
  InitGui();
end;

procedure TDisplay.InitRenderingContext(const width, height: integer; fullscreen: boolean);
var
  y: integer;
  x: integer;
  flags: longword;
begin
  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE,  24);
  SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, 32);
  SDL_GL_SetAttribute(SDL_GL_RED_SIZE,     8);
  SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE,   8);
  SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE,    8);
  SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE,   8);
  SDL_GL_LoadLibrary(nil);

  w := width;
  h := height;
  x := SDL_WINDOWPOS_CENTERED;
  y := SDL_WINDOWPOS_CENTERED;
  flags := SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL;
  if fullscreen then
      flags := flags or SDL_WINDOW_FULLSCREEN_DESKTOP;
  window := SDL_CreateWindow('SDL window', x, y, w, h, flags);
  if window = nil then begin
      writeln ('SDL_CreateWindow failed. Reason: ' + SDL_GetError());
      halt;
  end;

  context := SDL_GL_CreateContext(window);
  SDL_GL_SetSwapInterval(1); //enable VSync
  if not gladLoadGL(@GLFuncLoad) then
      writeln('couldn''t load opengl ext!');

  glClearColor(0.0, 0.0, 0.0, 0.0);
end;

procedure TDisplay.InitGui;
var
  io: PImGuiIO;
begin
  io := ImGui.GetIO();
  io^.DisplaySize.x := w;
  io^.DisplaySize.y := h;
  ImGui_ImplSdlGL2_Init();
end;

procedure TDisplay.FreeDisplay;
begin
  ImGui_ImplSdlGL2_Shutdown();
  SDL_GL_DeleteContext(context);
  SDL_DestroyWindow(window);
  SDL_QuitSubSystem(SDL_INIT_VIDEO);
end;

procedure TDisplay.SetWindowCaption(caption: string);
begin
  SDL_SetWindowTitle(window, pchar(caption));
end;

procedure TDisplay.NewFrame;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  ImGui_ImplSdlGL2_NewFrame(window);
  in_frame := true;
end;

procedure TDisplay.PresentFrame;
begin
  Assert(in_frame, 'PresentFrame without NewFrame!');
  SDL_GL_SwapWindow(window);
  in_frame := false;
end;

end.

