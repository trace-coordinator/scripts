#!/bin/bash

DEFAULT_LOCAL_FOLDER="/home/ubuntu"
local_folder="${1:-"$DEFAULT_LOCAL_FOLDER"}"

java_installation="$local_folder"/.java
export JAVA_HOME="$java_installation"/jdk-11
if [[ ! "$PATH" =~ "$JAVA_HOME" ]]; then
    echo -e "\n<---------- SET PATH JAVA ---------->\n"
    export PATH="$JAVA_HOME"/bin:$PATH
fi
if [[ ! -d "$java_installation" ]]; then
    echo -e "\n<---------- DOWNLOAD JAVA ---------->\n"
    (
        set -euo pipefail
        mkdir -p "$java_installation"
        cd "$java_installation"
        wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz
        tar xzf openjdk-11+28_linux-x64_bin.tar.gz
    )
fi

export_nvm_dir() {
    export NVM_DIR="$local_folder/.nvm"
}
source_nvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion
}
export_nvm_dir
if [[ -d "$NVM_DIR" ]]; then
    echo -e "\n<---------- UPDATE NVM ---------->\n"
else
    echo -e "\n<---------- INSTALL NVM ---------->\n"
    git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
    cat >"$NVM_DIR"/default-packages <<'EOF'
yarn
syncyarnlock
all-the-package-names
gitpkg
EOF
fi
(
    set -euo pipefail
    cd "$NVM_DIR"
    git fetch --tags origin
    git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
)
source_nvm
if [[ ! -d "$NVM_DIR"/versions/node/"$(nvm ls-remote --lts | tail -1 |
    awk '{ print $2 }' | sed -r "s/\x1b\[([0-9]{1,2}(;[0-9]{1,2})?)?m//g")" ]]; then

    echo -e "\n<---------- INSTALL LATEST NODE LTS ---------->\n"
    nvm install --lts
fi

# if [[ ! -d $local_folder/lttng-traces ]]; then
#     echo -e "\n<---------- COPY TRACES ---------->\n"
#     cp -r ~/lttng-traces/ $local_folder/
# fi
trace_coordinator="$local_folder"/another-trace-coordinator
if [[ -d "$trace_coordinator" ]]; then
    echo -e "\n<---------- UPDATE TRACE-COORDINATOR ---------->\n"
else
    echo -e "\n<---------- DOWNLOAD TRACE-COORDINATOR ---------->\n"
    git clone https://github.com/trace-coordinator/another-trace-coordinator.git "$trace_coordinator"
fi
(
    set -euo pipefail
    cd "$trace_coordinator"
    git pull
    yarn
)

trace_scripts="$local_folder"/trace-server-scripts
if [[ -d "$trace_scripts" ]]; then
    echo -e "\n<---------- UPDATE SCRIPTS ---------->\n"
    (
        cd "$trace_scripts" && git pull
    )
else
    echo -e "\n<---------- DOWNLOAD SCRIPTS ---------->\n"
    git clone https://github.com/trace-coordinator/scripts.git "$trace_scripts"
fi

trace_server="$local_folder"/trace-compass-server
if [[ -d "$trace_server" ]]; then
    echo -e "\n<---------- UPDATE TRACE COMPASS SERVER ---------->\n"
    (
        cd "$trace_server" && git pull
    )
else
    echo -e "\n<---------- DOWNLOAD TRACE COMPASS SERVER ---------->\n"
    git clone https://github.com/trace-coordinator/trace-compass-server-dev-builds.git "$trace_server"
fi

src=". \"$(realpath "$BASH_SOURCE")\""
if [[ ! "$(cat "$HOME"/.bashrc)" =~ "$src" ]]; then
    echo -e "\n<---------- CONFIG .BASHRC ---------->\n"
    echo "$src" >>"$HOME"/.bashrc
fi
