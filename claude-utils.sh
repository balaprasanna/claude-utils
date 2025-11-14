c() {
  # If stdin is a TTY (no pipe), use arguments as the prompt
  if [ -t 0 ]; then
    printf '%s\n' "$*" | claude -p
  else
    # If something is piped in, just forward it to Claude
    cat | claude -p
  fi
}

cfile() {
  local file="$1"
  shift
  local question="$*"

  if [ -z "$file" ] || [ ! -f "$file" ]; then
    echo "Usage: cfile <file> <question...>" >&2
    return 1
  fi

  (
    echo "You are given the following file as context."
    echo "Use this file to answer the question. If the answer is not in the file, say 'Not in file'."
    echo
    echo "===== FILE: $file ====="
    cat "$file"
    echo "===== END FILE ====="
    echo
    echo "Question: $question"
  ) | claude -p
}

cproj() {
  if [ "$#" -lt 2 ]; then
    echo "Usage: cproj <question...> -- <file1> [file2 ...]" >&2
    echo "Example: cproj \"Explain project\" -- README.md notes.txt" >&2
    return 1
  fi

  # Split: everything before -- is question, everything after -- is files
  local question=()
  local files=()
  local seen_sep=0

  for arg in "$@"; do
    if [ "$arg" = "--" ]; then
      seen_sep=1
      continue
    fi
    if [ "$seen_sep" -eq 0 ]; then
      question+=("$arg")
    else
      files+=("$arg")
    fi
  done

  if [ "${#files[@]}" -eq 0 ]; then
    echo "You must provide at least one file after --" >&2
    return 1
  fi

  (
    echo "You are given several project files as context."
    echo "Use ONLY these files to answer the question. If there is not enough info, say 'Not in files'."
    echo

    for f in "${files[@]}"; do
      if [ -f "$f" ]; then
        echo "===== FILE: $f ====="
        cat "$f"
        echo
      else
        echo "===== FILE: $f (missing) ====="
        echo "(File not found on disk)"
        echo
      fi
    done

    echo "===== END OF CONTEXT FILES ====="
    echo
    echo "Question: ${question[*]}"
  ) | claude -p
}


csum() {
  local file="$1"
  if [ -z "$file" ] || [ ! -f "$file" ]; then
    echo "Usage: csum <file>" >&2
    return 1
  fi

  (
    echo "Summarise the following file for me. Focus on key points and actionable items."
    echo
    echo "===== FILE: $file ====="
    cat "$file"
    echo "===== END FILE ====="
  ) | claude -p
}


cpipe() {
  local instruction="$*"

  (
    echo "$instruction"
    echo
    echo "===== INPUT START ====="
    cat
    echo "===== INPUT END ====="
  ) | claude -p
}



