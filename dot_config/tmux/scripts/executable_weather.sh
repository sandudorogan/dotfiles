#!/usr/bin/env bash

CACHE_FILE="/tmp/tmux-weather-${USER}"
CACHE_TTL=1800

LOCATION=$(tmux show-option -gqv @weather_location 2>/dev/null)
[[ -z "$LOCATION" ]] && exit 0

read_cache() {
    [[ ! -f "$CACHE_FILE" ]] && return 1
    local cached
    cached=$(cat "$CACHE_FILE")
    if [[ "$1" == "icon" ]]; then
        echo -n "${cached%%|*}"
    else
        echo -n "${cached##*|}"
    fi
}

if [[ -f "$CACHE_FILE" ]]; then
    cache_age=$(( $(date +%s) - $(stat -f%m "$CACHE_FILE") ))
    if (( cache_age < CACHE_TTL )); then
        read_cache "$1"
        exit 0
    fi
fi

RAW=$(curl -sf --max-time 5 "wttr.in/${LOCATION// /%20}?format=%C|%t" 2>/dev/null)
if [[ -z "$RAW" ]]; then
    read_cache "$1"
    exit 0
fi

CONDITION="${RAW%%|*}"
TEMP="${RAW##*|}"
TEMP="${TEMP#+}"
TEMP="${TEMP// /}"

case "$CONDITION" in
    *[Tt]hunder*)                                  ICON=$'\ue31d' ;;
    *[Ss]now*|*[Bb]lizzard*|*[Ss]leet*|*[Ii]ce*)  ICON=$'\ue31a' ;;
    *[Rr]ain*|*[Dd]rizzle*|*[Ss]hower*)            ICON=$'\ue318' ;;
    *[Ff]og*|*[Mm]ist*|*[Hh]aze*)                  ICON=$'\ue313' ;;
    *[Ss]unny*|*[Cc]lear*)                          ICON=$'\ue30d' ;;
    *[Pp]artly*[Cc]loudy*)                          ICON=$'\ue302' ;;
    *[Cc]loudy*|*[Oo]vercast*)                      ICON=$'\ue312' ;;
    *)                                              ICON=$'\ue312' ;;
esac

echo -n "${ICON}|${TEMP}" > "$CACHE_FILE"

if [[ "$1" == "icon" ]]; then
    echo -n "$ICON"
else
    echo -n "$TEMP"
fi
