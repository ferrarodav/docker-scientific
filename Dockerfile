FROM python:3.6

LABEL maintainer="Davide Ferraro <ferraro.dav@gmail.com>" \
    name="Experiment with Data Science" \
    description="Docker container with basic python packages for computation, visualization and experiment logging." \
    version="0.1"

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# OpenCV 3.4
# Dependencies
ENV OPENCV_VERSION="3.4"
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    yasm \
    pkg-config \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavformat-dev \
    libpq-dev
# Get source from github and compile
RUN git clone -b ${OPENCV_VERSION} --depth 1 https://github.com/opencv/opencv.git /usr/local/src/opencv; \
    cd /usr/local/src/opencv && mkdir build && cd build && \
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D BUILD_TESTS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
          .. && \
    make -j"$(nproc)" && \
    make install

# Base packages
ENV PIP_PACKAGES_BASE="\
    numpy \
    Cython \
    matplotlib \
    pandas \
    seaborn \
    scipy \
    scikit-learn \
    scikit-image \
    jupyter \
    xgboost \
    h5py \
    requests \
    pillow \
    networkx"
RUN pip install --no-cache-dir -U ${PIP_PACKAGES_BASE}

# Sacred, for experiment logging
ENV PIP_PACKAGES_SACRED="\
    pyyaml \
    pymongo \
    gitpython \
    python-telegram-bot \
    sacred"
RUN pip install --no-cache-dir -U ${PIP_PACKAGES_SACRED}

# Jupyter extensions
ENV PIP_PACKAGES_JUPYTER="\
    jupyter_contrib_nbextensions \
    jupyter_nbextensions_configurator"
RUN pip install --no-cache-dir -U ${PIP_PACKAGES_JUPYTER} && \
    jupyter nbextension enable --py widgetsnbextension && \
    jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user

WORKDIR /home/workspace

EXPOSE 8080

CMD ["jupyter", "notebook", "--port=8080", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token="]
