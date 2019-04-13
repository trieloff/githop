use epm
epm:install github.com/muesli/elvish-libs
use github.com/muesli/elvish-libs/theme/powerline
powerline:rprompt-segments = [ "git-dirty" "git-ahead" "git-behind" ]
powerline:prompt-segments = [ "dir" "git-branch" ]

paths = [ $@paths /usr/local/bin ]


# alias for ls
fn ls [@_args]{ exa $@_args }

clear