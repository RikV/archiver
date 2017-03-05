#!/usr/bin/env bash

function ssh_fail {
  echo -n "[SSh] "
  case $1 in
    255) echo "Error occurred in SSH ($1)"; ;;
    config) echo "Missing config value, check README!"; ;;
    *)     echo "Dunno...... ($1)"; ;;
  esac
  exit 1
}

function ssh_test {
  ssh -p $port $options -q $user@$host exit || ssh_fail $?
}

function ssh_config {
  basedir=${config_remote_ssh_basedir:-/production/archive}
  host=${config_remote_ssh_host:-null}
  user=${config_remote_ssh_user:-null}
  port=${config_remote_ssh_port:-22}
  options="-o PreferredAuthentications=publickey -o StrictHostKeyChecking=no -o ConnectTimeout=10"

  if [ "$host" == "null" ] || [ "$user" == "null" ] 
  then
    ssh_fail config
  fi   
}

# Arg: path del file 
# Metodo per la copia dei file con il modulo corrente
function ssh_copy {
  # scp non gestisce la creazione in automatico delle dir.. si procede manualmente
  ssh -p $port $user@$host "test -d $basedir/$hostname/$(dirname $1) || mkdir -p $basedir/$hostname/$(dirname $1)"
  # try rsync vai ssh... fallback to scp
  rsync -axP -e "ssh -p $port" $1 $user@$host:$basedir/$hostname/$1 || scp -P $port -p $1 $user@$host:$basedir/$hostname/$1 
}
