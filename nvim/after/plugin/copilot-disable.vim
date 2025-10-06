" Disable the old copilot.vim plugin to prevent conflicts with copilot.lua
" This prevents the range errors caused by multiple Copilot implementations

" Completely disable the old copilot.vim plugin
let g:copilot_enabled = 0
let g:copilot_filetypes = {}
let g:copilot_no_maps = 1
let g:copilot_assume_mapped = 1

" Disable all copilot.vim functionality
if exists('g:loaded_copilot')
  unlet g:loaded_copilot
endif

" Disable any auto-commands from the old plugin
augroup CopilotDisable
  autocmd!
  " Remove any existing copilot autocmds
  autocmd!
augroup END

" Unload any loaded copilot functions
if exists('*copilot#Enable')
  delfunction copilot#Enable
endif
if exists('*copilot#Disable')
  delfunction copilot#Disable
endif

" Clear any existing copilot commands
if exists(':Copilot')
  delcommand Copilot
endif
if exists(':CopilotAuth')
  delcommand CopilotAuth
endif
if exists(':CopilotDisable')
  delcommand CopilotDisable
endif
if exists(':CopilotEnable')
  delcommand CopilotEnable
endif
if exists(':CopilotLog')
  delcommand CopilotLog
endif
if exists(':CopilotPanel')
  delcommand CopilotPanel
endif
if exists(':CopilotStatus')
  delcommand CopilotStatus
endif
