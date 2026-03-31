# 1. Powerlevel10k Instant Prompt (반드시 최상단 유지)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 2. 핵심 변수 및 OMZ 사전 설정
# [보안 검사 생략] 권한 검사 딜레이 완전 제거
ZSH_DISABLE_COMPFIX="true"
SKIP_FIX_SECURE_COMPLETION="true"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# [속도 개선 핵심] OMZ 내부 체크 로직 비활성화
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_AUTO_TITLE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"

# 업데이트 확인 빈도 (30일)
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 30

# 3. 플러그인 설정
# [최적화] 무거운 플러그인 제외, git만 로드
plugins=(git
	zsh-autosuggestions
	fast-syntax-highlighting)

# 4. PATH 설정 (중요: Blender 경로를 여기에 넣지 마세요!)
export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# 5. Oh My Zsh 로드
source $ZSH/oh-my-zsh.sh

# 6. 사용자 정의 설정
# 자동완성 캐싱
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
# Powerlevel10k 설정 로드
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# 7. 무거운 플러그인 수동 로드 & 컴파일 최적화
# 함수: 파일이 변경되었을 때만 .zwc(바이트코드)로 컴파일하여 로딩 속도 가속
_zsh_source_optimized() {
  local file="$1"
  if [[ -f "$file" ]]; then
    # .zwc 파일이 없거나 원본보다 오래되었으면 컴파일
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
# (참고: 저장소 버전에 따라 .zsh 일 수도 있고 .plugin.zsh 일 수도 있어 둘 다 체크)
if [[ -f "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]]; then
    _zsh_source_optimized "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
else
    _zsh_source_optimized "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'  # 회색

# (2) fast-syntax-highlighting (가장 마지막 로드)
# 경로 변수 명확화
FSH_PATH="$ZSH/custom/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

if [[ -f "$FSH_PATH" ]]; then
  _zsh_source_optimized "$FSH_PATH"  
  # 설정 최적화
  FAST_HIGHLIGHT[fast_cursor]=1
  FAST_HIGHLIGHT[use_brackets]=1
else
  echo "⚠️Fast Syntax Highlighting을 찾을 수 없습니다."
fi

# 8. 히스토리 설정
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# 9. Aliases (이 별칭들은 ros 로드 전에도 정의해두지만, 실행은 환경 로드 후에만 제대로 동작함)
alias sz='source ~/.zshrc; echo \✅Zshrc is reloaded!\'
alias sgz='sudo gedit ~/.zshrc'

# ======================== 색상 사용 설정 ======================
export LS_COLORS="di=1;33:ln=1;36:so=1;33:pi=1;33:ex=1;32:bd=1;33;01:cd=1;33;01:su=1;37;41:sg=1;30;43:tw=1;30;42:ow=1;34;42"

# ========================== Node.js ==========================
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ========================== Cuda  ==========================
# export PATH=/usr/local/cuda/bin:$PATH

# add /usr/local/lib:
# export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# ========================== ROS2 HOMBLE ==========================
source ~/ros2_settings.sh          

# ============== Blendr 4.2.10 ===============
alias blender="cd /opt/blender-4.2.16-linux-x64/ && ./blender"
# ============================================
#export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.10/dist-packages


