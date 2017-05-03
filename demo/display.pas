(*
display.pas
*)
unit display;
{$mode objfpc}{$H+}

interface

uses
  sysutils,
  sdl2, gl, glu,
  fpimgui, fpimgui_impl_sdlgl2;
  
type
  { TDisplay }
  TDisplay = class
    public
      procedure InitDisplay(const width, height: word);
      procedure FreeDisplay;
      procedure SetWindowCaption(caption: string);

      procedure NewFrame;
      procedure DrawFrame;

    private
      w, h: word;
      window: PSDL_Window;
      in_frame: boolean;
      context: TSDL_GLContext;

      procedure InitGui;
      procedure InitRenderingContext(const height: word; const width: word);
      procedure DrawGui();
  end;
  
  
(*******************************************************************************
*******************************************************************************) 
implementation


{ TDisplay }

procedure TDisplay.InitDisplay (const width, height: word );
begin
  if (SDL_WasInit(SDL_INIT_VIDEO) and SDL_INIT_VIDEO) = 0 then begin
      writeln('SDL video was not init, initializing now');
      SDL_InitSubSystem(SDL_INIT_VIDEO);
  end;
  InitRenderingContext(height, width);
end;

procedure TDisplay.InitRenderingContext(const height: word; const width: word);
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

  w := width;
  h := height;
  x := SDL_WINDOWPOS_CENTERED_MASK;
  y := SDL_WINDOWPOS_CENTERED_MASK;
  flags := SDL_WINDOW_SHOWN or SDL_WINDOW_OPENGL;
  window := SDL_CreateWindow('SDL window', x, y, w, h, flags);
  if window = nil then begin
      writeln ('SDL_CreateWindow failed. Reason: ' + SDL_GetError());
      halt;
  end;

  context := SDL_GL_CreateContext(window);
  SDL_GL_SetSwapInterval(1); //enable VSync
  glClearColor( 0.0, 0.0, 0.0, 0);

  InitGui();
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

procedure TDisplay.DrawFrame;
begin
  Assert(in_frame, 'DrawFrame without NewFrame!');
  DrawGui();
  SDL_GL_SwapWindow(window);
  in_frame := false;
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

procedure TDisplay.DrawGui;
begin
  ImGui.Render;
end;




end.

