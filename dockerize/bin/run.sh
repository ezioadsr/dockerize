#!/usr/bin/env bash

function __run()
{
    CONTAINER_NAME=${T_CURRENT}-${T_DOCKERIZE_SERVICE}
    if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
      echo "# docker: [l] ${CONTAINER_NAME} ~> ${@}"$'\n'"# local"
      docker exec -it ${CONTAINER_NAME} ${@}
      return
    fi
    echo "# docker: ${CONTAINER_NAME} ~> ${@}"$'\n'"# global"
    PORT=""
    if [[ "${T_DOCKERIZE_PORT_HOST}" ]];then
      PORT="-p ${T_DOCKERIZE_PORT_HOST}:${T_DOCKERIZE_PORT_CONTAINER}"
    fi
    docker run -it --rm \
      -w ${T_DOCKERIZE_VOLUME_ROOT} \
      -u "$(id -u)" \
      ${PORT} \
      -v ${T_DIR}:${T_DOCKERIZE_VOLUME_ROOT} \
      -v ${T_COMPOSER}:${T_DOCKERIZE_USER_HOME}/.composer \
      -v ${T_CONFIG}:${T_DOCKERIZE_USER_HOME}/.config \
      -v ${T_CACHE}:${T_DOCKERIZE_USER_HOME}/.cache \
      -v ${T_LOCAL}:${T_DOCKERIZE_USER_HOME}/.local \
      -v ${T_SSH}:${T_DOCKERIZE_USER_HOME}/.ssh \
      ${T_DOCKERIZE_IMAGE} ${@}
}