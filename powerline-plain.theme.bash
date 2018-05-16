#!/usr/bin/env bash

SHELL_SSH_CHAR="⌁ "
SHELL_THEME_PROMPT_COLOR=110
SHELL_SSH_THEME_PROMPT_COLOR=219

VIRTUALENV_CHAR="ⓔ "
VIRTUALENV_THEME_PROMPT_COLOR=25

GEMSET_CHAR="ⓔ "
GEMSET_THEME_PROMPT_COLOR=25

SCM_NONE_CHAR=""
SCM_GIT_CHAR="⎇  "

SCM_THEME_PROMPT_CLEAN=""
SCM_THEME_PROMPT_DIRTY=""

SCM_THEME_PROMPT_COLOR=75
SCM_THEME_PROMPT_CLEAN_COLOR=19
SCM_THEME_PROMPT_DIRTY_COLOR=196
SCM_THEME_PROMPT_STAGED_COLOR=19
SCM_THEME_PROMPT_UNSTAGED_COLOR=196

CWD_THEME_PROMPT_COLOR=250

LAST_STATUS_THEME_PROMPT_COLOR=1

__bobby_clock() {
  printf "$(clock_prompt) "

  if [ "${THEME_SHOW_CLOCK_CHAR}" == "true" ]; then
    printf "$(clock_char) "
  fi
}

function set_rgb_color {
    if [[ "${1}" != "-" ]]; then
        fg="38;5;${1}"
    fi
    if [[ "${2}" != "-" ]]; then
        bg="48;5;${2}"
        [[ -n "${fg}" ]] && bg=";${bg}"
    fi
    echo -e "\[\033[${fg}${bg}m\]"
}

function powerline_shell_prompt {
    if [[ -n "${SSH_CLIENT}" ]]; then
        SHELL_PROMPT="${black}$(set_rgb_color - ${SHELL_SSH_THEME_PROMPT_COLOR}) ${SHELL_SSH_CHAR}\u@\H ${normal}"
    else
        SHELL_PROMPT="${black}$(set_rgb_color - ${SHELL_THEME_PROMPT_COLOR}) \u ${normal}"
    fi
}

function powerline_virtualenv_prompt {
    local environ=""

    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        environ="conda: $CONDA_DEFAULT_ENV"
    elif [[ -n "$VIRTUAL_ENV" ]]; then
        environ=$(basename "$VIRTUAL_ENV")
    fi

    if [[ -n "$environ" ]]; then
        VIRTUALENV_PROMPT=" $(set_rgb_color ${LAST_THEME_COLOR} ${VIRTUALENV_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${VIRTUALENV_THEME_PROMPT_COLOR}) ${VIRTUALENV_CHAR}$environ ${normal}"
        LAST_THEME_COLOR= ${VIRTUALENV_THEME_PROMPT_COLOR}
    else
        VIRTUALENV_PROMPT=""
    fi
}

function powerline_gemset_prompt {
    local gemset=$(rvm-prompt 2>/dev/null)

    if [[ -n "$gemset" ]]; then
        GEMSET_PROMPT=" $(set_rgb_color ${LAST_THEME_COLOR} ${GEMSET_THEME_PROMPT_COLOR})${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${GEMSET_THEME_PROMPT_COLOR}) ${VIRTUALENV_CHAR}$gemset ${normal}"
        LAST_THEME_COLOR=${GEMSET_THEME_PROMPT_COLOR}
    else
        GEMSET_PROMPT=""
    fi
}

function powerline_scm_prompt {
    scm_prompt_vars

    if [[ "${SCM_NONE_CHAR}" != "${SCM_CHAR}" ]]; then
        if [[ "${SCM_DIRTY}" -eq 3 ]]; then
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_STAGED_COLOR} ${SCM_THEME_PROMPT_COLOR})\e[1m"
        elif [[ "${SCM_DIRTY}" -eq 2 ]]; then
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_UNSTAGED_COLOR} ${SCM_THEME_PROMPT_COLOR})"
        elif [[ "${SCM_DIRTY}" -eq 1 ]]; then
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_DIRTY_COLOR} ${SCM_THEME_PROMPT_COLOR})\e[1m"
        else
            SCM_PROMPT="$(set_rgb_color ${SCM_THEME_PROMPT_CLEAN_COLOR} ${SCM_THEME_PROMPT_COLOR})"
        fi
        if [[ "${SCM_GIT_CHAR}" == "${SCM_CHAR}" ]]; then
            SCM_PROMPT+=" ${SCM_CHAR}${SCM_BRANCH}${SCM_STATE} "
        fi
        SCM_PROMPT=" ${SCM_PROMPT}${normal}"
    else
        SCM_PROMPT=""
    fi
}

function powerline_cwd_prompt {
    CWD_PROMPT=" ${THEME_PROMPT_SEPARATOR}${normal}$(set_rgb_color - ${CWD_THEME_PROMPT_COLOR}) \w ${normal}$(set_rgb_color ${CWD_THEME_PROMPT_COLOR} -)${normal}"
}

function powerline_last_status_prompt {
    if [[ "$1" -eq 0 ]]; then
        LAST_STATUS_PROMPT=""
    else
        LAST_STATUS_PROMPT=" $(set_rgb_color 231 ${LAST_STATUS_THEME_PROMPT_COLOR}) ${LAST_STATUS} ${normal}$(set_rgb_color ${LAST_STATUS_THEME_PROMPT_COLOR} - )${THEME_PROMPT_SEPARATOR}${normal}"
    fi
}

function powerline_prompt_command() {
    local LAST_STATUS="$?"

    powerline_shell_prompt
    powerline_virtualenv_prompt
    powerline_gemset_prompt
    powerline_scm_prompt
    powerline_cwd_prompt
    powerline_last_status_prompt LAST_STATUS

    PS1="\n$(__bobby_clock)${SHELL_PROMPT}${GEMSET_PROMPT}${VIRTUALENV_PROMPT}${SCM_PROMPT}${CWD_PROMPT}${LAST_STATUS_PROMPT}\n${green}→${reset_color} "
}

THEME_SHOW_CLOCK_CHAR=${THEME_SHOW_CLOCK_CHAR:-"true"}
THEME_CLOCK_CHAR_COLOR=${THEME_CLOCK_CHAR_COLOR:-"$red"}
THEME_CLOCK_COLOR=${THEME_CLOCK_COLOR:-"$bold_red"}
THEME_CLOCK_FORMAT=${THEME_CLOCK_FORMAT:-"%Y-%m-%d %H:%M:%S"}

safe_append_prompt_command powerline_prompt_command

