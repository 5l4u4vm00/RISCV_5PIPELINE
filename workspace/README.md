# RISC-V CPU 專案

## 專案結構

```
workspace/
├── Makefile              # 建置腳本
├── README.md             # 本說明文件
├── src/                  # 原始碼目錄
│   ├── top.sv            # 頂層模組
│   ├── top_tb.sv         # 測試平台
│   ├── SRAM_wrapper.sv   # SRAM 包裝器
│   └── output/           # 編譯輸出目錄
└── sim/                  # 模擬相關檔案
    ├── prog0/            # 測試程式 0
    │   ├── setup.S       # 初始化組語
    │   ├── main.S        # 主程式組語
    │   ├── main0~3.hex   # 記憶體初始化檔
    │   └── golden.hex    # 預期結果
    └── SRAM/             # SRAM 模型
        ├── SRAM_rtl.sv   # SRAM RTL 實作
        └── SRAM.v        # 可合成版本
```

## 環境需求

### 模擬工具

- **Icarus Verilog** (`iverilog`) - SystemVerilog 編譯器
- **VVP** - Verilog 模擬執行器
- **GTKWave** - 波形檢視器
- **Verilator** (選用) - 語法檢查工具

### RISC-V 工具鏈

- `riscv32-unknown-elf-gcc`
- `riscv32-unknown-elf-as`
- `riscv32-unknown-elf-ld`
- `riscv32-unknown-elf-objdump`
- `riscv32-unknown-elf-objcopy`

## 使用說明

### 基本使用

```bash
# 編譯並執行模擬 (預設使用 prog0)
make

# 或明確指定
make sim
```

### 模擬指令

| 指令            | 說明                        |
| --------------- | --------------------------- |
| `make compile`  | 編譯 SystemVerilog 原始碼   |
| `make sim`      | 編譯並執行模擬              |
| `make sim_wave` | 執行模擬並產生波形檔 (.vcd) |
| `make wave`     | 開啟 GTKWave 檢視波形       |
| `make lint`     | 使用 Verilator 進行語法檢查 |
| `make test`     | 執行模擬並顯示測試結果      |

### 組合語言編譯

| 指令        | 說明                   |
| ----------- | ---------------------- |
| `make hex`  | 將組語編譯為 hex 檔案  |
| `make dump` | 產生反組譯檔案 (.dump) |

### 清理指令

| 指令            | 說明               |
| --------------- | ------------------ |
| `make clean`    | 清除模擬輸出檔案   |
| `make cleanall` | 清除所有產生的檔案 |

### 切換測試程式

使用 `PROG` 變數指定不同的測試程式目錄：

```bash
# 使用 prog0 (預設)
make sim

# 使用 prog1
make sim PROG=prog1

# 使用其他程式並產生波形
make sim_wave PROG=prog2
```

## 模組說明

### top.sv (頂層模組)

- 實例化指令記憶體 (IM1) 和資料記憶體 (DM1)
- 連接 SRAM 控制訊號：CK, CS, OE, WEB, A, DI, DO

### SRAM_wrapper.sv (SRAM 包裝器)

- 將 32 位元匯流排轉換為單位元介面
- 處理 4 位元組寫入致能 (WEB[3:0])

### SRAM_rtl.sv (SRAM RTL)

- 14 位元位址線 (16,384 words)
- 32 位元資料寬度
- 支援單週期讀寫操作

### top_tb.sv (測試平台)

- 時脈週期：10ns
- 最大模擬週期：100,000
- 自動載入 hex 檔案到 SRAM
- 比對測試結果與 golden.hex

## 記憶體映射

| 位址範圍              | 用途             |
| --------------------- | ---------------- |
| `0x0000 - 0x1FFF`     | 指令記憶體       |
| `0x2000` (TEST_START) | 測試結果起始位址 |
| `0x3FFF` (SIM_END)    | 模擬結束標記位址 |

## 測試流程

1. 組語程式 (`setup.S` + `main.S`) 編譯為 hex 檔
2. 測試平台載入 hex 檔到 SRAM
3. 執行 RISC-V 指令測試
4. 將結果寫入 `TEST_START` (0x2000) 開始的位址
5. 寫入 `-1` 到 `SIM_END` (0x3FFF) 結束模擬
6. 比對結果與 `golden.hex`
7. 輸出測試結果到 `result_rtl.txt`

## 輸出檔案

| 檔案             | 位置          | 說明                   |
| ---------------- | ------------- | ---------------------- |
| `top_tb.out`     | `src/output/` | 編譯後的模擬執行檔     |
| `wave.vcd`       | `src/output/` | 波形檔案               |
| `result_rtl.txt` | `sim/prog0/`  | 測試結果 (通過數,總數) |
| `main.log`       | `sim/prog0/`  | 模擬日誌               |

## 常見問題

### Q: 找不到 iverilog 指令

安裝 Icarus Verilog：

```bash
# Ubuntu/Debian
sudo apt install iverilog

# macOS
brew install icarus-verilog
```

### Q: 找不到 RISC-V 工具鏈

安裝 RISC-V GNU Toolchain：

```bash
# Ubuntu/Debian
sudo apt install gcc-riscv64-unknown-elf

# 或從原始碼編譯
# https://github.com/riscv-collab/riscv-gnu-toolchain
```

### Q: 模擬卡住或超時

- 檢查組語程式是否正確寫入結束標記
- 確認 `SIM_END` 位址被寫入 `-1`
- 增加最大模擬週期數 (修改 `top_tb.sv` 中的 `MAX_CYCLE`)

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.sv", ".svh" },
	callback = function()
		vim.bo.filetype = "systemverilog"
	end,
})
