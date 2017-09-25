{
Additional imgui related code that may come in handy, mostly code samples from various sources
}
unit imgui_extra;

{$mode objfpc}{$H+}

interface

uses
  fpimgui;

type
ImVec3 = record
    x, y, z: single;
end;

function ImVec3Init(x,y,z: single): ImVec3;

{ code from procedural's GpuLib - https://github.com/procedural/gpulib/
  referenced in https://github.com/ocornut/imgui/issues/707
}
procedure imgui_easy_theming(color_for_text, color_for_head, color_for_area, color_for_body, color_for_pops: ImVec3);
procedure SetupImGuiStyle2();

implementation

function ImVec3Init(x,y,z: single): ImVec3;
begin
  result.x := x;
  result.y := y;
  result.z := z;
end;

procedure imgui_easy_theming(color_for_text, color_for_head, color_for_area, color_for_body, color_for_pops: ImVec3);
var
  style: PImGuiStyle;
begin
  style := ImGui.GetStyle();
  style^.Colors[ImGuiCol_Text] := ImVec4Init( color_for_text.x, color_for_text.y, color_for_text.z, 1.00 );
  style^.Colors[ImGuiCol_TextDisabled] := ImVec4Init( color_for_text.x, color_for_text.y, color_for_text.z, 0.58 );
  style^.Colors[ImGuiCol_WindowBg] := ImVec4Init( color_for_body.x, color_for_body.y, color_for_body.z, 0.95 );
  style^.Colors[ImGuiCol_ChildWindowBg] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 0.58 );
  style^.Colors[ImGuiCol_Border] := ImVec4Init( color_for_body.x, color_for_body.y, color_for_body.z, 0.00 );
  style^.Colors[ImGuiCol_BorderShadow] := ImVec4Init( color_for_body.x, color_for_body.y, color_for_body.z, 0.00 );
  style^.Colors[ImGuiCol_FrameBg] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 );
  style^.Colors[ImGuiCol_FrameBgHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 );
  style^.Colors[ImGuiCol_FrameBgActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_TitleBg] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 );
  style^.Colors[ImGuiCol_TitleBgCollapsed] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 0.75 );
  style^.Colors[ImGuiCol_TitleBgActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_MenuBarBg] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 0.47 );
  style^.Colors[ImGuiCol_ScrollbarBg] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 );
  style^.Colors[ImGuiCol_ScrollbarGrab] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.21 );
  style^.Colors[ImGuiCol_ScrollbarGrabHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 );
  style^.Colors[ImGuiCol_ScrollbarGrabActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_ComboBg] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 1.00 );
  style^.Colors[ImGuiCol_CheckMark] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.80 );
  style^.Colors[ImGuiCol_SliderGrab] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.50 );
  style^.Colors[ImGuiCol_SliderGrabActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_Button] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.50 );
  style^.Colors[ImGuiCol_ButtonHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.86 );
  style^.Colors[ImGuiCol_ButtonActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_Header] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.76 );
  style^.Colors[ImGuiCol_HeaderHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.86 );
  style^.Colors[ImGuiCol_HeaderActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_Separator] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.32 );
  style^.Colors[ImGuiCol_SeparatorHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 );
  style^.Colors[ImGuiCol_SeparatorActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_ResizeGrip] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.15 );
  style^.Colors[ImGuiCol_ResizeGripHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.78 );
  style^.Colors[ImGuiCol_ResizeGripActive] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_CloseButton] := ImVec4Init( color_for_text.x, color_for_text.y, color_for_text.z, 0.16 );
  style^.Colors[ImGuiCol_CloseButtonHovered] := ImVec4Init( color_for_text.x, color_for_text.y, color_for_text.z, 0.39 );
  style^.Colors[ImGuiCol_CloseButtonActive] := ImVec4Init( color_for_text.x, color_for_text.y, color_for_text.z, 1.00 );
  style^.Colors[ImGuiCol_PlotLines] := ImVec4Init( color_for_text.x, color_for_text.y, color_for_text.z, 0.63 );
  style^.Colors[ImGuiCol_PlotLinesHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_PlotHistogram] := ImVec4Init( color_for_text.x, color_for_text.y, color_for_text.z, 0.63 );
  style^.Colors[ImGuiCol_PlotHistogramHovered] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 1.00 );
  style^.Colors[ImGuiCol_TextSelectedBg] := ImVec4Init( color_for_head.x, color_for_head.y, color_for_head.z, 0.43 );
  style^.Colors[ImGuiCol_PopupBg] := ImVec4Init( color_for_pops.x, color_for_pops.y, color_for_pops.z, 0.92 );
  style^.Colors[ImGuiCol_ModalWindowDarkening] := ImVec4Init( color_for_area.x, color_for_area.y, color_for_area.z, 0.73 );
end;


procedure SetupImGuiStyle2();
var
  color_for_text, color_for_head, color_for_area, color_for_body, color_for_pops: ImVec3;
begin
  color_for_text := ImVec3Init(236.0 / 255.0, 240.0 / 255.0, 241.0 / 255.0);
  color_for_head := ImVec3Init(41.0 / 255.0, 128.0 / 255.0, 185.0 / 255.0);
  color_for_area := ImVec3Init(57.0 / 255.0, 79.0 / 255.0, 105.0 / 255.0);
  color_for_body := ImVec3Init(44.0 / 255.0, 62.0 / 255.0, 80.0 / 255.0);
  color_for_pops := ImVec3Init(33.0 / 255.0, 46.0 / 255.0, 60.0 / 255.0);
  imgui_easy_theming(color_for_text, color_for_head, color_for_area, color_for_body, color_for_pops);
end;

end.

