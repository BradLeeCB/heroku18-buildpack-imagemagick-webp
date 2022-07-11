FROM heroku/heroku:18-build
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  libjpeg-dev libpng-dev libtiff-dev libgif-dev

RUN curl -L http://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.2.tar.gz | tar zx \
  && cd libwebp-1.2.2 \
  && ./configure \
  && make \
  && make install

RUN cd /usr/src/ \
  && wget https://imagemagick.org/archive/ImageMagick-7.1.0-43.tar.gz \
  && tar xf ImageMagick-7.1.0-43.tar.gz \
  && cd ImageMagick-7* \
  && ./configure --with-webp --prefix=/usr/src/imagemagick \
  && make \
  && make install

RUN cp /usr/local/lib/libwebp.so.7 /usr/src/imagemagick/lib

# clean the build area ready for packaging
RUN cd /usr/src/imagemagick \
  && strip lib/*.a lib/lib*.so*

RUN cd /usr/src/imagemagick \
  && rm -rf build \
  && mkdir build \
  && tar czf \
  /usr/src/imagemagick/build/imagemagick.tar.gz bin include lib
