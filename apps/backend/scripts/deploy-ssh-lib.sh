#!/usr/bin/env bash
# Shared helpers for backend deploy scripts (rsync + ssh).
# Auth: set DEPLOY_SSH_PASSWORD for sshpass, OR use SSH keys (no password env).
#
# Optional env:
#   PRIMARY_SERVER   default: qt@172.16.40.61
#   BACKUP_SERVER    default: qt@172.16.40.60
#   BACKEND_DIR      default: ~/zoea-backend

export PRIMARY_SERVER="${PRIMARY_SERVER:-qt@172.16.40.61}"
export BACKUP_SERVER="${BACKUP_SERVER:-qt@172.16.40.60}"
export BACKEND_DIR="${BACKEND_DIR:-~/zoea-backend}"

require_deploy_auth() {
  if [ -n "${DEPLOY_SSH_PASSWORD:-}" ]; then
    command -v sshpass >/dev/null 2>&1 || {
      echo "❌ sshpass is required when DEPLOY_SSH_PASSWORD is set. Install: brew install sshpass (macOS)"
      exit 1
    }
    return 0
  fi
  if ssh -o BatchMode=yes -o ConnectTimeout=12 "$PRIMARY_SERVER" exit 2>/dev/null; then
    return 0
  fi
  echo "❌ Cannot SSH to $PRIMARY_SERVER without a password."
  echo "   Either: export DEPLOY_SSH_PASSWORD='...'"
  echo "   Or:     ssh-copy-id $PRIMARY_SERVER"
  exit 1
}

# Run ssh (password via DEPLOY_SSH_PASSWORD + sshpass -e, or plain ssh)
deploy_ssh() {
  if [ -n "${DEPLOY_SSH_PASSWORD:-}" ]; then
    SSHPASS="$DEPLOY_SSH_PASSWORD" sshpass -e ssh -o StrictHostKeyChecking=accept-new "$@"
  else
    ssh -o StrictHostKeyChecking=accept-new "$@"
  fi
}

# If dist/ was created by Docker as root, rsync cannot update it. When
# DEPLOY_SSH_PASSWORD is set, pipe it to sudo -S (often same as SSH password).
deploy_fix_remote_backend_dist() {
  local server="$1"
  [ -n "${DEPLOY_SSH_PASSWORD:-}" ] || return 0
  command -v sshpass >/dev/null 2>&1 || return 0
  echo "$DEPLOY_SSH_PASSWORD" | SSHPASS="$DEPLOY_SSH_PASSWORD" sshpass -e ssh -o StrictHostKeyChecking=accept-new "$server" \
    'sudo -S bash -c '"'"'set -e; rm -rf "$HOME/zoea-backend/dist"; mkdir -p "$HOME/zoea-backend"; chown -R "$(id -un):$(id -gn)" "$HOME/zoea-backend"'"'"'' \
    2>/dev/null || true
}

# rsync local_dir/ to server:remote_dir/
deploy_rsync_to() {
  local server="$1"
  local local_dir="$2"
  local remote_path="$3"
  local excludes=(
    --exclude 'node_modules'
    --exclude 'dist'
    --exclude '.git'
    --exclude '.DS_Store'
    --exclude '*.log'
    --exclude '.env'
    --exclude 'coverage'
    --exclude '.nyc_output'
  )
  if [ -n "${DEPLOY_SSH_PASSWORD:-}" ]; then
    SSHPASS="$DEPLOY_SSH_PASSWORD" rsync -avz --progress \
      -e "sshpass -e ssh -o StrictHostKeyChecking=accept-new" \
      "${excludes[@]}" \
      "$local_dir/" "${server}:${remote_path}/"
  else
    rsync -avz --progress \
      -e "ssh -o StrictHostKeyChecking=accept-new" \
      "${excludes[@]}" \
      "$local_dir/" "${server}:${remote_path}/"
  fi
}
