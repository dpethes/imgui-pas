program ImGuiDemo;

uses
  sysutils,
  sdl2, display, glad_gl,
  fpimgui, fpimgui_impl_sdlgl2, imgui_extra, TestWindow;

var
  disp: TDisplay;
  ev: TSDL_Event;
  counter: integer;
  testwin: TTestWindow;
  testwin_open: boolean = true;

procedure ShowGreetingWindows;
var
  draw_list: PImDrawList;
  pos: ImVec2;
begin
  ImGui.Begin_('Greeting');
    ImGui.SetWindowPos(ImVec2Init(100,100), ord(ImGuiCond_FirstUseEver));
    ImGui.Text('Hello, world %d', [counter]);
    if ImGui.Button('OK') then begin
        //button was pressed, do something special!
        Inc(counter);
    end;
    if ImGui.IsItemHovered(ord(ImGuiHoveredFlags_RectOnly)) then begin
        ImGui.SameLine();
        ImGui.Text('button hovered');
    end;

    ImGui.SameLine();
    pos := ImGui.GetCursorScreenPos();
    draw_list := ImGui.GetWindowDrawList();
    draw_list^.AddRectFilled(pos, ImVec2Init(pos.x + 50, pos.y + 25), $88000055);

    pos := ImVec2Init(pos.x + 50 + 20, pos.y);
    ImGui.SetCursorScreenPos(pos);

    draw_list^.AddRectFilled(pos, ImVec2Init(pos.x + ImGui.CalcTextSize(pchar('custom rectangles')).x, pos.y + 25), $88005500);
    ImGui.Text('custom rectangles');
    if ImGui.IsWindowHovered() then
        ImGui.Text('window hovered')
    else if ImGui.IsAnyWindowHovered then
        ImGui.Text('some window hovered');
  ImGui.End_;

  //cimgui interface
  igBegin('Another greeting');
    igSetWindowPos(ImVec2Init(400,200), ord(ImGuiCond_FirstUseEver));
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

  //uncomment to set a different gui theme
  //SetupImGuiStyle2();
  Imgui.StyleColorsDark(ImGui.GetStyle());

  while true do begin
      //begin new frame - clear screen etc.
      disp.NewFrame;

      //draw your scene and use imgui
      //(do some opengl calls...)

      ShowGreetingWindows;        //simple windows
      ImGui.ShowDemoWindow();     //integrated demo: shows just about everything that it can do. See imgui_demo.cpp
      testwin.Show(testwin_open); //partially translated demo

      //(...and do some more opengl calls)


      //draw imgui's data buffer -> the gui will be on top, if you don't draw any more stuff
      ImGui.Render;

      //show frame on display
      disp.PresentFrame;
      Assert(glGetError() = GL_NO_ERROR);

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


