{
Bindings for dear imgui (AKA ImGui) - a bloat-free graphical user interface library for C++
Based on ImGui 1.51 + cimgui wrapper
Not all functions were tested.
}
unit fpimgui;
{$mode objfpc}{$H+}
{$modeswitch advancedrecords}

interface

uses
{$PACKRECORDS C}
dynlibs,   //for SharedSuffix
sysutils;  //for Format()

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

  PImGuiContext = Pointer;

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
  PImWchar = PWord;
  ImTextureID = pointer;
  ImGuiID = ImU32;
  ImGuiCol = longint;
  ImGuiStyleVar = longint;
  ImGuiColorEditFlags = longint;
  ImGuiKey = longint;
  ImGuiInputTextFlags = longint;
  ImGuiSelectableFlags = longint;

  { Enums }

  ImGuiWindowFlags = longint;
  ImGuiWindowFlagsEnum = (
      ImGuiWindowFlags_Default = 0,                        // Default: 0
      ImGuiWindowFlags_NoTitleBar             = 1 shl 0,   // Disable title-bar
      ImGuiWindowFlags_NoResize               = 1 shl 1,   // Disable user resizing with the lower-right grip
      ImGuiWindowFlags_NoMove                 = 1 shl 2,   // Disable user moving the window
      ImGuiWindowFlags_NoScrollbar            = 1 shl 3,   // Disable scrollbars (window can still scroll with mouse or programatically)
      ImGuiWindowFlags_NoScrollWithMouse      = 1 shl 4,   // Disable user vertically scrolling with mouse wheel
      ImGuiWindowFlags_NoCollapse             = 1 shl 5,   // Disable user collapsing window by double-clicking on it
      ImGuiWindowFlags_AlwaysAutoResize       = 1 shl 6,   // Resize every window to its content every frame
      ImGuiWindowFlags_ShowBorders            = 1 shl 7,   // Show borders around windows and items
      ImGuiWindowFlags_NoSavedSettings        = 1 shl 8,   // Never load/save settings in .ini file
      ImGuiWindowFlags_NoInputs               = 1 shl 9,   // Disable catching mouse or keyboard inputs
      ImGuiWindowFlags_MenuBar                = 1 shl 10,  // Has a menu-bar
      ImGuiWindowFlags_HorizontalScrollbar    = 1 shl 11,  // Allow horizontal scrollbar to appear (off by default). You may use SetNextWindowContentSize(ImVec2(width,0.0f)); prior to calling Begin() to specify width. Read code in imgui_demo in the "Horizontal Scrolling" section.
      ImGuiWindowFlags_NoFocusOnAppearing     = 1 shl 12,  // Disable taking focus when transitioning from hidden to visible state
      ImGuiWindowFlags_NoBringToFrontOnFocus  = 1 shl 13,  // Disable bringing window to front when taking focus (e.g. clicking on it or programatically giving it focus)
      ImGuiWindowFlags_AlwaysVerticalScrollbar= 1 shl 14,  // Always show vertical scrollbar (even if ContentSize.y < Size.y)
      ImGuiWindowFlags_AlwaysHorizontalScrollbar=1shl 15,  // Always show horizontal scrollbar (even if ContentSize.x < Size.x)
      ImGuiWindowFlags_AlwaysUseWindowPadding = 1 shl 16   // Ensure child windows without border uses style.WindowPadding (ignored by default for non-bordered child windows, because more convenient)
  );

  // Flags for ImGui::TreeNodeEx(), ImGui::CollapsingHeader*()
  ImGuiTreeNodeFlags = longint;
  ImGuiTreeNodeFlagsEnum = (
      ImGuiTreeNodeFlags_Selected = 1 shl 0,
      ImGuiTreeNodeFlags_Framed = 1 shl 1,
      ImGuiTreeNodeFlags_AllowOverlapMode = 1 shl 2,
      ImGuiTreeNodeFlags_NoTreePushOnOpen = 1 shl 3,
      ImGuiTreeNodeFlags_NoAutoOpenOnLog = 1 shl 4,
      ImGuiTreeNodeFlags_CollapsingHeader = (1 shl 1) or (1 shl 4), //Framed or NoAutoOpenOnLog
      ImGuiTreeNodeFlags_DefaultOpen = 1 shl 5,
      ImGuiTreeNodeFlags_OpenOnDoubleClick = 1 shl 6,
      ImGuiTreeNodeFlags_OpenOnArrow = 1 shl 7,
      ImGuiTreeNodeFlags_Leaf = 1 shl 8,
      ImGuiTreeNodeFlags_Bullet = 1 shl 9
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
      ImGuiCol_Separator,
      ImGuiCol_SeparatorHovered,
      ImGuiCol_SeparatorActive,
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


  // Enumeration for PushStyleVar() / PopStyleVar()
  // NB: the enum only refers to fields of ImGuiStyle() which makes sense to be pushed/poped in UI code. Feel free to add others.
  ImGuiStyleVar_ = (
      ImGuiStyleVar_Alpha,               // float
      ImGuiStyleVar_WindowPadding,       // ImVec2
      ImGuiStyleVar_WindowRounding,      // float
      ImGuiStyleVar_WindowMinSize,       // ImVec2
      ImGuiStyleVar_ChildWindowRounding, // float
      ImGuiStyleVar_FramePadding,        // ImVec2
      ImGuiStyleVar_FrameRounding,       // float
      ImGuiStyleVar_ItemSpacing,         // ImVec2
      ImGuiStyleVar_ItemInnerSpacing,    // ImVec2
      ImGuiStyleVar_IndentSpacing,       // float
      ImGuiStyleVar_GrabMinSize,         // float
      ImGuiStyleVar_ButtonTextAlign      // flags ImGuiAlign_*
      //ImGuiStyleVar_Count_ - unnecessary
  );


  ImGuiColorEditFlags_ = (
      ImGuiColorEditFlags_NoAlpha         = 1 shl 1,
      ImGuiColorEditFlags_NoPicker        = 1 shl 2,
      ImGuiColorEditFlags_NoOptions       = 1 shl 3,
      ImGuiColorEditFlags_NoSmallPreview  = 1 shl 4,
      ImGuiColorEditFlags_NoInputs        = 1 shl 5,
      ImGuiColorEditFlags_NoTooltip       = 1 shl 6,
      ImGuiColorEditFlags_NoLabel         = 1 shl 7,
      ImGuiColorEditFlags_NoSidePreview   = 1 shl 8,
      // User Options (right-click on widget to change some of them). You can set application defaults using SetColorEditOptions().
      // The idea is that you probably don't want to override them in most of your calls, let the user choose and/or call SetColorEditOptions() during startup.
      ImGuiColorEditFlags_AlphaBar        = 1 shl 9,
      ImGuiColorEditFlags_AlphaPreview    = 1 shl 10,
      ImGuiColorEditFlags_AlphaPreviewHalf= 1 shl 11,
      ImGuiColorEditFlags_HDR             = 1 shl 12,
      ImGuiColorEditFlags_RGB             = 1 shl 13,
      ImGuiColorEditFlags_HSV             = 1 shl 14,
      ImGuiColorEditFlags_HEX             = 1 shl 15,
      ImGuiColorEditFlags_Uint8           = 1 shl 16,
      ImGuiColorEditFlags_Float           = 1 shl 17,
      ImGuiColorEditFlags_PickerHueBar    = 1 shl 18,
      ImGuiColorEditFlags_PickerHueWheel  = 1 shl 19
      // Internals/Masks
      {
      ImGuiColorEditFlags__InputsMask     = ImGuiColorEditFlags_RGB|ImGuiColorEditFlags_HSV|ImGuiColorEditFlags_HEX,
      ImGuiColorEditFlags__DataTypeMask   = ImGuiColorEditFlags_Uint8|ImGuiColorEditFlags_Float,
      ImGuiColorEditFlags__PickerMask     = ImGuiColorEditFlags_PickerHueWheel|ImGuiColorEditFlags_PickerHueBar,
      ImGuiColorEditFlags__OptionsDefault = ImGuiColorEditFlags_Uint8|ImGuiColorEditFlags_RGB|ImGuiColorEditFlags_PickerHueBar    // Change application default using SetColorEditOptions()
      }
  );

  // Enumeration for GetMouseCursor()
  ImGuiMouseCursor = longint;
  ImGuiMouseCursorEnum = (
      ImGuiMouseCursor_None = -1,
      ImGuiMouseCursor_Arrow = 0,
      ImGuiMouseCursor_TextInput,
      ImGuiMouseCursor_Move,
      ImGuiMouseCursor_ResizeNS,
      ImGuiMouseCursor_ResizeEW,
      ImGuiMouseCursor_ResizeNESW,
      ImGuiMouseCursor_ResizeNWSE
      //ImGuiMouseCursor_Count_ - unnecessary
  );

  // Condition flags for ImGui::SetWindow***(), SetNextWindow***(), SetNextTreeNode***() functions
  // All those functions treat 0 as a shortcut to ImGuiCond_Always
  ImGuiCond = longint;
  ImGuiCondEnum = (
      ImGuiCond_Always       = 1 shl 0, // Set the variable
      ImGuiCond_Once         = 1 shl 1, // Set the variable once per runtime session (only the first call with succeed)
      ImGuiCond_FirstUseEver = 1 shl 2, // Set the variable if the window has no saved data (if doesn't exist in the .ini file)
      ImGuiCond_Appearing    = 1 shl 3  // Set the variable if the window is appearing after being hidden/inactive (or the first time)
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

  //forward decls for ImGuiIO
  PImDrawData = ^ImDrawData;
  PImFont = ^ImFont;
  PImFontAtlas = ^ImFontAtlas;
  PImFontConfig = ^ImFontConfig;
  PImGuiSizeConstraintCallbackData = ^ImGuiSizeConstraintCallbackData;
  PImGuiStorage = ^ImGuiStorage;
  PImGuiTextEditCallbackData = ^ImGuiTextEditCallbackData;
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

      // Advanced/subtle behaviors
      OSXBehaviors : bool;

      // User Functions
      RenderDrawListsFn : procedure (data:PImDrawData);cdecl;

      GetClipboardTextFn : function (user_data:pointer):Pchar;cdecl;
      SetClipboardTextFn : procedure (user_data:pointer; text:Pchar);cdecl;
      ClipboardUserData : pointer;

      MemAllocFn : function (sz:size_t):pointer;cdecl;
      MemFreeFn : procedure (ptr:pointer);cdecl;

      ImeSetInputScreenPosFn : procedure (x:longint; y:longint);cdecl;
      ImeWindowHandle : pointer;

      // Input - Fill before calling NewFrame()
      MousePos : ImVec2;
      MouseDown : array[0..4] of bool;
      MouseWheel : single;
      MouseDrawCursor : bool;
      KeyCtrl : bool;
      KeyShift : bool;
      KeyAlt : bool;
      KeySuper : bool;
      KeysDown : array[0..511] of bool;
      InputCharacters : array[0..16] of ImWchar;

      // Output - Retrieve after calling NewFrame()
      WantCaptureMouse : bool;
      WantCaptureKeyboard : bool;
      WantTextInput : bool;
      Framerate : single;
      MetricsAllocs : longint;
      MetricsRenderVertices : longint;
      MetricsRenderIndices : longint;
      MetricsActiveWindows : longint;

      MouseDelta : ImVec2;

      // [Private] ImGui will maintain those fields. Forward compatibility not guaranteed!
      // this part is not included, so be careful when doing sizeof(ImGuiIO) for example
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

  //definitions for private members aren't translated, so always pass around pointers to this struct and don't copy it
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
      //not translated
  end;
  ImGuiSizeConstraintCallbackData = record
      //not translated
  end;
  ImGuiStorage = record
      //not translated
  end;
  ImFont = record
      //not translated
  end;
  ImFontConfig = record
      //not translated
  end;
  ImFontAtlas = record
      TexID: ImTextureID;
      TexPixelsAlpha8: pbyte;
      TexPixelsRGBA32: pInt32;
      TexWidth: integer;
      TexHeight: integer;
      TexDesiredWidth: Integer;
      TexGlyphPadding: Integer;
  end;

  ImGuiTextEditCallback = function(Data: PImGuiTextEditCallbackData): longint; cdecl;
  ImGuiSizeConstraintCallback = procedure(Data: PImGuiSizeConstraintCallbackData); cdecl;

//binding helpers
type
  TCol3 = array[0..2] of single;  //todo : does this work?
  TCol4 = array[0..3] of single;

function ImVec2Init(const x, y: single): Imvec2; inline;
function ImVec4Init(const x, y, z, w: single): ImVec4; inline;
function ImIDPtr(const i: integer): pointer; inline;
function ImColor(const color: ImVec4): ImU32; inline;

{ Static ImGui class, wraps external cimgui dll calls
Used for:
- having original's C++ styled API
- adding default parameters
- using native strings
Notes:
- formatting in functions with variable parameter list is done by pascal's Format() function from sysutils
- trivial methods should be inlined to prevent calling overhead. Functions with variable parameter list cannot be inlined as of FPC 3.0
}
type
ImGui = class
public
  class function  GetIO(): PImGuiIO;  inline;
  class function  GetStyle(): PImGuiStyle;  inline;
  class function  GetDrawData(): PImDrawData;  inline;
  class procedure NewFrame;  inline;
  class procedure Render;  inline;
  class procedure Shutdown;  inline;
  class procedure ShowUserGuide;  inline;
  class procedure ShowStyleEditor(ref: PImGuiStyle);  inline;
  class procedure ShowTestWindow(p_open: Pbool = nil);  inline;
  class procedure ShowMetricsWindow(p_open: Pbool = nil);  inline;

  { Window }
  class function  Begin_(name: string; p_open: Pbool = nil; flags: ImGuiWindowFlags = 0): Boolean;  inline;
  class procedure End_;  inline;
  class function  BeginChild(str_id: string; size: ImVec2; border: bool; extra_flags: ImGuiWindowFlags): bool;  inline;
  class function  BeginChildEx(id: ImGuiID; size: ImVec2; border: bool; extra_flags: ImGuiWindowFlags): bool;  inline;
  class procedure EndChild;  inline;
  class procedure GetContentRegionMax(out_: PImVec2);  inline;
  class procedure GetContentRegionAvail(out_: PImVec2);  inline;
  class function  GetContentRegionAvailWidth: single;  inline;
  class procedure GetWindowContentRegionMin(out_: PImVec2);  inline;
  class procedure GetWindowContentRegionMax(out_: PImVec2);  inline;
  class function  GetWindowContentRegionWidth: single;  inline;
  class function  GetWindowDrawList(): PImDrawList;  inline;
  class procedure GetWindowPos(out_: PImVec2);  inline;
  class procedure GetWindowSize(out_: PImVec2);  inline;
  class function  GetWindowWidth: single;  inline;
  class function  GetWindowHeight: single;  inline;
  class function  IsWindowCollapsed: bool;  inline;
  class procedure SetWindowFontScale(scale: single);  inline;
  class procedure SetNextWindowPos(pos: ImVec2; cond: ImGuiCond = 0);  inline;
  class procedure SetNextWindowPosCenter(cond: ImGuiCond = 0);  inline;
  class procedure SetNextWindowSize(size: ImVec2; cond: ImGuiCond = 0);  inline;
  class procedure SetNextWindowSizeConstraints(size_min: ImVec2; size_max: ImVec2; custom_callback: ImGuiSizeConstraintCallback; custom_callback_data: pointer);  inline;
  class procedure SetNextWindowContentSize(size: ImVec2);  inline;
  class procedure SetNextWindowContentWidth(Width: single);  inline;
  class procedure SetNextWindowCollapsed(collapsed: bool; cond: ImGuiCond = 0);  inline;
  class procedure SetNextWindowFocus;  inline;
  class procedure SetWindowPos(pos: ImVec2; cond: ImGuiCond = 0);  inline;
  class procedure SetWindowSize(size: ImVec2; cond: ImGuiCond = 0);  inline;
  class procedure SetWindowCollapsed(collapsed: bool; cond: ImGuiCond = 0);  inline;
  class procedure SetWindowFocus;  inline;
  class procedure SetWindowPosByName(Name: PChar; pos: ImVec2; cond: ImGuiCond = 0);  inline;
  class procedure SetWindowSize2(Name: PChar; size: ImVec2; cond: ImGuiCond = 0);  inline;
  class procedure SetWindowCollapsed2(Name: PChar; collapsed: bool; cond: ImGuiCond = 0);  inline;
  class procedure SetWindowFocus2(Name: PChar);  inline;
  class function  GetScrollX: single;  inline;
  class function  GetScrollY: single;  inline;
  class function  GetScrollMaxX: single;  inline;
  class function  GetScrollMaxY: single;  inline;
  class procedure SetScrollX(scroll_x: single);  inline;
  class procedure SetScrollY(scroll_y: single);  inline;
  class procedure SetScrollHere(center_y_ratio: single);  inline;
  class procedure SetScrollFromPosY(pos_y: single; center_y_ratio: single);  inline;
  class procedure SetKeyboardFocusHere(offset: longint);  inline;
  class procedure SetStateStorage(tree: PImGuiStorage);  inline;
  class function  GetStateStorage(): PImGuiStorage;  inline;


  { Parameters stacks (shared) }
  class procedure PushFont(font: PImFont);  inline;
  class procedure PopFont;  inline;
  class procedure PushStyleColor(idx: ImGuiCol; col: ImVec4);  inline;
  class procedure PopStyleColor(count: longint);  inline;
  class procedure PushStyleVar(idx: ImGuiStyleVar; val: single);  inline;
  class procedure PushStyleVarVec(idx: ImGuiStyleVar; val: ImVec2);  inline;
  class procedure PopStyleVar(count: longint = 1);  inline;
  class function  GetFont(): PImFont;  inline;
  class function  GetFontSize: single;  inline;
  class function  GetFontTexUvWhitePixel(): ImVec2;
  class function  GetColorU32(idx: ImGuiCol; alpha_mul: single): ImU32;  inline;
  class function  GetColorU32Vec(col: PImVec4): ImU32;  inline;

  { Parameters stacks (current window) }
  class procedure PushItemWidth(item_width: single);  inline;
  class procedure PopItemWidth;  inline;
  class function  CalcItemWidth: single;  inline;
  class procedure PushTextWrapPos(wrap_pos_x: single);  inline;
  class procedure PopTextWrapPos;  inline;
  class procedure PushAllowKeyboardFocus(v: bool);  inline;
  class procedure PopAllowKeyboardFocus;  inline;
  class procedure PushButtonRepeat(_repeat: bool);  inline;
  class procedure PopButtonRepeat;  inline;

  { Layout }
  class procedure Separator;  inline;
  class procedure SameLine(pos_x: single = 0; spacing_w: single = -1);  inline;
  class procedure NewLine;  inline;
  class procedure Spacing;  inline;
  class procedure Dummy(size: PImVec2);  inline;
  class procedure Indent(indent_w: single);  inline;
  class procedure Unindent(indent_w: single);  inline;
  class procedure BeginGroup;  inline;
  class procedure EndGroup;  inline;
  class function  GetCursorPos(): ImVec2;  inline;
  class function  GetCursorPosX: single;  inline;
  class function  GetCursorPosY: single;  inline;
  class procedure SetCursorPos(local_pos: ImVec2);  inline;
  class procedure SetCursorPosX(x: single);  inline;
  class procedure SetCursorPosY(y: single);  inline;
  class function  GetCursorStartPos(): ImVec2;  inline;
  class function  GetCursorScreenPos(): ImVec2;  inline;
  class procedure SetCursorScreenPos(pos: ImVec2);  inline;
  class procedure AlignFirstTextHeightToWidgets;  inline;
  class function  GetTextLineHeight: single;  inline;
  class function  GetTextLineHeightWithSpacing: single;  inline;
  class function  GetItemsLineHeightWithSpacing: single;  inline;

  { Columns }
  class procedure Columns(Count: longint; id: PChar; border: bool);  inline;
  class procedure NextColumn;  inline;
  class function  GetColumnIndex: longint;  inline;
  class function  GetColumnOffset(column_index: longint): single;  inline;
  class procedure SetColumnOffset(column_index: longint; offset_x: single);  inline;
  class function  GetColumnWidth(column_index: longint): single;  inline;
  class procedure SetColumnWidth(column_index: longint; width: single);  inline;
  class function  GetColumnsCount: longint;  inline;

  { ID scopes }
  { If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them }
  { You can also use "##extra" within your widget name to distinguish them from each others (see 'Programmer Guide') }
  class procedure PushIdStr(str_id: PChar);  inline;
  class procedure PushIdStrRange(str_begin: PChar; str_end: PChar);  inline;
  class procedure PushIdPtr(ptr_id: pointer);  inline;
  class procedure PushIdInt(int_id: longint);  inline;
  class procedure PopId;  inline;
  class function  GetIdStr(str_id: PChar): ImGuiID;  inline;
  class function  GetIdStrRange(str_begin: PChar; str_end: PChar): ImGuiID;  inline;
  class function  GetIdPtr(ptr_id: pointer): ImGuiID;  inline;

  { Widgets }
  class procedure Text(const text_: string);
  class procedure Text(const Fmt: string; const Args: array of Const);
  //procedure igTextV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
  class procedure TextColored(col: ImVec4; fmt: PChar; args: array of const); { inline; }
  class procedure TextColored(col: ImVec4; const fmt: string); inline;
  //procedure igTextColoredV(col:ImVec4; fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
  class procedure TextDisabled(const fmt: string; args: array of const); {inline;}
  class procedure TextDisabled(const fmt: string); inline;
  //procedure igTextDisabledV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
  class procedure TextWrapped(const fmt: string; args: array of const); {inline;}
  class procedure TextWrapped(const fmt: string); inline;
  //procedure igTextWrappedV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
  class procedure TextUnformatted(const _text: string);
  class procedure TextUnformatted(const _text: PChar; const text_end: PChar = nil);
  class procedure LabelText(_label: string; fmt: string);
  class procedure LabelText(_label: string; fmt: PChar; args: array of const);
  //procedure igLabelTextV(_label:Pchar; fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
  class procedure Bullet;  inline;
  class procedure BulletText(const fmt: string; args: array of const); {inline;}
  class procedure BulletText(const fmt: string);  inline;
  //procedure igBulletTextV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
  class function  Button(_label: string; size: ImVec2): bool;
  class function  Button(_label: string): bool; //overload for default size (0,0)
  class function  SmallButton(_label: PChar): bool;  inline;
  class function  InvisibleButton(str_id: PChar; size: ImVec2): bool;  inline;
  class procedure Image(user_texture_id: ImTextureID; size: ImVec2; uv0: ImVec2; uv1: ImVec2; tint_col: ImVec4; border_col: ImVec4);  inline;
  class function  ImageButton(user_texture_id: ImTextureID; size: ImVec2; uv0: ImVec2; uv1: ImVec2; frame_padding: longint; bg_col: ImVec4; tint_col: ImVec4): bool;  inline;
  class function  Checkbox(_label: PChar; v: Pbool): bool;  inline;
  class function  CheckboxFlags(_label: PChar; flags: Pdword; flags_value: dword): bool;  inline;
  class function  RadioButtonBool(_label: PChar; active: bool): bool;  inline;
  class function  RadioButton(_label: PChar; v: Plongint; v_button: longint): bool;  inline;
  class function  Combo(_label: PChar; current_item: Plongint; items: PPchar; items_count: longint; height_in_items: longint): bool;  inline;
  class function  Combo2(_label: PChar; current_item: Plongint; items_separated_by_zeros: PChar; height_in_items: longint): bool;  inline;

  //todo : func type param
  //function  igCombo3(_label:Pchar; current_item:Plongint; items_getter:function (data:pointer; idx:longint; out_text:PPchar):bool; data:pointer; items_count:longint;
  //  height_in_items:longint):bool;cdecl;external ImguiLibName;
  class function  ColorButton(desc_id: PChar; col: ImVec4; flags: ImGuiColorEditFlags; size: ImVec2): bool;  inline;
  class function  ColorEdit3(_label: PChar; col: TCol3; flags: ImGuiColorEditFlags = 0): bool;  inline;
  class function  ColorEdit4(_label: PChar; col: TCol4; flags: ImGuiColorEditFlags = 0): bool;  inline;
  class function  ColorPicker3(_label: PChar; col: TCol3; flags: ImGuiColorEditFlags = 0): bool;  inline;
  class function  ColorPicker4(_label: PChar; col: TCol4; flags: ImGuiColorEditFlags = 0): bool;  inline;
  class procedure SetColorEditOptions(flags: ImGuiColorEditFlags);  inline;

  class procedure PlotLines(_label: PChar; values: Psingle; values_count: longint; values_offset: longint; overlay_text: PChar; scale_min: single; scale_max: single; graph_size: ImVec2; stride: longint);  inline;

  //TODO : func type
  //procedure igPlotLines2(_label:Pchar; values_getter:function (data:pointer; idx:longint):single; data:pointer; values_count:longint; values_offset:longint;
  //            overlay_text:Pchar; scale_min:single; scale_max:single; graph_size:ImVec2);cdecl;external ImguiLibName;
  class procedure PlotHistogram(_label: PChar; values: Psingle; values_count: longint; values_offset: longint; overlay_text: PChar; scale_min: single;   scale_max: single; graph_size: ImVec2; stride: longint);  inline;

  //TODO : func type
  //procedure igPlotHistogram2(_label:Pchar; values_getter:function (data:pointer; idx:longint):single; data:pointer; values_count:longint; values_offset:longint;
  //            overlay_text:Pchar; scale_min:single; scale_max:single; graph_size:ImVec2);cdecl;external ImguiLibName;
  class procedure ProgressBar(fraction: single; size_arg: PImVec2; overlay: PChar);  inline;

  { Widgets: Sliders (tip: ctrl+click on a slider to input text) }
  class function  SliderFloat (_label: PChar; v: Psingle; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  SliderFloat2(_label: PChar; v: TFloat2; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  SliderFloat3(_label: PChar; v: TFloat3; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  SliderFloat4(_label: PChar; v: TFloat4; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  SliderAngle(_label: PChar; v_rad: Psingle; v_degrees_min: single = -360; v_degrees_max: single = 360): bool;  inline;
  class function  SliderInt (_label: PChar; v: Plongint; v_min: longint; v_max: longint;  display_format: PChar = '%.0f'): bool;  inline;
  class function  SliderInt2(_label: PChar; v: TLongInt2; v_min: longint; v_max: longint; display_format: PChar = '%.0f'): bool;  inline;
  class function  SliderInt3(_label: PChar; v: TLongInt3; v_min: longint; v_max: longint; display_format: PChar = '%.0f'): bool;  inline;
  class function  SliderInt4(_label: PChar; v: TLongInt4; v_min: longint; v_max: longint; display_format: PChar = '%.0f'): bool;  inline;
  class function  VSliderFloat(_label: PChar; size: ImVec2; v: Psingle; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  VSliderInt(_label: PChar; size: ImVec2; v: Plongint; v_min: longint; v_max: longint; display_format: PChar = '%.0f'): bool;  inline;

  { Widgets: Drags (tip: ctrl+click on a drag box to input text) }
  // For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, remember than a 'float v[3]' function argument is the same as 'float* v'. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
  { If v_min >= v_max we have no bound }
  class function  DragFloat (_label: PChar; v: Psingle; v_speed: single; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  DragFloat2(_label: PChar; v: TFloat2; v_speed: single; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  DragFloat3(_label: PChar; v: TFloat3; v_speed: single; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  DragFloat4(_label: PChar; v: TFloat4; v_speed: single; v_min: single; v_max: single; display_format: PChar = '%.3f'; power: single = 1): bool;  inline;
  class function  DragFloatRange2(_label: PChar; v_current_min: Psingle; v_current_max: Psingle; v_speed: single = 1;
                                  v_min: single = 0; v_max: single = 0; display_format: PChar = '%.3f'; display_format_max: PChar = nil; power: single = 1): bool;  inline;

  { If v_min >= v_max we have no bound }
  class function  DragInt (_label: PChar; v: Plongint;  v_speed: single = 1; v_min: longint = 0; v_max: longint = 0; display_format: PChar = '%.0f'): bool;  inline;
  class function  DragInt2(_label: PChar; v: TLongInt2; v_speed: single = 1; v_min: longint = 0; v_max: longint = 0; display_format: PChar = '%.0f'): bool;  inline;
  class function  DragInt3(_label: PChar; v: TLongInt3; v_speed: single = 1; v_min: longint = 0; v_max: longint = 0; display_format: PChar = '%.0f'): bool;  inline;
  class function  DragInt4(_label: PChar; v: TLongInt4; v_speed: single = 1; v_min: longint = 0; v_max: longint = 0; display_format: PChar = '%.0f'): bool;  inline;
  class function  DragIntRange2(_label: PChar; v_current_min: Plongint; v_current_max: Plongint; v_speed: single = 1;
                                v_min: longint = 0; v_max: longint = 0; display_format: PChar = '%.0f'; display_format_max: PChar = nil): bool;  inline;

  { Widgets: Input with Keyboard }
  class function  InputText(_label: PChar; buf: PChar; buf_size: size_t; flags: ImGuiInputTextFlags; callback: ImGuiTextEditCallback;   user_data: pointer): bool;  inline;
  class function  InputTextMultiline(_label: PChar; buf: PChar; buf_size: size_t; size: ImVec2; flags: ImGuiInputTextFlags; callback: ImGuiTextEditCallback;   user_data: pointer): bool;  inline;
  class function  InputFloat(_label: PChar; v: Psingle; step: single; step_fast: single; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;    inline;
  class function  InputFloat2(_label: PChar; v: TFloat2; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;  inline;
  class function  InputFloat3(_label: PChar; v: TFloat3; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;  inline;
  class function  InputFloat4(_label: PChar; v: TFloat4; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;  inline;
  class function  InputInt(_label: PChar; v: Plongint; step: longint; step_fast: longint; extra_flags: ImGuiInputTextFlags): bool;  inline;
  class function  InputInt2(_label: PChar; v: TLongInt2; extra_flags: ImGuiInputTextFlags): bool;  inline;
  class function  InputInt3(_label: PChar; v: TLongInt3; extra_flags: ImGuiInputTextFlags): bool;  inline;
  class function  InputInt4(_label: PChar; v: TLongInt4; extra_flags: ImGuiInputTextFlags): bool;  inline;

  { Widgets: Trees }
  class function  TreeNode(_label: string): bool;   inline;
  class function  TreeNode(str_id: string; fmt: string; args: array of const): bool; {inline;}
  class function  TreeNode(str_id: string; fmt: string): bool;  inline;
  class function  TreeNode(ptr_id: pointer; fmt: string; args: array of const): bool; {inline;}
  class function  TreeNode(ptr_id: pointer; fmt: string): bool;  inline;

  class function  TreeNodeEx(_label: PChar; flags: ImGuiTreeNodeFlags): bool;  inline;
  class function  TreeNodeEx(str_id: PChar; flags: ImGuiTreeNodeFlags; fmt: string; args: array of const): bool; {inline;}
  class function  TreeNodeEx(str_id: PChar; flags: ImGuiTreeNodeFlags; fmt: string): bool;  inline;
  class function  TreeNodeEx(ptr_id: pointer; flags: ImGuiTreeNodeFlags; fmt: string; args: array of const): bool; {inline;}
  class function  TreeNodeEx(ptr_id: pointer; flags: ImGuiTreeNodeFlags; fmt: string): bool;  inline;
  //todo : vargs
  //    function  igTreeNodeExV(str_id:Pchar; flags:ImGuiTreeNodeFlags; fmt:Pchar; args:va_list):bool;cdecl;external ImguiLibName;
  //todo : vargs
  //    function  igTreeNodeExVPtr(ptr_id:pointer; flags:ImGuiTreeNodeFlags; fmt:Pchar; args:va_list):bool;cdecl;external ImguiLibName;
  class procedure TreePushStr(str_id: PChar);  inline;
  class procedure TreePushPtr(ptr_id: pointer);  inline;
  class procedure TreePop;  inline;
  class procedure TreeAdvanceToLabelPos;  inline;
  class function  GetTreeNodeToLabelSpacing: single;  inline;
  class procedure SetNextTreeNodeOpen(opened: bool; cond: ImGuiCond = 0);  inline;
  class function  CollapsingHeader(_label: PChar; flags: ImGuiTreeNodeFlags = 0): bool;  inline;
  class function  CollapsingHeader(_label: PChar; p_open: Pbool; flags: ImGuiTreeNodeFlags = 0): bool;  inline;

  { Widgets: Selectable / Lists }
  class function  Selectable(_label: string; selected: bool; flags: ImGuiSelectableFlags; size: ImVec2): bool;
  class function  Selectable(_label: string; selected: bool; flags: ImGuiSelectableFlags = 0): bool; //overload for default size (0,0)
  class function  SelectableEx(_label: PChar; p_selected: Pbool; flags: ImGuiSelectableFlags; size: ImVec2): bool;  inline;
  class function  ListBox(_label: PChar; current_item: Plongint; items: PPchar; items_count: longint; height_in_items: longint): bool;  inline;
  //todo : func type
  //    function  igListBox2(_label:Pchar; current_item:Plongint; items_getter:function (data:pointer; idx:longint; out_text:PPchar):bool; data:pointer; items_count:longint;
  //               height_in_items:longint):bool;cdecl;external ImguiLibName;
  class function  ListBoxHeader(_label: PChar; size: ImVec2): bool;  inline;
  class function  ListBoxHeader2(_label: PChar; items_count: longint; height_in_items: longint): bool;  inline;
  class procedure ListBoxFooter;  inline;

  { Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!) }
  class procedure ValueBool(prefix: PChar; b: bool);  inline;
  class procedure ValueInt(prefix: PChar; v: longint);  inline;
  class procedure ValueUInt(prefix: PChar; v: dword);  inline;
  class procedure ValueFloat(prefix: PChar; v: single; float_format: PChar);  inline;

  { Tooltip }
  class procedure SetTooltip(fmt: string; args: array of const); {inline}
  class procedure SetTooltip(fmt: string); inline;
  //todo : vargs
  //    procedure igSetTooltipV(fmt:Pchar; args:va_list);cdecl;external ImguiLibName;
  class procedure BeginTooltip;  inline;
  class procedure EndTooltip;  inline;

  { Widgets: Menus }
  class function  BeginMainMenuBar: bool;  inline;
  class procedure EndMainMenuBar;  inline;
  class function  BeginMenuBar: bool;  inline;
  class procedure EndMenuBar;  inline;
  class function  BeginMenu(_label: PChar; Enabled: bool = true): bool;  inline;
  class procedure EndMenu;  inline;
  class function  MenuItem(_label: PChar; shortcut: PChar; selected: bool; Enabled: bool = true): bool;  inline;
  class function  MenuItem(_label: PChar; shortcut: PChar; p_selected: Pbool; Enabled: bool = true): bool;  inline;

  { Popup }
  class procedure OpenPopup(str_id: PChar);  inline;
  class function  BeginPopup(str_id: PChar): bool;  inline;
  class function  BeginPopupModal(Name: PChar; p_open: Pbool; extra_flags: ImGuiWindowFlags): bool;  inline;
  class function  BeginPopupContextItem(str_id: PChar; mouse_button: longint): bool;  inline;
  class function  BeginPopupContextWindow(str_id: PChar = nil; mouse_button: longint = 1; also_over_items: bool = true): bool;  inline;
  class function  BeginPopupContextVoid(str_id: PChar; mouse_button: longint): bool;  inline;
  class procedure EndPopup;  inline;
  class function  IsPopupOpen(str_id: PChar): bool;  inline;
  class procedure CloseCurrentPopup;  inline;

  { Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened. }
  class procedure LogToTTY(max_depth: longint);  inline;
  class procedure LogToFile(max_depth: longint; filename: PChar);  inline;
  class procedure LogToClipboard(max_depth: longint);  inline;
  class procedure LogFinish;  inline;
  class procedure LogButtons;  inline;
  class procedure LogText(const fmt: string; args: array of const);
  class procedure LogText(const fmt: string);

  { Clipping }
  class procedure PushClipRect(clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: bool);  inline;
  class procedure PopClipRect;  inline;

  { Utilities }
  class function  IsItemHovered: bool;  inline;
  class function  IsItemRectHovered: bool;  inline;
  class function  IsItemActive: bool;  inline;
  class function  IsItemClicked(mouse_button: longint = 0): bool;  inline;
  class function  IsItemVisible: bool;  inline;
  class function  IsAnyItemHovered: bool;  inline;
  class function  IsAnyItemActive: bool;  inline;
  class procedure GetItemRectMin(pOut: PImVec2);  inline;
  class procedure GetItemRectMax(pOut: PImVec2);  inline;
  class procedure GetItemRectSize(pOut: PImVec2);  inline;
  class procedure SetItemAllowOverlap;  inline;
  class function  IsWindowHovered: bool;  inline;
  class function  IsWindowFocused: bool;  inline;
  class function  IsRootWindowFocused: bool;  inline;
  class function  IsRootWindowOrAnyChildFocused: bool;  inline;
  class function  IsRootWindowOrAnyChildHovered: bool;  inline;
  class function  IsRectVisible(const item_size: ImVec2): bool;  inline;
  class function  IsRectVisible(const rect_min, rect_max: PImVec2): bool;  inline;

  class function  GetTime: single;  inline;
  class function  GetFrameCount: longint;  inline;
  class function  GetStyleColorName(idx: ImGuiCol): PChar;  inline;
  class function  CalcItemRectClosestPoint(pos: ImVec2; on_edge: bool; outward: single): ImVec2; inline;
  class function  CalcTextSize(_text: PChar; text_end: PChar = nil; hide_text_after_double_hash: bool = false; wrap_width: single = -1): ImVec2; inline;
  class procedure CalcListClipping(items_count: longint; items_height: single; out_items_display_start: Plongint; out_items_display_end: Plongint);  inline;

  class function  BeginChildFrame(id: ImGuiID; size: ImVec2; extra_flags: ImGuiWindowFlags): bool;  inline;
  class procedure EndChildFrame;  inline;

  class procedure ColorConvertU32ToFloat4(pOut: PImVec4; in_: ImU32);  inline;
  class function  ColorConvertFloat4ToU32(in_: ImVec4): ImU32;  inline;
  class procedure ColorConvertRGBtoHSV(r: single; g: single; b: single; out_h: Psingle; out_s: Psingle; out_v: Psingle);  inline;
  class procedure ColorConvertHSVtoRGB(h: single; s: single; v: single; out_r: Psingle; out_g: Psingle; out_b: Psingle);  inline;

  class function  GetKeyIndex(key: ImGuiKey): longint;  inline;
  class function  IsKeyDown(user_key_index: longint): bool; inline;
  class function  IsKeyPressed(user_key_index: longint; _repeat: bool = true): bool; inline;
  class function  IsKeyReleased(user_key_index: longint): bool; inline;
  class function  IsMouseDown(_button: longint): bool;  inline;
  class function  IsMouseClicked(_button: longint; _repeat: bool = false): bool;  inline;
  class function  IsMouseDoubleClicked(_button: longint): bool;  inline;
  class function  IsMouseReleased(_button: longint): bool;  inline;
  class function  IsWindowRectHovered: bool;  inline;
  class function  IsAnyWindowHovered: bool;  inline;
  class function  IsMouseHoveringRect(r_min: ImVec2; r_max: ImVec2; clip: bool = true): bool; inline;
  class function  IsMouseDragging(_button: longint = 0; lock_threshold: single = -1): bool; inline;
  class function  GetMousePos: ImVec2; inline;
  class function  GetMousePosOnOpeningCurrentPopup: ImVec2; inline;
  class function  GetMouseDragDelta(_button: longint = 0; lock_threshold: single = -1): ImVec2; inline;
  class procedure ResetMouseDragDelta(_button: longint = 0); inline;
  class function  GetMouseCursor: ImGuiMouseCursor;  inline;
  class procedure SetMouseCursor(_type: ImGuiMouseCursor);  inline;
  class procedure CaptureKeyboardFromApp(capture: bool = true);  inline;
  class procedure CaptureMouseFromApp(capture: bool = true);  inline;

  { Helpers functions to access functions pointers in ImGui::GetIO() }
  class function  MemAlloc(sz: size_t): pointer;  inline;
  class procedure MemFree(ptr: pointer);  inline;
  class function  GetClipboardText: PChar;  inline;
  class procedure SetClipboardText(_text: PChar);  inline;

  { Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself }
  class function  GetVersion(): PChar;  inline;
end;



{ Record helper for ImDrawList, wraps external cimgui dll calls
Used for:
- having original's C++ styled API - struct with functions
- adding default parameters
Notes:
- it could be a type helper for PImDrawList instead of record helper, but Lazarus' code completion seems to work better this way (at the moment)
}
TImDrawListHelper = record helper for ImDrawList
  procedure PushClipRect(clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: bool);  inline;
  procedure PushClipRectFullScreen();  inline;
  procedure PopClipRect();  inline;
  procedure PushTextureID(texture_id: ImTextureID);  inline;
  procedure PopTextureID();  inline;

  { Primitives }
  procedure AddLine(a: ImVec2; b: ImVec2; col: ImU32; thickness: single);  inline;
  procedure AddRect(a: ImVec2; b: ImVec2; col: ImU32; rounding: single = 0; rounding_corners_flags: longint = not 0; thickness: single = 1);  inline;
  procedure AddRectFilled(a: ImVec2; b: ImVec2; col: ImU32; rounding: single = 0; rounding_corners_flags: longint = not 0);  inline;
  procedure AddRectFilledMultiColor(a: ImVec2; b: ImVec2; col_upr_left: ImU32; col_upr_right: ImU32;  col_bot_right: ImU32; col_bot_left: ImU32);  inline;
  procedure AddQuad(a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; col: ImU32; thickness: single);  inline;
  procedure AddQuadFilled(a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; col: ImU32);  inline;
  procedure AddTriangle(a: ImVec2; b: ImVec2; c: ImVec2; col: ImU32; thickness: single);  inline;
  procedure AddTriangleFilled(a: ImVec2; b: ImVec2; c: ImVec2; col: ImU32);  inline;
  procedure AddCircle(centre: ImVec2; radius: single; col: ImU32; num_segments: longint; thickness: single);  inline;
  procedure AddCircleFilled(centre: ImVec2; radius: single; col: ImU32; num_segments: longint);  inline;
  procedure AddText(pos: ImVec2; col: ImU32; text_begin: PChar; text_end: PChar);  inline;
  procedure AddTextExt(font: PImFont; font_size: single; pos: ImVec2; col: ImU32; text_begin: PChar;  text_end: PChar; wrap_width: single; cpu_fine_clip_rect: PImVec4);  inline;
  procedure AddImage(user_texture_id: ImTextureID; a: ImVec2; b: ImVec2; uva: ImVec2; uvb: ImVec2; col: ImU32);  inline;
  procedure AddImageQuad(user_texture_id: ImTextureID; const a, b, c, d: ImVec2; const uva, uvb, uvc, uvd: ImVec2; col: ImU32);  inline;
  procedure AddPolyline(points: PImVec2; num_points: longint; col: ImU32; closed: bool; thickness: single;  anti_aliased: bool);  inline;
  procedure AddConvexPolyFilled(points: PImVec2; num_points: longint; col: ImU32; anti_aliased: bool);  inline;
  procedure AddBezierCurve(pos0: ImVec2; cp0: ImVec2; cp1: ImVec2; pos1: ImVec2; col: ImU32; thickness: single;  num_segments: longint);  inline;

  { Stateful path API, add points then finish with PathFill() or PathStroke() }
  procedure PathClear();  inline;
  procedure PathLineTo(pos: ImVec2);  inline;
  procedure PathLineToMergeDuplicate(pos: ImVec2);  inline;
  procedure PathFillConvex(col: ImU32);  inline;
  procedure PathStroke(col: ImU32; closed: bool; thickness: single);  inline;
  procedure PathArcTo(centre: ImVec2; radius: single; a_min: single; a_max: single; num_segments: longint);  inline;
  { Use precomputed angles for a 12 steps circle }
  procedure PathArcToFast(centre: ImVec2; radius: single; a_min_of_12: longint; a_max_of_12: longint);  inline;
  procedure PathBezierCurveTo(p1: ImVec2; p2: ImVec2; p3: ImVec2; num_segments: longint);  inline;
  procedure PathRect(rect_min: ImVec2; rect_max: ImVec2; rounding: single; rounding_corners_flags: longint);  inline;

  { Channels }
  procedure ChannelsSplit(channels_count: longint);  inline;
  procedure ChannelsMerge();  inline;
  procedure ChannelsSetCurrent(channel_index: longint);  inline;

  { Advanced }
  { Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles. }
  procedure AddCallback(callback: ImDrawCallback; callback_data: pointer);  inline;
  { This is useful if you need to forcefully create a new draw call (to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible }
  procedure AddDrawCmd();  inline;

  { Internal helpers }
  { NB: all primitives needs to be reserved via PrimReserve() beforehand! }
  procedure PrimReserve(idx_count: longint; vtx_count: longint);  inline;
  procedure PrimRect(a: ImVec2; b: ImVec2; col: ImU32);  inline;
  procedure PrimRectUV(a: ImVec2; b: ImVec2; uv_a: ImVec2; uv_b: ImVec2; col: ImU32);  inline;
  procedure PrimQuadUV(a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; uv_a: ImVec2; uv_b: ImVec2; uv_c: ImVec2;  uv_d: ImVec2; col: ImU32);  inline;
  procedure PrimWriteVtx(pos: ImVec2; uv: ImVec2; col: ImU32);  inline;
  procedure PrimWriteIdx(idx: ImDrawIdx);  inline;
  procedure PrimVtx(pos: ImVec2; uv: ImVec2; col: ImU32);  inline;
  procedure UpdateClipRect();  inline;
  procedure UpdateTextureID; inline;
end;


{ Cimgui function declaration list.
  Functions marked as OBSOLETE shouldn't be here.
}
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

procedure igSetNextWindowPos(pos: ImVec2; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetNextWindowPosCenter(cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetNextWindowSize(size: ImVec2; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetNextWindowSizeConstraints(size_min: ImVec2; size_max: ImVec2; custom_callback: ImGuiSizeConstraintCallback; custom_callback_data: pointer); cdecl; external ImguiLibName;
procedure igSetNextWindowContentSize(size: ImVec2); cdecl; external ImguiLibName;
procedure igSetNextWindowContentWidth(Width: single); cdecl; external ImguiLibName;
procedure igSetNextWindowCollapsed(collapsed: bool; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetNextWindowFocus; cdecl; external ImguiLibName;
procedure igSetWindowPos(pos: ImVec2; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetWindowSize(size: ImVec2; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetWindowCollapsed(collapsed: bool; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetWindowFocus; cdecl; external ImguiLibName;
procedure igSetWindowPosByName(Name: PChar; pos: ImVec2; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetWindowSize2(Name: PChar; size: ImVec2; cond: ImGuiCond); cdecl; external ImguiLibName;
procedure igSetWindowCollapsed2(Name: PChar; collapsed: bool; cond: ImGuiCond); cdecl; external ImguiLibName;
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

{ Columns }
procedure igColumns(Count: longint; id: PChar; border: bool); cdecl; external ImguiLibName;
procedure igNextColumn; cdecl; external ImguiLibName;
function  igGetColumnIndex: longint; cdecl; external ImguiLibName;
function  igGetColumnOffset(column_index: longint): single; cdecl; external ImguiLibName;
procedure igSetColumnOffset(column_index: longint; offset_x: single); cdecl; external ImguiLibName;
function  igGetColumnWidth(column_index: longint): single; cdecl; external ImguiLibName;
procedure igSetColumnWidth(column_index: longint; width: single); cdecl; external ImguiLibName;
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
procedure igTextUnformatted(text: PChar; text_end: PChar); cdecl; external ImguiLibName;
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
function  igColorButton(desc_id: PChar; col: ImVec4; flags: ImGuiColorEditFlags; size: ImVec2): bool; cdecl; external ImguiLibName;
function  igColorEdit3(_label: PChar; col: TCol3; flags: ImGuiColorEditFlags = 0): bool; cdecl; external ImguiLibName;
function  igColorEdit4(_label: PChar; col: TCol4; flags: ImGuiColorEditFlags = 0): bool; cdecl; external ImguiLibName;
function  igColorPicker3(_label: PChar; col: TCol3; flags: ImGuiColorEditFlags = 0): bool; cdecl; external ImguiLibName;
function  igColorPicker4(_label: PChar; col: TCol4; flags: ImGuiColorEditFlags = 0): bool; cdecl; external ImguiLibName;
procedure igSetColorEditOptions(flags: ImGuiColorEditFlags); cdecl; external ImguiLibName;

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
procedure igSetNextTreeNodeOpen(opened: bool; cond: ImGuiCond); cdecl; external ImguiLibName;
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
function  igIsPopupOpen(str_id: PChar): bool; cdecl; external ImguiLibName;
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
function  igIsItemRectHovered: bool; cdecl; external ImguiLibName;
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
function  igIsRectVisible(const item_size: ImVec2): bool; cdecl; external ImguiLibName;
function  igIsRectVisible2(const rect_min, rect_max: PImVec2): bool; cdecl; external ImguiLibName;

function  igGetTime: single; cdecl; external ImguiLibName;
function  igGetFrameCount: longint; cdecl; external ImguiLibName;
function  igGetStyleColorName(idx: ImGuiCol): PChar; cdecl; external ImguiLibName;
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
function  igIsKeyDown(user_key_index: longint): bool; cdecl; external ImguiLibName;
function  igIsKeyPressed(user_key_index: longint; _repeat: bool): bool; cdecl; external ImguiLibName;
function  igIsKeyReleased(user_key_index: longint): bool; cdecl; external ImguiLibName;
function  igIsMouseDown(button: longint): bool; cdecl; external ImguiLibName;
function  igIsMouseClicked(button: longint; _repeat: bool): bool; cdecl; external ImguiLibName;
function  igIsMouseDoubleClicked(button: longint): bool; cdecl; external ImguiLibName;
function  igIsMouseReleased(button: longint): bool; cdecl; external ImguiLibName;
function  igIsWindowRectHovered: bool; cdecl; external ImguiLibName;
function  igIsAnyWindowHovered: bool; cdecl; external ImguiLibName;
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
function  igGetCurrentContext(): PImGuiContext; cdecl; external ImguiLibName;
procedure igSetCurrentContext(ctx: PImGuiContext); cdecl; external ImguiLibName;

procedure ImFontConfig_DefaultConstructor(config: PImFontConfig); cdecl; external ImguiLibName;

procedure ImFontAtlas_GetTexDataAsRGBA32(atlas: PImFontAtlas; out_pixels: PPByte; out_width, out_height: PInteger; out_bytes_per_pixel: PInteger = nil); cdecl; external ImguiLibName;
procedure ImFontAtlas_GetTexDataAsAlpha8(atlas: PImFontAtlas; out_pixels: PPByte; out_width, out_height: PInteger; out_bytes_per_pixel: PInteger = nil); cdecl; external ImguiLibName;
procedure ImFontAtlas_SetTexID(atlas: PImFontAtlas; id: ImTextureID); cdecl; external ImguiLibName;

function  ImFontAtlas_AddFontDefault(atlas: PImFontAtlas; config: PImFontConfig = nil): PImFont; cdecl; external ImguiLibName;
function  ImFontAtlas_AddFont(atlas: PImFontAtlas; const font_cfg: PImFontConfig): PImFont; cdecl; external ImguiLibName;
function  ImFontAtlas_AddFontFromFileTTF(atlas: PImFontAtlas; const filename: PChar; size_pixels: single; const font_cfg: PImFontConfig; const glyph_ranges: PImWchar): PImFont; cdecl; external ImguiLibName;
{todo
function  ImFontAtlas_AddFontFromMemoryTTF(struct ImFontAtlas* atlas, void* ttf_data, int ttf_size, float size_pixels, CONST struct ImFontConfig* font_cfg, CONST ImWchar* glyph_ranges): PImFont;
function  ImFontAtlas_AddFontFromMemoryCompressedTTF(struct ImFontAtlas* atlas, CONST void* compressed_ttf_data, int compressed_ttf_size, float size_pixels, CONST struct ImFontConfig* font_cfg, CONST ImWchar* glyph_ranges): PImFont;
function  ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(struct ImFontAtlas* atlas, CONST char* compressed_ttf_data_base85, float size_pixels, CONST struct ImFontConfig* font_cfg, CONST ImWchar* glyph_ranges): PImFont;
}

procedure ImFontAtlas_ClearTexData(atlas: PImFontAtlas); cdecl; external ImguiLibName;
procedure ImFontAtlas_Clear(atlas: PImFontAtlas); cdecl; external ImguiLibName;

function ImFontAtlas_GetGlyphRangesDefault(atlas: PImFontAtlas): PImWchar; cdecl; external ImguiLibName;
function ImFontAtlas_GetGlyphRangesKorean(atlas: PImFontAtlas): PImWchar; cdecl; external ImguiLibName;
function ImFontAtlas_GetGlyphRangesJapanese(atlas: PImFontAtlas): PImWchar; cdecl; external ImguiLibName;
function ImFontAtlas_GetGlyphRangesChinese(atlas: PImFontAtlas): PImWchar; cdecl; external ImguiLibName;
function ImFontAtlas_GetGlyphRangesCyrillic(atlas: PImFontAtlas): PImWchar; cdecl; external ImguiLibName;
function ImFontAtlas_GetGlyphRangesThai(atlas: PImFontAtlas): PImWchar; cdecl; external ImguiLibName;

procedure ImGuiIO_AddInputCharacter(c: word); cdecl; external ImguiLibName;
procedure ImGuiIO_AddInputCharactersUTF8(utf8_chars: pchar); cdecl; external ImguiLibName;
procedure ImGuiIO_ClearInputCharacters(); cdecl; external ImguiLibName;

{ImDrawData }
procedure ImDrawData_DeIndexAllBuffers(drawData: PImDrawData); cdecl; external ImguiLibName;
procedure ImDrawData_ScaleClipRects(drawData: PImDrawData; sc: ImVec2); cdecl; external ImguiLibName;

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
procedure ImDrawList_AddRect(list: PImDrawList; a: ImVec2; b: ImVec2; col: ImU32; rounding: single; rounding_corners_flags: longint; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_AddRectFilled(list: PImDrawList; a: ImVec2; b: ImVec2; col: ImU32; rounding: single; rounding_corners_flags: longint); cdecl; external ImguiLibName;
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
procedure ImDrawList_AddImage(list: PImDrawList; user_texture_id: ImTextureID; a: ImVec2; b: ImVec2; uva: ImVec2; uvb: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_AddImageQuad(list: PImDrawList; user_texture_id: ImTextureID; const a, b, c, d: ImVec2; const uva, uvb, uvc, uvd: ImVec2; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_AddPolyline(list: PImDrawList; points: PImVec2; num_points: longint; col: ImU32; closed: bool; thickness: single;
  anti_aliased: bool); cdecl; external ImguiLibName;
procedure ImDrawList_AddConvexPolyFilled(list: PImDrawList; points: PImVec2; num_points: longint; col: ImU32; anti_aliased: bool); cdecl; external ImguiLibName;
procedure ImDrawList_AddBezierCurve(list: PImDrawList; pos0: ImVec2; cp0: ImVec2; cp1: ImVec2; pos1: ImVec2; col: ImU32; thickness: single;
  num_segments: longint); cdecl; external ImguiLibName;

{ Stateful path API, add points then finish with PathFill() or PathStroke() }
procedure ImDrawList_PathClear(list: PImDrawList); cdecl; external ImguiLibName;
procedure ImDrawList_PathLineTo(list: PImDrawList; pos: ImVec2); cdecl; external ImguiLibName;
procedure ImDrawList_PathLineToMergeDuplicate(list: PImDrawList; pos: ImVec2); cdecl; external ImguiLibName;
procedure ImDrawList_PathFillConvex(list: PImDrawList; col: ImU32); cdecl; external ImguiLibName;
procedure ImDrawList_PathStroke(list: PImDrawList; col: ImU32; closed: bool; thickness: single); cdecl; external ImguiLibName;
procedure ImDrawList_PathArcTo(list: PImDrawList; centre: ImVec2; radius: single; a_min: single; a_max: single; num_segments: longint); cdecl; external ImguiLibName;
{ Use precomputed angles for a 12 steps circle }
procedure ImDrawList_PathArcToFast(list: PImDrawList; centre: ImVec2; radius: single; a_min_of_12: longint; a_max_of_12: longint); cdecl; external ImguiLibName;
procedure ImDrawList_PathBezierCurveTo(list: PImDrawList; p1: ImVec2; p2: ImVec2; p3: ImVec2; num_segments: longint); cdecl; external ImguiLibName;
procedure ImDrawList_PathRect(list: PImDrawList; rect_min: ImVec2; rect_max: ImVec2; rounding: single; rounding_corners_flags: longint); cdecl; external ImguiLibName;

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


implementation

function ImVec2Init(const x, y: single): Imvec2;
begin
  result.x := x;
  result.y := y;
end;

function ImVec4Init(const x, y, z, w: single): ImVec4;
begin
  result.x := x;
  result.y := y;
  result.z := z;
  result.w := w;
end;

//Replacement for (void*)(intptr_t) int cast, used for IDs. Generates warnings
function ImIDPtr(const i: integer): pointer;
begin
  result := pointer( IntPtr(i) )
end;

function ImColor(const color: ImVec4): ImU32;
begin
  result := ImGui.ColorConvertFloat4ToU32(color);
end;


{ ImGui
  Keep functions short, they're mostly just wrappers. Inlining begin/end with trivial function body is ok
}

class function ImGui.GetIO: PImGuiIO; begin result := igGetIO end;
class function ImGui.GetStyle: PImGuiStyle; begin result := igGetStyle end;
class function ImGui.GetDrawData: PImDrawData; begin result := igGetDrawData end;
class procedure ImGui.NewFrame; begin igNewFrame end;
class procedure ImGui.Render; begin igRender end;
class procedure ImGui.Shutdown; begin igShutdown end;
class procedure ImGui.ShowUserGuide; begin igShowUserGuide end;
class procedure ImGui.ShowStyleEditor(ref: PImGuiStyle); begin igShowStyleEditor(ref) end;
class procedure ImGui.ShowTestWindow(p_open: Pbool); begin igShowTestWindow(p_open) end;
class procedure ImGui.ShowMetricsWindow(p_open: Pbool); begin igShowMetricsWindow(p_open) end;

class function ImGui.Begin_(name: string; p_open: Pbool; flags: ImGuiWindowFlags): Boolean;
    begin result := igBegin(pchar(name), p_open, flags); end;
class procedure ImGui.End_;
    begin igEnd end;
class function ImGui.BeginChild(str_id: string; size: ImVec2; border: bool; extra_flags: ImGuiWindowFlags): bool;
    begin result := BeginChild(PChar(str_id), size, border, extra_flags); end;
class function ImGui.BeginChildEx(id: ImGuiID; size: ImVec2; border: bool; extra_flags: ImGuiWindowFlags): bool;
    begin result := igBeginChildEx(id, size, border, extra_flags) end;
class procedure ImGui.EndChild;
    begin igEndChild end;
class procedure ImGui.GetContentRegionMax(out_: PImVec2);
    begin igGetContentRegionMax(out_) end;
class procedure ImGui.GetContentRegionAvail(out_: PImVec2);
    begin igGetContentRegionAvail(out_) end;
class function ImGui.GetContentRegionAvailWidth: single;
    begin result := igGetContentRegionAvailWidth end;
class procedure ImGui.GetWindowContentRegionMin(out_: PImVec2);
    begin igGetWindowContentRegionMin(out_) end;
class procedure ImGui.GetWindowContentRegionMax(out_: PImVec2);
    begin igGetWindowContentRegionMax(out_) end;
class function ImGui.GetWindowContentRegionWidth: single;
    begin result := igGetWindowContentRegionWidth end;
class function ImGui.GetWindowDrawList(): PImDrawList;
    begin result := igGetWindowDrawList end;
class procedure ImGui.GetWindowPos(out_: PImVec2);
    begin igGetWindowPos(out_) end;
class procedure ImGui.GetWindowSize(out_: PImVec2);
    begin igGetWindowSize(out_) end;
class function ImGui.GetWindowWidth: single;
    begin result := igGetWindowWidth end;
class function ImGui.GetWindowHeight: single;
    begin result := igGetWindowHeight end;
class function ImGui.IsWindowCollapsed: bool;
    begin result := igIsWindowCollapsed end;
class procedure ImGui.SetWindowFontScale(scale: single);
    begin igSetWindowFontScale(scale) end;
class procedure ImGui.SetNextWindowPos(pos: ImVec2; cond: ImGuiCond = 0);
    begin igSetNextWindowPos(pos, cond) end;
class procedure ImGui.SetNextWindowPosCenter(cond: ImGuiCond = 0);
    begin igSetNextWindowPosCenter(cond) end;
class procedure ImGui.SetNextWindowSize(size: ImVec2; cond: ImGuiCond = 0);
    begin igSetNextWindowSize(size, cond) end;
class procedure ImGui.SetNextWindowSizeConstraints(size_min: ImVec2; size_max: ImVec2; custom_callback: ImGuiSizeConstraintCallback; custom_callback_data: pointer);
    begin igSetNextWindowSizeConstraints(size_min, size_max, custom_callback, custom_callback_data) end;
class procedure ImGui.SetNextWindowContentSize(size: ImVec2);
    begin igSetNextWindowContentSize(size) end;
class procedure ImGui.SetNextWindowContentWidth(Width: single);
    begin igSetNextWindowContentWidth(Width) end;
class procedure ImGui.SetNextWindowCollapsed(collapsed: bool; cond: ImGuiCond = 0);
    begin igSetNextWindowCollapsed(collapsed, cond) end;
class procedure ImGui.SetNextWindowFocus;
    begin igSetNextWindowFocus end;
class procedure ImGui.SetWindowPos(pos: ImVec2; cond: ImGuiCond = 0);
    begin igSetWindowPos(pos, cond) end;
class procedure ImGui.SetWindowSize(size: ImVec2; cond: ImGuiCond = 0);
    begin igSetWindowSize(size, cond) end;
class procedure ImGui.SetWindowCollapsed(collapsed: bool; cond: ImGuiCond = 0);
    begin igSetWindowCollapsed(collapsed, cond) end;
class procedure ImGui.SetWindowFocus;
    begin igSetWindowFocus end;
class procedure ImGui.SetWindowPosByName(Name: PChar; pos: ImVec2; cond: ImGuiCond = 0);
    begin igSetWindowPosByName(Name, pos, cond) end;
class procedure ImGui.SetWindowSize2(Name: PChar; size: ImVec2; cond: ImGuiCond = 0);
    begin igSetWindowSize2(Name, size, cond) end;
class procedure ImGui.SetWindowCollapsed2(Name: PChar; collapsed: bool; cond: ImGuiCond = 0);
    begin igSetWindowCollapsed2(Name, collapsed, cond) end;
class procedure ImGui.SetWindowFocus2(Name: PChar);
    begin igSetWindowFocus2(Name) end;
class function ImGui.GetScrollX: single;
    begin result := igGetScrollX end;
class function ImGui.GetScrollY: single;
    begin result := igGetScrollY end;
class function ImGui.GetScrollMaxX: single;
    begin result := igGetScrollMaxX end;
class function ImGui.GetScrollMaxY: single;
    begin result := igGetScrollMaxY end;
class procedure ImGui.SetScrollX(scroll_x: single);
    begin igSetScrollX(scroll_x) end;
class procedure ImGui.SetScrollY(scroll_y: single);
    begin igSetScrollY(scroll_y) end;
class procedure ImGui.SetScrollHere(center_y_ratio: single);
    begin igSetScrollHere(center_y_ratio) end;
class procedure ImGui.SetScrollFromPosY(pos_y: single; center_y_ratio: single);
    begin igSetScrollFromPosY(pos_y, center_y_ratio) end;
class procedure ImGui.SetKeyboardFocusHere(offset: longint);
    begin igSetKeyboardFocusHere(offset) end;
class procedure ImGui.SetStateStorage(tree: PImGuiStorage);
    begin igSetStateStorage(tree) end;
class function ImGui.GetStateStorage(): PImGuiStorage;
    begin result := igGetStateStorage end;



{ Parameters stacks (shared) }
class procedure ImGui.PushFont(font: PImFont);
    begin igPushFont(font) end;
class procedure ImGui.PopFont;
    begin igPopFont end;
class procedure ImGui.PushStyleColor(idx: ImGuiCol; col: ImVec4);
    begin igPushStyleColor(idx, col) end;
class procedure ImGui.PopStyleColor(count: longint);
    begin igPopStyleColor(Count) end;
class procedure ImGui.PushStyleVar(idx: ImGuiStyleVar; val: single);
    begin igPushStyleVar(idx, val) end;
class procedure ImGui.PushStyleVarVec(idx: ImGuiStyleVar; val: ImVec2);
    begin igPushStyleVarVec(idx, val) end;
class procedure ImGui.PopStyleVar(count: longint);
    begin igPopStyleVar(count) end;
class function ImGui.GetFont(): PImFont;
    begin result := igGetFont end;
class function ImGui.GetFontSize: single;
    begin result := igGetFontSize end;
class function ImGui.GetFontTexUvWhitePixel():ImVec2;
    begin igGetFontTexUvWhitePixel(@result); end;
class function ImGui.GetColorU32(idx: ImGuiCol; alpha_mul: single): ImU32;
    begin result := igGetColorU32(idx, alpha_mul) end;
class function ImGui.GetColorU32Vec(col: PImVec4): ImU32;
    begin result := igGetColorU32Vec(col) end;

{ Parameters stacks (current window) }
class procedure ImGui.PushItemWidth(item_width: single);
    begin igPushItemWidth(item_width) end;
class procedure ImGui.PopItemWidth;
    begin igPopItemWidth end;
class function ImGui.CalcItemWidth: single;
    begin result := igCalcItemWidth end;
class procedure ImGui.PushTextWrapPos(wrap_pos_x: single);
    begin igPushTextWrapPos(wrap_pos_x) end;
class procedure ImGui.PopTextWrapPos;
    begin igPopTextWrapPos end;
class procedure ImGui.PushAllowKeyboardFocus(v: bool);
    begin igPushAllowKeyboardFocus(v) end;
class procedure ImGui.PopAllowKeyboardFocus;
    begin igPopAllowKeyboardFocus end;
class procedure ImGui.PushButtonRepeat(_repeat: bool);
    begin igPushButtonRepeat(_repeat) end;
class procedure ImGui.PopButtonRepeat;
    begin igPopButtonRepeat end;

{ Layout }
class procedure ImGui.Separator;
    begin igSeparator end;
class procedure ImGui.SameLine(pos_x: single; spacing_w: single);
    begin igSameLine(pos_x, spacing_w) end;
class procedure ImGui.NewLine;
    begin igNewLine end;
class procedure ImGui.Spacing;
    begin igSpacing end;
class procedure ImGui.Dummy(size: PImVec2);
    begin igDummy(size) end;
class procedure ImGui.Indent(indent_w: single);
    begin igIndent(indent_w) end;
class procedure ImGui.Unindent(indent_w: single);
    begin igUnindent(indent_w) end;
class procedure ImGui.BeginGroup;
    begin igBeginGroup end;
class procedure ImGui.EndGroup;
    begin igEndGroup end;
class function ImGui.GetCursorPos: ImVec2;
    begin igGetCursorPos(@result) end;
class function ImGui.GetCursorPosX: single;
    begin result := igGetCursorPosX end;
class function ImGui.GetCursorPosY: single;
    begin result := igGetCursorPosY end;
class procedure ImGui.SetCursorPos(local_pos: ImVec2);
    begin igSetCursorPos(local_pos) end;
class procedure ImGui.SetCursorPosX(x: single);
    begin igSetCursorPosX(x) end;
class procedure ImGui.SetCursorPosY(y: single);
    begin igSetCursorPosY(y) end;
class function ImGui.GetCursorStartPos: ImVec2;
    begin igGetCursorStartPos(@result) end;
class function ImGui.GetCursorScreenPos: ImVec2;
    begin igGetCursorScreenPos(@result) end;
class procedure ImGui.SetCursorScreenPos(pos: ImVec2);
    begin igSetCursorScreenPos(pos) end;
class procedure ImGui.AlignFirstTextHeightToWidgets;
    begin igAlignFirstTextHeightToWidgets end;
class function ImGui.GetTextLineHeight: single;
    begin result := igGetTextLineHeight end;
class function ImGui.GetTextLineHeightWithSpacing: single;
    begin result := igGetTextLineHeightWithSpacing end;
class function ImGui.GetItemsLineHeightWithSpacing: single;
    begin result := igGetItemsLineHeightWithSpacing end;

{ Columns }
class procedure ImGui.Columns(Count: longint; id: PChar; border: bool);
    begin igColumns(Count, id, border) end;
class procedure ImGui.NextColumn;
    begin igNextColumn end;
class function ImGui.GetColumnIndex: longint;
    begin result := igGetColumnIndex end;
class function ImGui.GetColumnOffset(column_index: longint): single;
    begin result := igGetColumnOffset(column_index) end;
class procedure ImGui.SetColumnOffset(column_index: longint; offset_x: single);
    begin igSetColumnOffset(column_index, offset_x) end;
class function ImGui.GetColumnWidth(column_index: longint): single;
    begin result := igGetColumnWidth(column_index) end;
class procedure ImGui.SetColumnWidth(column_index: longint; width: single);
    begin igSetColumnWidth(column_index, width); end;
class function ImGui.GetColumnsCount: longint;
    begin result := igGetColumnsCount end;

{ ID scopes }
{ If you are creating widgets in a loop you most likely want to push a unique identifier so ImGui can differentiate them }
{ You can also use "##extra" within your widget name to distinguish them from each others (see 'Programmer Guide') }
class procedure ImGui.PushIdStr(str_id: PChar);
    begin igPushIdStr(str_id) end;
class procedure ImGui.PushIdStrRange(str_begin: PChar; str_end: PChar);
    begin igPushIdStrRange(str_begin, str_end) end;
class procedure ImGui.PushIdPtr(ptr_id: pointer);
    begin igPushIdPtr(ptr_id) end;
class procedure ImGui.PushIdInt(int_id: longint);
    begin igPushIdInt(int_id) end;
class procedure ImGui.PopId;
    begin igPopId end;
class function ImGui.GetIdStr(str_id: PChar): ImGuiID;
    begin result := igGetIdStr(str_id) end;
class function ImGui.GetIdStrRange(str_begin: PChar; str_end: PChar): ImGuiID;
    begin result := igGetIdStrRange(str_begin, str_end) end;
class function ImGui.GetIdPtr(ptr_id: pointer): ImGuiID;
    begin result := igGetIdPtr(ptr_id) end;

{ Widgets }
class procedure ImGui.Text(const text_: string);
    begin igText(Pchar(text_)) end;
class procedure ImGui.Text(const Fmt: string; const Args: array of const);
    begin Text(Format(fmt, args)) end;
class procedure ImGui.TextColored(col: ImVec4; fmt: PChar; args: array of const);
    begin TextColored(col, Format(fmt, args)) end;
class procedure ImGui.TextColored(col: ImVec4; const fmt: string);
    begin igTextColored(col, pchar(fmt)) end;
class procedure ImGui.TextDisabled(const fmt: string; args: array of const);
    begin TextDisabled(Format(fmt, args)) end;
class procedure ImGui.TextDisabled(const fmt: string);
    begin igTextDisabled(pchar(fmt)) end;
class procedure ImGui.TextWrapped(const fmt: string; args: array of const);
    begin TextWrapped(Format(fmt, args)) end;
class procedure ImGui.TextWrapped(const fmt: string);
    begin igTextWrapped(pchar(fmt)) end;
class procedure ImGui.TextUnformatted(const _text: string);
    begin igTextUnformatted(pchar(_text), nil) end;
class procedure ImGui.TextUnformatted(const _text: PChar; const text_end: PChar);
    begin igTextUnformatted(_text, text_end) end;
class procedure ImGui.LabelText(_label: string; fmt: PChar; args: array of const);
    begin LabelText(_label, Format(fmt, args)) end;
class procedure ImGui.LabelText(_label: string; fmt: string);
    begin igLabelText(pchar(_label), pchar(fmt)) end;
class procedure ImGui.Bullet;
    begin igBullet end;
class procedure ImGui.BulletText(const fmt: string; args: array of const);
    begin BulletText(Format(fmt, args)) end;
class procedure ImGui.BulletText(const fmt: string);
    begin igBulletText(pchar(fmt)) end;
class function ImGui.Button(_label: string; size: ImVec2): bool;
     begin result := igButton(pchar(_label), size) end;
class function ImGui.Button(_label: string): bool;
     begin result := Button(_label, ImVec2Init(0,0)) end;
class function ImGui.SmallButton(_label: PChar): bool;
    begin result := igSmallButton(_label) end;
class function ImGui.InvisibleButton(str_id: PChar; size: ImVec2): bool;
    begin result := igInvisibleButton(str_id, size) end;
class procedure ImGui.Image(user_texture_id: ImTextureID; size: ImVec2; uv0: ImVec2; uv1: ImVec2; tint_col: ImVec4; border_col: ImVec4);
    begin igImage(user_texture_id, size, uv0, uv1, tint_col, border_col) end;
class function ImGui.ImageButton(user_texture_id: ImTextureID; size: ImVec2; uv0: ImVec2; uv1: ImVec2; frame_padding: longint; bg_col: ImVec4; tint_col: ImVec4): bool;
    begin result := igImageButton(user_texture_id, size, uv0, uv1, frame_padding, bg_col, tint_col) end;
class function ImGui.Checkbox(_label: PChar; v: Pbool): bool;
    begin result := igCheckbox(_label, v) end;
class function ImGui.CheckboxFlags(_label: PChar; flags: Pdword; flags_value: dword): bool;
    begin result := igCheckboxFlags(_label, flags, flags_value) end;
class function ImGui.RadioButtonBool(_label: PChar; active: bool): bool;
    begin result := igRadioButtonBool(_label, active) end;
class function ImGui.RadioButton(_label: PChar; v: Plongint; v_button: longint): bool;
    begin result := igRadioButton(_label, v, v_button) end;
class function ImGui.Combo(_label: PChar; current_item: Plongint; items: PPchar; items_count: longint; height_in_items: longint): bool;
    begin result := igCombo(_label, current_item, items, items_count, height_in_items) end;
class function ImGui.Combo2(_label: PChar; current_item: Plongint; items_separated_by_zeros: PChar; height_in_items: longint): bool;
    begin result := igCombo2(_label, current_item, items_separated_by_zeros, height_in_items) end;

class function ImGui.ColorButton(desc_id: PChar; col: ImVec4; flags: ImGuiColorEditFlags; size: ImVec2): bool;
    begin result := igColorButton(desc_id, col, flags, size) end;
class function ImGui.ColorEdit3(_label: PChar; col: TCol3; flags: ImGuiColorEditFlags): bool;
    begin result := igColorEdit3(_label, col, flags) end;
class function ImGui.ColorEdit4(_label: PChar; col: TCol4; flags: ImGuiColorEditFlags): bool;
    begin result := igColorEdit4(_label, col, flags) end;
class function ImGui.ColorPicker3(_label: PChar; col: TCol3; flags: ImGuiColorEditFlags): bool;
    begin result := igColorPicker3(_label, col, flags) end;
class function ImGui.ColorPicker4(_label: PChar; col: TCol4; flags: ImGuiColorEditFlags): bool;
    begin result := igColorPicker4(_label, col, flags) end;
class procedure ImGui.SetColorEditOptions(flags: ImGuiColorEditFlags);
    begin igSetColorEditOptions(flags) end;

class procedure ImGui.PlotLines(_label: PChar; values: Psingle; values_count: longint; values_offset: longint; overlay_text: PChar; scale_min: single; scale_max: single; graph_size: ImVec2; stride: longint);
    begin igPlotLines(_label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride) end;

class procedure ImGui.PlotHistogram(_label: PChar; values: Psingle; values_count: longint; values_offset: longint; overlay_text: PChar; scale_min: single;   scale_max: single; graph_size: ImVec2; stride: longint);
    begin igPlotHistogram(_label, values, values_count, values_offset, overlay_text, scale_min,   scale_max, graph_size, stride) end;

class procedure ImGui.ProgressBar(fraction: single; size_arg: PImVec2; overlay: PChar);
    begin igProgressBar(fraction, size_arg, overlay) end;

{ Widgets: Sliders (tip: ctrl+click on a slider to input text) }
class function ImGui.SliderFloat(_label: PChar; v: Psingle; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igSliderFloat(_label, v, v_min, v_max, display_format, power) end;
class function ImGui.SliderFloat2(_label: PChar; v: TFloat2; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igSliderFloat2(_label, v, v_min, v_max, display_format, power) end;
class function ImGui.SliderFloat3(_label: PChar; v: TFloat3; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igSliderFloat3(_label, v, v_min, v_max, display_format, power) end;
class function ImGui.SliderFloat4(_label: PChar; v: TFloat4; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igSliderFloat4(_label, v, v_min, v_max, display_format, power) end;
class function ImGui.SliderAngle(_label: PChar; v_rad: Psingle; v_degrees_min: single; v_degrees_max: single): bool;
    begin result := igSliderAngle(_label, v_rad, v_degrees_min, v_degrees_max) end;
class function ImGui.SliderInt(_label: PChar; v: Plongint; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igSliderInt(_label, v, v_min, v_max, display_format) end;
class function ImGui.SliderInt2(_label: PChar; v: TLongInt2; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igSliderInt2(_label, v, v_min, v_max, display_format) end;
class function ImGui.SliderInt3(_label: PChar; v: TLongInt3; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igSliderInt3(_label, v, v_min, v_max, display_format) end;
class function ImGui.SliderInt4(_label: PChar; v: TLongInt4; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igSliderInt4(_label, v, v_min, v_max, display_format) end;
class function ImGui.VSliderFloat(_label: PChar; size: ImVec2; v: Psingle; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igVSliderFloat(_label, size, v, v_min, v_max, display_format, power) end;
class function ImGui.VSliderInt(_label: PChar; size: ImVec2; v: Plongint; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igVSliderInt(_label, size, v, v_min, v_max, display_format) end;

{ Widgets: Drags (tip: ctrl+click on a drag box to input text) }
// For all the Float2/Float3/Float4/Int2/Int3/Int4 versions of every functions, remember than a 'float v[3]' function argument is the same as 'float* v'. You can pass address of your first element out of a contiguous set, e.g. &myvector.x
{ If v_max >= v_max we have no bound }
class function ImGui.DragFloat(_label: PChar; v: Psingle; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igDragFloat(_label, v, v_speed, v_min, v_max, display_format, power) end;
class function ImGui.DragFloat2(_label: PChar; v: TFloat2; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igDragFloat2(_label, v, v_speed, v_min, v_max, display_format, power) end;
class function ImGui.DragFloat3(_label: PChar; v: TFloat3; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igDragFloat3(_label, v, v_speed, v_min, v_max, display_format, power) end;
class function ImGui.DragFloat4(_label: PChar; v: TFloat4; v_speed: single; v_min: single; v_max: single; display_format: PChar; power: single): bool;
    begin result := igDragFloat4(_label, v, v_speed, v_min, v_max, display_format, power) end;
class function ImGui.DragFloatRange2(_label: PChar; v_current_min: Psingle; v_current_max: Psingle; v_speed: single; v_min: single; v_max: single; display_format: PChar; display_format_max: PChar; power: single): bool;
    begin result := igDragFloatRange2(_label, v_current_min, v_current_max, v_speed, v_min, v_max,   display_format, display_format_max, power) end;
{ If v_max >= v_max we have no bound }
class function ImGui.DragInt(_label: PChar; v: Plongint; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igDragInt(_label, v, v_speed, v_min, v_max, display_format) end;
class function ImGui.DragInt2(_label: PChar; v: TLongInt2; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igDragInt2(_label, v, v_speed, v_min, v_max, display_format) end;
class function ImGui.DragInt3(_label: PChar; v: TLongInt3; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igDragInt3(_label, v, v_speed, v_min, v_max, display_format) end;
class function ImGui.DragInt4(_label: PChar; v: TLongInt4; v_speed: single; v_min: longint; v_max: longint; display_format: PChar): bool;
    begin result := igDragInt4(_label, v, v_speed, v_min, v_max, display_format) end;
class function ImGui.DragIntRange2(_label: PChar; v_current_min: Plongint; v_current_max: Plongint; v_speed: single; v_min: longint; v_max: longint; display_format: PChar; display_format_max: PChar): bool;
    begin result := igDragIntRange2(_label, v_current_min, v_current_max, v_speed, v_min, v_max,   display_format, display_format_max) end;

{ Widgets: Input }
class function ImGui.InputText(_label: PChar; buf: PChar; buf_size: size_t; flags: ImGuiInputTextFlags; callback: ImGuiTextEditCallback; user_data: pointer): bool;
    begin result := igInputText(_label, buf, buf_size, flags, callback,   user_data) end;
class function ImGui.InputTextMultiline(_label: PChar; buf: PChar; buf_size: size_t; size: ImVec2; flags: ImGuiInputTextFlags; callback: ImGuiTextEditCallback; user_data: pointer): bool;
    begin result := igInputTextMultiline(_label, buf, buf_size, size, flags, callback,   user_data) end;
class function ImGui.InputFloat(_label: PChar; v: Psingle; step: single; step_fast: single; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputFloat(_label, v, step, step_fast, decimal_precision, extra_flags) end;
class function ImGui.InputFloat2(_label: PChar; v: TFloat2; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputFloat2(_label, v, decimal_precision, extra_flags) end;
class function ImGui.InputFloat3(_label: PChar; v: TFloat3; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputFloat3(_label, v, decimal_precision, extra_flags) end;
class function ImGui.InputFloat4(_label: PChar; v: TFloat4; decimal_precision: longint; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputFloat4(_label, v, decimal_precision, extra_flags) end;
class function ImGui.InputInt(_label: PChar; v: Plongint; step: longint; step_fast: longint; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputInt(_label, v, step, step_fast, extra_flags) end;
class function ImGui.InputInt2(_label: PChar; v: TLongInt2; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputInt2(_label, v, extra_flags) end;
class function ImGui.InputInt3(_label: PChar; v: TLongInt3; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputInt3(_label, v, extra_flags) end;
class function ImGui.InputInt4(_label: PChar; v: TLongInt4; extra_flags: ImGuiInputTextFlags): bool;
    begin result := igInputInt4(_label, v, extra_flags) end;

{ Widgets: Trees }
class function ImGui.TreeNode(_label: string): bool;
    begin result := igTreeNode(pchar(_label)) end;
class function ImGui.TreeNode(str_id: string; fmt: string; args: array of const): bool;
    begin result := TreeNode(str_id, Format(fmt, args)) end;
class function ImGui.TreeNode(str_id: string; fmt: string): bool;
    begin result := igTreeNodeStr(pchar(str_id), pchar(fmt)) end;
class function ImGui.TreeNode(ptr_id: pointer; fmt: string; args: array of const): bool;
    begin result := TreeNode(ptr_id, Format(fmt, args)) end;
class function ImGui.TreeNode(ptr_id: pointer; fmt: string): bool;
    begin result := igTreeNodePtr(ptr_id, pchar(fmt)) end;

class function ImGui.TreeNodeEx(_label: PChar; flags: ImGuiTreeNodeFlags): bool;
    begin result := igTreeNodeEx(_label, flags) end;
class function ImGui.TreeNodeEx(str_id: PChar; flags: ImGuiTreeNodeFlags; fmt: string; args: array of const): bool;
    begin result := TreeNodeEx(str_id, flags, Format(fmt, args)) end;
class function ImGui.TreeNodeEx(str_id: PChar; flags: ImGuiTreeNodeFlags; fmt: string): bool;
    begin result := igTreeNodeExStr(str_id, flags, pchar(fmt)) end;
class function ImGui.TreeNodeEx(ptr_id: pointer; flags: ImGuiTreeNodeFlags; fmt: string; args: array of const): bool;
    begin result := TreeNodeEx(ptr_id, flags, Format(fmt, args)) end;
class function ImGui.TreeNodeEx(ptr_id: pointer; flags: ImGuiTreeNodeFlags; fmt: string): bool;
    begin result := igTreeNodeExPtr(ptr_id, flags, pchar(fmt)) end;
class procedure ImGui.TreePushStr(str_id: PChar);
    begin igTreePushStr(str_id) end;
class procedure ImGui.TreePushPtr(ptr_id: pointer);
    begin igTreePushPtr(ptr_id) end;
class procedure ImGui.TreePop;
    begin igTreePop end;
class procedure ImGui.TreeAdvanceToLabelPos;
    begin igTreeAdvanceToLabelPos end;
class function ImGui.GetTreeNodeToLabelSpacing: single;
    begin result := igGetTreeNodeToLabelSpacing end;
class procedure ImGui.SetNextTreeNodeOpen(opened: bool; cond: ImGuiCond = 0);
    begin igSetNextTreeNodeOpen(opened, cond) end;
class function ImGui.CollapsingHeader(_label: PChar; flags: ImGuiTreeNodeFlags): bool;
    begin result := igCollapsingHeader(_label, flags) end;
class function ImGui.CollapsingHeader(_label: PChar; p_open: Pbool; flags: ImGuiTreeNodeFlags): bool;
    begin result := igCollapsingHeaderEx(_label, p_open, flags) end;

{ Widgets: Selectable / Lists }
class function ImGui.Selectable(_label: string; selected: bool; flags: ImGuiSelectableFlags; size: ImVec2): bool;
    begin result := igSelectable(pchar(_label), selected, flags, size) end;
class function ImGui.Selectable(_label: string; selected: bool; flags: ImGuiSelectableFlags): bool;
    begin result := Selectable(_label, selected, flags, ImVec2Init(0,0)); end;
class function ImGui.SelectableEx(_label: PChar; p_selected: Pbool; flags: ImGuiSelectableFlags; size: ImVec2): bool;
    begin result := igSelectableEx(_label, p_selected, flags, size) end;
class function ImGui.ListBox(_label: PChar; current_item: Plongint; items: PPchar; items_count: longint; height_in_items: longint): bool;
    begin result := igListBox(_label, current_item, items, items_count, height_in_items) end;
class function ImGui.ListBoxHeader(_label: PChar; size: ImVec2): bool;
    begin result := igListBoxHeader(_label, size) end;
class function ImGui.ListBoxHeader2(_label: PChar; items_count: longint; height_in_items: longint): bool;
    begin result := igListBoxHeader2(_label, items_count, height_in_items) end;
class procedure ImGui.ListBoxFooter;
    begin igListBoxFooter end;

{ Widgets: Value() Helpers. Output single value in "name: value" format (tip: freely declare your own within the ImGui namespace!) }
class procedure ImGui.ValueBool(prefix: PChar; b: bool);
    begin igValueBool(prefix, b) end;
class procedure ImGui.ValueInt(prefix: PChar; v: longint);
    begin igValueInt(prefix, v) end;
class procedure ImGui.ValueUInt(prefix: PChar; v: dword);
    begin igValueUInt(prefix, v) end;
class procedure ImGui.ValueFloat(prefix: PChar; v: single; float_format: PChar);
    begin igValueFloat(prefix, v, float_format) end;

{ Tooltip }
class procedure ImGui.SetTooltip(fmt: string; args: array of const);
    begin SetTooltip(Format(fmt, args)) end;
class procedure ImGui.SetTooltip(fmt: string);
    begin igSetTooltip(pchar(fmt)) end;
class procedure ImGui.BeginTooltip;
    begin igBeginTooltip end;
class procedure ImGui.EndTooltip;
    begin igEndTooltip end;

{ Widgets: Menus }
class function ImGui.BeginMainMenuBar: bool;
    begin result := igBeginMainMenuBar end;
class procedure ImGui.EndMainMenuBar;
    begin igEndMainMenuBar end;
class function ImGui.BeginMenuBar: bool;
    begin result := igBeginMenuBar end;
class procedure ImGui.EndMenuBar;
    begin igEndMenuBar end;
class function ImGui.BeginMenu(_label: PChar; Enabled: bool): bool;
    begin result := igBeginMenu(_label, Enabled) end;
class procedure ImGui.EndMenu;
    begin igEndMenu end;
class function ImGui.MenuItem(_label: PChar; shortcut: PChar; selected: bool; Enabled: bool): bool;
    begin result := igMenuItem(_label, shortcut, selected, Enabled) end;
class function ImGui.MenuItem(_label: PChar; shortcut: PChar; p_selected: Pbool; Enabled: bool): bool;
    begin result := igMenuItemPtr(_label, shortcut, p_selected, Enabled) end;

{ Popup }
class procedure ImGui.OpenPopup(str_id: PChar);
    begin igOpenPopup(str_id) end;
class function ImGui.BeginPopup(str_id: PChar): bool;
    begin result := igBeginPopup(str_id) end;
class function ImGui.BeginPopupModal(Name: PChar; p_open: Pbool; extra_flags: ImGuiWindowFlags): bool;
    begin result := igBeginPopupModal(Name, p_open, extra_flags) end;
class function ImGui.BeginPopupContextItem(str_id: PChar; mouse_button: longint): bool;
    begin result := igBeginPopupContextItem(str_id, mouse_button) end;
class function ImGui.BeginPopupContextWindow(str_id: PChar; mouse_button: longint; also_over_items: bool): bool;
    begin result := igBeginPopupContextWindow(also_over_items, str_id, mouse_button) end;
class function ImGui.BeginPopupContextVoid(str_id: PChar; mouse_button: longint): bool;
    begin result := igBeginPopupContextVoid(str_id, mouse_button) end;
class procedure ImGui.EndPopup;
    begin igEndPopup end;
class function ImGui.IsPopupOpen(str_id: PChar): bool;
    begin result := igIsPopupOpen(str_id); end;
class procedure ImGui.CloseCurrentPopup;
    begin igCloseCurrentPopup end;

{ Logging: all text output from interface is redirected to tty/file/clipboard. Tree nodes are automatically opened. }
class procedure ImGui.LogToTTY(max_depth: longint);
    begin igLogToTTY(max_depth) end;
class procedure ImGui.LogToFile(max_depth: longint; filename: PChar);
    begin igLogToFile(max_depth, filename) end;
class procedure ImGui.LogToClipboard(max_depth: longint);
    begin igLogToClipboard(max_depth) end;
class procedure ImGui.LogFinish;
    begin igLogFinish end;
class procedure ImGui.LogButtons;
    begin igLogButtons end;
class procedure ImGui.LogText(const fmt: string; args: array of const);
    begin LogText(Format(fmt, args)) end;
class procedure ImGui.LogText(const fmt: string);
    begin igLogText(pchar(fmt)) end;

{ Clipping }
class procedure ImGui.PushClipRect(clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: bool);
    begin igPushClipRect(clip_rect_min, clip_rect_max, intersect_with_current_clip_rect) end;
class procedure ImGui.PopClipRect;
    begin igPopClipRect end;

{ Utilities }
class function ImGui.IsItemHovered: bool;
    begin result := igIsItemHovered end;
class function ImGui.IsItemRectHovered: bool;
    begin result := igIsItemRectHovered end;
class function ImGui.IsItemActive: bool;
    begin result := igIsItemActive end;
class function ImGui.IsItemClicked(mouse_button: longint): bool;
    begin result := igIsItemClicked(mouse_button) end;
class function ImGui.IsItemVisible: bool;
    begin result := igIsItemVisible end;
class function ImGui.IsAnyItemHovered: bool;
    begin result := igIsAnyItemHovered end;
class function ImGui.IsAnyItemActive: bool;
    begin result := igIsAnyItemActive end;
class procedure ImGui.GetItemRectMin(pOut: PImVec2);
    begin igGetItemRectMin(pOut) end;
class procedure ImGui.GetItemRectMax(pOut: PImVec2);
    begin igGetItemRectMax(pOut) end;
class procedure ImGui.GetItemRectSize(pOut: PImVec2);
    begin igGetItemRectSize(pOut) end;
class procedure ImGui.SetItemAllowOverlap;
    begin igSetItemAllowOverlap end;
class function ImGui.IsWindowHovered: bool;
    begin result := igIsWindowHovered end;
class function ImGui.IsWindowFocused: bool;
    begin result := igIsWindowFocused end;
class function ImGui.IsRootWindowFocused: bool;
    begin result := igIsRootWindowFocused end;
class function ImGui.IsRootWindowOrAnyChildFocused: bool;
    begin result := igIsRootWindowOrAnyChildFocused end;
class function ImGui.IsRootWindowOrAnyChildHovered: bool;
    begin result := igIsRootWindowOrAnyChildHovered end;
class function ImGui.IsRectVisible(const item_size: ImVec2): bool;
    begin result := igIsRectVisible(item_size) end;
class function ImGui.IsRectVisible(const rect_min, rect_max: PImVec2): bool;
    begin result := igIsRectVisible2(rect_min, rect_max) end;
class function ImGui.GetTime: single;
    begin result := igGetTime end;
class function ImGui.GetFrameCount: longint;
    begin result := igGetFrameCount end;
class function ImGui.GetStyleColorName(idx: ImGuiCol): PChar;
    begin result := igGetStyleColorName(idx) end;
class function ImGui.CalcItemRectClosestPoint(pos: ImVec2; on_edge: bool; outward: single): ImVec2;
    begin igCalcItemRectClosestPoint(@result, pos, on_edge, outward) end;
class function ImGui.CalcTextSize(_text: PChar; text_end: PChar; hide_text_after_double_hash: bool; wrap_width: single): ImVec2;
    begin igCalcTextSize(@result, _text, text_end, hide_text_after_double_hash, wrap_width) end;
class procedure ImGui.CalcListClipping(items_count: longint; items_height: single; out_items_display_start: Plongint; out_items_display_end: Plongint);
    begin igCalcListClipping(items_count, items_height, out_items_display_start, out_items_display_end) end;

class function ImGui.BeginChildFrame(id: ImGuiID; size: ImVec2; extra_flags: ImGuiWindowFlags): bool;
    begin result := igBeginChildFrame(id, size, extra_flags) end;
class procedure ImGui.EndChildFrame;
    begin igEndChildFrame end;

class procedure ImGui.ColorConvertU32ToFloat4(pOut: PImVec4; in_: ImU32);
    begin igColorConvertU32ToFloat4(pOut, in_) end;
class function ImGui.ColorConvertFloat4ToU32(in_: ImVec4): ImU32;
    begin result := igColorConvertFloat4ToU32(in_) end;
class procedure ImGui.ColorConvertRGBtoHSV(r: single; g: single; b: single; out_h: Psingle; out_s: Psingle; out_v: Psingle);
    begin igColorConvertRGBtoHSV(r, g, b, out_h, out_s, out_v) end;
class procedure ImGui.ColorConvertHSVtoRGB(h: single; s: single; v: single; out_r: Psingle; out_g: Psingle; out_b: Psingle);
    begin igColorConvertHSVtoRGB(h, s, v, out_r, out_g, out_b) end;

class function ImGui.GetKeyIndex(key: ImGuiKey): longint;
    begin result := igGetKeyIndex(key) end;
class function ImGui.IsKeyDown(user_key_index: longint): bool;
    begin result := igIsKeyDown(user_key_index) end;
class function ImGui.IsKeyPressed(user_key_index: longint; _repeat: bool): bool;
    begin result := igIsKeyPressed(user_key_index, _repeat) end;
class function ImGui.IsKeyReleased(user_key_index: longint): bool;
    begin result := igIsKeyReleased(user_key_index) end;
class function ImGui.IsMouseDown(_button: longint): bool;
    begin result := igIsMouseDown(_button) end;
class function ImGui.IsMouseClicked(_button: longint; _repeat: bool): bool;
    begin result := igIsMouseClicked(_button, _repeat) end;
class function ImGui.IsMouseDoubleClicked(_button: longint): bool;
    begin result := igIsMouseDoubleClicked(_button) end;
class function ImGui.IsMouseReleased(_button: longint): bool;
    begin result := igIsMouseReleased(_button) end;
class function ImGui.IsWindowRectHovered: bool;
    begin result := igIsWindowRectHovered; end;
class function ImGui.IsAnyWindowHovered: bool;
    begin result := igIsAnyWindowHovered; end;
class function ImGui.IsMouseHoveringRect(r_min: ImVec2; r_max: ImVec2; clip: bool): bool;
    begin result := igIsMouseHoveringRect(r_min, r_max, clip) end;
class function ImGui.IsMouseDragging(_button: longint; lock_threshold: single): bool;
    begin result := igIsMouseDragging(_button, lock_threshold) end;
class function ImGui.GetMousePos(): ImVec2;
    begin igGetMousePos(@result) end;
class function ImGui.GetMousePosOnOpeningCurrentPopup(): ImVec2;
    begin igGetMousePosOnOpeningCurrentPopup(@result) end;
class function ImGui.GetMouseDragDelta(_button: longint; lock_threshold: single): ImVec2;
    begin igGetMouseDragDelta(@result, _button, lock_threshold) end;
class procedure ImGui.ResetMouseDragDelta(_button: longint);
    begin igResetMouseDragDelta(_button) end;
class function ImGui.GetMouseCursor: ImGuiMouseCursor;
    begin result := igGetMouseCursor end;
class procedure ImGui.SetMouseCursor(_type: ImGuiMouseCursor);
    begin igSetMouseCursor(_type) end;
class procedure ImGui.CaptureKeyboardFromApp(capture: bool);
    begin igCaptureKeyboardFromApp(capture) end;
class procedure ImGui.CaptureMouseFromApp(capture: bool);
    begin igCaptureMouseFromApp(capture) end;

{ Helpers functions to access functions pointers in ImGui::GetIO() }
class function ImGui.MemAlloc(sz: size_t): pointer;
    begin result := igMemAlloc(sz) end;
class procedure ImGui.MemFree(ptr: pointer);
    begin igMemFree(ptr) end;
class function ImGui.GetClipboardText: PChar;
    begin result := igGetClipboardText end;
class procedure ImGui.SetClipboardText(_text: PChar);
    begin igSetClipboardText(_text) end;

{ Internal state access - if you want to share ImGui state between modules (e.g. DLL) or allocate it yourself }
class function ImGui.GetVersion(): PChar;
    begin result := igGetVersion end;



{ TImDrawListHelper }

procedure TImDrawListHelper.PushClipRect(clip_rect_min: ImVec2; clip_rect_max: ImVec2; intersect_with_current_clip_rect: bool);
    begin ImDrawList_PushClipRect(@self, clip_rect_min, clip_rect_max, intersect_with_current_clip_rect) end;
procedure TImDrawListHelper.PushClipRectFullScreen();
    begin ImDrawList_PushClipRectFullScreen(@self) end;
procedure TImDrawListHelper.PopClipRect();
    begin ImDrawList_PopClipRect(@self) end;
procedure TImDrawListHelper.PushTextureID(texture_id: ImTextureID);
    begin ImDrawList_PushTextureID(@self, texture_id) end;
procedure TImDrawListHelper.PopTextureID();
    begin ImDrawList_PopTextureID(@self) end;
procedure TImDrawListHelper.AddLine(a: ImVec2; b: ImVec2; col: ImU32; thickness: single);
    begin ImDrawList_AddLine(@self, a, b, col, thickness) end;
procedure TImDrawListHelper.AddRect(a: ImVec2; b: ImVec2; col: ImU32; rounding: single; rounding_corners_flags: longint; thickness: single);
    begin ImDrawList_AddRect(@self, a, b, col, rounding, rounding_corners_flags, thickness) end;
procedure TImDrawListHelper.AddRectFilled(a: ImVec2; b: ImVec2; col: ImU32; rounding: single; rounding_corners_flags: longint);
    begin ImDrawList_AddRectFilled(@self, a, b, col, rounding, rounding_corners_flags) end;
procedure TImDrawListHelper.AddRectFilledMultiColor(a: ImVec2; b: ImVec2; col_upr_left: ImU32; col_upr_right: ImU32;  col_bot_right: ImU32; col_bot_left: ImU32);
    begin ImDrawList_AddRectFilledMultiColor(@self, a, b, col_upr_left, col_upr_right,  col_bot_right, col_bot_left) end;
procedure TImDrawListHelper.AddQuad(a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; col: ImU32; thickness: single);
    begin ImDrawList_AddQuad(@self, a, b, c, d, col, thickness) end;
procedure TImDrawListHelper.AddQuadFilled(a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; col: ImU32);
    begin ImDrawList_AddQuadFilled(@self, a, b, c, d, col) end;
procedure TImDrawListHelper.AddTriangle(a: ImVec2; b: ImVec2; c: ImVec2; col: ImU32; thickness: single);
    begin ImDrawList_AddTriangle(@self, a, b, c, col, thickness) end;
procedure TImDrawListHelper.AddTriangleFilled(a: ImVec2; b: ImVec2; c: ImVec2; col: ImU32);
    begin ImDrawList_AddTriangleFilled(@self, a, b, c, col) end;
procedure TImDrawListHelper.AddCircle(centre: ImVec2; radius: single; col: ImU32; num_segments: longint; thickness: single);
    begin ImDrawList_AddCircle(@self, centre, radius, col, num_segments, thickness) end;
procedure TImDrawListHelper.AddCircleFilled(centre: ImVec2; radius: single; col: ImU32; num_segments: longint);
    begin ImDrawList_AddCircleFilled(@self, centre, radius, col, num_segments) end;
procedure TImDrawListHelper.AddText(pos: ImVec2; col: ImU32; text_begin: PChar; text_end: PChar);
    begin ImDrawList_AddText(@self, pos, col, text_begin, text_end) end;
procedure TImDrawListHelper.AddTextExt(font: PImFont; font_size: single; pos: ImVec2; col: ImU32; text_begin: PChar;  text_end: PChar; wrap_width: single; cpu_fine_clip_rect: PImVec4);
    begin ImDrawList_AddTextExt(@self, font, font_size, pos, col, text_begin,  text_end, wrap_width, cpu_fine_clip_rect) end;
procedure TImDrawListHelper.AddImage(user_texture_id: ImTextureID; a: ImVec2; b: ImVec2; uva: ImVec2; uvb: ImVec2; col: ImU32);
    begin ImDrawList_AddImage(@self, user_texture_id, a, b, uva, uvb, col) end;
procedure TImDrawListHelper.AddImageQuad(user_texture_id: ImTextureID; const a, b, c, d: ImVec2; const uva, uvb, uvc, uvd: ImVec2; col: ImU32);
    begin ImDrawList_AddImageQuad(@self, user_texture_id, a, b, c, d, uva, uvb, uvc, uvd, col) end;
procedure TImDrawListHelper.AddPolyline(points: PImVec2; num_points: longint; col: ImU32; closed: bool; thickness: single;  anti_aliased: bool);
    begin ImDrawList_AddPolyline(@self, points, num_points, col, closed, thickness,  anti_aliased) end;
procedure TImDrawListHelper.AddConvexPolyFilled(points: PImVec2; num_points: longint; col: ImU32; anti_aliased: bool);
    begin ImDrawList_AddConvexPolyFilled(@self, points, num_points, col, anti_aliased) end;
procedure TImDrawListHelper.AddBezierCurve(pos0: ImVec2; cp0: ImVec2; cp1: ImVec2; pos1: ImVec2; col: ImU32; thickness: single;  num_segments: longint);
    begin ImDrawList_AddBezierCurve(@self, pos0, cp0, cp1, pos1, col, thickness,  num_segments) end;

{ Stateful path API, add points then finish with PathFill() or PathStroke() }
procedure TImDrawListHelper.PathClear();
    begin ImDrawList_PathClear(@self) end;
procedure TImDrawListHelper.PathLineTo(pos: ImVec2);
    begin ImDrawList_PathLineTo(@self, pos) end;
procedure TImDrawListHelper.PathLineToMergeDuplicate(pos: ImVec2);
    begin ImDrawList_PathLineToMergeDuplicate(@self, pos) end;
procedure TImDrawListHelper.PathFillConvex(col: ImU32);
    begin ImDrawList_PathFillConvex(@self, col) end;
procedure TImDrawListHelper.PathStroke(col: ImU32; closed: bool; thickness: single);
    begin ImDrawList_PathStroke(@self, col, closed, thickness) end;
procedure TImDrawListHelper.PathArcTo(centre: ImVec2; radius: single; a_min: single; a_max: single; num_segments: longint);
    begin ImDrawList_PathArcTo(@self, centre, radius, a_min, a_max, num_segments) end;
{ Use precomputed angles for a 12 steps circle }
procedure TImDrawListHelper.PathArcToFast(centre: ImVec2; radius: single; a_min_of_12: longint; a_max_of_12: longint);
    begin ImDrawList_PathArcToFast(@self, centre, radius, a_min_of_12, a_max_of_12) end;
procedure TImDrawListHelper.PathBezierCurveTo(p1: ImVec2; p2: ImVec2; p3: ImVec2; num_segments: longint);
    begin ImDrawList_PathBezierCurveTo(@self, p1, p2, p3, num_segments) end;
procedure TImDrawListHelper.PathRect(rect_min: ImVec2; rect_max: ImVec2; rounding: single; rounding_corners_flags: longint);
    begin ImDrawList_PathRect(@self, rect_min, rect_max, rounding, rounding_corners_flags) end;

{ Channels }
procedure TImDrawListHelper.ChannelsSplit(channels_count: longint);
    begin ImDrawList_ChannelsSplit(@self, channels_count) end;
procedure TImDrawListHelper.ChannelsMerge();
    begin ImDrawList_ChannelsMerge(@self) end;
procedure TImDrawListHelper.ChannelsSetCurrent(channel_index: longint);
    begin ImDrawList_ChannelsSetCurrent(@self, channel_index) end;

{ Advanced }
{ Your rendering function must check for 'UserCallback' in ImDrawCmd and call the function instead of rendering triangles. }
procedure TImDrawListHelper.AddCallback(callback: ImDrawCallback; callback_data: pointer);
    begin ImDrawList_AddCallback(@self, callback, callback_data) end;
{ This is useful if you need to forcefully create a new draw call (to allow for dependent rendering / blending). Otherwise primitives are merged into the same draw-call as much as possible }
procedure TImDrawListHelper.AddDrawCmd();
    begin ImDrawList_AddDrawCmd(@self) end;

{ Internal helpers }
procedure TImDrawListHelper.PrimReserve(idx_count: longint; vtx_count: longint);
    begin ImDrawList_PrimReserve(@self, idx_count, vtx_count) end;
procedure TImDrawListHelper.PrimRect(a: ImVec2; b: ImVec2; col: ImU32);
    begin ImDrawList_PrimRect(@self, a, b, col) end;
procedure TImDrawListHelper.PrimRectUV(a: ImVec2; b: ImVec2; uv_a: ImVec2; uv_b: ImVec2; col: ImU32);
    begin ImDrawList_PrimRectUV(@self, a, b, uv_a, uv_b, col) end;
procedure TImDrawListHelper.PrimQuadUV(a: ImVec2; b: ImVec2; c: ImVec2; d: ImVec2; uv_a: ImVec2; uv_b: ImVec2; uv_c: ImVec2;  uv_d: ImVec2; col: ImU32);
    begin ImDrawList_PrimQuadUV(@self, a, b, c, d, uv_a, uv_b, uv_c,  uv_d, col) end;
procedure TImDrawListHelper.PrimWriteVtx(pos: ImVec2; uv: ImVec2; col: ImU32);
    begin ImDrawList_PrimWriteVtx(@self, pos, uv, col) end;
procedure TImDrawListHelper.PrimWriteIdx(idx: ImDrawIdx);
    begin ImDrawList_PrimWriteIdx(@self, idx) end;
procedure TImDrawListHelper.PrimVtx(pos: ImVec2; uv: ImVec2; col: ImU32);
    begin ImDrawList_PrimVtx(@self, pos, uv, col) end;
procedure TImDrawListHelper.UpdateClipRect();
    begin ImDrawList_UpdateClipRect(@self) end;
procedure TImDrawListHelper.UpdateTextureID();
    begin ImDrawList_UpdateTextureID(@self) end;

end.
