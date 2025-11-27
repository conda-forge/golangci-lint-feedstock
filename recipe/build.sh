#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

go build -o=${PREFIX}/bin/${PKG_NAME} -ldflags="-s -w -X main.version=${PKG_VERSION}" ./cmd/${PKG_NAME}
go-licenses save ./cmd/${PKG_NAME} --save_path=license-files \
    --ignore github.com/golangci/golangci-lint \
    --ignore github.com/ashanbrown/forbidigo \
    --ignore github.com/ashanbrown/makezero

# Manually copy licenses that go-licenses could not download
cp -r ${RECIPE_DIR}/license-files/* ${SRC_DIR}/license-files

if [[ ${build_platform} == ${target_platform} ]]; then
    mkdir -p ${PREFIX}/etc/bash_completion.d 
    mkdir -p ${PREFIX}/share/fish/vendor_completions.d 
    mkdir -p ${PREFIX}/share/zsh/site-functions
    ${PKG_NAME} completion bash > ${PREFIX}/etc/bash_completion.d/${PKG_NAME}
    ${PKG_NAME} completion fish > ${PREFIX}/share/fish/vendor_completions.d/${PKG_NAME}.fish
    ${PKG_NAME} completion zsh > ${PREFIX}/share/zsh/site-functions/_${PKG_NAME}
fi
