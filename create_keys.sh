#!/bin/bash
gen_key() {
  keytype=$1
  ks="${keytype}_"
  key="keys/ssh_host_${ks}key"
  if [ ! -e "${key}" ] ; then
    if ssh-keygen --help 2>&1 | grep -e '-E ' > /dev/null; then
      ssh-keygen -t ${keytype} -f "${key}" -N '' -E md5 2>&1 | tee keys/keygen.log
    else
      ssh-keygen -t ${keytype} -f "${key}" -N '' 2>&1 | tee keys/keygen.log
    fi
    return $?
  fi
}

mkdir -p keys
gen_key rsa || exit 1
