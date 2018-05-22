{ Partial translation of imgui demo / ShowTestWindow
  While you're probably better off with the original version as it's way more extensive,
  this is good as
    * a test case for the bindings or
    * a quick guide if something isn't translated in a straightforward way
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
      no_resize: boolean;
      no_move: boolean;
      no_scrollbar: boolean;
      no_collapse: boolean;
      no_menu: boolean;

      procedure Trees;
    public
      constructor Create;
      procedure Show(var p_open: boolean);
  end;

implementation

procedure ShowHelpMarker(const desc: string);
begin
    ImGui.TextDisabled('(?)');
    if (ImGui.IsItemHovered()) then
    begin
        ImGui.BeginTooltip();
        ImGui.PushTextWrapPos(450.0);
        ImGui.TextUnformatted(desc);
        ImGui.PopTextWrapPos();
        ImGui.EndTooltip();
    end;
end;

{ TTestWindow }

procedure TTestWindow.Trees;
const  //static vars
  align_label_with_current_x_position: boolean = false;
  selection_mask: integer = 1 << 2;  // Dumb representation of what may be user-side selection state. You may carry selection state inside or outside your objects in whatever format you see fit.
var
  node_open: bool;
  node_clicked: Integer;
  i: Integer;
  node_flags: ImGuiTreeNodeFlags;
begin
  if (ImGui.TreeNode('Basic trees')) then
  begin
      for i := 0 to 4 do
          if (ImGui.TreeNode(ImIDPtr(i), 'Child %d', [i])) then
          begin
              ImGui.Text('blah blah');
              ImGui.SameLine();
              if (ImGui.SmallButton('print')) then writeln('Child ',i,' pressed');
              ImGui.TreePop();
          end;
      ImGui.TreePop();
  end;

  if (ImGui.TreeNode('Advanced, with Selectable nodes')) then
  begin
      ShowHelpMarker('This is a more standard looking tree with selectable nodes.' + LineEnding
                     + 'Click to select, CTRL+Click to toggle, click on arrows or double-click to open.');
      ImGui.Checkbox('Align label with current X position)', @align_label_with_current_x_position);
      ImGui.Text('Hello!');
      if (align_label_with_current_x_position) then
          ImGui.Unindent(ImGui.GetTreeNodeToLabelSpacing());
      node_clicked := -1;         // Temporary storage of what node we have clicked to process selection at the end of the loop. May be a pointer to your own node type, etc.
      ImGui.PushStyleVar(ord(ImGuiStyleVar_IndentSpacing), ImGui.GetFontSize() * 3); // Increase spacing to differentiate leaves from expanded contents.
      for i := 0 to 5 do
      begin
          // Disable the default open on single-click behavior and pass in Selected flag according to our selection state.
          //ImGuiTreeNodeFlags node_flags := ImGuiTreeNodeFlags_OpenOnArrow | ImGuiTreeNodeFlags_OpenOnDoubleClick | ((selection_mask & (1 << i)) ? ImGuiTreeNodeFlags_Selected : 0);
          node_flags := ord(ImGuiTreeNodeFlags_OpenOnArrow) or ord(ImGuiTreeNodeFlags_OpenOnDoubleClick);
          if (selection_mask and (1 << i)) > 0 then
              node_flags := node_flags or ord (ImGuiTreeNodeFlags_Selected);
          if (i < 3) then
          begin
              // Node
              node_open := ImGui.TreeNodeEx(ImIDPtr(i), node_flags, 'Selectable Node %d', [i]);
              if (ImGui.IsItemClicked()) then
                  node_clicked := i;
              if (node_open) then
              begin
                  ImGui.Text('Blah blah' + LineEnding + 'Blah Blah');
                  ImGui.TreePop();
              end;
          end
          else
          begin
              // Leaf: The only reason we have a TreeNode at all is to allow selection of the leaf. Otherwise we can use BulletText() or TreeAdvanceToLabelPos()+Text().
              node_flags := node_flags or ord(ImGuiTreeNodeFlags_Leaf) or ord(ImGuiTreeNodeFlags_NoTreePushOnOpen);
              ImGui.TreeNodeEx(ImIDPtr(i), node_flags, 'Selectable Leaf %d', [i]);
              if (ImGui.IsItemClicked()) then
                  node_clicked := i;
          end;
      end;
      if (node_clicked <> - 1) then
      begin
          // Update selection state. Process outside of tree loop to avoid visual inconsistencies during the clicking-frame.
          if (ImGui.GetIO()^.KeyCtrl) then
              selection_mask := selection_mask xor (1 << node_clicked)          // CTRL+click to toggle
          else //if (!(selection_mask & (1 << node_clicked))) // Depending on selection behavior you want, this commented bit preserve selection when clicking on item that is part of the selection
              selection_mask := (1 << node_clicked);           // Click to single-select
      end;
      ImGui.PopStyleVar();
      if (align_label_with_current_x_position) then
          ImGui.Indent(ImGui.GetTreeNodeToLabelSpacing());
      ImGui.TreePop();
  end;
  ImGui.TreePop();
end;

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
  no_resize := false;
  no_move := false;
  no_scrollbar := false;
  no_collapse := false;
  no_menu := false;
end;

procedure TTestWindow.Show(var p_open: boolean);
var
  window_flags: ImGuiWindowFlags = 0;
  draw_list: PImDrawList;
  value_raw, value_with_lock_threshold, mouse_delta: ImVec2;
begin
  // Demonstrate the various window flags. Typically you would just use the default.
  if (no_titlebar)   then window_flags := window_flags or ord(ImGuiWindowFlags_NoTitleBar);
  if (no_resize)     then window_flags := window_flags or ord(ImGuiWindowFlags_NoResize);
  if (no_move)       then window_flags := window_flags or ord(ImGuiWindowFlags_NoMove);
  if (no_scrollbar)  then window_flags := window_flags or ord(ImGuiWindowFlags_NoScrollbar);
  if (no_collapse)   then window_flags := window_flags or ord(ImGuiWindowFlags_NoCollapse);
  if (not no_menu)   then window_flags := window_flags or ord(ImGuiWindowFlags_MenuBar);
  ImGui.SetNextWindowSize(ImVec2Init(550,680), ord(ImGuiCond_FirstUseEver));
  if not ImGui.Begin_('ImGui Demo (translated version)', @p_open, window_flags) then begin
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
      ImGui.Checkbox('No resize', @no_resize);
      ImGui.Checkbox('No move', @no_move); ImGui.SameLine(150);
      ImGui.Checkbox('No scrollbar', @no_scrollbar); ImGui.SameLine(300);
      ImGui.Checkbox('No collapse', @no_collapse);
      ImGui.Checkbox('No menu', @no_menu);

      if ImGui.TreeNode('Style') then
      begin
          ImGui.ShowStyleEditor(Imgui.GetStyle());  //this is useful to have, but doesn't need to be translated as an example
          ImGui.TreePop();
      end;

      if ImGui.TreeNode('Logging') then
      begin
          ImGui.TextWrapped('The logging API redirects all text output so you can easily capture the content of a window or a block. Tree nodes can be automatically expanded. You can also call ImGui.LogText() to output directly to the log without a visual output.');
          ImGui.LogButtons();
          ImGui.TreePop();
      end;
  end;

  if ImGui.CollapsingHeader('Widgets') then
  begin
      if ImGui.TreeNode('Trees') then
          Trees;
  end;

  if ImGui.CollapsingHeader('Keyboard, Mouse & Focus') then
  begin
      if ImGui.TreeNode('Dragging') then
      begin
          ImGui.TextWrapped('You can use ImGui::GetMouseDragDelta(0) to query for the dragged amount on any widget.');
          ImGui.Button('Drag Me');
          if ImGui.IsItemActive() then
          begin
              // Draw a line between the button and the mouse cursor
              draw_list := ImGui.GetWindowDrawList();
              draw_list^.PushClipRectFullScreen;
              draw_list^.AddLine(ImGui.CalcItemRectClosestPoint(ImGui.GetIO()^.MousePos, true, -2.0), ImGui.GetIO()^.MousePos,
                  ImColor(ImGui.GetStyle()^.Colors[ImGuiCol_Button]), 4.0);
              draw_list^.PopClipRect;

              value_raw := ImGui.GetMouseDragDelta(0, 0.0);
              value_with_lock_threshold := ImGui.GetMouseDragDelta(0);
              mouse_delta := ImGui.GetIO()^.MouseDelta;
              ImGui.SameLine();
              ImGui.Text('Raw (%.1f, %.1f), WithLockThresold (%.1f, %.1f), MouseDelta (%.1f, %.1f)',
                  [value_raw.x, value_raw.y, value_with_lock_threshold.x, value_with_lock_threshold.y, mouse_delta.x, mouse_delta.y]);
          end;
          ImGui.TreePop();
      end;
  end;

  ImGui.End_;
end;

end.

