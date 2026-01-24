# RISC-V CPU Development Environment
# Contains Verilog simulation, waveform viewer, RISC-V toolchain, Neovim + LazyVim

FROM ubuntu:22.04

LABEL maintainer="RISC-V CPU Dev Environment"
LABEL description="Complete development environment for RISC-V CPU design with Verilog"

# Avoid interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei

# Basic tools and dependencies
RUN apt update
RUN apt install -y \
  fish \
  build-essential \
  git \
  curl \
  wget \
  libclang-dev \
  python3.10-venv \
  # Verilog simulation tools
  iverilog \
  verilator \
  # Waveform viewer
  gtkwave \
  # Build tools
  make \
  # Neovim dependencies
  unzip \
  ripgrep \
  fd-find \
  fzf \
  && rm -rf /var/lib/apt/lists/*

# Install lazygit (download from GitHub release)
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
  tar xf lazygit.tar.gz lazygit && \
  install lazygit /usr/local/bin && \
  rm lazygit.tar.gz lazygit

# ============================
# Install Neovim (v0.11.5 stable)
# ============================
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz && \
  tar -xzf nvim-linux-x86_64.tar.gz -C /opt && \
  ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim && \
  rm nvim-linux-x86_64.tar.gz

# ============================
# Install Node.js (required by some LazyVim plugins)
# ============================
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
  apt install -y nodejs && \
  rm -rf /var/lib/apt/lists/*

# ============================
# Install Rust and tree-sitter-cli
# ============================
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
  . ~/.cargo/env && \
  cargo install tree-sitter-cli

ENV PATH="/root/.cargo/bin:${PATH}"

# ============================
# Install Lua Language Server
# ============================
RUN mkdir -p /opt/lua-language-server && \
  curl -L https://github.com/LuaLS/lua-language-server/releases/download/3.10.6/lua-language-server-3.10.6-linux-x64.tar.gz | \
  tar -xz -C /opt/lua-language-server && \
  ln -s /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server

# Create working directory
WORKDIR /workspace

# Download pre-compiled RISC-V GNU Toolchain (RV32)
# Use pre-compiled version provided by SiFive to save compilation time
RUN mkdir -p /opt/riscv && \
  cd /tmp && \
  wget -q https://github.com/stnolting/riscv-gcc-prebuilt/releases/download/rv32i-131023/riscv32-unknown-elf.gcc-13.2.0.tar.gz && \
  tar -xzf riscv32-unknown-elf.gcc-13.2.0.tar.gz -C /opt/riscv --strip-components=1 && \
  rm riscv32-unknown-elf.gcc-13.2.0.tar.gz

# Set environment variables
ENV RISCV=/opt/riscv
ENV PATH="${RISCV}:${PATH}"
ENV EDITOR=nvim
ENV VISUAL=nvim

# ============================
# Configure LazyVim
# ============================
# Create Neovim configuration directory
RUN mkdir -p /root/.config/nvim

# Copy LazyVim configuration
COPY nvim/ /root/.config/nvim/

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/fish"]
