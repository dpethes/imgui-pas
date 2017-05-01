{
Bindings for dear imgui (AKA ImGui) - a bloat-free graphical user interface library for C++
Based on cimgui+ImGui 1.49/1.50
}
unit fpimgui;

interface

{$IFDEF FPC}
{$PACKRECORDS C}
uses dynlibs;
{$ENDIF}

const
  ImguiLibName = 'cimgui.' + SharedSuffix;

type
  bool = boolean;
  Pbool = ^bool;
  Pbyte = ^byte;
  Pdword = ^dword;

  TFloat2 = array[0..1] of single;
  TFloat3 = array[0..2] of single;
  TFloat4 = array[0..3] of single;

  TLongInt2 = array[0..1] of longint;
  TLongInt3 = array[0..2] of longint;
  TLongInt4 = array[0..3] of longint;

  PImDrawData = ^ImDrawData;
  PImFont = ^ImFont;
  PImFontAtlas = ^ImFontAtlas;
  PImFontConfig = ^ImFontConfig;
  PImGuiContext = Pointer;
  PImGuiSizeConstraintCallbackData = ^ImGuiSizeConstraintCallbackData;
  PImGuiStorage = ^ImGuiStorage;
  PImGuiTextEditCallbackData = ^ImGuiTextEditCallbackData;

  ImVec2 = record
      x, y: single;
  end;
  PImVec2 = ^ImVec2;
  ImVec4 = record
      x, y, z, w: single;
  end;
  PImVec4 = ^ImVec4;

  ImU32 = dword;
  ImWchar = word;
  ImTextureID = pointer;
  ImGuiID = ImU32;
  ImGuiCol = longint;
  ImGuiStyleVar = longint;
  ImGuiKey = longint;
  ImGuiAlign = longint;
  ImGuiColorEditMode = longint;
  ImGuiMouseCursor = longint;
  ImGuiWindowFlags = longint;
  ImGuiSetCond = longint;
  ImGuiInputTextFlags = longint;
  ImGuiSelectableFlags = longint;

  { Enums }

  ImGuiTreeNodeFlags = (
      Selected = 1 shl 0,
      Framed = 1 shl 1,
      AllowOverlapMode = 1 shl 2,
      NoTreePushOnOpen = 1 shl 3,
      NoAutoOpenOnLog = 1 shl 4,
      DefaultOpen = 1 shl 5,
      OpenOnDoubleClick = 1 shl 6,
      OpenOnArrow = 1 shl 7,
      Leaf = 1 shl 8,
      Bullet = 1 shl 9
  );

  ImGuiKey_ = (
      ImGuiKey_Tab,       // for tabbing through fields
      ImGuiKey_LeftArrow, // for text edit
      ImGuiKey_RightArrow,// for text edit
      ImGuiKey_UpArrow,   // for text edit
      ImGuiKey_DownArrow, // for text edit
      ImGuiKey_PageUp,
      ImGuiKey_PageDown,
      ImGuiKey_Home,      // for text edit
      ImGuiKey_End,       // for text edit
      ImGuiKey_Delete,    // for text edit
      ImGuiKey_Backspace, // for text edit
      ImGuiKey_Enter,     // for text edit
      ImGuiKey_Escape,    // for text edit
      ImGuiKey_A,         // for text edit CTRL+A: select all
      ImGuiKey_C,         // for text edit CTRL+C: copy
      ImGuiKey_V,         // for text edit CTRL+V: paste
      ImGuiKey_X,         // for text edit CTRL+X: cut
      ImGuiKey_Y,         // for text edit CTRL+Y: redo
      ImGuiKey_Z          // for text edit CTRL+Z: undo
      //ImGuiKey_COUNT    // this is unnecessary, if we declare KeyMap as array[ImGuiKey_]
  );

  ImGuiCol_ = (
      ImGuiCol_Text,
      ImGuiCol_TextDisabled,
      ImGuiCol_WindowBg,
      ImGuiCol_ChildWindowBg,
      ImGuiCol_PopupBg,
      ImGuiCol_Border,
      ImGuiCol_BorderShadow,
      ImGuiCol_FrameBg,
      ImGuiCol_FrameBgHovered,
      ImGuiCol_FrameBgActive,
      ImGuiCol_TitleBg,
      ImGuiCol_TitleBgCollapsed,
      ImGuiCol_TitleBgActive,
      ImGuiCol_MenuBarBg,
      ImGuiCol_ScrollbarBg,
      ImGuiCol_ScrollbarGrab,
      ImGuiCol_ScrollbarGrabHovered,
      ImGuiCol_ScrollbarGrabActive,
      ImGuiCol_ComboBg,
      ImGuiCol_CheckMark,
      ImGuiCol_SliderGrab,
      ImGuiCol_SliderGrabActive,
      ImGuiCol_Button,
      ImGuiCol_ButtonHovered,
      ImGuiCol_ButtonActive,
      ImGuiCol_Header,
      ImGuiCol_HeaderHovered,
      ImGuiCol_HeaderActive,
      ImGuiCol_Column,
      ImGuiCol_ColumnHovered,
      ImGuiCol_ColumnActive,
      ImGuiCol_ResizeGrip,
      ImGuiCol_ResizeGripHovered,
      ImGuiCol_ResizeGripActive,
      ImGuiCol_CloseButton,
      ImGuiCol_CloseButtonHovered,
      ImGuiCol_CloseButtonActive,
      ImGuiCol_PlotLines,
      ImGuiCol_PlotLinesHovered,
      ImGuiCol_PlotHistogram,
      ImGuiCol_PlotHistogramHovered,
      ImGuiCol_TextSelectedBg,
      ImGuiCol_ModalWindowDarkening
      //ImGuiCol_COUNT  - unnecessary
  );

  { Structs }
  ImGuiStyle = record
      Alpha : single;
      WindowPadding : ImVec2;
      WindowMinSize : ImVec2;
      WindowRounding : single;
      WindowTitleAlign : ImVec2;
      ChildWindowRounding : single;
      FramePadding : ImVec2;
      FrameRounding : single;
      ItemSpacing : ImVec2;
      ItemInnerSpacing : ImVec2;
      TouchExtraPadding : ImVec2;
      IndentSpacing : single;
      ColumnsMinSpacing : single;
      ScrollbarSize : single;
      ScrollbarRounding : single;
      GrabMinSize : single;
      GrabRounding : single;
      ButtonTextAlign : ImVec2;
      DisplayWindowPadding : ImVec2;
      DisplaySafeAreaPadding : ImVec2;
      AntiAliasedLines : bool;
      AntiAliasedShapes : bool;
      CurveTessellationTol : single;
      Colors: array[ImGuiCol_] of ImVec4;
  end;
  PImGuiStyle = ^ImGuiStyle;

  ImGuiIO = record
      DisplaySize : ImVec2;
      DeltaTime : single;
      IniSavingRate : single;
      IniFilename : Pchar;
      LogFilename : Pchar;
      MouseDoubleClickTime : single;
      MouseDoubleClickMaxDist : single;
      MouseDragThreshold : single;
      KeyMap : array[ImGuiKey_] of longint;
      KeyRepeatDelay : single;
      KeyRepeatRate : single;
      UserData : pointer;
      Fonts : PImFontAtlas;
      FontGlobalScale : single;
      FontAllowUserScaling : bool;
      FontDefault : PImFont;
      DisplayFramebufferScale : ImVec2;
      DisplayVisibleMin : ImVec2;
      DisplayVisibleMax : ImVec2;
      OSXBehaviors : bool;
      RenderDrawListsFn : procedure (data:PImDrawData);cdecl;
      GetClipboardTextFn : function (user_data:pointer):Pchar;cdecl;
      SetClipboardTextFn : procedure (user_data:pointer; text:Pchar);cdecl;
      ClipboardUserData : pointer;
      MemAllocFn : function (sz:size_t):pointer;cdecl;
      MemFreeFn : procedure (ptr:pointer);cdecl;
      ImeSetInputScreenPosFn : procedure (x:longint; y:longint);cdecl;
      ImeWindowHandle : pointer;
      MousePos : ImVec2;
      MouseDown : array[0..4] of bool;
      MouseWheel : single;
      MouseDrawCursor : bool;
      KeyCtrl : bool;
      KeyShift : bool;
      KeyAlt : bool;
      KeySuper : bool;
      KeysDown : array[0..511] of bool;
      InputCharacters : array[0..(16+1)-1] of ImWchar;
      WantCaptureMouse : bool;
      WantCaptureKeyboard : bool;
      WantTextInput : bool;
      Framerate : single;
      MetricsAllocs : longint;
      MetricsRenderVertices : longint;
      MetricsRenderIndices : longint;
      MetricsActiveWindows : longint;
      MouseDelta : ImVec2;
  end;
  PImGuiIO = ^ImGuiIO;

  ImDrawVert = record
      pos, uv: ImVec2;
      col: ImU32;
  end;
  PImDrawVert = ^ImDrawVert;

  PImDrawList = ^ImDrawList;
  PPImDrawList = ^PImDrawList;
  PImDrawIdx = ^ImDrawIdx;
  ImDrawIdx = word;

  PImDrawCmd = ^ImDrawCmd;
  ImDrawCallback = procedure(parent_list: PImDrawList; cmd: PImDrawCmd); cdecl;
  ImDrawCmd = record
      ElemCount: longword;
      ClipRect: ImVec4;
      TextureId: ImTextureID;
      UserCallback: ImDrawCallback;
      UserCallbackData: Pointer;
  end;

  //imgui uses generic T* pointer as Data, so we need to specialize with pointer types
  generic ImVector<_T> = record
      Size: integer;
      Capacity: integer;
      Data: _T;
  end;
  ImVectorDrawCmd = specialize ImVector<PImDrawCmd>;
  ImVectorDrawIdx = specialize ImVector<PImDrawIdx>;
  ImVectorDrawVert = specialize ImVector<PImDrawVert>;
  ImDrawList = record
      CmdBuffer: ImVectorDrawCmd;
      IdxBuffer: ImVectorDrawIdx;
      VtxBuffer: ImVectorDrawVert;
  end;

  ImDrawData = record
      Valid: boolean;
      CmdLists: PPImDrawList;
      CmdListsCount,
      TotalVtxCount,
      TotalIdxCount: integer;
  end;

  ImGuiTextEditCallbackData = record
  end;
  ImGuiSizeConstraintCallbackData = record
  end;
  ImGuiStorage = record
  end;
  ImFont = record
  end;
  ImFontConfig = record
  end;
  ImFontAtlas = record
  end;


  ImGuiTextEditCallback = function(Data: PImGuiTextEditCallbackData): longint; cdecl;
  ImGuiSizeConstraintCallback = procedure(Data: PImGuiSizeConstraintCallbackData); cdecl;

