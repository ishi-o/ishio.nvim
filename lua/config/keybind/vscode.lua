local command_palette = "workbench.action.showCommands"

local function vscode_call(command, args)
  return function()
    local vscode = require("vscode")
    if args == nil then
      vscode.call(command)
    else
      vscode.call(command, args)
    end
  end
end

local function map(lhs, command, desc, mode, args)
  local mapping = { lhs, vscode_call(command, args), desc = desc }
  if mode ~= nil then
    mapping.mode = mode
  end
  return mapping
end

local function native(lhs, rhs, desc, mode)
  local mapping = { lhs, rhs, desc = desc }
  if mode ~= nil then
    mapping.mode = mode
  end
  return mapping
end

local function command_palette_map(lhs, desc, mode)
  return map(lhs, command_palette, desc, mode)
end

local mappings = {
  native("<C-_>", function()
    require("which-key").show({ global = false })
  end, "Buffer Local Keymaps", { "n", "x", "i", "c", "o", "t" }),

  -- General: buffers
  map("<leader>ee", "workbench.action.files.openFile", "New buffer (input filename)"),
  map("<leader>en", "workbench.action.files.newUntitledFile", "New file"),
  map("[b", "workbench.action.previousEditor", "Goto: prev buffer"),
  map("]b", "workbench.action.nextEditor", "Goto: next buffer"),
  map("<leader>bl", "workbench.action.openPreviousRecentlyUsedEditorInGroup", "Goto: last buffer"),
  map("<leader>bd", "workbench.action.closeActiveEditor", "Delete curr buffer"),
  map("<leader>bC", "workbench.action.files.copyPathOfActiveFile", "Copy curr buffer absolute path"),
  map("<leader>bc", "copyRelativeFilePath", "Copy curr buffer relative path"),
  map("[B", "workbench.action.moveEditorLeftInGroup", "Move buffer left"),
  map("]B", "workbench.action.moveEditorRightInGroup", "Move buffer right"),
  map("H", "workbench.action.previousEditor", "Goto: prev buffer"),
  map("L", "workbench.action.nextEditor", "Goto: next buffer"),
  map("<leader>bH", "workbench.action.closeEditorsToTheLeft", "Delete left buffers"),
  map("<leader>bL", "workbench.action.closeEditorsToTheRight", "Delete right buffers"),
  map("<leader>bo", "workbench.action.closeOtherEditors", "Delete other buffers"),
  map("<leader>bp", "workbench.action.pinEditor", "Toggle: buffer pin"),
  map("<leader>bP", "workbench.action.closeUnmodifiedEditors", "Delete unpinned buffers"),
  map("<leader>bs", "workbench.action.showAllEditors", "Select buffer"),

  -- General: miscellaneous
  native("jj", "<Esc>", "Return to normal mode", "i"),
  native("jj", "<C-c>", "Return to normal mode", "c"),
  map("<leader>w", "workbench.action.files.save", "Save file"),
  map("<leader>z", "workbench.action.quit", "Quit neovim"),

  -- General: tabs
  map("<leader><tab><tab>", "workbench.action.files.openFile", "NewTab (input filename)"),
  map("[<tab>", "workbench.action.previousEditor", "Previous tab"),
  map("]<tab>", "workbench.action.nextEditor", "Next tab"),
  map("<leader><tab>d", "workbench.action.closeActiveEditor", "Delete tab"),
  command_palette_map("<leader><tab>r", "Rename"),

  -- General: UI
  command_palette_map("<leader>ur", "Redraw, Noh, Diff update"),
  map("<leader>ud", "workbench.action.problems.focus", "Toggle diagnostic (virtual lines)"),
  map("<leader>uz", "workbench.action.toggleZenMode", "Toggle zen mode"),
  map("<leader>uZ", "workbench.action.toggleMaximizeEditorGroup", "Toggle zoom mode"),
  map("<leader>uD", "workbench.action.toggleCenteredLayout", "Toggle dim"),
  command_palette_map("<leader>ut", "Toggle indent"),
  command_palette_map("<leader>uS", "Toggle smooth scroll"),
  map("<leader>uc", "workbench.action.toggleLightDarkThemes", "Switch colorscheme (light / dark)"),
  map("<leader>uC", "workbench.action.selectTheme", "Colorschemes"),
  map("<leader>u<tab>", "workbench.action.toggleWindowTabsBar", "Toggle tabline mode (buffers / tabs)"),

  -- General: windows
  map("<leader>V", "workbench.action.splitEditorDown", "Horizontal Split (input filename)"),
  map("<leader>v", "workbench.action.splitEditorRight", "Vertical Split (input filename)"),
  map("<leader>-", "workbench.action.splitEditorDown", "Horizontal Split"),
  map("<leader>|", "workbench.action.splitEditorRight", "Vertical Split"),
  map("<leader>q", "workbench.action.closeActiveEditor", "Delete window"),
  map("<C-h>", "workbench.action.focusLeftGroup", "Focus on the left page"),
  map("<C-j>", "workbench.action.focusBelowGroup", "Focus on the page below"),
  map("<C-k>", "workbench.action.focusAboveGroup", "Focus on the page above"),
  map("<C-l>", "workbench.action.focusRightGroup", "Focus on the right page"),
  map("<A-h>", "workbench.action.decreaseViewWidth", "Window resize left"),
  map("<A-j>", "workbench.action.increaseViewHeight", "Window resize down"),
  map("<A-k>", "workbench.action.decreaseViewHeight", "Window resize up"),
  map("<A-l>", "workbench.action.increaseViewWidth", "Window resize right"),
  map("<leader>H", "workbench.action.moveEditorToLeftGroup", "Window swap left"),
  map("<leader>J", "workbench.action.moveEditorToBelowGroup", "Window swap down"),
  map("<leader>K", "workbench.action.moveEditorToAboveGroup", "Window swap up"),
  map("<leader>L", "workbench.action.moveEditorToRightGroup", "Window swap right"),

  -- Language tooling: completion
  map("<Tab>", "acceptSelectedSuggestion", "Confirm complete", "i"),
  map("<A-k>", "selectPrevSuggestion", "Prev complete item", "i"),
  map("<A-j>", "selectNextSuggestion", "Next complete item", "i"),
  map("<Tab>", "selectPrevSuggestion", "Prev complete item", "c"),
  map("<S-Tab>", "selectNextSuggestion", "Next complete item", "c"),
  map("<C-y>", "editor.action.triggerSuggest", "Toggle: complete panel", { "i", "c" }),

  -- Language tooling: LSP
  map("<F2>", "editor.action.rename", "Rename"),
  map("<leader>rn", "editor.action.rename", "Rename"),
  map("<leader>cr", "editor.action.rename", "Rename"),
  map("<leader>C", "editor.action.codeAction", "Code actions"),
  map("<leader>cc", "editor.action.codeAction", "Code actions"),
  map("<leader>co", "editor.action.organizeImports", "Organize imports"),
  map("<leader>ct", "editor.action.refactor", "Rewrite structure"),
  map("<leader>cf", "editor.action.fixAll", "Fix all"),
  map("gd", "editor.action.revealDefinition", "Goto: definition"),
  map("gi", "editor.action.goToImplementation", "Goto: implementation"),
  map("gr", "editor.action.goToReferences", "Goto: reference"),
  map("gy", "editor.action.goToTypeDefinition", "Goto: type definition"),
  map("gt", "editor.action.goToTypeDefinition", "Goto: type definition"),
  map("gD", "editor.action.goToDeclaration", "Goto: declaration"),
  map("K", "editor.action.showHover", "Show: documentation"),
  map("gK", "editor.action.triggerParameterHints", "Show: signature help"),
  map("gai", "editor.showIncomingCalls", "Show: incoming calls"),
  map("gao", "editor.showOutgoingCalls", "Show: outgoing calls"),

  -- Language tooling: diagnostics
  map("gk", "editor.action.showHover", "Show: diagnostic (float)"),
  map("[e", "editor.action.marker.prev", "Goto: prev error"),
  map("]e", "editor.action.marker.next", "Goto: next error"),
  map("[w", "editor.action.marker.prev", "Goto: prev warning"),
  map("]w", "editor.action.marker.next", "Goto: next warning"),
  map("[d", "editor.action.marker.prev", "Goto: prev diagnostic"),
  map("]d", "editor.action.marker.next", "Goto: next diagnostic"),
  map("[D", "editor.action.marker.prevInFiles", "Goto: prev diagnostic"),
  map("]D", "editor.action.marker.nextInFiles", "Goto: next diagnostic"),
  map("[l", "editor.action.marker.prev", "Goto: prev location"),
  map("]l", "editor.action.marker.next", "Goto: next location"),
  map("[L", "editor.action.marker.prevInFiles", "Goto: prev location"),
  map("]L", "editor.action.marker.nextInFiles", "Goto: next location"),
  map("[q", "editor.action.marker.prev", "Goto: prev quickfix"),
  map("]q", "editor.action.marker.next", "Goto: next quickfix"),
  map("[Q", "editor.action.marker.prevInFiles", "Goto: prev quickfix"),
  map("]Q", "editor.action.marker.nextInFiles", "Goto: next quickfix"),
  map("gQ", "workbench.action.problems.focus", "Show: qflist"),
  map("gL", "workbench.action.problems.focus", "Show: loclist"),

  -- Language tooling: folds
  map("zR", "editor.unfoldAll", "Open all folds"),
  map("zM", "editor.foldAll", "Close all folds"),
  map("zp", "editor.unfold", "Peek folded lines"),

  -- Language tooling: tasks and tests
  map("<F4>", "workbench.action.tasks.build", "Build"),
  map("<F5>", "workbench.action.debug.start", "Build & run"),
  map("<leader>yb", "workbench.action.tasks.build", "Build"),
  map("<leader>yr", "workbench.action.debug.start", "Build & run"),
  map("<leader>yR", "workbench.action.tasks.runTask", "Run"),
  map("<leader>yy", "workbench.action.tasks.showTasks", "Toggle: overseer panel"),
  map("<leader>fy", "workbench.action.tasks.runTask", "Run lists"),
  map("<leader>fY", "workbench.action.tasks.showTasks", "Task actions"),
  command_palette_map("<leader>ta", "Attach to Test (Neotest)"),
  map("<leader>tt", "testing.runCurrentFile", "Run File (Neotest)"),
  map("<leader>tT", "testing.runAll", "Run All Test Files (Neotest)"),
  map("<leader>tr", "testing.runAtCursor", "Run Nearest (Neotest)"),
  map("<leader>tl", "testing.reRunLastRun", "Run Last (Neotest)"),
  map("<leader>ts", "testing.openTesting", "Toggle Summary (Neotest)"),
  map("<leader>to", "testing.openOutputPeek", "Show Output (Neotest)"),
  map("<leader>tO", "testing.showMostRecentOutput", "Toggle Output Panel (Neotest)"),
  map("<leader>tS", "testing.cancelRun", "Stop (Neotest)"),
  map("<leader>tw", "testing.startContinuousRun", "Toggle Watch (Neotest)"),

  -- Enhancements: code map, notifications, and surround
  map("<leader>cmo", "editor.action.toggleMinimap", "Open minimap"),
  map("<leader>cmf", "editor.action.toggleMinimap", "Toggle: minimap focus"),
  map("<leader>cmc", "editor.action.toggleMinimap", "Close minimap"),
  map("<leader>cmm", "editor.action.toggleMinimap", "Toggle: minimap"),
  map("<leader>n", "notifications.showList", "Notification History"),
  map("<leader>fn", "notifications.showList", "Notification History"),
  map("gsa", "editor.action.surroundWithSnippet", "Add Surrounding", { "n", "x" }),
  map("gsd", "editor.action.removeBrackets", "Delete Surrounding"),
  command_palette_map("gsf", "Find Right Surrounding"),
  command_palette_map("gsF", "Find Left Surrounding"),
  command_palette_map("gsh", "Highlight Surrounding"),
  map("gsr", "editor.action.surroundWithSnippet", "Replace Surrounding"),
  command_palette_map("gsn", "Update `MiniSurround.config.n_lines`"),

  -- Enhancements: replace and TODOs
  map("<leader>ss", "workbench.action.replaceInFiles", "Search and Replace", { "n", "x" }),
  map("s", "editor.action.startFindReplaceAction", "Substitute in operator mode"),
  map("ss", "editor.action.startFindReplaceAction", "Substitute curr line"),
  map("S", "editor.action.startFindReplaceAction", "Substitute to eol"),
  map("s", "editor.action.startFindReplaceAction", "Substitute in visual mode", "x"),
  map("]t", "editor.action.marker.next", "Next Todo Comment"),
  map("[t", "editor.action.marker.prev", "Previous Todo Comment"),
  map("]]", "editor.action.wordHighlight.next", "Next Reference", { "n", "t" }),
  map("[[", "editor.action.wordHighlight.prev", "Prev Reference", { "n", "t" }),
  map("<leader>ft", "workbench.action.findInFiles", "Todo"),
  map("<leader>fT", "workbench.action.findInFiles", "Todo/Fix/Fixme"),

  -- Enhancements: find and search
  map("<leader><space>", "workbench.action.quickOpen", "Smart Find Files"),
  map("<leader>,", "workbench.action.showAllEditors", "Buffers"),
  map("<leader>/", "workbench.action.findInFiles", "Grep"),
  map("<leader>:", "workbench.action.showCommands", "Command History"),
  map("<leader>fb", "workbench.action.showAllEditors", "Buffers"),
  map("<leader>fc", "workbench.action.openApplicationSettingsJson", "Find Config File"),
  map("<leader>ff", "workbench.action.quickOpen", "Find Files"),
  map("<leader>fg", "workbench.action.quickOpen", "Find Git Files"),
  map("<leader>fP", "workbench.action.openRecent", "Projects"),
  map("<leader>fr", "workbench.action.openRecent", "Recent"),
  map("<leader>sb", "workbench.action.gotoLine", "Buffer Lines"),
  map("<leader>sB", "workbench.action.findInFiles", "Grep Open Buffers"),
  map("<leader>sg", "workbench.action.findInFiles", "Grep"),
  map("<leader>sw", "actions.findWithSelection", "Visual selection or word", { "n", "x" }),
  command_palette_map('<leader>s"', "Registers"),
  map("<leader>s/", "workbench.action.findInFiles", "Search History"),
  command_palette_map("<leader>sa", "Autocmds"),
  map("<leader>sc", "workbench.action.showCommands", "Command History"),
  map("<leader>sC", "workbench.action.showCommands", "Commands"),
  map("<leader>sd", "workbench.action.problems.focus", "Diagnostics"),
  map("<leader>sD", "workbench.action.problems.focus", "Buffer Diagnostics"),
  command_palette_map("<leader>sh", "Help Pages"),
  command_palette_map("<leader>sH", "Highlights"),
  command_palette_map("<leader>si", "Icons"),
  map("<leader>sj", "workbench.action.navigateBack", "Jumps"),
  map("<leader>sk", "workbench.action.openGlobalKeybindings", "Keymaps"),
  map("<leader>sl", "workbench.action.problems.focus", "Location List"),
  command_palette_map("<leader>sm", "Marks"),
  command_palette_map("<leader>sM", "Man Pages"),
  command_palette_map("<leader>sp", "Search for Plugin Spec"),
  map("<leader>sq", "workbench.action.problems.focus", "Quickfix List"),
  map("<leader>sR", "workbench.action.findInFiles", "Resume"),
  command_palette_map("<leader>su", "Undo History"),

  -- Enhancements: workspace
  map("<leader>fs", "workbench.action.openRecent", "Session"),
  command_palette_map("<leader>Sd", "Delete"),
  command_palette_map("<leader>SD", "DeletePicker"),
  map("<leader>Sr", "workbench.action.openRecent", "Restore"),
  command_palette_map("<leader>Ss", "Save"),

  -- Git
  map("<leader>gg", "workbench.view.scm", "Show: neogit ui"),
  map("<leader>gD", "git.branch", "Diff file against branch"),
  map("<leader>gb", "git.branch", "Git Branches"),
  command_palette_map("<leader>gl", "Git Log"),
  command_palette_map("<leader>gL", "Git Log Line"),
  map("<leader>gs", "workbench.view.scm", "Git Status"),
  map("<leader>gS", "git.stash", "Git Stash"),
  map("<leader>gd", "git.openChange", "Git Diff (Hunks)"),
  command_palette_map("<leader>gf", "Git Log File"),
  command_palette_map("<leader>ghcc", "Close"),
  command_palette_map("<leader>ghce", "Expand"),
  command_palette_map("<leader>ghco", "Open to"),
  command_palette_map("<leader>ghcp", "Pop out"),
  command_palette_map("<leader>ghcz", "Collapse"),
  command_palette_map("<leader>ghip", "Preview"),
  command_palette_map("<leader>ghlt", "Toggle: panel"),
  command_palette_map("<leader>ghpc", "Close"),
  command_palette_map("<leader>ghpd", "Details"),
  command_palette_map("<leader>ghpe", "Expand"),
  command_palette_map("<leader>ghpo", "Open"),
  command_palette_map("<leader>ghpp", "PopOut"),
  command_palette_map("<leader>ghpr", "Refresh"),
  command_palette_map("<leader>ghpt", "Open to"),
  command_palette_map("<leader>ghpz", "Collapse"),
  command_palette_map("<leader>ghrb", "Begin"),
  command_palette_map("<leader>ghrc", "Close"),
  command_palette_map("<leader>ghrd", "Delete"),
  command_palette_map("<leader>ghre", "Expand"),
  command_palette_map("<leader>ghrs", "Submit"),
  command_palette_map("<leader>ghrz", "Collapse"),
  command_palette_map("<leader>ghtc", "Create"),
  command_palette_map("<leader>ghtn", "Next"),
  command_palette_map("<leader>ghtt", "Toggle thread"),
  map("[h", "workbench.action.editor.previousChange", "Prev hunk"),
  map("]h", "workbench.action.editor.nextChange", "Next hunk"),
  map("<leader>hs", "git.diff.stageHunk", "Stage hunk", { "n", "x" }),
  map("<leader>hr", "git.revertChange", "Reset hunk", { "n", "x" }),
  map("<leader>hS", "git.stage", "Stage buffer"),
  map("<leader>hR", "git.clean", "Reset buffer"),
  map("<leader>hu", "git.unstageChange", "Undo stage hunk"),
  map("<leader>hp", "git.openChange", "Preview hunk"),
  map("<leader>hb", "git.blame.toggleEditorDecoration", "Blame line"),
  map("<leader>hB", "git.blame.toggleEditorDecoration", "Blame buffer"),
  map("<leader>hd", "git.openChange", "Diff this"),
  map("<leader>hD", "git.openChange", "Diff line ~"),
  map("ih", "git.openChange", "GitSigns Select Hunk", { "o", "x" }),

  -- Database mappings are buffer-local in Neovim; VS Code exposes the command palette
  -- because it has no corresponding built-in database UI or SQL execution command.
  command_palette_map("<leader>dd", "Database UI"),
  command_palette_map("<leader>dc", "Switch SQL connection"),
  command_palette_map("<leader>db", "Switch SQL database"),
  command_palette_map("<leader>dx", "Execute query", { "n", "x" }),
}

return mappings
