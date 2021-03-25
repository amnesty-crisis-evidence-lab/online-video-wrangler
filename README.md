# online-video-wrangler

# Detailed instructions

Can be found [here](https://docs.google.com/document/d/e/2PACX-1vQd9v5U2doMwskQtkqBlwpUL0jM9Jua6I6tylan4slngL27cuX3h1ogv54u1IxCV8wjrmaltDFk2DQ_/pub#h.x0gh668ct9ab]).

# Quick instructions

## Install software 

Install Homebrew 
[brew.sh](https://brew.sh)

Install FFMPEG
```	
brew install ffmpeg
```

Install ImageMagick
```	
brew install imagemagick
```

Install youtube-dl
```
brew install youtube-dl
```

## Edit videos.csv with the videos to download

- Column 1: filename
- Column 2: url
- Column 3: trim start (optional per video to override CLIP_START, see below)
- Column 3: trim start (optional per video to override CLIP_END, see below)

## Edit process-videos.sh configuration

Edit the variables at the top of the script
- CLIP_START: Start timestamp
- CLIP_END: End timestamp
- CLIP_WIDTH: Width of clip
- STILL_SIZE_LARGE: Dimensions for the large thumbnail (Resulting image will be exactly this size, centered and letterboxed)
- STILL_SIZE_SMALL: Dimensions for the small thumbnail (Resulting image will be scaled down to fit within this size)

## Run the script

Open the terminal to this directory and run

```
bash process-videos.sh
```