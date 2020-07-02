#!/bin/bash

set -e

. ci/travis/lib.sh

build_default() {
    pushd "${TRAVIS_BUILD_DIR}"
    cd build
    sudo make -j${NUM_JOBS}
    popd
}

build_cppcheck() {
    check_cppcheck
}

build_clang_format() {
    check_clangformat
}

build_deploy_doxygen() {
    pushd "${TRAVIS_BUILD_DIR}/doc"
    mkdir build && cd build && cmake ..
    check_doxygen
    deploy_doxygen
    popd
}

build_dragonboard() {
    run_docker ${DOCKER} /aditof_sdk/ci/travis/inside_docker.sh -DDRAGONBOARD=TRUE
}

build_raspberrypi3() {
    echo_green "############Running build for the 96tof1 camera!"
    run_docker ${DOCKER} /aditof_sdk/ci/travis/inside_docker.sh -DRASPBERRYPI=TRUE
    echo_green "############Running build for the chicony-006 camera!"
    run_docker ${DOCKER} /aditof_sdk/ci/travis/inside_docker.sh "-DRASPBERRYPI=TRUE -DUSE_CHICONY=TRUE"
}

build_ros(){
    pushd "${TRAVIS_BUILD_DIR}"
    cd build
    sudo cmake --build . --target install
    cmake --build . --target aditof_ros_package
    popd
}

build_${BUILD_TYPE:-default}
