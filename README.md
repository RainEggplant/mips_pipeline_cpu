# MIPS Pipeline CPU

**MIPS Pipeline CPU** is a vivado project (2018.3) for the _Fundamental Experiment of Digital Logic and Processor （数字逻辑与处理器基础实验）_ course of EE, Tsinghua University.

See the [report](./reports/report.md).

## Set up this project

When opening the project after cloning it, do it by using `Tools -> Run Tcl Script...` and selecting the `mips_pipeline_cpu.tcl` file. This will regenerate the project so that you can start to work.

## VSCode Integration
If you want to use VSCode to develop, please view this [link](https://github.com/RainEggplant/vscode-verilog-integration).

After you set up the environment, remember to change `"systemverilog.launchConfiguration"` property in `.vscode/settings.json` to ensure that it contains the correct directories.

## About

This project uses [kevlaine/vivado-git](https://github.com/kevlaine/vivado-git) to make it git-friendly (works under Vivado 2018.3).