function  igGetIO(): PImGuiIO; cdecl; external ImguiLibName;
function  igGetStyle(): PImGuiStyle; cdecl; external ImguiLibName;
function  igGetDrawData(): PImDrawData; cdecl; external ImguiLibName;
procedure igNewFrame; cdecl; external ImguiLibName;
procedure igRender; cdecl; external ImguiLibName;
procedure igShutdown; cdecl; external ImguiLibName;
procedure igShowUserGuide; cdecl; external ImguiLibName;
procedure igShowStyleEditor(ref: PImGuiStyle); cdecl; external ImguiLibName;
procedure igShowTestWindow(opened: Pbool); cdecl; external ImguiLibName;
procedure igShowMetricsWindow(opened: Pbool); cdecl; external ImguiLibName;

{ Window }
function  igBegin(Name: PChar; p_open: Pbool = nil; flags: ImGuiWindowFlags = 0): bool; cdecl; external ImguiLibName;
function  igBegin2(Name: PChar; p_open: Pbool; size_on_first_use: ImVec2; bg_alpha: single; flags: ImGuiWindowFlags): bool; cdecl; external ImguiLibName;
procedure igEnd; cdecl; external ImguiLibName;
function  igBeginChild(str_id: PChar; size: ImVec2; border: bool; extra_flags: ImGuiWindowFlags): bool; cdecl; external ImguiLibName;
function  igBeginChildEx(id: ImGuiID; size: ImVec2; border: bool; extra_flags: ImGuiWindowFlags): bool; cdecl; external ImguiLibName;
procedure igEndChild; cdecl; external ImguiLibName;
procedure igGetContentRegionMax(out_: PImVec2); cdecl; external ImguiLibName;
procedure igGetContentRegionAvail(out_: PImVec2); cdecl; external ImguiLibName;
function  igGetContentRegionAvailWidth: single; cdecl; external ImguiLibName;
procedure igGetWindowContentRegionMin(out_: PImVec2); cdecl; external ImguiLibName;
procedure igGetWindowContentRegionMax(out_: PImVec2); cdecl; external ImguiLibName;
function  igGetWindowContentRegionWidth: single; cdecl; external ImguiLibName;
function  igGetWindowDrawList(): PImDrawList; cdecl; external ImguiLibName;
procedure igGetWindowPos(out_: PImVec2); cdecl; external ImguiLibName;
procedure igGetWindowSize(out_: PImVec2); cdecl; external ImguiLibName;
function  igGetWindowWidth: single; cdecl; external ImguiLibName;
function  igGetWindowHeight: single; cdecl; external ImguiLibName;
function  igIsWindowCollapsed: bool; cdecl; external ImguiLibName;
procedure igSetWindowFontScale(scale: single); cdecl; external ImguiLibName;

