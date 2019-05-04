use epm
use re


epm:install github.com/zzamboni/elvish-completions
epm:install github.com/muesli/elvish-libs
epm:install github.com/trieloff/elvish-completions

use github.com/muesli/elvish-libs/theme/powerline

ci = {
try {
  branch = (git rev-parse --abbrev-ref HEAD 2> /dev/null)
  remote = (git config branch.$branch.remote)
  url = (git config remote.$remote.url)
  github = ?(echo $url | grep github.com > /dev/null)
  if $github {
    versioncontrol = "github"
    match = ( re:find ":(.*)/(.*).git" $url )
    owner = $match[groups][1][text]
    project = $match[groups][2][text]
    status = (curl https://circleci.com/api/v1.1/project/$versioncontrol/$owner/$project/tree/$branch"?limit=1" 2> /dev/null | jq -r ".[0].failed" 2> /dev/null )
    if ( ==s $status "true" ) {
      edit:styled "CI ⨯" "red"
    } elif ( ==s $status "false" ) {
      edit:styled "CI ✓" "green"
    } else {
      edit:styled "CI …" "lightgray"️
    }
  }
} except err {
  put ""️
}
}

powerline:rprompt-segments = [ $ci "git-dirty" "git-ahead" "git-behind" ]
powerline:prompt-segments = [ "dir" "git-branch" ]

paths = [ $@paths /usr/local/bin ]


# alias for ls
fn ls [@_args]{ exa $@_args }

use github.com/zzamboni/elvish-completions/git
use github.com/trieloff/elvish-completions/npx
use github.com/trieloff/elvish-completions/npm
use github.com/trieloff/elvish-completions/wsk


set-env EDITOR micro

clear