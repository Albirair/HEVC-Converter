#!/usr/bin/env sh
SOURCE=
DESTINATION=
FORCE=false
for CLA in "$@"; do
	if [ "$CLA" = "-f" ]; then
		FORCE=true
	elif [ -z "$SOURCE" ]; then
		SOURCE=$CLA
	else
		DESTINATION=$CLA
	fi
done
# Check if input & output files were specified
if [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]; then
	printf "usage: hevc.sh [-f] <input> <output>\nwhere -f forces the \
conversion even if <input> is in HEVC\n"
	exit 1
fi
# Check if the output exists
if [ -e "$DESTINATION" ]; then
	echo "\033[1;94m$DESTINATION already exists\033[0m"
	exit 2
fi
# Check if the input is a video file
if [ -f "$SOURCE" ] && file -b --mime-type "$SOURCE" | grep -q 'video'; then
	# Check if the video codec is not HEVC (H.265)
	if $FORCE || ! ffprobe -v error -select_streams v:0 -show_entries \
		stream=codec_name -of default=noprint_wrappers=1:nokey=1 \
		"$SOURCE" | grep -q "hevc"; then
		# Convert the video file to HEVC using ffmpeg
		ffmpeg -analyzeduration 2147483647 -probesize 2147483647 -i "$SOURCE" \
			-map 0 -c:v libx265 -c:a copy -c:s copy -c:d copy -c:t copy \
			-map_metadata 0 -n "$DESTINATION"
		# Check if the video has been converted
		if [ $? -ne 0 ]; then
			echo "\033[1;93mfailed to convert $SOURCE to HEVC\033[0m"
			exit 3
		fi
		touch -r "$SOURCE" "$DESTINATION"
		echo "\033[1;92mConverted $SOURCE to HEVC: $DESTINATION\033[0m"
	else
		echo "\033[1;95mSkipping $SOURCE as it is already in HEVC\033[0m"
		exit 4
	fi
else
	echo "\033[1;91m$SOURCE isn't video\033[0m"
	exit 5
fi