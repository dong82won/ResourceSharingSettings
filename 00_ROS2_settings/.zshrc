# ==============================================================================
# 1. Powerlevel10k Instant Prompt (반드시 최상단 유지)
# ==============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# 2. Oh My Zsh 핵심 및 속도 최적화 설정
# ==============================================================================
# 권한 검사 딜레이 및 OMZ 내부 체크 로직 비활성화 (속도 개선)
ZSH_DISABLE_COMPFIX="true"
SKIP_FIX_SECURE_COMPLETION="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"

# 업데이트 확인 빈도 (30일)
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 30


# Oh My Zsh 기본 설정 및 플러그인 로드 (가벼운 git만 로드)
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh


# 자동완성 캐싱
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Powerlevel10k 테마 설정 로드
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



# ==============================================================================
# 3. 환경 변수 (PATH, 색상, 기타)
# ==============================================================================
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"
# PYTHONPATH 안전한 추가 방식 (콜론 중복 방지)
export PYTHONPATH="${PYTHONPATH:+$PYTHONPATH:}/usr/local/lib/python3.10/dist-packages"

# 그래픽 렌더링 라이브러리 충돌 (별도 분리)
export PATH="/usr/local/cuda-13.0/bin:$PATH"

# 디렉토리 색상 설정
export LS_COLORS="di=1;33:ln=1;36:so=1;33:pi=1;33:ex=1;32:bd=1;33;01:cd=1;33;01:su=1;37;41:sg=1;30;43:tw=1;30;42:ow=1;34;42"


# ==============================================================================
# 4. 히스토리(History) 설정
# ==============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY


# ==============================================================================
# 5. 사용자 단축어 (Aliases)
# ==============================================================================
# 시스템 단축어
alias sz="source ~/.zshrc; echo '✅ Zshrc is reloaded!'"
alias sgz="sudo gedit ~/.zshrc"
alias of="dolphin . > /dev/null 2>&1 &"

# Blender 단축어
alias blender="/opt/blender-4.2.16-linux-x64/blender"
alias blender4="/opt/blender-4.5.8-linux-x64/blender"



# ==============================================================================
# 6. 외부 프로그램 및 스크립트 로드
# ==============================================================================
# ROS2 HUMBLE 설정
source ~/ros2_settings.sh


# ========================== Node.js ==========================
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# ==============================================================================
# 7. 무거운 플러그인 수동 로드 & 컴파일 최적화 (마지막 로드)
# ==============================================================================
# 함수: 파일이 변경되었을 때만 .zwc(바이트코드)로 컴파일하여 로딩 속도 가속
_zsh_source_optimized() {
  local file="$1"
  if [[ -f "$file" ]]; then
    if [[ ! "$file.zwc" -nt "$file" ]]; then
      zcompile "$file"
    fi
    source "$file"
  else
    echo "⚠️플러그인을 찾을 수 없습니다: $file"
    echo "  --> 'git clone'을 통해 설치되었는지 확인하세요."
  fi
}

# (1) zsh-autosuggestions
if [[ -f "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]]; then
    _zsh_source_optimized "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
else
    _zsh_source_optimized "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'  # 회색

# (2) fast-syntax-highlighting
FSH_PATH="$ZSH/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
if [[ -f "$FSH_PATH" ]]; then
  _zsh_source_optimized "$FSH_PATH"  
  FAST_HIGHLIGHT[fast_cursor]=1
  FAST_HIGHLIGHT[use_brackets]=1
else
  echo "⚠️Fast Syntax Highlighting을 찾을 수 없습니다."
fi




 
