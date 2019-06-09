# I cannot get credit for this....
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'


# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi


# Paths
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )


# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi



########
############### KevCaz's SETUP
########

### Welcome
# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  /home/kevcaz/.local/{bin,sbin}
  /home/kevcaz/R/r
  /home/kevcaz/Github/Applications/julia/usr/bin
  $path
)
# welcome
source ~/.welcome


############### ALIAS

# New windows of file manager here
alias nw="nautilus -w .&"

# edit zprofile
alias zedit="atom ~/.zprofile"

# dropbox
alias dbox='~/.dropbox-dist/dropboxd &'

# firefox stable
alias fire='snap run firefox &'

# to display hidden files
alias ls='ls -a'

# todolist
alias todo='atom -a ~/Dropbox/_drafts/todo.md'

# Remoote access to my MacOS machine
alias tomac='ssh KevCaz@10.0.1.8'
sendtomac() {
  scp -rp $1 KevCaz@10.0.1.8:${2-./}
}
getfrommac() {
  scp -rp KevCaz@10.0.1.8:$1 $2
}

# Get access to Mp2
alias tomam='ssh kevcaz@dgravel-mp2.ccs.usherbrooke.ca'
# Send something to Mp2
sendtomam() {
  scp -rp $1 kevcaz@dgravel-mp2.ccs.usherbrooke.ca:${2-./}
}
# Get from Mp2
getfrommam() {
  scp -rp kevcaz@dgravel-mp2.ccs.usherbrooke.ca:$1 $2
}




# Searches
# Find processus
alias psgrep='ps aux | grep'
## Search in Zotero database
alias seazot='grep -rnw ~/Zotero/storage/ -e'
## Search in all docs
alias seadoc='grep -rnw /home/kevcaz/ -e'
## Search in installed packages
alias seapkgi='apt-get list --installed | grep'

# Go to Github directories
alias gh='cd ~/Github'
alias gha='cd ~/Github/Applications'
alias ghb='cd ~/Github/Books'
alias ghg='cd ~/Github/Gists'
alias gho='cd ~/Github/Others'
alias ghr='cd ~/Github/Rpackages'
alias ghs='cd ~/Github/Studies'
alias ght='cd ~/Github/Tutorials'
alias ghw='cd ~/Github/Websites'
alias ghm='cd ~/Github/mccannlab'

# Go to
alias gorev='cd ~/Documents/Reviews'
alias gopci='cd ~/Documents/Reviews/PCI'


# change screen and keyboard backlight
alias mysbl='sudo tee /sys/class/backlight/intel_backlight/brightness <<<'
alias mykbl='sudo tee /sys/class/leds/tpacpi::kbd_backlight/brightness <<<'

# open a file
alias pop='xdg-open'
# open tor
alias tor='cd ~/Tor; ./start-tor-browser.desktop'

# open sage
alias sage='~/Github/Applications/sage/sage'

## update debian packages
alias updeb='sudo apt-get update && sudo apt-get upgrade'
## update atom
alias atomup='aria2c https://atom.io/download/deb && sudo dpkg -i atom-amd64.deb && rm atom-amd64.deb'

# R alias
# in order to use little, we need to re-assign r otherwise with zsh it keeps
# repeating the last command.
alias r=/usr/bin/r
## edit Renviron.site
alias renvi='sudo nano /usr/lib/R/etc/Renviron.site'
alias redit='atom ~/.Rprofile'
alias rhome="cd /usr/lib/R"
## update R packages
alias rupdate='sudo Rscript --no-init-file -e "update.packages(ask=FALSE, repos=\"https://cran.wu.ac.at/\")"'

# Websites
## launch my website
alias hukev='ghw && cd KevCaz.github.io && hugo server &; firefox http://localhost:1313/; fg;'
## launch inSileco local website
alias insil='cd ~/Github/Websites/inSileco.github.io; Rscript --no-site-file -e "blogdown::serve_site()"'
## add a new note on my website
newnotes() {
  cd ~/Github/Websites/kevcaz.github.io
  for a in "$@" # Loop over arguments
  do
    hugo new notes/$a
  done
}



######################### FUNCTIONS

# Meteo
meteo() {
  curl wttr.in/$1
}


# Install an R package
rinstall() {
  for pkg in "$@"
  do
    Rscript -e "install.packages('$pkg')"
  done
}

# Search new package
findpkg() {
  apt-cache search $1 | grep $1
}

# Classical git
mygit() {
  git add -A;
  git commit -m "$1";
  git push;
}

# to outBox
outbox() {
  mv $@ ~/Dropbox/outBox/
}

# Get a DOI using crossref https://stackoverflow.com/questions/9354847/concatenate-inputs-in-bash-script
getDOI() {
  request=""
  for a in "$@" # Loop over arguments
  do
    if [[ "${a:0:1}" != "-" ]] # Ignore flags (first character is -)
    then
      if [[ "$request" != "" ]]
      then
        request+="+" # Delimeter
      fi
      request+="$a"
    fi
  done
  firefox "https://search.crossref.org/?q=$request"
}

# Get a ref from a DOI
getRef() {
 firefox http://sci-hub.tw$1
}
# Get a pdf from a DOI
getPdf() {
 wget "$(wget -qO- http://sci-hub.tw/$1 | grep iframe | grep -o 'https*://[^"]*')" -P ~/Downloads
}

## New review
newreview() {
  cd ~/Documents/Reviews;
  cp -r emptyreview $1;
  atom -a $1
}

## Install R packages
rpkg() {
 sudo Rscript --no-init-file  -e "install.packages('$1', repos='https://cran.wu.ac.at/')";
}

## Convert a rmarkdown files
rmdto() {
  Rscript --no-init-file -e "rmarkdown::render('$1', output_format = 'all')";
}

## Convert a file to pdf using pandoc
topdf() {
  pandoc $1 -o ${1%.*}.pdf --bibliography=/home/kevcaz/Dropbox/kevcaz.bib --pdf-engine=pdflatex
}

## Convert a file to pdf using pandoc
todocx() {
  pandoc $1 -o ${1%.*}.docx --bibliography=/home/kevcaz/Dropbox/kevcaz.bib
}


## Convert xlsx or xls to csv files (one per sheet)
tocsv() {
  ssconvert -S $1 %s.csv;
}

## Change extensions
chgext() {
  for file in *.$1
  do
    mv "$file" "${file%.$1}.$2"
  done
}

## Send to trash
junk() {
  mv "$@" ~/.Trash/;
 }
