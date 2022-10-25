#!/usr/bin/env bash

export FILE_NAME_TEMPLATE="[{created.strftime,%Y-%m-%d}][{created.strftime,%H_%M_%S}]{place.country_code?[{place.country_code}],[]}{place.name.city?[{place.name.city}],[]}{exif.camera_model?[{exif.camera_model}],[]}{edited?[EDITED],[ORIGINAL]}"
export FILE_NAME_TEMPLATE_WITH_SHORT_UUID="[{created.strftime,%Y-%m-%d}][{created.strftime,%H_%M_%S}][{shortuuid}]{place.country_code?[{place.country_code}],[]}{place.name.city?[{place.name.city}],[]}{exif.camera_model?[{exif.camera_model}],[]}{edited?[EDITED],[ORIGINAL]}"

get_last_day_of_month() {
    local MONTH=$1
    local YEAR=$2
    cal $MONTH $YEAR | awk 'NF {DAYS = $NF}; END {print DAYS}'
}

photos_export() {
    set -x
    
    { which osxphotos; } || { echo "EXIT. osxphotos NOT FOUND."; return 1; }

    local TARGET_DIR=$1
    local YEAR=$2
    local SEASON=$3
    local SPLIT_BY_MONTH=$4

    local OUTPUT_DIR_TEMPLATE="{created.mm}-{created.month}"
    local OUTPUT_NAME_TEMPLATE=$FILE_NAME_TEMPLATE
    local EXPORT_DIR
    local REPORT_PATH

    [[ -d "$TARGET_DIR" ]] && { echo "Directory $TARGET_DIR exists."; } || { echo "Error: Directory /path/to/dir does not exists."; return 1; }

    if [ -z "$SEASON" ]; then
        echo "\$SEASON is empty. Export by Year."
        local EXPORT_DIR=$TARGET_DIR/${YEAR}
        REPORT_PATH=$TARGET_DIR/${YEAR}-report.csv
        mkdir -p $EXPORT_DIR
        osxphotos export $EXPORT_DIR \
            --year $YEAR \
            --directory "$OUTPUT_DIR_TEMPLATE" \
            --filename "$OUTPUT_NAME_TEMPLATE" \
            --edited-suffix "" \
            --skip-original-if-edited \
            --download-missing \
            --use-photokit \
            --retry 5 \
            --update \
            --cleanup \
            --report $REPORT_PATH
    else
        echo "\$SEASON is provided. Export by Year Season."
        [[ $SEASON -eq 1 ]] && { FROM_MONTH="01"; TO_MONTH="03"; }
        [[ $SEASON -eq 2 ]] && { FROM_MONTH="04"; TO_MONTH="06"; }
        [[ $SEASON -eq 3 ]] && { FROM_MONTH="07"; TO_MONTH="09"; }
        [[ $SEASON -eq 4 ]] && { FROM_MONTH="10"; TO_MONTH="12"; }
        local FROM_DATE="${YEAR}-${FROM_MONTH}-01"
        local TO_MONTH_LAST_DAY="$(get_last_day_of_month $TO_MONTH $YEAR)"
        local TO_DATE="${YEAR}-${TO_MONTH}-${TO_MONTH_LAST_DAY}"
        local EXPORT_DIR=$TARGET_DIR/${YEAR}-Season-${SEASON}
        REPORT_PATH=$TARGET_DIR/${YEAR}-Season-${SEASON}-report.csv
        mkdir -p $EXPORT_DIR
        if [[ -z "$SPLIT_BY_MONTH" ]]; then
            osxphotos export $EXPORT_DIR \
                --from-date "${FROM_DATE}" \
                --to-date "${TO_DATE}" \
                --directory "$OUTPUT_DIR_TEMPLATE" \
                --filename "$OUTPUT_NAME_TEMPLATE" \
                --edited-suffix "" \
                --skip-original-if-edited \
                --download-missing \
                --use-photokit \
                --retry 5 \
                --update \
                --cleanup \
                --report $REPORT_PATH
        fi
        if [[ "$SPLIT_BY_MONTH" == "split" ]]; then
            echo "Split by Month mode. Iterate each month for season $SEASON"
            for month in $(seq $((10#$FROM_MONTH)) $((10#$TO_MONTH))); do
                local each_month=$(printf "%02d\n" $month)
                local from_date="${YEAR}-${each_month}-01"
                local each_month_last_day="$(get_last_day_of_month $each_month $YEAR)"
                local to_date="${YEAR}-${each_month}-${each_month_last_day}"
                osxphotos export $EXPORT_DIR \
                    --from-date "${from_date}" \
                    --to-date "${to_date}" \
                    --directory "$OUTPUT_DIR_TEMPLATE" \
                    --filename "$OUTPUT_NAME_TEMPLATE" \
                    --edited-suffix "" \
                    --skip-original-if-edited \
                    --download-missing \
                    --use-photokit \
                    --retry 5 \
                    --update \
                    --cleanup \
                    --report $REPORT_PATH
            done
        fi
    fi
    set +x
} 