procedure igSetNextWindowPos(pos: ImVec2; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetNextWindowPosCenter(cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetNextWindowSize(size: ImVec2; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetNextWindowSizeConstraints(size_min: ImVec2; size_max: ImVec2; custom_callback: ImGuiSizeConstraintCallback; custom_callback_data: pointer); cdecl; external ImguiLibName;
procedure igSetNextWindowContentSize(size: ImVec2); cdecl; external ImguiLibName;
procedure igSetNextWindowContentWidth(Width: single); cdecl; external ImguiLibName;
procedure igSetNextWindowCollapsed(collapsed: bool; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetNextWindowFocus; cdecl; external ImguiLibName;
procedure igSetWindowPos(pos: ImVec2; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetWindowSize(size: ImVec2; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetWindowCollapsed(collapsed: bool; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetWindowFocus; cdecl; external ImguiLibName;
procedure igSetWindowPosByName(Name: PChar; pos: ImVec2; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetWindowSize2(Name: PChar; size: ImVec2; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetWindowCollapsed2(Name: PChar; collapsed: bool; cond: ImGuiSetCond); cdecl; external ImguiLibName;
procedure igSetWindowFocus2(Name: PChar); cdecl; external ImguiLibName;

function  igGetScrollX: single; cdecl; external ImguiLibName;
function  igGetScrollY: single; cdecl; external ImguiLibName;
function  igGetScrollMaxX: single; cdecl; external ImguiLibName;
function  igGetScrollMaxY: single; cdecl; external ImguiLibName;
procedure igSetScrollX(scroll_x: single); cdecl; external ImguiLibName;
procedure igSetScrollY(scroll_y: single); cdecl; external ImguiLibName;
procedure igSetScrollHere(center_y_ratio: single); cdecl; external ImguiLibName;
procedure igSetScrollFromPosY(pos_y: single; center_y_ratio: single); cdecl; external ImguiLibName;
procedure igSetKeyboardFocusHere(offset: longint); cdecl; external ImguiLibName;
procedure igSetStateStorage(tree: PImGuiStorage); cdecl; external ImguiLibName;
function  igGetStateStorage(): PImGuiStorage; cdecl; external ImguiLibName;


{ Parameters stacks (shared) }
procedure igPushFont(font: PImFont); cdecl; external ImguiLibName;
procedure igPopFont; cdecl; external ImguiLibName;
procedure igPushStyleColor(idx: ImGuiCol; col: ImVec4); cdecl; external ImguiLibName;
procedure igPopStyleColor(Count: longint); cdecl; external ImguiLibName;
procedure igPushStyleVar(idx: ImGuiStyleVar; val: single); cdecl; external ImguiLibName;
procedure igPushStyleVarVec(idx: ImGuiStyleVar; val: ImVec2); cdecl; external ImguiLibName;
procedure igPopStyleVar(Count: longint); cdecl; external ImguiLibName;
function  igGetFont(): PImFont; cdecl; external ImguiLibName;
function  igGetFontSize: single; cdecl; external ImguiLibName;
procedure igGetFontTexUvWhitePixel(pOut: PImVec2); cdecl; external ImguiLibName;
function  igGetColorU32(idx: ImGuiCol; alpha_mul: single): ImU32; cdecl; external ImguiLibName;
function  igGetColorU32Vec(col: PImVec4): ImU32; cdecl; external ImguiLibName;

{ Parameters stacks (current window) }
procedure igPushItemWidth(item_width: single); cdecl; external ImguiLibName;
procedure igPopItemWidth; cdecl; external ImguiLibName;
function  igCalcItemWidth: single; cdecl; external ImguiLibName;
procedure igPushTextWrapPos(wrap_pos_x: single); cdecl; external ImguiLibName;
procedure igPopTextWrapPos; cdecl; external ImguiLibName;
procedure igPushAllowKeyboardFocus(v: bool); cdecl; external ImguiLibName;
procedure igPopAllowKeyboardFocus; cdecl; external ImguiLibName;
procedure igPushButtonRepeat(_repeat: bool); cdecl; external ImguiLibName;
procedure igPopButtonRepeat; cdecl; external ImguiLibName;

{ Layout }
procedure igSeparator; cdecl; external ImguiLibName;
procedure igSameLine(pos_x: single; spacing_w: single); cdecl; external ImguiLibName;
procedure igNewLine; cdecl; external ImguiLibName;
procedure igSpacing; cdecl; external ImguiLibName;
procedure igDummy(size: PImVec2); cdecl; external ImguiLibName;
procedure igIndent(indent_w: single); cdecl; external ImguiLibName;
procedure igUnindent(indent_w: single); cdecl; external ImguiLibName;
procedure igBeginGroup; cdecl; external ImguiLibName;
procedure igEndGroup; cdecl; external ImguiLibName;
procedure igGetCursorPos(pOut: PImVec2); cdecl; external ImguiLibName;
function  igGetCursorPosX: single; cdecl; external ImguiLibName;
function  igGetCursorPosY: single; cdecl; external ImguiLibName;
procedure igSetCursorPos(local_pos: ImVec2); cdecl; external ImguiLibName;
procedure igSetCursorPosX(x: single); cdecl; external ImguiLibName;
procedure igSetCursorPosY(y: single); cdecl; external ImguiLibName;
procedure igGetCursorStartPos(pOut: PImVec2); cdecl; external ImguiLibName;
procedure igGetCursorScreenPos(pOut: PImVec2); cdecl; external ImguiLibName;
procedure igSetCursorScreenPos(pos: ImVec2); cdecl; external ImguiLibName;
procedure igAlignFirstTextHeightToWidgets; cdecl; external ImguiLibName;
function  igGetTextLineHeight: single; cdecl; external ImguiLibName;
function  igGetTextLineHeightWithSpacing: single; cdecl; external ImguiLibName;
function  igGetItemsLineHeightWithSpacing: single; cdecl; external ImguiLibName;

{Columns }
procedure igColumns(Count: longint; id: PChar; border: bool); cdecl; external ImguiLibName;
procedure igNextColumn; cdecl; external ImguiLibName;
function  igGetColumnIndex: longint; cdecl; external ImguiLibName;
function  igGetColumnOffset(column_index: longint): single; cdecl; external ImguiLibName;
procedure igSetColumnOffset(column_index: longint; offset_x: single); cdecl; external ImguiLibName;
function  igGetColumnWidth(column_index: longint): single; cdecl; external ImguiLibName;
function  igGetColumnsCount: longint; cdecl; external ImguiLibName;

{ ID scopes }
{ If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them }
{ You can also use "##extra" within your widget name to distinguish them from each others (see 'Programmer Guide') }
procedure igPushIdStr(str_id: PChar); cdecl; external ImguiLibName;
procedure igPushIdStrRange(str_begin: PChar; str_end: PChar); cdecl; external ImguiLibName;
procedure igPushIdPtr(ptr_id: pointer); cdecl; external ImguiLibName;
procedure igPushIdInt(int_id: longint); cdecl; external ImguiLibName;
procedure igPopId; cdecl; external ImguiLibName;
function  igGetIdStr(str_id: PChar): ImGuiID; cdecl; external ImguiLibName;
function  igGetIdStrRange(str_begin: PChar; str_end: PChar): ImGuiID; cdecl; external ImguiLibName;
function  igGetIdPtr(ptr_id: pointer): ImGuiID; cdecl; external ImguiLibName;

{ Widgets }
procedure igText(fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igText(fmt: PChar); cdecl; external ImguiLibName;
//procedure igTextV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
procedure igTextColored(col: ImVec4; fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igTextColored(col: ImVec4; fmt: PChar); cdecl; external ImguiLibName;
//procedure igTextColoredV(col:ImVec4; fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
procedure igTextDisabled(fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igTextDisabled(fmt: PChar); cdecl; external ImguiLibName;
//procedure igTextDisabledV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
procedure igTextWrapped(fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igTextWrapped(fmt: PChar); cdecl; external ImguiLibName;
//procedure igTextWrappedV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
procedure igTextUnformatted(Text: PChar; text_end: PChar); cdecl; external ImguiLibName;
procedure igLabelText(_label: PChar; fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igLabelText(_label: PChar; fmt: PChar); cdecl; external ImguiLibName;
//procedure igLabelTextV(_label:Pchar; fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
procedure igBullet; cdecl; external ImguiLibName;
procedure igBulletText(fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igBulletText(fmt: PChar); cdecl; external ImguiLibName;
//procedure igBulletTextV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
function  igButton(_label: PChar; size: ImVec2): bool; cdecl; external ImguiLibName;
function  igSmallButton(_label: PChar): bool; cdecl; external ImguiLibName;
function  igInvisibleButton(str_id: PChar; size: ImVec2): bool; cdecl; external ImguiLibName;
procedure igImage(user_texture_id: ImTextureID; size: ImVec2; uv0: ImVec2; uv1: ImVec2; tint_col: ImVec4; border_col: ImVec4); cdecl; external ImguiLibName;
function  igImageButton(user_texture_id: ImTextureID; size: ImVec2; uv0: ImVec2; uv1: ImVec2; frame_padding: longint; bg_col: ImVec4;
  tint_col: ImVec4): bool; cdecl; external ImguiLibName;
function  igCheckbox(_label: PChar; v: Pbool): bool; cdecl; external ImguiLibName;
function  igCheckboxFlags(_label: PChar; flags: Pdword; flags_value: dword): bool; cdecl; external ImguiLibName;
function  igRadioButtonBool(_label: PChar; active: bool): bool; cdecl; external ImguiLibName;
function  igRadioButton(_label: PChar; v: Plongint; v_button: longint): bool; cdecl; external ImguiLibName;
function  igCombo(_label: PChar; current_item: Plongint; items: PPchar; items_count: longint; height_in_items: longint): bool; cdecl; external ImguiLibName;
function  igCombo2(_label: PChar; current_item: Plongint; items_separated_by_zeros: PChar; height_in_items: longint): bool; cdecl; external ImguiLibName;

//todo : func type param
//function  igCombo3(_label:Pchar; current_item:Plongint; items_getter:function (data:pointer; idx:longint; out_text:PPchar):bool; data:pointer; items_count:longint;
//  height_in_items:longint):bool;cdecl;external ImguiLibName;
function  igColorButton(col: ImVec4; small_height: bool; outline_border: bool): bool; cdecl; external ImguiLibName;

type
  TCol3 = array[0..2] of single;  //todo : does this work?
  TCol4 = array[0..3] of single;
function  igColorEdit3(_label: PChar; col: TCol3): bool; cdecl; external ImguiLibName;
function  igColorEdit4(_label: PChar; col: TCol4; show_alpha: bool): bool; cdecl; external ImguiLibName;

procedure igColorEditMode(mode: ImGuiColorEditMode); cdecl; external ImguiLibName;
procedure igPlotLines(_label: PChar; values: Psingle; values_count: longint; values_offset: longint; overlay_text: PChar; scale_min: single;
  scale_max: single; graph_size: ImVec2; stride: longint); cdecl; external ImguiLibName;

//TODO : func type
//procedure igPlotLines2(_label:Pchar; values_getter:function (data:pointer; idx:longint):single; data:pointer; values_count:longint; values_offset:longint;
//            overlay_text:Pchar; scale_min:single; scale_max:single; graph_size:ImVec2);cdecl;external ImguiLibName;
procedure igPlotHistogram(_label: PChar; values: Psingle; values_count: longint; values_offset: longint; overlay_text: PChar; scale_min: single;
  scale_max: single; graph_size: ImVec2; stride: longint); cdecl; external ImguiLibName;

//TODO : func type
//procedure igPlotHistogram2(_label:Pchar; values_getter:function (data:pointer; idx:longint):single; data:pointer; values_count:longint; values_offset:longint;
//            overlay_text:Pchar; scale_min:single; scale_max:single; graph_size:ImVec2);cdecl;external ImguiLibName;
procedure igProgressBar(fraction: single; size_arg: PImVec2; overlay: PChar); cdecl; external ImguiLibName;

{ Widgets: Sliders (tip: ctrl+click on a slider to input text) }
function  igSliderFloat(_label: PChar; v: Psingle; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igSliderFloat2(_label: PChar; v: TFloat2; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igSliderFloat3(_label: PChar; v: TFloat3; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igSliderFloat4(_label: PChar; v: TFloat4; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igSliderAngle(_label: PChar; v_rad: Psingle; v_degrees_min: single; v_degrees_max: single): bool; cdecl; external ImguiLibName;
function  igSliderInt(_label: PChar; v: Plongint; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igSliderInt2(_label: PChar; v: TLongInt2; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igSliderInt3(_label: PChar; v: TLongInt3; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igSliderInt4(_label: PChar; v: TLongInt4; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igVSliderFloat(_label: PChar; size: ImVec2; v: Psingle; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igVSliderInt(_label: PChar; size: ImVec2; v: Plongint; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;

{ Widgets: Drags (tip: ctrl+click on a drag box to input text) }
// For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, remember than a 'float v[3]' function argument is the same as 'float* v'. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
{ If v_max >= v_max we have no bound }
function  igDragFloat(_label: PChar; v: Psingle; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igDragFloat2(_label: PChar; v: TFloat2; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igDragFloat3(_label: PChar; v: TFloat3; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igDragFloat4(_label: PChar; v: TFloat4; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool; cdecl; external ImguiLibName;
function  igDragFloatRange2(_label: PChar; v_current_min: Psingle; v_current_max: Psingle; v_speed: single; v_min: single; v_max: single;
  display_format: PChar; display_format_max: PChar; power: single): bool; cdecl; external ImguiLibName;
{ If v_max >= v_max we have no bound }
function  igDragInt(_label: PChar; v: Plongint; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igDragInt2(_label: PChar; v: TLongInt2; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igDragInt3(_label: PChar; v: TLongInt3; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igDragInt4(_label: PChar; v: TLongInt4; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool; cdecl; external ImguiLibName;
function  igDragIntRange2(_label: PChar; v_current_min: Plongint; v_current_max: Plongint; v_speed: single; v_min: longint; v_max: longint;
  display_format: PChar; display_format_max: PChar): bool; cdecl; external ImguiLibName;

{ Widgets: Input }
function  igInputText(_label: PChar; buf: PChar; buf_size: size_t; flags: ImGuiInputTextFlags; callback: ImGuiTextEditCallback;
  user_data: pointer): bool; cdecl; external ImguiLibName;
function  igInputTextMultiline(_label: PChar; buf: PChar; buf_size: size_t; size: ImVec2; flags: ImGuiInputTextFlags; callback: ImGuiTextEditCallback;
  user_data: pointer): bool; cdecl; external ImguiLibName;
function  igInputFloat(_label: PChar; v: Psingle; step: single; step_fast: single; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;
  cdecl; external ImguiLibName;
function  igInputFloat2(_label: PChar; v: TFloat2; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool; cdecl; external ImguiLibName;
function  igInputFloat3(_label: PChar; v: TFloat3; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool; cdecl; external ImguiLibName;
function  igInputFloat4(_label: PChar; v: TFloat4; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool; cdecl; external ImguiLibName;
function  igInputInt(_label: PChar; v: Plongint; step: longint; step_fast: longint; extra_flags: ImGuiInputTextFlags): bool; cdecl; external ImguiLibName;
function  igInputInt2(_label: PChar; v: TLongInt2; extra_flags: ImGuiInputTextFlags): bool; cdecl; external ImguiLibName;
function  igInputInt3(_label: PChar; v: TLongInt3; extra_flags: ImGuiInputTextFlags): bool; cdecl; external ImguiLibName;
function  igInputInt4(_label: PChar; v: TLongInt4; extra_flags: ImGuiInputTextFlags): bool; cdecl; external ImguiLibName;

{ Widgets: Trees }
function  igTreeNode(_label: PChar): bool; cdecl; external ImguiLibName;
function  igTreeNodeStr(str_id: PChar; fmt: PChar; args: array of const): bool; cdecl; external ImguiLibName;
function  igTreeNodeStr(str_id: PChar; fmt: PChar): bool; cdecl; external ImguiLibName;
function  igTreeNodePtr(ptr_id: pointer; fmt: PChar; args: array of const): bool; cdecl; external ImguiLibName;
function  igTreeNodePtr(ptr_id: pointer; fmt: PChar): bool; cdecl; external ImguiLibName;
//todo : vargs
//    function  igTreeNodeStrV(str_id:Pchar; fmt:Pchar; args:va_list):bool;cdecl;external ImguiLibName;
//todo : vargs
//    function  igTreeNodePtrV(ptr_id:pointer; fmt:Pchar; args:va_list):bool;cdecl;external ImguiLibName;
function  igTreeNodeEx(_label: PChar; flags: ImGuiTreeNodeFlags): bool; cdecl; external ImguiLibName;
function  igTreeNodeExStr(str_id: PChar; flags: ImGuiTreeNodeFlags; fmt: PChar; args: array of const): bool; cdecl; external ImguiLibName;
function  igTreeNodeExStr(str_id: PChar; flags: ImGuiTreeNodeFlags; fmt: PChar): bool; cdecl; external ImguiLibName;
function  igTreeNodeExPtr(ptr_id: pointer; flags: ImGuiTreeNodeFlags; fmt: PChar; args: array of const): bool; cdecl; external ImguiLibName;
function  igTreeNodeExPtr(ptr_id: pointer; flags: ImGuiTreeNodeFlags; fmt: PChar): bool; cdecl; external ImguiLibName;
//todo : vargs
//    function  igTreeNodeExV(str_id:Pchar; flags:ImGuiTreeNodeFlags; fmt:Pchar; args:va_list):bool;cdecl;external ImguiLibName;
//todo : vargs
//    function  igTreeNodeExVPtr(ptr_id:pointer; flags:ImGuiTreeNodeFlags; fmt:Pchar; args:va_list):bool;cdecl;external ImguiLibName;
procedure igTreePushStr(str_id: PChar); cdecl; external ImguiLibName;
procedure igTreePushPtr(ptr_id: pointer); cdecl; external ImguiLibName;
procedure igTreePop; cdecl; external ImguiLibName;
procedure igTreeAdvanceToLabelPos; cdecl; external ImguiLibName;
function  igGetTreeNodeToLabelSpacing: single; cdecl; external ImguiLibName;
procedure igSetNextTreeNodeOpen(opened: bool; cond: ImGuiSetCond); cdecl; external ImguiLibName;
function  igCollapsingHeader(_label: PChar; flags: ImGuiTreeNodeFlags): bool; cdecl; external ImguiLibName;
function  igCollapsingHeaderEx(_label: PChar; p_open: Pbool; flags: ImGuiTreeNodeFlags): bool; cdecl; external ImguiLibName;

{ Widgets: Selectable / Lists }
function  igSelectable(_label: PChar; selected: bool; flags: ImGuiSelectableFlags; size: ImVec2): bool; cdecl; external ImguiLibName;
function  igSelectableEx(_label: PChar; p_selected: Pbool; flags: ImGuiSelectableFlags; size: ImVec2): bool; cdecl; external ImguiLibName;
function  igListBox(_label: PChar; current_item: Plongint; items: PPchar; items_count: longint; height_in_items: longint): bool; cdecl; external ImguiLibName;
//todo : func type
//    function  igListBox2(_label:Pchar; current_item:Plongint; items_getter:function (data:pointer; idx:longint; out_text:PPchar):bool; data:pointer; items_count:longint;
//               height_in_items:longint):bool;cdecl;external ImguiLibName;
function  igListBoxHeader(_label: PChar; size: ImVec2): bool; cdecl; external ImguiLibName;
function  igListBoxHeader2(_label: PChar; items_count: longint; height_in_items: longint): bool; cdecl; external ImguiLibName;
procedure igListBoxFooter; cdecl; external ImguiLibName;

{ Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!) }
procedure igValueBool(prefix: PChar; b: bool); cdecl; external ImguiLibName;
procedure igValueInt(prefix: PChar; v: longint); cdecl; external ImguiLibName;
procedure igValueUInt(prefix: PChar; v: dword); cdecl; external ImguiLibName;
procedure igValueFloat(prefix: PChar; v: single; float_format: PChar); cdecl; external ImguiLibName;
procedure igValueColor(prefix: PChar; v: ImVec4); cdecl; external ImguiLibName;
procedure igValueColor2(prefix: PChar; v: dword); cdecl; external ImguiLibName;

{ Tooltip }
procedure igSetTooltip(fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igSetTooltip(fmt: PChar); cdecl; external ImguiLibName;
//todo : vargs
//    procedure igSetTooltipV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
procedure igBeginTooltip; cdecl; external ImguiLibName;
procedure igEndTooltip; cdecl; external ImguiLibName;

{ Widgets: Menus }
function  igBeginMainMenuBar: bool; cdecl; external ImguiLibName;
procedure igEndMainMenuBar; cdecl; external ImguiLibName;
function  igBeginMenuBar: bool; cdecl; external ImguiLibName;
procedure igEndMenuBar; cdecl; external ImguiLibName;
function  igBeginMenu(_label: PChar; Enabled: bool): bool; cdecl; external ImguiLibName;
procedure igEndMenu; cdecl; external ImguiLibName;
function  igMenuItem(_label: PChar; shortcut: PChar; selected: bool; Enabled: bool): bool; cdecl; external ImguiLibName;
function  igMenuItemPtr(_label: PChar; shortcut: PChar; p_selected: Pbool; Enabled: bool): bool; cdecl; external ImguiLibName;

{ Popup }
procedure igOpenPopup(str_id: PChar); cdecl; external ImguiLibName;
function  igBeginPopup(str_id: PChar): bool; cdecl; external ImguiLibName;
function  igBeginPopupModal(Name: PChar; p_open: Pbool; extra_flags: ImGuiWindowFlags): bool; cdecl; external ImguiLibName;
function  igBeginPopupContextItem(str_id: PChar; mouse_button: longint): bool; cdecl; external ImguiLibName;
function  igBeginPopupContextWindow(also_over_items: bool; str_id: PChar; mouse_button: longint): bool; cdecl; external ImguiLibName;
function  igBeginPopupContextVoid(str_id: PChar; mouse_button: longint): bool; cdecl; external ImguiLibName;
procedure igEndPopup; cdecl; external ImguiLibName;
procedure igCloseCurrentPopup; cdecl; external ImguiLibName;

{ Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened. }
procedure igLogToTTY(max_depth: longint); cdecl; external ImguiLibName;
procedure igLogToFile(max_depth: longint; filename: PChar); cdecl; external ImguiLibName;
procedure igLogToClipboard(max_depth: longint); cdecl; external ImguiLibName;
procedure igLogFinish; cdecl; external ImguiLibName;
procedure igLogButtons; cdecl; external ImguiLibName;
procedure igLogText(fmt: PChar; args: array of const); cdecl; external ImguiLibName;
procedure igLogText(fmt: PChar); cdecl; external ImguiLibName;

{ Clipping }
procedure igPushClipRect(clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: bool); cdecl; external ImguiLibName;
procedure igPopClipRect; cdecl; external ImguiLibName;

{ Utilities }
function  igIsItemHovered: bool; cdecl; external ImguiLibName;
function  igIsItemHoveredRect: bool; cdecl; external ImguiLibName;
function  igIsItemActive: bool; cdecl; external ImguiLibName;
function  igIsItemClicked(mouse_button: longint): bool; cdecl; external ImguiLibName;
function  igIsItemVisible: bool; cdecl; external ImguiLibName;
function  igIsAnyItemHovered: bool; cdecl; external ImguiLibName;
function  igIsAnyItemActive: bool; cdecl; external ImguiLibName;
procedure igGetItemRectMin(pOut: PImVec2); cdecl; external ImguiLibName;
procedure igGetItemRectMax(pOut: PImVec2); cdecl; external ImguiLibName;
procedure igGetItemRectSize(pOut: PImVec2); cdecl; external ImguiLibName;
procedure igSetItemAllowOverlap; cdecl; external ImguiLibName;
function  igIsWindowHovered: bool; cdecl; external ImguiLibName;
function  igIsWindowFocused: bool; cdecl; external ImguiLibName;
function  igIsRootWindowFocused: bool; cdecl; external ImguiLibName;
function  igIsRootWindowOrAnyChildFocused: bool; cdecl; external ImguiLibName;
function  igIsRootWindowOrAnyChildHovered: bool; cdecl; external ImguiLibName;
function  igIsRectVisible(item_size: ImVec2): bool; cdecl; external ImguiLibName;
function  igIsPosHoveringAnyWindow(pos: ImVec2): bool; cdecl; external ImguiLibName;
function  igGetTime: single; cdecl; external ImguiLibName;
function  igGetFrameCount: longint; cdecl; external ImguiLibName;
function  igGetStyleColName(idx: ImGuiCol): PChar; cdecl; external ImguiLibName;
procedure igCalcItemRectClosestPoint(pOut: PImVec2; pos: ImVec2; on_edge: bool; outward: single); cdecl; external ImguiLibName;
procedure igCalcTextSize(pOut: PImVec2; Text: PChar; text_end: PChar; hide_text_after_double_hash: bool; wrap_width: single); cdecl; external ImguiLibName;
procedure igCalcListClipping(items_count: longint; items_height: single; out_items_display_start: Plongint; out_items_display_end: Plongint); cdecl; external ImguiLibName;

function  igBeginChildFrame(id: ImGuiID; size: ImVec2; extra_flags: ImGuiWindowFlags): bool; cdecl; external ImguiLibName;
procedure igEndChildFrame; cdecl; external ImguiLibName;

procedure igColorConvertU32ToFloat4(pOut: PImVec4; in_: ImU32); cdecl; external ImguiLibName;
function  igColorConvertFloat4ToU32(in_: ImVec4): ImU32; cdecl; external ImguiLibName;
procedure igColorConvertRGBtoHSV(r: single; g: single; b: single; out_h: Psingle; out_s: Psingle; out_v: Psingle); cdecl; external ImguiLibName;
procedure igColorConvertHSVtoRGB(h: single; s: single; v: single; out_r: Psingle; out_g: Psingle; out_b: Psingle); cdecl; external ImguiLibName;

function  igGetKeyIndex(key: ImGuiKey): longint; cdecl; external ImguiLibName;
function  igIsKeyDown(key_index: longint): bool; cdecl; external ImguiLibName;
function  igIsKeyPressed(key_index: longint; _repeat: bool): bool; cdecl; external ImguiLibName;
function  igIsKeyReleased(key_index: longint): bool; cdecl; external ImguiLibName;
function  igIsMouseDown(button: longint): bool; cdecl; external ImguiLibName;
function  igIsMouseClicked(button: longint; _repeat: bool): bool; cdecl; external ImguiLibName;
function  igIsMouseDoubleClicked(button: longint): bool; cdecl; external ImguiLibName;
function  igIsMouseReleased(button: longint): bool; cdecl; external ImguiLibName;
function  igIsMouseHoveringWindow: bool; cdecl; external ImguiLibName;
function  igIsMouseHoveringAnyWindow: bool; cdecl; external ImguiLibName;
function  igIsMouseHoveringRect(r_min: ImVec2; r_max: ImVec2; clip: bool): bool; cdecl; external ImguiLibName;
function  igIsMouseDragging(button: longint; lock_threshold: single): bool; cdecl; external ImguiLibName;
procedure igGetMousePos(pOut: PImVec2); cdecl; external ImguiLibName;
procedure igGetMousePosOnOpeningCurrentPopup(pOut: PImVec2); cdecl; external ImguiLibName;
procedure igGetMouseDragDelta(pOut: PImVec2; button: longint; lock_threshold: single); cdecl; external ImguiLibName;
procedure igResetMouseDragDelta(button: longint); cdecl; external ImguiLibName;
function  igGetMouseCursor: ImGuiMouseCursor; cdecl; external ImguiLibName;
procedure igSetMouseCursor(_type: ImGuiMouseCursor); cdecl; external ImguiLibName;
procedure igCaptureKeyboardFromApp(capture: bool); cdecl; external ImguiLibName;
procedure igCaptureMouseFromApp(capture: bool); cdecl; external ImguiLibName;

{ Helpers functions to access functions pointers in ImGui::GetIO() }
function  igMemAlloc(sz: size_t): pointer; cdecl; external ImguiLibName;
procedure igMemFree(ptr: pointer); cdecl; external ImguiLibName;
function  igGetClipboardText: PChar; cdecl; external ImguiLibName;
procedure igSetClipboardText(Text: PChar); cdecl; external ImguiLibName;

{ Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself }
function  igGetVersion(): PChar; cdecl; external ImguiLibName;

procedure ImFontConfig_DefaultConstructor(config: PImFontConfig); cdecl; external ImguiLibName;

procedure ImFontAtlas_GetTexDataAsRGBA32(atlas: PImFontAtlas; out_pixels: PPByte; out_width, out_height: PInteger; out_bytes_per_pixel: PInteger = nil); cdecl; external ImguiLibName;
procedure ImFontAtlas_GetTexDataAsAlpha8(atlas: PImFontAtlas; out_pixels: PPByte; out_width, out_height: PInteger; out_bytes_per_pixel: PInteger = nil); cdecl; external ImguiLibName;
procedure ImFontAtlas_SetTexID(atlas: PImFontAtlas; tex: Pointer); cdecl; external ImguiLibName;
function  ImFontAtlas_AddFontDefault(atlas: PImFontAtlas; config: PImFontConfig = nil): PImFont; cdecl; external ImguiLibName;
{todo
function  ImFontAtlas_AddFont(struct ImFontAtlas* atlas, CONST struct ImFontConfig* font_cfg): PImFont;
function  ImFontAtlas_AddFontFromFileTTF(struct ImFontAtlas* atlas, CONST char* filename, float size_pixels, CONST struct ImFontConfig* font_cfg, CONST ImWchar* glyph_ranges): PImFont;
function  ImFontAtlas_AddFontFromMemoryTTF(struct ImFontAtlas* atlas, void* ttf_data, int ttf_size, float size_pixels, CONST struct ImFontConfig* font_cfg, CONST ImWchar* glyph_ranges): PImFont;
function  ImFontAtlas_AddFontFromMemoryCompressedTTF(struct ImFontAtlas* atlas, CONST void* compressed_ttf_data, int compressed_ttf_size, float size_pixels, CONST struct ImFontConfig* font_cfg, CONST ImWchar* glyph_ranges): PImFont;
function  ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(struct ImFontAtlas* atlas, CONST char* compressed_ttf_data_base85, float size_pixels, CONST struct ImFontConfig* font_cfg, CONST ImWchar* glyph_ranges): PImFont;
}
procedure ImFontAtlas_ClearTexData(atlas: PImFontAtlas); cdecl; external ImguiLibName;
procedure ImFontAtlas_Clear(atlas: PImFontAtlas); cdecl; external ImguiLibName;

procedure ImGuiIO_AddInputCharacter(c: word); cdecl; external ImguiLibName;
procedure ImGuiIO_AddInputCharactersUTF8(utf8_chars: pchar); cdecl; external ImguiLibName;
procedure ImGuiIO_ClearInputCharacters(); cdecl; external ImguiLibName;

{ImDrawData }
procedure ImDrawData_DeIndexAllBuffers(drawData: PImDrawData); cdecl; external ImguiLibName;

{ImDrawList }
function ImDrawList_GetVertexBufferSize(list: PImDrawList): longint; cdecl; external ImguiLibName;
function ImDrawList_GetVertexPtr(list: PImDrawList; n: longint): PImDrawVert; external ImguiLibName;
function ImDrawList_GetIndexBufferSize(list: PImDrawList): longint; cdecl; external ImguiLibName;
function ImDrawList_GetIndexPtr(list: PImDrawList; n: longint): PImDrawIdx; cdecl; external ImguiLibName;
function ImDrawList_GetCmdSize(list: PImDrawList): longint; cdecl; external ImguiLibName;
function ImDrawList_GetCmdPtr(list: PImDrawList; n: longint): PImDrawCmd; external ImguiLibName;

procedure ImDrawList_Clear(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_ClearFreeMemory(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_PushClipRect(list: PImDrawList; clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: bool); cdecl; external ImguiLibName;
procedure ImDrawList_PushClipRectFullScreen(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_PopClipRect(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_PushTextureID(list: PImDrawList; texture_id: ImTextureID); cdecl; external ImguiLibName;
procedure ImDrawList_PopTextureID(list: PImDrawList); cdecl; external ImguiLibName;

{ Primitives }
procedure ImDrawList_AddLine(list: PImDrawList; a: ImVec2; b: ImVec2; col: ImU32; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_AddRect(list: PImDrawList; a: ImVec2; b: ImVec2; col: ImU32; rounding: single; rounding_corners: longint; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_AddRectFilled(list: PImDrawList; a: ImVec2; b: ImVec2; col: ImU32; rounding: single; rounding_corners: longint); cdecl; external ImguiLibName;
procedure ImDrawList_AddRectFilledMultiColor(list: PImDrawList; a: ImVec2; b: ImVec2; col_upr_left: ImU32; col_upr_right: ImU32;
  col_bot_right: ImU32; col_bot_left: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_AddQuad(list: PImDrawList; a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; col: ImU32; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_AddQuadFilled(list: PImDrawList; a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_AddTriangle(list: PImDrawList; a: ImVec2; b: ImVec2; c: ImVec2; col: ImU32; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_AddTriangleFilled(list: PImDrawList; a: ImVec2; b: ImVec2; c: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_AddCircle(list: PImDrawList; centre: ImVec2; radius: single; col: ImU32; num_segments: longint; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_AddCircleFilled(list: PImDrawList; centre: ImVec2; radius: single; col: ImU32; num_segments: longint); cdecl; external ImguiLibName;
procedure ImDrawList_AddText(list: PImDrawList; pos: ImVec2; col: ImU32; text_begin: PChar; text_end: PChar); cdecl; external ImguiLibName;
procedure ImDrawList_AddTextExt(list: PImDrawList; font: PImFont; font_size: single; pos: ImVec2; col: ImU32; text_begin: PChar;
  text_end: PChar; wrap_width: single; cpu_fine_clip_rect: PImVec4); cdecl; external ImguiLibName;
procedure ImDrawList_AddImage(list: PImDrawList; user_texture_id: ImTextureID; a: ImVec2; b: ImVec2; uv0: ImVec2; uv1: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_AddPolyline(list: PImDrawList; points: PImVec2; num_points: longint; col: ImU32; closed: bool; thickness: single;
  anti_aliased: bool); cdecl; external ImguiLibName;
procedure ImDrawList_AddConvexPolyFilled(list: PImDrawList; points: PImVec2; num_points: longint; col: ImU32; anti_aliased: bool); cdecl; external ImguiLibName;
procedure ImDrawList_AddBezierCurve(list: PImDrawList; pos0: ImVec2; cp0: ImVec2; cp1: ImVec2; pos1: ImVec2; col: ImU32; thickness: single;
  num_segments: longint); cdecl; external ImguiLibName;

{ Stateful path API, add points then finish with PathFill() or PathStroke() }
procedure ImDrawList_PathClear(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_PathLineTo(list: PImDrawList; pos: ImVec2); cdecl; external ImguiLibName;
procedure ImDrawList_PathLineToMergeDuplicate(list: PImDrawList; pos: ImVec2); cdecl; external ImguiLibName;
procedure ImDrawList_PathFill(list: PImDrawList; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_PathStroke(list: PImDrawList; col: ImU32; closed: bool; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_PathArcTo(list: PImDrawList; centre: ImVec2; radius: single; a_min: single; a_max: single; num_segments: longint); cdecl; external ImguiLibName;
{ Use precomputed angles for a 12 steps circle }
procedure ImDrawList_PathArcToFast(list: PImDrawList; centre: ImVec2; radius: single; a_min_of_12: longint; a_max_of_12: longint); cdecl; external ImguiLibName;
procedure ImDrawList_PathBezierCurveTo(list: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; num_segments: longint); cdecl; external ImguiLibName;
procedure ImDrawList_PathRect(list: PImDrawList; rect_min: ImVec2; rect_max: ImVec2; rounding: single; rounding_corners: longint); cdecl; external ImguiLibName;

{ Channels }
procedure ImDrawList_ChannelsSplit(list: PImDrawList; channels_count: longint); cdecl; external ImguiLibName;
procedure ImDrawList_ChannelsMerge(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_ChannelsSetCurrent(list: PImDrawList; channel_index: longint); cdecl; external ImguiLibName;

{ Advanced }
{ Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles. }
procedure ImDrawList_AddCallback(list: PImDrawList; callback: ImDrawCallback; callback_data: pointer); cdecl; external ImguiLibName;
{ This is useful if you need to forcefully create a new draw call (to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible }
procedure ImDrawList_AddDrawCmd(list: PImDrawList); cdecl; external ImguiLibName;

{ Internal helpers }
procedure ImDrawList_PrimReserve(list: PImDrawList; idx_count: longint; vtx_count: longint); cdecl; external ImguiLibName;
procedure ImDrawList_PrimRect(list: PImDrawList; a: ImVec2; b: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_PrimRectUV(list: PImDrawList; a: ImVec2; b: ImVec2; uv_a: ImVec2; uv_b: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_PrimQuadUV(list: PImDrawList; a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; uv_a: ImVec2; uv_b: ImVec2; uv_c: ImVec2;
  uv_d: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_PrimWriteVtx(list: PImDrawList; pos: ImVec2; uv: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_PrimWriteIdx(list: PImDrawList; idx: ImDrawIdx); cdecl; external ImguiLibName;
procedure ImDrawList_PrimVtx(list: PImDrawList; pos: ImVec2; uv: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_UpdateClipRect(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_UpdateTextureID(list: PImDrawList); cdecl; external ImguiLibName;


//binding helpers
function ImVec2Init(const x, y: single): Imvec2; inline;

implementation

function ImVec2Init(const x, y: single): Imvec2;
begin
  result.x := x;
  result.y := y;
end;

end.
