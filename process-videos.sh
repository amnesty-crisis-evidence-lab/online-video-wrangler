#!/bin/bash

CLIP_START=00:00:05
CLIP_END=00:00:10
CLIP_WIDTH=320

STILL_SIZE_LARGE=540x355
STILL_SIZE_SMALL=255x171

###

ORIGINAL_VIDEOS_DIR=./files/videos-originals
RESIZED_CLIPS_DIR=./files/videos-clips

STILLS_ORIGINAL_DIR=./files/stills-originals
STILLS_LARGE_DIR=./files/stills-large
STILLS_SMALL_DIR=./files/stills-small

cd "$(dirname "$0")"

mkdir -p "./files"
mkdir -p "$ORIGINAL_VIDEOS_DIR"

rm -rf "$RESIZED_CLIPS_DIR"
mkdir "$RESIZED_CLIPS_DIR"

rm -rf "$STILLS_ORIGINAL_DIR"
mkdir "$STILLS_ORIGINAL_DIR"

rm -rf "$STILLS_LARGE_DIR"
mkdir "$STILLS_LARGE_DIR"

rm -rf "$STILLS_SMALL_DIR"
mkdir "$STILLS_SMALL_DIR"

while IFS=, read -r filename url start end
do

	if [ ! -z $filename ] && [ ! -z $url ]
	then
		
		# 1. DOWNLOAD VIDEO
		
		if [ ! -f "${ORIGINAL_VIDEOS_DIR}/${filename}" ]
		then
			youtube-dl -f 'bestvideo[ext=mp4][height<=720]/best[ext=mp4]/best' -o "${ORIGINAL_VIDEOS_DIR}/${filename}" $url
		fi
		
		# 2. CREATE TRIMMED AND SCALED CLIP
		
		start_time=$CLIP_START
		end_time=$CLIP_END
		
		if [ ! -z $start ] && [ ! -z $end ]
		then
			start_time=$start
			end_time=$end
		fi
		
		ffmpeg -nostdin -i "${ORIGINAL_VIDEOS_DIR}/${filename}" -an -vcodec libx264 -crf 20 -vf scale="${CLIP_WIDTH}:-2"  -ss $start_time -to $end_time "${RESIZED_CLIPS_DIR}/${filename}"
			
		# 3. CREATE STILLS
		
		thumb_name_original=$(basename "$filename" .mp4).jpg
		thumb_name_large=$(basename "$filename" .mp4)_large.jpg
		thumb_name_small=$(basename "$filename" .mp4)_small.jpg
		
		ffmpeg -nostdin -i "${ORIGINAL_VIDEOS_DIR}/${filename}" -vcodec mjpeg -vframes 1 -an -f rawvideo -ss `ffmpeg -i "${ORIGINAL_VIDEOS_DIR}/${filename}" 2>&1 | grep Duration | awk '{print $2}' | tr -d , | awk -F ':' '{print ($3+$2*60+$1*3600)/2}'` "${STILLS_ORIGINAL_DIR}/${thumb_name_original}"
		convert "${STILLS_ORIGINAL_DIR}/${thumb_name_original}" -resize $STILL_SIZE_LARGE -background black -gravity center -extent $STILL_SIZE_LARGE "${STILLS_LARGE_DIR}/${thumb_name_large}"
		convert "${STILLS_ORIGINAL_DIR}/${thumb_name_original}" -thumbnail $STILL_SIZE_SMALL -background black -gravity center "${STILLS_SMALL_DIR}/${thumb_name_small}"
		
   	fi
done < ./videos.csv
