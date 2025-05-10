# NAME
       hevc.sh - HEVC Converter
# SYNOPSIS
```bash
hevc.sh [-f] <input> <output>
```
# DESCRIPTION
A simple shell script that converts videos to
[HEVC](https://en.wikipedia.org/wiki/High_Efficiency_Video_Coding)
(High Efficiency Video Coding).
It depenends on the packages [ffmpeg & ffprobe](https://ffmpeg.org/) to produce
HEVC \<output> which is usually **4 times smaller** than \<input>, although the
saving can be reduced to half if \<input> is already in HEVC.

    -f  forces the conversion even if <input> is in HEVC
# AUTHOR
Written by [Musab Albirair](mailto:musabalbirair@gmail.com).
