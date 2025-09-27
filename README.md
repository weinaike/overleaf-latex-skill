# LaTeX论文项目

这是一个使用LaTeX撰写的学术论文项目，采用IEEE会议论文格式。

## 项目结构

```
├── main.tex                    # 主文件，包含文档类、包导入和整体结构
├── references.bib             # 参考文献数据库
├── chapters/                  # 各章节内容目录
│   ├── abstract.tex          # 摘要和关键词
│   ├── introduction.tex      # 引言
│   ├── background.tex        # 背景和相关工作
│   ├── methodology.tex       # 方法论
│   ├── evaluation.tex        # 评估实验
│   ├── threats.tex           # 有效性威胁
│   └── conclusion.tex        # 结论
└── README.md                 # 项目说明文档
```

## 编译说明

### 推荐方式：直接使用命令行 🚀

**快速编译**（推荐日常使用）
```bash
pdflatex main.tex
```

**完整编译**（首次编译或有新参考文献时）
```bash
pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

> **为什么要运行多次？**
> 1. **第1次 pdflatex**：生成基本PDF，创建引用信息文件(.aux)
> 2. **bibtex**：处理参考文献，生成格式化的参考文献列表(.bbl)  
> 3. **第2次 pdflatex**：插入参考文献到PDF中
> 4. **第3次 pdflatex**：解决所有交叉引用，确保页码等信息正确

**简化版本**（如果确定引用都正确）
```bash
pdflatex main.tex && bibtex main && pdflatex main.tex
```

**清理临时文件**
```bash
rm -f *.aux *.bbl *.blg *.log *.out *.toc *.synctex.gz *.fls *.fdb_latexmk
```

### 📝 编译策略建议

**日常写作**：只用快速编译
```bash
pdflatex main.tex  # 适合预览内容变化
```

**添加新引用后**：用完整编译
```bash
pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

**解决编译问题**：先清理再编译
```bash
rm -f *.aux *.bbl *.blg *.log && pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

**最终提交前**：确保用完整编译检查所有引用

## 章节说明

- **Abstract**: 论文摘要和关键词
- **Introduction**: 问题介绍、动机和贡献
- **Background & Related Work**: 技术背景和相关研究综述
- **Methodology**: 提出的方法和算法描述
- **Evaluation**: 实验设置、结果和分析
- **Threats to Validity**: 研究有效性威胁分析
- **Conclusion**: 总结和未来工作

## 使用指南

1. 在`main.tex`中修改论文标题、作者信息
2. 在`chapters/`目录下的对应文件中编写各章节内容
3. 在`references.bib`中添加参考文献
4. 使用提供的VS Code任务或命令行进行编译

## 注意事项

- 图片文件建议放在单独的`figures/`目录中
- 表格和图片的标签要与文中引用保持一致
- 参考文献使用BibTeX格式管理

## IEEE论文格式要求

✅ 使用 `\documentclass[10pt,conference]{IEEEtran}`  
✅ 标题使用24pt字体（由IEEEtran自动处理）  
✅ 正文使用10pt字体  
✅ 页数限制：10页内容 + 2页参考文献  

## LaTeX环境配置

### 跨平台支持 🌍
本项目已配置跨平台兼容的VS Code设置，支持：
- **macOS**: `/usr/local/texlive/2025basic/bin/universal-darwin`
- **Linux**: `/usr/local/texlive/2025basic/bin/x86_64-linux` 
- **Windows**: `C:\texlive\2025basic\bin\win32`

详细跨平台配置说明请查看：[`.vscode/CROSS-PLATFORM.md`](.vscode/CROSS-PLATFORM.md)

### 快速检测环境
```bash
# 运行环境检测脚本（推荐）
./check-latex-env.sh

# 或手动检查
which pdflatex
pdflatex --version
```

### 系统级PATH设置（可选）

**macOS/Linux**
```bash
# 添加到 ~/.zshrc 或 ~/.bashrc
export PATH="/usr/local/texlive/2025basic/bin/universal-darwin:$PATH"  # macOS
export PATH="/usr/local/texlive/2025basic/bin/x86_64-linux:$PATH"     # Linux
```

**Windows**
在系统环境变量中添加对应的TeX Live bin目录

### VS Code扩展
推荐安装LaTeX Workshop扩展，它提供：
- 自动编译
- PDF预览
- 语法高亮
- 智能补全
- 错误检查

## 准备提交

提交前检查清单：
1. 编译生成PDF文件
2. 检查页数限制（10页+2页参考文献）  
3. 确保所有引用正确
4. 检查格式符合IEEE要求
5. 通过相应平台上传PDF