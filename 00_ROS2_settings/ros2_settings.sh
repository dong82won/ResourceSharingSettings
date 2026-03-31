# ===============================================================
# 1. ROS 2 기본 로드 및 자동완성 (필수)
# ===============================================================
# Tab 자동완성 활성화 (이것만 있으면 if문 필요 없음)
eval "$(register-python-argcomplete3 ros2)"
eval "$(register-python-argcomplete3 colcon)"

# ===============================================================
# 2. 로그 및 기타 설정
# ===============================================================
export RCUTILS_COLORIZED_OUTPUT=1
export RCUTILS_LOGGING_USE_STDOUT=1
export RCUTILS_LOGGING_BUFFERED_STREAM=0
export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity}] [{time}] [{name}]: {message}"

export ROS_LOCALHOST_ONLY=0
#export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
#export CYCLONEDDS_URI=file:///home/won/cycloneDDS_setting/cycloneDDS_for_humble.xml
#export CYCLONEDDS_URI=file:///home/won/cycloneDDS_setting/cycloneDDS_zero_copy.xml

#export CYCLONEDDS_URI=file:///home/won/cycloneDDS_setting/cycloneDDS_lo_shm.xml
export CYCLONEDDS_URI=file:///home/won/cycloneDDS_setting/cycloneDDS_lo_udp.xml

export CYCLONEDDS_LOG_LEVEL=info

# 색상 정의
YELLOW="\033[33m"
RESET="\033[0m"
RED="\033[31m"


# ===============================================================
# 3. 워크스페이스 관리 함수 (누적 로드 버전)
# ===============================================================
ws() {
    local ws_name="$1"
    : ${ROS_DISTRO:=humble}
    : ${ROS_DOMAIN_ID:=77}
    
    # 1. 이전 환경의 유령(Ghost) 경로들 완전히 제거
    if [ -z "$ROS_ENV_LOADED" ]; then
        # ROS 2가 이전 워크스페이스를 기억할 때 사용하는 핵심 변수 4가지 제거
        unset AMENT_PREFIX_PATH
        unset COLCON_PREFIX_PATH
        unset CMAKE_PREFIX_PATH
        unset PYTHONPATH

        # 기본 ROS 2 환경 로드 (이때 기존 경로를 참조하지 않게 됨)
        if [ -f "/opt/ros/$ROS_DISTRO/setup.zsh" ]; then
            source "/opt/ros/$ROS_DISTRO/setup.zsh"
            export ROS_ENV_LOADED=1
            echo -e "${YELLOW}Base ROS 2 ($ROS_DISTRO) environment cleaned and initialized.${RESET}"
        fi
    fi
    
    # 2. 원하는 워크스페이스만 누적 로드
    local TARGET_PATH="$HOME/$ws_name/install/local_setup.zsh"
    
    if [ -f "$TARGET_PATH" ]; then
        source "$TARGET_PATH"
        echo -e "${YELLOW}Workspace '$ws_name' is now overlaid.${RESET}"
    else
        echo -e "${RED}Error: $TARGET_PATH not found. Did you build it?${RESET}"
    fi
}

ros2_status() {
    echo "ROS_DOMAIN_ID     : ${ROS_DOMAIN_ID:-0}"
    echo "ROS_LOCALHOST_ONLY: ${ROS_LOCALHOST_ONLY:-0}"
    echo "RMW_IMPLEMENTATION: ${RMW_IMPLEMENTATION:-0}"
}

# ========================================================
# 4. Aliases
# ========================================================
alias humble='source /opt/ros/humble/setup.zsh; echo \🐢/opt/ros/humble/setup.zsh\'

# log tools
alias roslog="ccze -A"
alias roserr="grep -E 'WARN|ERROR'"

alias cb='cd ~/ros2_ws && colcon build --symlink-install'
alias cbs='colcon build --symlink-install'
alias cbp='colcon build --symlink-install --packages-select'
alias cbu='colcon build --symlink-install --packages-up-to'
alias ct='colcon test'
alias ctp='colcon test --packages-select'
alias ctr='colcon test-result'
alias tl='ros2 topic list'
alias te='ros2 topic echo'
alias nl='ros2 node list'
alias af='ament_flake8'
alias ac='ament_cpplint'
alias testpub='ros2 run demo_nodes_cpp talker'
alias testsub='ros2 run demo_nodes_cpp listener'
alias testpubimg='ros2 run image_tools cam2image'
alias testsubimg='ros2 run image_tools showimage'
alias di='rosdep install --from-paths src -y --ignore-src --os=ubuntu:jammy'

# ========================================================
alias killgazebo='killall -9 gazebo & killall -9 gzserver & killall -9 gzclient'
export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11
export GAZEBO_MODEL_DATABASE_URI=""
#export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/won/.gazebo/my_models:/home/won/building_editor_models:/home/won/.gazebo/hartyao_models
export IGN_FUEL_DISABLE=1
export GAZEBO_MODEL_DATABASE_URI=""
#export IGN_PARTITION=DongWon
export IGN_TRANSPORT_LOG_LEVEL=error
# ========================================================
# NVIDIA GPU 가속 강제 사용 설정
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
# ========================================================
export TURTLEBOT3_MODEL=burger
export LDS_MODEL=LDS-02
