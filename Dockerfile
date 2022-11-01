FROM ubuntu:20.04

WORKDIR /app

RUN apt update && apt install -y sox python3 python3-distutils curl ffmpeg libsox-fmt-mp3

# Install youtube-dl
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py
RUN curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
RUN chmod a+rx /usr/local/bin/yt-dlp
# RUN pip3 install youtube-dl

# Grab a traffic noise video
# RUN yt-dlp -f 'ba' https://www.youtube.com/watch?v=cUpox5jGdRQ --extract-audio --audio-format m4a && \
#     mv *.m4a traffic.m4a

# # Take the first 30 minutes and turn into mp3
# RUN ffmpeg -i traffic.m4a -ss 00:00:00 -to 00:30:00 -c:v copy -c:a libmp3lame -q:a 4 traffic.mp3 && \
#     rm traffic.m4a

# # Create 3sec. segments from the 30 minutes of audio
# RUN mkdir -p segments && \
#     ffmpeg -i traffic.mp3 -f segment -segment_time 3 -c copy segments/traffic_%04d.mp3 && \
#     rm traffic.mp3

COPY data/Noise.wav /app/Noise.wav

# Take the first 30 minutes and turn into mp3
RUN ffmpeg -i Noise.wav -ss 00:00:00 -to 00:30:00 -c:v copy -c:a libmp3lame -q:a 4 Noise.mp3 && \
    rm Noise.wav

# Create 3sec. segments from the 30 minutes of audio
RUN mkdir -p segments && \
    ffmpeg -i Noise.mp3 -f segment -segment_time 2 -c copy segments/Noise_%04d.mp3 && \
    rm Noise.mp3



# Copy the convert script
COPY convert.sh ./

ENTRYPOINT [ "/bin/bash", "convert.sh" ]
