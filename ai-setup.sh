#!/bin/bash
# Author: TheLeopard65

set -euo pipefail

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
success() { echo -e "${GREEN}[ OK ]${NC} $1"; }

if [[ "$(id -u)" -ne 0 ]]; then
    error "Please run this script using ROOT or SUDO. (Example: 'sudo $0')"
    exit 1
fi

if ! command -v figlet &> /dev/null; then
    apt-get -qq install -y figlet || true
fi

echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
figlet "PENTESTER'S KALI - LINUX" 2>/dev/null || echo -e "${YELLOW}(Install 'figlet' to see ASCII banners)${NC}"
echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"

export DEBIAN_FRONTEND=noninteractive
echo '* libraries/restart-without-asking boolean true' | debconf-set-selections

TARGET_USER="${SUDO_USER:-$(whoami)}"
TARGET_HOME="$(eval echo "~$TARGET_USER")"
TOOLS_DIR="$TARGET_HOME/IMP-TOOLS"
LLAMA_DIR="$TOOLS_DIR/llama.cpp"
MODEL_DIR="$TARGET_HOME/models/VulnLLM-R-7B-GGUF"
VENV_DIR="$TARGET_HOME/AI-VENV"

prompt_yes_no() {
    read -p "[#] $1 (Y/N) [default: N]: " reply
    reply="${reply:-N}"
    echo "${reply,,}"
}

install_deps() {
    info "Installing system dependencies for llama.cpp..."
    apt-get -qq install -y build-essential cmake git python3-pip rustc cargo
}

setup_llama_cpp() {
    mkdir -p "$TOOLS_DIR"
    if [[ -d "$LLAMA_DIR/.git" ]]; then
        warn "llama.cpp already exists in $LLAMA_DIR"
        if [[ "$(prompt_yes_no "Update to latest commit?")" == "y" ]]; then
            cd "$LLAMA_DIR"
            git pull --quiet
            success "Updated llama.cpp repository."
        fi
    else
        info "Cloning llama.cpp from GitHub..."
        git clone --quiet --depth 1 https://github.com/ggerganov/llama.cpp "$LLAMA_DIR"
        success "llama.cpp cloned."
    fi
}

build_llama_cpp() {
    if [[ -x "$LLAMA_DIR/build/bin/llama-cli" && -x "$LLAMA_DIR/build/bin/llama-server" ]]; then
	    info "Existing llama-cli found: $(command -v llama-cli)"
	    if [[ "$(prompt_yes_no "Use existing installation and skip build?")" == "y" ]]; then
	        return
	    fi
	fi

    cd "$LLAMA_DIR"
    CUDA_AVAILABLE=false
    if command -v nvidia-smi &> /dev/null; then
        CUDA_AVAILABLE=true
    fi

    BUILD_WITH_CUDA=false
    if [[ "$CUDA_AVAILABLE" == true ]]; then
        if [[ "$(prompt_yes_no "NVIDIA GPU detected. Build with CUDA support?")" == "y" ]]; then
            BUILD_WITH_CUDA=true
        fi
    fi

    rm -rf build
    mkdir -p build
    cd build

    if [[ "$BUILD_WITH_CUDA" == true ]]; then
        cmake .. -DLLAMA_CUDA=ON
    else
        cmake .. -DLLAMA_CUDA=OFF
    fi

    info "Building llama.cpp (this may take a while)..."
    make -j"$(nproc)"
    success "Build completed."

    for bin in llama-cli llama-server llama-perplexity; do
        if [[ -f "$LLAMA_DIR/build/bin/$bin" ]]; then
            ln -sf "$LLAMA_DIR/build/bin/$bin" "/usr/local/bin/$bin"
        fi
    done
    success "Symlinks created for llama-cli, llama-server, llama-perplexity."
}

get_gguf_files() {
    local repo="Mungert/VulnLLM-R-7B-GGUF"
    local api_url="https://huggingface.co/api/models/$repo"
    local response
    response=$(curl -s "$api_url")
    if [[ -z "$response" ]]; then
        warn "Failed to fetch file list from HuggingFace API."
        return 1
    fi
    echo "$response" | grep -oP '"siblings":\s*\[\s*\K[^]]*' | grep -oP '"rfilename":\s*"\K[^"]*\.gguf' || true
}

