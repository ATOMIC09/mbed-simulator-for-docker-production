FROM debian

ENV PATH="/emsdk:/emsdk/emscripten/tag-1.38.21:/emsdk/fastcomp-clang/tag-e1.38.21/build_tag-e1.38.21_64/bin:/usr/bin/python:/usr/bin/hg:/usr/bin/node:/usr/bin/npm:${PATH}"

RUN apt-get update -y && apt-get upgrade -y && \
	apt-get install python2 curl wget git mercurial -y && \
	apt-get install build-essential -y

RUN	update-alternatives --install /usr/bin/python python /usr/bin/python2 1 && \
	curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
	python get-pip.py && pip install mbed-cli
	
RUN dpkg --add-architecture i386 && apt-get update -y && \
	apt install -y libc6:i386 libncurses5:i386 libstdc++6:i386

RUN cd /usr/local && wget https://github.com/Kitware/CMake/releases/download/v3.10.3/cmake-3.10.3.tar.gz && \
	tar -zxvf cmake-3.10.3.tar.gz && cd cmake-3.10.3 && \
	./bootstrap && make && make install
	
RUN git clone https://github.com/emscripten-core/emsdk.git && \
	cd /emsdk && ./emsdk install emscripten-1.38.21 && \
    ./emsdk install sdk-fastcomp-tag-1.38.21-64bit && \
    ./emsdk activate emscripten-1.38.21 && \
    ./emsdk activate fastcomp-clang-tag-e1.38.21-64bit && \
	chmod +x /emsdk/emsdk_env.sh

RUN /bin/bash -c 'source "/emsdk/emsdk_env.sh"' >> ~/.bashrc
	
RUN	curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh && \
	bash nodesource_setup.sh && apt install nodejs

ADD . /app

WORKDIR /app

RUN npm install && ./build-demos.sh

EXPOSE 7829

CMD ["node", "server.js"]
