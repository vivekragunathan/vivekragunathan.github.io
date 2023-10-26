---
title: Keep Killing It
author: higherkindedtype
layout: post
url: /posts/keep-killing
date: 2023-10-26
tags: [ 'bash', 'pkill' ]
summary: |
  There are times when even decent chaps have to pick up the sword and fight. I am talking about times when some process on your machine is always peeking over your shoulder. Worst part, consumes a lot of resources, especially CPU time, and obstructs your productivity. Or peace of mind. For such cases, I give you `slay`

---

There are times when even decent chaps have to pick up the sword and fight. I am talking about times when some process on your machine is always peeking over your shoulder. Worst part, consumes a lot of resources, especially CPU time, and obstructs your productivity. Or peace of mind.

For such cases, I give you `slay.sh` - a little script which looks for a process by its name and keeps killing it.

```bash
#!/usr/bin/env bash

screen_width () {
  tput cols
}

patch_spaces_needed () {
  local columns
  columns="$(screen_width)"
  echo "$((columns - ${#1}))"
}

render_msg () {
  num_spaces="$(patch_spaces_needed "$1")"
  printf -v trailing "%0.s " $(seq 1 "$num_spaces")
  echo >&2 -ne "${1}$trailing\r"
}

kill_process_by_name () {
  local process_name="$1"

  if [[ -z "$process_name" ]]; then
    render_msg "Process name to terminate not specified"
  elif pgrep -x "$process_name" >/dev/null; then
    render_msg "Process '$process_name' is running. Killing..."
    sudo pkill -x "$process_name"
  else
    render_msg "Process '$process_name' is not running."
  fi
}

keep_killing_process_by_name () {
  local process_name="$1"
  local interval="${2:-5}"

  while true; do
    kill_process_by_name "$process_name"
    sleep "$interval"
  done
  echo
}
```

If you would like to keep killing that monitoring daemon, _one that monitors you_, you just call this:

```bash
keep_killing_process_by_name "<process-monitoring-me>" # default interval to check = 5 seconds
```
