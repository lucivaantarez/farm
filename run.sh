#!/usr/bin/env bash
# ================================================
# THE FOOL - ARCHITECTURE BOOTSTRAP
# @lanavienrose | repo: farm
# ================================================

REPO_URL="https://github.com/lucivaantarez/farm.git"
DIR_NAME="$HOME/farm"
BRANCH="main"

# ANSI Formatting
R="\033[0m"
G="\033[92m"
GR="\033[90m"

echo -e "${GR}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
echo -e "${G}[~] SYNCHRONIZING CORE ARCHITECTURE...${R}"

# 1. Framework Dependency Check
if ! command -v git &> /dev/null || ! command -v python &> /dev/null; then
    echo -e "${GR}[~] Installing system frameworks...${R}"
    if command -v pkg &> /dev/null; then
        pkg update -y > /dev/null 2>&1 && pkg install git python -y > /dev/null 2>&1
    elif command -v apt &> /dev/null; then
        apt update -y > /dev/null 2>&1 && apt install git python3 -y > /dev/null 2>&1
    fi
fi

# 2. Repository Management
if [ -d "$DIR_NAME" ]; then
    cd "$DIR_NAME" || exit
    git fetch origin --quiet
    git reset --hard "origin/$BRANCH" --quiet
else
    git clone --quiet "$REPO_URL" "$DIR_NAME"
    cd "$DIR_NAME" || exit
fi

# 3. Execution
echo -e "${G}[+] BOOTING THE FOOL...${R}"
echo -e "${GR}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"

python hopper.py
