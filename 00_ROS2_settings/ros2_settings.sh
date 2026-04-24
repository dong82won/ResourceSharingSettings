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

# ===============================================================
# 색상 정의 추가 (GREEN, BLUE 추가)
# ===============================================================
YELLOW="\033[33m"
GREEN="\033[32m"
BLUE="\033[34m"
RED="\033[31m"
RESET="\033[0m"

source /opt/ros/humble/setup.zsh
alias humble="source /opt/ros/humble/setup.zsh; echo '🐢 /opt/ros/humble/setup.zsh'"

# ===============================================================
# 워크스페이스 관리 함수 (선택적 누적 및 초기화 버전)
# ===============================================================

ws() {
    local ws_name="$1"
    : ${ROS_DISTRO:=humble}
    : ${ROS_DOMAIN_ID:=77}

    # 1. 기본 ROS 2 환경 로드 (최초 1회 또는 초기화 후 실행)
    # AMENT_PREFIX_PATH가 없거나 /opt/ros만 남았을 때 기본을 잡아줍니다.
    if [[ -z "$AMENT_PREFIX_PATH" || "$AMENT_PREFIX_PATH" == "/opt/ros/$ROS_DISTRO" ]]; then
        if [ -f "/opt/ros/$ROS_DISTRO/setup.zsh" ]; then
            source "/opt/ros/$ROS_DISTRO/setup.zsh"
            echo -e "${YELLOW}Base ROS 2 ($ROS_DISTRO) initialized.${RESET}"
        fi
    fi

    # 2. 특정 워크스페이스의 '현재 패키지만' 누적 로드
    # local_setup.zsh를 사용하면 빌드 시점의 부모(Underlays)를 무시하고 
    # 현재 워크스페이스의 패키지만 환경 변수에 추가합니다.
    local TARGET_PATH="$HOME/$ws_name/install/local_setup.zsh"

    if [ -f "$TARGET_PATH" ]; then
        source "$TARGET_PATH"
        echo -e "${GREEN}Workspace '$ws_name' added to current environment.${RESET}"
    else
        echo -e "${RED}Error: $TARGET_PATH not found. Did you build it?${RESET}"
    fi
}

# 모든 추가 경로를 지우고 기본 ROS 환경으로 되돌리는 함수
ws_reset() {
    local ROS_DISTRO=${1:-humble}
    
    # [핵심 수정] 기존에 누적된 모든 ROS 관련 경로 변수를 강제로 제거합니다.
    unset AMENT_PREFIX_PATH
    unset COLCON_PREFIX_PATH
    unset ROS_PREFIX_PATH
    
    if [ -f "/opt/ros/$ROS_DISTRO/setup.zsh" ]; then
        # 변수가 비워진 상태에서 기본 setup을 실행하면 /opt/ros/humble만 깔끔하게 남습니다.
        source "/opt/ros/$ROS_DISTRO/setup.zsh"
        echo -e "${BLUE}Environment reset to Base ROS 2 ($ROS_DISTRO) only.${RESET}"
    else
        echo -e "${RED}Error: Base ROS 2 not found at /opt/ros/$ROS_DISTRO${RESET}"
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


# log tools
alias roslog="ccze -A"
alias roserr="grep -E 'WARN|ERROR'"

#alias cb='cd ~/ros2_ws && colcon build --symlink-install'
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
#export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/won/.gazebo/my_models
#export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11

export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11

#export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/home/won/.gazebo/my_models:/usr/share/gazebo-11/models:~/.gazebo/models
#export GAZEBO_PLUGIN_PATH=$GAZEBO_PLUGIN_PATH:/usr/lib/x86_64-linux-gnu/gazebo-11/plugins
# 경로 변수가 비어있을 경우 콜론(:)이 앞에 붙지 않도록 안전하게 처리
export GAZEBO_MODEL_PATH="${GAZEBO_MODEL_PATH:+$GAZEBO_MODEL_PATH:}/home/won/.gazebo/my_models:/usr/share/gazebo-11/models:~/.gazebo/models"
export GAZEBO_PLUGIN_PATH="${GAZEBO_PLUGIN_PATH:+$GAZEBO_PLUGIN_PATH:}/usr/lib/x86_64-linux-gnu/gazebo-11/plugins"

export GAZEBO_MODEL_DATABASE_URI=""
export IGN_FUEL_DISABLE=1
export IGN_TRANSPORT_LOG_LEVEL=error
# ========================================================
# NVIDIA GPU 가속 강제 사용 설정(#노트북 전용#)
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
# ========================================================
export TURTLEBOT3_MODEL=burger
export LDS_MODEL=LDS-02
