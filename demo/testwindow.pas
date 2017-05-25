{ partial translation of imgui demo / ShowTestWindow
}
unit TestWindow;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpimgui;

type

  { TTestWindow }
  TTestWindow = class
    private
      show_app_main_menu_bar: boolean;
      show_app_console: boolean;
      show_app_log: boolean;
      show_app_layout: boolean;
      show_app_property_editor: boolean;
      show_app_long_text: boolean;
      show_app_auto_resize: boolean;
      show_app_constrained_resize: boolean;
      show_app_fixed_overlay: boolean;
      show_app_manipulating_window_title: boolean;
      show_app_custom_rendering: boolean;
      show_app_style_editor: boolean;

      show_app_metrics: boolean;
      show_app_about: boolean;

      no_titlebar: boolean;
      no_border: boolean;
      no_resize: boolean;
      no_move: boolean;
      no_scrollbar: boolean;
      no_collapse: boolean;
      no_menu: boolean;
    public
      constructor Create;
      procedure Show(var p_open: boolean);
  end;

implementation

const
  ImGuiSetCond_FirstUseEver = 1 shl 2;


{ TTestWindow }

constructor TTestWindow.Create;
begin
  show_app_main_menu_bar := false;
  show_app_console := false;
  show_app_log := false;
  show_app_layout := false;
  show_app_property_editor := false;
  show_app_long_text := false;
  show_app_auto_resize := false;
  show_app_constrained_resize := false;
  show_app_fixed_overlay := false;
  show_app_manipulating_window_title := false;
  show_app_custom_rendering := false;
  show_app_style_editor := false;

  show_app_metrics := false;
  show_app_about := false;

  no_titlebar := false;
  no_border := true;
  no_resize := false;
  no_move := false;
  no_scrollbar := false;
  no_collapse := false;
  no_menu := false;
end;

procedure TTestWindow.Show(var p_open: boolean);
var
  window_flags: ImGuiWindowFlags = 0;
begin
  // Demonstrate the various window flags. Typically you would just use the default.
  if (no_titlebar)   then window_flags := window_flags or ord(ImGuiWindowFlags_NoTitleBar);
  if (not no_border) then window_flags := window_flags or ord(ImGuiWindowFlags_ShowBorders);
  if (no_resize)     then window_flags := window_flags or ord(ImGuiWindowFlags_NoResize);
  if (no_move)       then window_flags := window_flags or ord(ImGuiWindowFlags_NoMove);
  if (no_scrollbar)  then window_flags := window_flags or ord(ImGuiWindowFlags_NoScrollbar);
  if (no_collapse)   then window_flags := window_flags or ord(ImGuiWindowFlags_NoCollapse);
  if (not no_menu)   then window_flags := window_flags or ord(ImGuiWindowFlags_MenuBar);
  ImGui.SetNextWindowSize(ImVec2Init(550,680), ImGuiSetCond_FirstUseEver);
  if not ImGui.Begin_('ImGui Demo', @p_open, window_flags) then begin
      // Early out if the window is collapsed, as an optimization.
      ImGui.End_;
      exit;
  end;

  //ImGui::PushItemWidth(ImGui::GetWindowWidth() * 0.65f);    // 2/3 of the space for widget and 1/3 for labels
  ImGui.PushItemWidth(-140);                                 // Right align, keep 140 pixels for labels

  ImGui.Text('Dear ImGui says hello.');

  // Menu
  if (ImGui.BeginMenuBar()) then
  begin
      if (ImGui.BeginMenu('Menu')) then
      begin
          //ShowExampleMenuFile();
          ImGui.EndMenu();
      end;
      if (ImGui.BeginMenu('Examples')) then
      begin
          ImGui.MenuItem('Main menu bar', nil, @show_app_main_menu_bar);
          ImGui.MenuItem('Console', nil, @show_app_console);
          ImGui.MenuItem('Log', nil, @show_app_log);
          ImGui.MenuItem('Simple layout', nil, @show_app_layout);
          ImGui.MenuItem('Property editor', nil, @show_app_property_editor);
          ImGui.MenuItem('Long text display', nil, @show_app_long_text);
          ImGui.MenuItem('Auto-resizing window', nil, @show_app_auto_resize);
          ImGui.MenuItem('Constrained-resizing window', nil, @show_app_constrained_resize);
          ImGui.MenuItem('Simple overlay', nil, @show_app_fixed_overlay);
          ImGui.MenuItem('Manipulating window title', nil, @show_app_manipulating_window_title);
          ImGui.MenuItem('Custom rendering', nil, @show_app_custom_rendering);
          ImGui.EndMenu();
      end;
      if (ImGui.BeginMenu('Help')) then
      begin
          ImGui.MenuItem('Metrics', nil, @show_app_metrics);
          ImGui.MenuItem('Style Editor', nil, @show_app_style_editor);
          ImGui.MenuItem('About ImGui', nil, @show_app_about);
          ImGui.EndMenu();
      end;
      ImGui.EndMenuBar();
  end;

  ImGui.Spacing();
  if ImGui.CollapsingHeader('Help') then
  begin
      ImGui.TextWrapped('This window is being created by the ShowTestWindow() function. Please refer to the code for programming reference.' + LineEnding + LineEnding + 'User Guide:');
      ImGui.ShowUserGuide();
  end;

  if ImGui.CollapsingHeader('Window options') then
  begin
      ImGui.Checkbox('No titlebar', @no_titlebar); ImGui.SameLine(150);
      ImGui.Checkbox('No border', @no_border); ImGui.SameLine(300);
      ImGui.Checkbox('No resize', @no_resize);
      ImGui.Checkbox('No move', @no_move); ImGui.SameLine(150);
      ImGui.Checkbox('No scrollbar', @no_scrollbar); ImGui.SameLine(300);
      ImGui.Checkbox('No collapse', @no_collapse);
      ImGui.Checkbox('No menu', @no_menu);

      if ImGui.TreeNode('Style') then
      begin
          //ImGui.ShowStyleEditor();  //DP: todo
          ImGui.TreePop();
      end;

      if ImGui.TreeNode('Logging') then
      begin
          ImGui.TextWrapped('The logging API redirects all text output so you can easily capture the content of a window or a block. Tree nodes can be automatically expanded. You can also call ImGui.LogText() to output directly to the log without a visual output.');
          ImGui.LogButtons();
          ImGui.TreePop();
      end;
  end;

  ImGui.End_;
end;

end.