download_model() {
    mkdir -p "$MODEL_DIR"
    if compgen -G "$MODEL_DIR/*.gguf" > /dev/null; then
        warn "Model file already exists in $MODEL_DIR:"
        ls -lh "$MODEL_DIR"/*.gguf
        if [[ "$(prompt_yes_no "Skip download and keep existing?")" == "y" ]]; then
            return 0
        fi
        rm -f "$MODEL_DIR"/*.gguf
    fi

    info "Fetching list of available .gguf files from HuggingFace..."
    mapfile -t gguf_files < <(get_gguf_files)
    if [[ ${#gguf_files[@]} -eq 0 ]]; then
        error "No .gguf files found in repo. Please check manually."
        return 1
    fi

    echo "Available quantized models:"
    PS3="Select a quant (enter number): "
    select selected in "${gguf_files[@]}"; do
        if [[ -n "$selected" ]]; then
            break
        else
            echo "Invalid selection, try again."
        fi
    done

    info "Downloading $selected ..."
    local download_url="https://huggingface.co/Mungert/VulnLLM-R-7B-GGUF/resolve/main/$selected"
    wget -q --show-progress "$download_url" -P "$MODEL_DIR"
    success "Model downloaded to $MODEL_DIR/$selected"
    ln -sf "$MODEL_DIR/$selected" "$MODEL_DIR/model.gguf"
}

setup_venv() {
    if [[ "$(prompt_yes_no "Set up a Python virtual environment with huggingface-hub and open-interpreter?")" == "y" ]]; then
        if [[ -d "$VENV_DIR" ]]; then
            warn "Python virtual environment already exists: $VENV_DIR"
            return 0
        fi

        info "Creating Python virtual environment..."
        python3 -m venv "$VENV_DIR"
        source "$VENV_DIR/bin/activate"
        pip install --upgrade pip setuptools wheel

        if pip install huggingface-hub open-interpreter; then
            success "Virtual environment created successfully."
        else
            warn "Python package installation failed."
            warn "llama.cpp and model installation are still usable."
        fi

        deactivate
        info "Activate with:"
        echo "source $VENV_DIR/bin/activate"
    fi
}

main() {
    info "Starting AI setup for llama.cpp and VulnLLM-R-7B..."

    if [[ "$(prompt_yes_no "Proceed with installation?")" != "y" ]]; then
        error "Aborted by user."
        exit 0
    fi

    install_deps
    setup_llama_cpp
    build_llama_cpp
    download_model
    setup_venv

    echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
    echo -e "${GREEN}[###] Kali-Linux Pentester's AI-Agent Setup is complete!${NC}"
    echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
    echo -e "${YELLOW}To use the model with Open Interpreter:${NC}"
    echo -e "1. Start the llama-server in the background:"
    echo -e "   ${BLUE}llama-server -m $MODEL_DIR/model.gguf --host 127.0.0.1 --port 8080 --ctx-size 8192 &${NC}"
	echo
    echo -e "2. Run Open Interpreter (make sure the 'interpreter' command is in your PATH):"
    echo -e "   ${BLUE}interpreter --api_base http://127.0.0.1:8080/v1 --model openai/VulnLLM-R-7B-GGUF --context_window 8192${NC}"
    echo -e "   (you can also set environment variables: OPENAI_API_BASE, OPENAI_API_KEY=fake_key)"
    echo
    echo -e "${YELLOW}Or use a Python script (recommended for better control):${NC}"
    echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
    cat << 'EOF'
from interpreter import interpreter

interpreter.offline = True
interpreter.llm.model = "openai/VulnLLM-R-7B-GGUF"
interpreter.llm.api_base = "http://127.0.0.1:8080/v1"
interpreter.llm.api_key = "fake_key"
interpreter.llm.context_window = 8192

# Start interactive chat
interpreter.chat()
EOF
    echo -e "${GREEN}[###] ----------------------------------------------------------------------------------------------------------------- [###]${NC}"
}

main "$@"
sudo chown -R kali:kali $TOOLS_DIR
