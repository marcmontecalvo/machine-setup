#!/usr/bin/env bash

backup_file_once() {
  local file="$1"
  [[ -f "$file" ]] || return 0
  local backup="${file}.machine-setup-backup"
  if [[ ! -e "$backup" ]]; then
    cp -p "$file" "$backup"
    echo "Backed up $file to $backup"
  fi
}

write_file_if_changed() {
  local source="$1" target="$2"
  mkdir -p "$(dirname "$target")"
  if [[ -f "$target" ]] && cmp -s "$source" "$target"; then
    rm -f "$source"
    echo "Unchanged: $target"
    return 0
  fi
  backup_file_once "$target"
  chmod --reference="$target" "$source" 2>/dev/null || true
  mv -f "$source" "$target"
  echo "Updated: $target"
}

replace_managed_block() {
  local file="$1" name="$2" content="$3"
  local start="# >>> machine-setup: ${name} >>>"
  local end="# <<< machine-setup: ${name} <<<"
  local stripped output
  stripped="$(mktemp "${TMPDIR:-/tmp}/machine-setup.XXXXXX")"
  output="$(mktemp "${TMPDIR:-/tmp}/machine-setup.XXXXXX")"

  if [[ -f "$file" ]]; then
    awk -v start="$start" -v end="$end" '
      $0 == start { skip=1; next }
      $0 == end { skip=0; next }
      !skip { print }
    ' "$file" > "$stripped"
  fi

  cat "$stripped" > "$output"
  if [[ -s "$output" ]] && [[ "$(tail -c 1 "$output" 2>/dev/null || true)" != "" ]]; then
    printf '\n' >> "$output"
  fi
  printf '%s\n%s\n%s\n' "$start" "$content" "$end" >> "$output"
  rm -f "$stripped"
  write_file_if_changed "$output" "$file"
}
