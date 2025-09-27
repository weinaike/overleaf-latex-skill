# VS Code 跨平台 LaTeX 配置说明

## 配置策略

本项目的VS Code配置采用跨平台兼容设计，支持macOS、Linux和Windows环境。

## 跨平台PATH配置

### 方案一：VS Code工作区配置（推荐）
在 `.vscode/settings.json` 中针对不同平台设置PATH：

```json
{
    "terminal.integrated.env.osx": {
        "PATH": "/usr/local/texlive/2025basic/bin/universal-darwin:/opt/homebrew/bin:/usr/local/bin:${env:PATH}"
    },
    "terminal.integrated.env.linux": {
        "PATH": "/usr/local/texlive/2025basic/bin/x86_64-linux:/usr/bin:/usr/local/bin:${env:PATH}"
    },
    "terminal.integrated.env.windows": {
        "PATH": "C:\\texlive\\2025basic\\bin\\win32;${env:PATH}"
    }
}
```

### 方案二：系统级配置（通用）
不同系统设置系统PATH：

**macOS/Linux**
```bash
# 添加到 ~/.zshrc 或 ~/.bashrc
export PATH="/usr/local/texlive/2025basic/bin/universal-darwin:$PATH"  # macOS
export PATH="/usr/local/texlive/2025basic/bin/x86_64-linux:$PATH"     # Linux
```

**Windows**
- 在系统环境变量中添加 `C:\texlive\2025basic\bin\win32`

## 常见LaTeX安装路径

### macOS
- **MacTeX/BasicTeX**: `/usr/local/texlive/YYYY/bin/universal-darwin`
- **Homebrew**: `/opt/homebrew/bin` 或 `/usr/local/bin`

### Linux
- **TeX Live**: `/usr/local/texlive/YYYY/bin/x86_64-linux`
- **包管理器安装**: `/usr/bin`
- **手动安装**: `/opt/texlive/YYYY/bin/x86_64-linux`

### Windows
- **MiKTeX**: `C:\Program Files\MiKTeX\miktex\bin\x64`
- **TeX Live**: `C:\texlive\YYYY\bin\win32`

## 自动检测脚本

为了更好的跨平台支持，可以创建自动检测脚本：

**检测LaTeX安装 (check-latex.sh)**
```bash
#!/bin/bash
if command -v pdflatex &> /dev/null; then
    echo "✅ pdflatex found: $(which pdflatex)"
    pdflatex --version | head -1
else
    echo "❌ pdflatex not found"
    echo "Please install LaTeX distribution"
fi
```

## 团队协作建议

1. **文档说明**：在README中说明每个平台的安装步骤
2. **路径检测**：提供脚本检测LaTeX安装状态
3. **fallback配置**：工具配置不依赖硬编码路径
4. **统一版本**：团队使用相同的TeX Live版本

## 故障排除

### 常见问题
1. **命令未找到**：检查PATH设置
2. **权限问题**：确保LaTeX目录有执行权限
3. **版本冲突**：移除旧版本或调整PATH优先级

### 调试命令
```bash
# 检查PATH
echo $PATH

# 检查命令位置
which pdflatex
which bibtex

# 测试编译
pdflatex --version
```