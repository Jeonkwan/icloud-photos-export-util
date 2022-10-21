#!/usr/bin/env bash

export DIR_NAME_TEMPLATE="{created.year}/{created.month}"
export FILE_NAME_TEMPLATE="[{created.strftime,%Y-%m-%d}][{created.strftime,%H_%M_%S}]{place.country_code?[{place.country_code}],[]}{place.name.city?[{place.name.city}],[]}{exif.camera_model?[{exif.camera_model}],[]}{edited?[EDITED],[ORIGINAL]}"
export FILE_NAME_TEMPLATE_WITH_SHORT_UUID="[{created.strftime,%Y-%m-%d}][{created.strftime,%H_%M_%S}][{shortuuid}]{place.country_code?[{place.country_code}],[]}{place.name.city?[{place.name.city}],[]}{exif.camera_model?[{exif.camera_model}],[]}{edited?[EDITED],[ORIGINAL]}"


get_year_range_flag() {
    local TARGET_YEAR=$1
    echo "--year $TARGET_YEAR"
}

get_season_range_flag() {
    local YEAR=$1
    local SEASON=$2
    local SEASON_RANGE_FLAG=""

    local FIRST="--from-date \"${YEAR}-01-01\" --to-date \"${YEAR}-03-31\""
    local SECOND="--from-date \"${YEAR}-04-01\" --to-date \"${YEAR}-06-30\""
    local THIRD="--from-date \"${YEAR}-07-01\" --to-date \"${YEAR}-09-30\""
    local FOURTH="--from-date \"${YEAR}-10-01\" --to-date \"${YEAR}-12-31\""

    [[ $SEASON -eq 1 ]] && { echo "$FIRST"; return 0; }
    [[ $SEASON -eq 2 ]] && { echo "$SECOND"; return 0; }
    [[ $SEASON -eq 3 ]] && { echo "$THIRD"; return 0; }
    [[ $SEASON -eq 4 ]] && { echo "$FOURTH"; return 0; }
}

photos_export() {
    local TARGET_DIR=$1
    local RANGE_FLAG=$2
    local OUTPUT_DIR_TEMPLATE=$3
    local OUTPUT_NAME_TEMPLATE=$4

    [[ -d "$TARGET_DIR" ]] && { echo "Directory $TARGET_DIR exists."; } || { echo "Error: Directory /path/to/dir does not exists."; return 1; }

    { which osxphotos; } || { echo "EXIT. osxphotos NOT FOUND."; return 1; }
    osxphotos export $TARGET_DIR \
        $RANGE_FLAG \
        --directory $OUTPUT_DIR_TEMPLATE \
        --filename $OUTPUT_NAME_TEMPLATE \
        --edited-suffix "" \
        --skip-original-if-edited \
        --download-missing \
        --retry 5 \
        --update \
        --cleanup
} 

export_by_year() {
    local TARGET_DIR=$1
    local YEAR=$2

    YEAR_RANGE_FLAG=$(get_year_range_flag $YEAR)
    photos_export $TARGET_DIR $YEAR_RANGE_FLAG $DIR_NAME_TEMPLATE $FILE_NAME_TEMPLATE
}

export_by_year_season() {
    local TARGET_DIR=$1
    local YEAR=$2
    local SEASON=$3

    SEASON_RANGE_FLAG=$(get_season_range_flag $YEAR $SEASON)
    photos_export $TARGET_DIR $SEASON_RANGE_FLAG $DIR_NAME_TEMPLATE $FILE_NAME_TEMPLATE
}
