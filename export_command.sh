#!/usr/bin/env bash

export DIR_NAME_TEMPLATE="{created.year}/{created.month}"
export FILE_NAME_TEMPLATE="[{created.strftime,%Y-%m-%d}][{created.strftime,%H_%M_%S}]{place.country_code?[{place.country_code}],[]}{place.name.city?[{place.name.city}],[]}{exif.camera_model?[{exif.camera_model}],[]}{edited?[EDITED],[ORIGINAL]}"
export FILE_NAME_TEMPLATE_WITH_SHORT_UUID="[{created.strftime,%Y-%m-%d}][{created.strftime,%H_%M_%S}][{shortuuid}]{place.country_code?[{place.country_code}],[]}{place.name.city?[{place.name.city}],[]}{exif.camera_model?[{exif.camera_model}],[]}{edited?[EDITED],[ORIGINAL]}"

photos_export() {
    set -x
    
    { which osxphotos; } || { echo "EXIT. osxphotos NOT FOUND."; return 1; }

    local TARGET_DIR=$1
    local YEAR=$2
    local SEASON=$3

    local OUTPUT_DIR_TEMPLATE=$DIR_NAME_TEMPLATE
    local OUTPUT_NAME_TEMPLATE=$FILE_NAME_TEMPLATE

    [[ -d "$TARGET_DIR" ]] && { echo "Directory $TARGET_DIR exists."; } || { echo "Error: Directory /path/to/dir does not exists."; return 1; }

    if [ -z "$SEASON" ]; then
        echo "\$SEASON is empty. Export by Year."
        osxphotos export $TARGET_DIR \
            --year $YEAR \
            --directory "$OUTPUT_DIR_TEMPLATE" \
            --filename "$OUTPUT_NAME_TEMPLATE" \
            --edited-suffix "" \
            --skip-original-if-edited \
            --download-missing \
            --retry 5 \
            --update \
            --cleanup
    else
        echo "\$SEASON is provided. Export by Year Season."
        [[ $SEASON -eq 1 ]] && { FROM_DATE="${YEAR}-01-01"; TO_DATE="${YEAR}-03-31"; }
        [[ $SEASON -eq 2 ]] && { FROM_DATE="${YEAR}-04-01"; TO_DATE="${YEAR}-06-30"; }
        [[ $SEASON -eq 3 ]] && { FROM_DATE="${YEAR}-07-01"; TO_DATE="${YEAR}-09-30"; }
        [[ $SEASON -eq 4 ]] && { FROM_DATE="${YEAR}-10-01"; TO_DATE="${YEAR}-12-31"; }
        osxphotos export $TARGET_DIR \
            --from-date "${FROM_DATE}" \
            --to-date "${TO_DATE}" \
            --directory "$OUTPUT_DIR_TEMPLATE" \
            --filename "$OUTPUT_NAME_TEMPLATE" \
            --edited-suffix "" \
            --skip-original-if-edited \
            --download-missing \
            --retry 5 \
            --update \
            --cleanup
    fi
    set +x
} 
