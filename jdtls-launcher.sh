#!/bin/bash

JDTLS_ROOT="/usr/local/lib/jdtls-launcher/jdtls"
EQUINOX_LAUNCHER="$JDTLS_ROOT/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar"
LOMBOK="$JDTLS_ROOT/plugins/lombok.jar"
WORKSPACE="$HOME/workspace"

SYSTEM=`uname -s`
case "$SYSTEM" in
    [Ll]inux) # Linux and WSL
        CONFIG="$JDTLS_ROOT/config_linux"
        ;;
    [Dd]arwin) # MacOS
        CONFIG="$JDTLS_ROOT/config_mac"
        ;;
    *)
        echo "ERROR: Unknown or unsupported system $SYSTEM" >> /dev/stderr
        echo "Consider opening a new issue: https://github.com/eruizc-dev/jdtls-launcher/issues/new?title=Unsupported%20system%20$SYSTEM" >> /dev/stderr
        exit 1
        ;;
esac

java \
    -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044 \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.level=ALL \
    -noverify \
    -Xmx1G \
    -javaagent:"$LOMBOK" \
    -jar "$EQUINOX_LAUNCHER" \
    -configuration "$CONFIG" \
    -data "$WORKSPACE" \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED
