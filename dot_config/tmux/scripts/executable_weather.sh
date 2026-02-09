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
    *[Tt]hunder*)                                  ICON=$'\U000F0593' ;;
    *[Ss]now*|*[Bb]lizzard*|*[Ss]leet*|*[Ii]ce*)  ICON=$'\U000F0598' ;;
    *[Rr]ain*|*[Dd]rizzle*|*[Ss]hower*)            ICON=$'\U000F0596' ;;
    *[Ff]og*|*[Mm]ist*|*[Hh]aze*)                  ICON=$'\U000F0591' ;;
    *[Ss]unny*|*[Cc]lear*)                          ICON=$'\U000F0599' ;;
    *[Pp]artly*[Cc]loudy*)                          ICON=$'\U000F0595' ;;
    *[Cc]loudy*|*[Oo]vercast*)                      ICON=$'\U000F0590' ;;
    *)                                              ICON=$'\U000F0590' ;;
esac

echo -n "${ICON}|${TEMP}" > "$CACHE_FILE"

if [[ "$1" == "icon" ]]; then
    echo -n "$ICON"
else
    echo -n "$TEMP"
fi
