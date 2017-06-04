program ImGuiDemo;

uses
  sysutils,
  sdl2, display,
  fpimgui, fpimgui_impl_sdlgl2, TestWindow;

var
  disp: TDisplay;
  ev: TSDL_Event;
  counter: integer;
  testwin: TTestWindow;
  testwin_open: boolean = true;

procedure ShowGreetingWindows;
begin
  ImGui.Begin_('Greeting');
  ImGui.SetWindowPos(ImVec2Init(100,100), ord(ImGuiSetCond_FirstUseEver));
  ImGui.Text('Hello, world %d', [counter]);
  if ImGui.Button('OK') then begin
      //button was pressed, do something special!
      Inc(counter);
  end;
  ImGui.End_;

  //same version, cimgui interface
  igBegin('Another greeting');
  igSetWindowPos(ImVec2Init(400,200), ord(ImGuiSetCond_FirstUseEver));
  igText('Hello, next world %d', [counter]);
  if igButton('Not OK!', ImVec2Init(0,0)) then begin
      Dec(counter);
  end;
  igEnd;
end;

begin
  SDL_SetHint(SDL_HINT_WINDOWS_DISABLE_THREAD_NAMING, '1');  //prevent SDL from raising a debugger exception to name threads

  //open new SDL window with OpenGL rendering support
  SDL_Init(SDL_INIT_VIDEO or SDL_INIT_TIMER);
  disp := TDisplay.Create;
  disp.InitDisplay(800, 600);

  testwin := TTestWindow.Create;
  counter := 0;
  while true do begin
      //begin new frame - clear screen etc.
      disp.NewFrame;

      //draw your scene and use imgui
      //(do some opengl calls...)

      //ShowGreetingWindows;        //simple windows
      //ImGui.ShowTestWindow();     //integrated demo: shows just about everything that it can do. See imgui_demo.cpp
      testwin.Show(testwin_open); //partially translated demo

      //(...and do some more opengl calls)


      //draw imgui's data buffer -> the gui will be on top, if you don't draw any more stuff
      ImGui.Render;

      //show frame on display
      disp.DrawFrame;

      //handle input
      if SDL_PollEvent(@ev) <> 0 then begin
          //pass events to imgui as well, otherwise widgets wouldn't be interactive
          ImGui_ImplSdlGL2_ProcessEvent(@ev);

          case ev.type_ of
                SDL_QUITEV:
                    break;
                //(other event handling)
          end;
      end;
  end;
  testwin.Free;

  //we won't need the SDL window anymore
  disp.FreeDisplay;
  disp.Free;
  SDL_Quit;
end.


