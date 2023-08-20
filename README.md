# 简介

本工具可以将 [wavetone](https://ackiesound.ifdef.jp/download.html#wt) 导出的 `midi` 文件转化成简谱(其他格式没有测试)
具体的效果可以参考`tests`目录下的 [示例文件](./tests/src.pdf)

# 安装与使用

这个项目挺简陋的，也没有进行过多少测试，所以也没有为小白用户提供易用的操作方法，因此以下默认你有一定的命令行基础。

clone 下来安装依赖：

```
git clone https://github.com/slqy123/midi2jianpu
pip install -r requirements.txt
```

使用方法可以参考 `tests.bat`，如下：

```
# 由midi生成jianpu-ly格式文件
python main.py tests\src.mid %* > tests\src
# 进而生成lilypond 的解析文件
python jianpu-ly.py tests\src > tests\src.ly
# 再用lilypond 生成最终pdf
lilypond --pdf tests\src.ly
```

你可以通过 `python main.py --help` 来查看可以选择的参数。

# 最后

本人就是个乐理小白，简谱还有 midi 的那些规范格式啥的根本搞不懂，所以可能会有一堆 bug。
不过我本人弄这东西就是想要一种有时长的 JE 谱，因此对我来说基本是够用了。

另外这个项目我一开始是拿 jupyter notebook 写的，单文件从头写到底，可读性不是很好，因此 fork 前请三思。
