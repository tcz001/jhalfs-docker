git clone git://git.linuxfromscratch.org/jhalfs.git
git clone git://git.linuxfromscratch.org/lfs.git
docker build --tag lfs .
docker run -it --privileged --name lfs lfs
