#!/bin/bash

# LaTeX环境检测脚本
# 用于验证跨平台LaTeX配置

echo "🔍 检查LaTeX环境配置..."
echo "=================="

# 检测操作系统
OS=$(uname -s)
case "$OS" in
    Darwin*)    PLATFORM="macOS";;
    Linux*)     PLATFORM="Linux";;
    CYGWIN*|MINGW*|MSYS*) PLATFORM="Windows";;
    *)          PLATFORM="Unknown";;
esac

echo "📍 操作系统: $PLATFORM"

# 检查PATH
echo "📂 当前PATH:"
echo "$PATH" | tr ':' '\n' | grep -E "(texlive|tex|latex)" || echo "   未找到TeX相关路径"

# 检查LaTeX工具
echo ""
echo "🔧 LaTeX工具检查:"

tools=("pdflatex" "bibtex" "latex")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        location=$(which "$tool")
        version=$($tool --version 2>&1 | head -1 | cut -d' ' -f1-3)
        echo "   ✅ $tool: $location"
        echo "      版本: $version"
    else
        echo "   ❌ $tool: 未找到"
    fi
done

# 测试编译
echo ""
echo "🧪 测试编译:"
if command -v pdflatex &> /dev/null; then
    echo "\\documentclass{article}\\begin{document}Hello\\end{document}" > test.tex
    if pdflatex -interaction=nonstopmode test.tex &> /dev/null; then
        echo "   ✅ 编译测试通过"
        rm -f test.*
    else
        echo "   ❌ 编译测试失败"
        rm -f test.*
    fi
else
    echo "   ❌ 无法进行编译测试"
fi

echo ""
echo "🎯 建议:"
case "$PLATFORM" in
    "macOS")
        echo "   - 如需安装: brew install basictex 或下载MacTeX"
        echo "   - PATH建议: /usr/local/texlive/2025basic/bin/universal-darwin"
        ;;
    "Linux")
        echo "   - 如需安装: sudo apt-get install texlive-latex-base"
        echo "   - PATH建议: /usr/local/texlive/2025basic/bin/x86_64-linux"
        ;;
    "Windows")
        echo "   - 如需安装: 下载MiKTeX或TeX Live"
        echo "   - PATH建议: C:\\texlive\\2025basic\\bin\\win32"
        ;;
esac

echo "=================="
echo "✨ 检查完成"