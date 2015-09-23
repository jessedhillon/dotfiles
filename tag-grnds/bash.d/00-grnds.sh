# grnds
export GR_USERNAME=jesse.dhillon
export GR_HOME=~/Devel
export IPSEC_SECRETS_FILE=/usr/local/etc/ipsec.secrets
export KEY_SUFFIX=grandroundshealth.com

if [ -d "${GR_HOME}/engineering" ]; then
    PATH="${GR_HOME}/engineering/bin:${PATH}"

    for sh in ${GR_HOME}/engineering/bash/*.sh; do
        source $sh
    done
fi
