#!/bin/bash

  _nowhere="$(dirname "$PWD")"
  source "$_nowhere/proton_tkg_token" || source "$_nowhere/src/proton_tkg_token"

  cd "$_nowhere"/Proton

  git clone https://gitlab.freedesktop.org/gstreamer/orc.git gst-orc || true # It'll complain the path already exists on subsequent builds
  cd gst-orc
  git reset --hard HEAD
  git clean -xdf
  git checkout 9901a96
  cd ..

  git clone https://gitlab.freedesktop.org/gstreamer/gstreamer.git || true # It'll complain the path already exists on subsequent builds
  cd gstreamer
  git reset --hard HEAD
  git clean -xdf
  git checkout eacb7aa
  cd ..

  git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git || true # It'll complain the path already exists on subsequent builds
  cd gst-plugins-base
  git reset --hard HEAD
  git clean -xdf
  git checkout ce69d10
  cd ..

  git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git || true # It'll complain the path already exists on subsequent builds
  cd gst-plugins-good
  git reset --hard HEAD
  git clean -xdf
  git checkout 941312f
  cd ..

  git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git || true # It'll complain the path already exists on subsequent builds
  cd gst-plugins-bad
  git reset --hard HEAD
  git clean -xdf
  git checkout 8cb03bd
  cd ..

  git clone https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git || true # It'll complain the path already exists on subsequent builds
  cd gst-plugins-ugly
  git reset --hard HEAD
  git clean -xdf
  git checkout bb3f9de20025820fb1c913f96e31cf0a27528bcc
  cd ..

  git clone https://gitlab.freedesktop.org/gstreamer/gst-libav.git || true # It'll complain the path already exists on subsequent builds
  cd gst-libav
  git reset --hard HEAD
  git clean -xdf
  git checkout e896aabe3c3d278510fb567712c4a55ed0eae075
  cd ..

  git clone https://gitlab.freedesktop.org/gstreamer/meson-ports/ffmpeg.git || true # It'll complain the path already exists on subsequent builds
  cd ffmpeg
  git reset --hard HEAD
  git clean -xdf
  git checkout 31efd11
  cd ..

  if [ "$_build_faudio" = "true" ]; then
    git clone https://github.com/FNA-XNA/FAudio.git || true # It'll complain the path already exists on subsequent builds
    cd FAudio
    git reset --hard HEAD
    git clean -xdf
    git pull origin master
    cd ..
    rm -rf FAudio32 && cp -R FAudio FAudio32
    rm -rf "$_nowhere"/Proton/build/faudio*
  fi

  rm -rf "$_nowhere"/Proton/build/gst*

  ##### 64

  # If /usr/lib32 doesn't exist (such as on Fedora), make sure we're using /usr/lib64 for 64-bit pkgconfig path
  if [ ! -d '/usr/lib32' ]; then
    export PKG_CONFIG_PATH="$_proton_tkg_path/gst/lib64/pkgconfig:/usr/lib64/pkgconfig"
  else
    export PKG_CONFIG_PATH="$_proton_tkg_path/gst/lib64/pkgconfig"
  fi

  # orc
  cd "$_nowhere"/Proton/gst-orc
  mkdir -p "$_nowhere"/Proton/build/gst-orc64
  meson "$_nowhere"/Proton/build/gst-orc64 --prefix="$_nowhere/gst" \
	--libdir="lib64" \
	--buildtype=plain \
	-Dorc-test=disabled \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dgtk_doc=disabled \
	-Dbenchmarks=disabled

  ninja -C "$_nowhere"/Proton/build/gst-orc64 install

  # gst
  cd "$_nowhere"/Proton/gstreamer
  mkdir -p "$_nowhere"/Proton/build/gst64
  meson "$_nowhere"/Proton/build/gst64 --prefix="$_nowhere/gst" \
	--libdir="lib64" \
	--buildtype=plain \
	-Dpkg_config_path=$_nowhere/gst/lib64/pkgconfig \
	-Dgst_parse=false \
	-Dbenchmarks=disabled \
	-Dtools=disabled \
	-Dbash-completion=disabled \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dgtk_doc=disabled \
	-Dintrospection=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dnls=disabled \
	-Dbenchmarks=disabled

  ninja -C "$_nowhere"/Proton/build/gst64 install

  # gst plugins-base
  cd "$_nowhere"/Proton/gst-plugins-base
  patch -Np1 < "$_nowhere"/proton-tkg-userpatches/gstreamer-base
  mkdir -p "$_nowhere"/Proton/build/gstbase64
  meson "$_nowhere"/Proton/build/gstbase64 --prefix="$_nowhere/gst" \
	--libdir="lib64" \
	--buildtype=plain \
	-Dpkg_config_path=$_nowhere/gst/lib64/pkgconfig \
	-Dalsa=disabled \
	-Daudiomixer=disabled \
	-Daudiorate=disabled \
	-Daudiotestsrc=disabled \
	-Dcdparanoia=disabled \
	-Dcompositor=disabled \
	-Dencoding=disabled \
	-Dgio=disabled \
	-Dgl=disabled \
	-Dlibvisual=disabled \
	-Doverlaycomposition=disabled \
	-Dpango=disabled \
	-Drawparse=disabled \
	-Dsubparse=disabled \
	-Dtcp=disabled \
	-Dtremor=disabled \
	-Dvideorate=disabled \
	-Dvideotestsrc=disabled \
	-Dvolume=disabled \
	-Dx11=disabled \
	-Dxshm=disabled \
	-Dxvideo=disabled \
	-Dtools=disabled \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dintrospection=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dnls=disabled

  ninja -C "$_nowhere"/Proton/build/gstbase64 install

  # gst plugins good
  cd "$_nowhere"/Proton/gst-plugins-good
  mkdir -p "$_nowhere"/Proton/build/gstgood64
  meson "$_nowhere"/Proton/build/gstgood64 --prefix="$_nowhere/gst" \
	--libdir="lib64" \
	--buildtype=plain \
	-Dpkg_config_path=$_nowhere/gst/lib64/pkgconfig \
	-Daalib=disabled \
	-Dalpha=disabled \
	-Dapetag=disabled \
	-Daudiofx=disabled \
	-Dauparse=disabled \
	-Dcairo=disabled \
	-Dcutter=disabled \
	-Ddtmf=disabled \
	-Deffectv=disabled \
	-Dequalizer=disabled \
	-Dgdk-pixbuf=disabled \
	-Dgtk3=disabled \
	-Dgoom=disabled \
	-Dgoom2k1=disabled \
	-Dicydemux=disabled \
	-Dimagefreeze=disabled \
	-Dinterleave=disabled \
	-Djack=disabled \
	-Dlaw=disabled \
	-Dlevel=disabled \
	-Dlibcaca=disabled \
	-Dmonoscope=disabled \
	-Dmultifile=disabled \
	-Dmultipart=disabled \
	-Doss=disabled \
	-Doss4=disabled \
	-Dpng=disabled \
	-Dpulse=disabled \
	-Dqt5=disabled \
	-Dreplaygain=disabled \
	-Drtp=disabled \
	-Drtpmanager=disabled \
	-Drtsp=disabled \
	-Dshapewipe=disabled \
	-Dshout2=disabled \
	-Dsmpte=disabled \
	-Dsoup=disabled \
	-Dspectrum=disabled \
	-Dtaglib=disabled \
	-Dudp=disabled \
	-Dv4l2=disabled \
	-Dvideocrop=disabled \
	-Dvideomixer=disabled \
	-Dwavenc=disabled \
	-Dximagesrc=disabled \
	-Dy4m=disabled \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dnls=disabled

  ninja -C "$_nowhere"/Proton/build/gstgood64 install

  # gst plugins bad
  cd "$_nowhere"/Proton/gst-plugins-bad
  patch -Np1 < "$_nowhere"/proton-tkg-userpatches/gstreamer-bad
  mkdir -p "$_nowhere"/Proton/build/gstbad64
  meson "$_nowhere"/Proton/build/gstbad64 --prefix="$_nowhere/gst" \
	--libdir="lib64" \
	--buildtype=plain \
	-Dpkg_config_path=$_nowhere/gst/lib64/pkgconfig \
	-Dfbdev=disabled \
	-Ddecklink=disabled \
	-Ddts=disabled \
	-Dfaac=disabled \
	-Dfaad=disabled \
	-Dlibmms=disabled \
	-Dmpeg2enc=disabled \
	-Dmplex=disabled \
	-Dneon=disabled \
	-Drtmp=disabled \
	-Dflite=disabled \
	-Dvulkan=disabled \
	-Dsbc=disabled \
	-Dopencv=disabled \
	-Dvoamrwbenc=disabled \
	-Dx265=disabled \
	-Dopenexr=disabled \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dintrospection=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dnls=disabled

  ninja -C "$_nowhere"/Proton/build/gstbad64 install

  # gst plugins ugly
  cd "$_nowhere"/Proton/gst-plugins-ugly
  patch -Np1 < "$_nowhere"/proton-tkg-userpatches/gstreamer-ugly
  mkdir -p "$_nowhere"/Proton/build/gstugly64
  meson "$_nowhere"/Proton/build/gstugly64 --prefix="$_nowhere/gst" \
	--libdir="lib64" \
	--buildtype=plain \
	-Dpkg_config_path=$_nowhere/gst/lib64/pkgconfig \
	-Dgobject-cast-checks='disabled' \
	-Dglib-asserts='disabled' \
	-Dglib-checks='disabled' \
	-Ddoc='disabled' \
	-Dtests=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled \
	-Dnls=disabled

  ninja -C "$_nowhere"/Proton/build/gstugly64 install

  # gst libav
  mkdir -p "$_nowhere"/Proton/gst-libav/subprojects
  ln -s "$_nowhere"/Proton/ffmpeg "$_nowhere"/Proton/gst-libav/subprojects/FFmpeg
  sed -i 's/0.54/0.47/g' "$_nowhere"/Proton/gst-libav/subprojects/FFmpeg/meson.build

  cd "$_nowhere"/Proton/gst-libav
  mkdir -p "$_nowhere"/Proton/build/gstlibav64
  meson "$_nowhere"/Proton/build/gstlibav64 --prefix="$_nowhere/gst" \
	--libdir="lib64" \
	--buildtype=plain \
	-Dpkg_config_path=$_nowhere/gst/lib64/pkgconfig \
	-Ddoc='disabled'

  ninja -C "$_nowhere"/Proton/build/gstlibav64 install

  # FAudio
  if [ "$_build_faudio" = "true" ]; then
    mkdir -p "$_nowhere"/Proton/build/faudio64/build
    cp -a "$_nowhere"/Proton/FAudio/* "$_nowhere"/Proton/build/faudio64 && cd "$_nowhere"/Proton/build/faudio64/build
    cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -Dpkg_config_path="$_nowhere"/gst/lib64/pkgconfig \
        -DCMAKE_INSTALL_PREFIX="$_nowhere"/gst \
        -DCMAKE_INSTALL_LIBDIR=lib64 \
        -DCMAKE_INSTALL_INCLUDEDIR=include/FAudio \
        -DGSTREAMER=ON
    make && make install
  fi

  strip --strip-unneeded "$_nowhere"/gst/lib64/*.so

  ##### 32
  if [ "$_lib32_gstreamer" = "true" ]; then
    (
    if [ -d '/usr/lib32/pkgconfig' ]; then # Typical Arch path
        export PKG_CONFIG_PATH="$_proton_tkg_path/gst/lib/pkgconfig:/usr/lib32/pkgconfig"
    elif [ -d '/usr/lib/i386-linux-gnu/pkgconfig' ]; then # Ubuntu 18.04/19.04 path
        export PKG_CONFIG_PATH="$_proton_tkg_path/gst/lib/pkgconfig:/usr/lib/i386-linux-gnu/pkgconfig"
    else
        export PKG_CONFIG_PATH="$_proton_tkg_path/gst/lib/pkgconfig:/usr/lib/pkgconfig" # Pretty common path, possibly helpful for OpenSuse & Fedora
    fi
    export CC="gcc -m32"
    export CXX="g++ -m32"

    # orc
    cd "$_nowhere"/Proton/gst-orc
    mkdir -p "$_nowhere"/Proton/build/gst-orc32
    meson "$_nowhere"/Proton/build/gst-orc32 --prefix="$_nowhere/gst" \
        --libdir="lib" \
        --buildtype=plain \
        -Dorc-test=disabled \
        -Dexamples=disabled \
        -Dtests=disabled \
        -Dgtk_doc=disabled \
        -Dbenchmarks=disabled

    ninja -C "$_nowhere"/Proton/build/gst-orc32 install

    # gst
    cd "$_nowhere"/Proton/gstreamer
    mkdir -p "$_nowhere"/Proton/build/gst32
    meson "$_nowhere"/Proton/build/gst32 --prefix="$_nowhere/gst" \
        --libdir="lib" \
        --buildtype=plain \
        -Dintrospection=disabled \
        -Dgst_parse=false \
        -Dbenchmarks=disabled \
        -Dtools=disabled \
        -Dbash-completion=disabled \
        -Dexamples=disabled \
        -Dtests=disabled \
        -Dgtk_doc=disabled \
        -Dintrospection=disabled \
        -Dgobject-cast-checks=disabled \
        -Dglib-asserts=disabled \
        -Dglib-checks=disabled \
        -Dnls=disabled \
        -Dbenchmarks=disabled

    ninja -C "$_nowhere"/Proton/build/gst32 install

    # gst plugins-base
    cd "$_nowhere"/Proton/gst-plugins-base
    mkdir -p "$_nowhere"/Proton/build/gstbase32
    meson "$_nowhere"/Proton/build/gstbase32 --prefix="$_nowhere/gst" \
        --libdir="lib" \
        --buildtype=plain \
        -Dalsa=disabled \
        -Daudiomixer=disabled \
        -Daudiorate=disabled \
        -Daudiotestsrc=disabled \
        -Dcdparanoia=disabled \
        -Dcompositor=disabled \
        -Dencoding=disabled \
        -Dgio=disabled \
        -Dgl=disabled \
        -Dlibvisual=disabled \
        -Doverlaycomposition=disabled \
        -Dpango=disabled \
        -Drawparse=disabled \
        -Dsubparse=disabled \
        -Dtcp=disabled \
        -Dtremor=disabled \
        -Dvideorate=disabled \
        -Dvideotestsrc=disabled \
        -Dvolume=disabled \
        -Dx11=disabled \
        -Dxshm=disabled \
        -Dxvideo=disabled \
        -Dtools=disabled \
        -Dexamples=disabled \
        -Dtests=disabled \
        -Dintrospection=disabled \
        -Dgobject-cast-checks=disabled \
        -Dglib-asserts=disabled \
        -Dglib-checks=disabled \
        -Dnls=disabled

    ninja -C "$_nowhere"/Proton/build/gstbase32 install

    # gst plugins good
    cd "$_nowhere"/Proton/gst-plugins-good
    mkdir -p "$_nowhere"/Proton/build/gstgood32
    meson "$_nowhere"/Proton/build/gstgood32 --prefix="$_nowhere/gst" \
        --libdir="lib" \
        --buildtype=plain \
        -Daalib=disabled \
        -Dalpha=disabled \
        -Dapetag=disabled \
        -Daudiofx=disabled \
        -Dauparse=disabled \
        -Dcairo=disabled \
        -Dcutter=disabled \
        -Ddtmf=disabled \
        -Deffectv=disabled \
        -Dequalizer=disabled \
        -Dgdk-pixbuf=disabled \
        -Dgtk3=disabled \
        -Dgoom=disabled \
        -Dgoom2k1=disabled \
        -Dicydemux=disabled \
        -Dimagefreeze=disabled \
        -Dinterleave=disabled \
        -Djack=disabled \
        -Dlaw=disabled \
        -Dlevel=disabled \
        -Dlibcaca=disabled \
        -Dmonoscope=disabled \
        -Dmultifile=disabled \
        -Dmultipart=disabled \
        -Doss=disabled \
        -Doss4=disabled \
        -Dpng=disabled \
        -Dpulse=disabled \
        -Dqt5=disabled \
        -Dreplaygain=disabled \
        -Drtp=disabled \
        -Drtpmanager=disabled \
        -Drtsp=disabled \
        -Dshapewipe=disabled \
        -Dshout2=disabled \
        -Dsmpte=disabled \
        -Dsoup=disabled \
        -Dspectrum=disabled \
        -Dtaglib=disabled \
        -Dudp=disabled \
        -Dv4l2=disabled \
        -Dvideocrop=disabled \
        -Dvideomixer=disabled \
        -Dwavenc=disabled \
        -Dximagesrc=disabled \
        -Dy4m=disabled \
        -Dexamples=disabled \
        -Dtests=disabled \
        -Dgobject-cast-checks=disabled \
        -Dglib-asserts=disabled \
        -Dglib-checks=disabled \
        -Dnls=disabled

    ninja -C "$_nowhere"/Proton/build/gstgood32 install

    # gst plugins bad
    cd "$_nowhere"/Proton/gst-plugins-bad
    mkdir -p "$_nowhere"/Proton/build/gstbad32
    meson "$_nowhere"/Proton/build/gstbad32 --prefix="$_nowhere/gst" \
        --libdir="lib" \
        --buildtype=plain \
        -Dfbdev=disabled \
        -Ddecklink=disabled \
        -Ddts=disabled \
        -Dfaac=disabled \
        -Dfaad=disabled \
        -Dlibmms=disabled \
        -Dmpeg2enc=disabled \
        -Dmplex=disabled \
        -Dneon=disabled \
        -Drtmp=disabled \
        -Dflite=disabled \
        -Dvulkan=disabled \
        -Dsbc=disabled \
        -Dopencv=disabled \
        -Dvoamrwbenc=disabled \
        -Dx265=disabled \
        -Dmsdk=disabled \
        -Dchromaprint=disabled \
        -Davtp=disabled \
        -Dkate=disabled \
        -Dopenexr=disabled \
        -Dladspa=disabled \
        -Dofa=disabled \
        -Dmicrodns=disabled \
        -Dopenh264=disabled \
        -Dresindvd=disabled \
        -Dspandsp=disabled \
        -Dsvthevcenc=disabled \
        -Dsrtp=disabled \
        -Dwildmidi=disabled \
        -Dzbar=disabled \
        -Dzxing=disabled \
        -Dwebrtc=disabled \
        -Dwebrtcdsp=disabled \
        -Dopenmpt=disabled \
        -Dbluez=disabled \
        -Dbs2b=disabled \
        -Dtimecode=disabled \
        -Dexamples=disabled \
        -Dtests=disabled \
        -Dintrospection=disabled \
        -Dgobject-cast-checks=disabled \
        -Dglib-asserts=disabled \
        -Dglib-checks=disabled \
        -Dnls=disabled

    ninja -C "$_nowhere"/Proton/build/gstbad32 install

    # gst plugins ugly
    cd "$_nowhere"/Proton/gst-plugins-ugly
    mkdir -p "$_nowhere"/Proton/build/gstugly32
    meson "$_nowhere"/Proton/build/gstugly32 --prefix="$_nowhere/gst" \
        --libdir="lib" \
        --buildtype=plain \
        -Dgobject-cast-checks='disabled' \
        -Dglib-asserts='disabled' \
        -Dglib-checks='disabled' \
        -Ddoc='disabled' \
        -Dtests=disabled \
        -Dgobject-cast-checks=disabled \
        -Dglib-asserts=disabled \
        -Dglib-checks=disabled \
        -Dnls=disabled

    ninja -C "$_nowhere"/Proton/build/gstugly32 install

    # gst libav
    cd "$_nowhere"/Proton/gst-libav
    mkdir -p "$_nowhere"/Proton/build/gstlibav32
    meson "$_nowhere"/Proton/build/gstlibav32 --prefix="$_nowhere/gst" \
        --libdir="lib" \
        --buildtype=plain \
        -Ddoc='disabled'

    ninja -C "$_nowhere"/Proton/build/gstlibav32 install

    # FAudio
    if [ "$_build_faudio" = "true" ]; then
      mkdir -p "$_nowhere"/Proton/build/faudio32/build
      cp -a "$_nowhere"/Proton/FAudio/* "$_nowhere"/Proton/build/faudio32 && cd "$_nowhere"/Proton/build/faudio32/build
      cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="$_nowhere"/gst \
        -DCMAKE_INSTALL_LIBDIR=lib \
        -DCMAKE_INSTALL_INCLUDEDIR=include/FAudio \
        -DGSTREAMER=ON
      make && make install
    fi

    strip --strip-unneeded "$_nowhere"/gst/lib/*.so
    )
  fi

  cd "$_nowhere"
