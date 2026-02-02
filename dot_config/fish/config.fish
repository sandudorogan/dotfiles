#!/usr/bin/fish

# fish_vi_key_bindings

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursor to an underscore
set fish_cursor_replace_one underscore
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block

# Aliases

# # Human readable, coloured list
# function ls
#     command ls -h --color=auto --group-directories-first $argv
# end
# # Default application management
# function ag
#     command sudo apt-get $argv
# end
# # Color grep - highlight desired sequence
# function grep
#     command grep --color=auto $argv
# end
# # Color cat - print file w/ syntax highlighting
# function ccat
#     highlight --out-format=ansi $argv
# end
# # Download video link
# function yt
#     youtube-dlc --add-metadata -ic $argv
# end
# # Download only audio
# function yta
#     youtube-dlc --add-metadata -xlc $argv
# end
#
