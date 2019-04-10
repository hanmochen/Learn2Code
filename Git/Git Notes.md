# Git Notes



[TOC]

## 创建版本库



- 创建版本库命令 `git init`
- 把文件添加到仓库 `git add <file>`
- 把文件提交到仓库 `git commit -m <message>`
- `commit`可以一次提交很多文件，可以多次`add`不同的文件然后执行一次 `commit`



## 版本控制



### 基础操作

- 监测文件修改 `git status`
- 查看修改的内容 `git diff <file>`
- 查看历史记录 `git log`
- 版本号 `commit id`



#### 回退

- 在Git中，用`HEAD`表示当前版本，上一个版本就是`HEAD^`，上上一个版本就是`HEAD^^`，当然往上100个版本可以写成`HEAD~100`

- 回退到上一个版本 `git reset --hard HEAD^`
  - `--hard` 参数？
- 撤销回退：用版本号 
- 查看每一次命令



### 工作区和暂存区

- **工作区（Working Directory）** ： `.git` 所在的目录
- **版本库（Repository）**：`.git` 文件
  - **暂存区**（stage / index）
  - **分支** (master) 
  - **指向 master 的指针** Head
- `git add` 把文件修改添加到暂存区
- `git commit`往`master`分支上提交更改
- `git status` 监测工作区所有文件
  - modified : 修改但未上传
  - untracked: 未添加
- `git commit`一次性把暂存区的所有修改提交到分支
- `git diff` 比较的是工作区文件与暂存区文件的区别（上次git add 的内容）
  `git diff --cached` 比较的是暂存区的文件与仓库分支里（上次git commit 后的内容）的区别



### 管理修改

- Git跟踪并管理的是修改，而非文件
- 第一次修改 -> `git add` -> 第二次修改 -> `git commit`
- 第一次的修改被提交了，第二次的修改不会被提交
- `git diff HEAD -- <file>`可以查看工作区和版本库里面最新版本的区别



#### 撤销修改

- `git checkout -- file`丢弃工作区的修改
  - 修改后还没有提交到暂存区：恢复到版本库
  - 修改后已经 `add` : 恢复到 `add` 的修改

- `git reset HEAD <file>`可以把暂存区的修改撤销掉（unstage），重新放回工作区



#### 删除文件

- 从版本库中删除文件`git remove` + `git commit`
- 误删文件: `git checkout -- <FILE>`



## 远程仓库

### 添加到远程库

- 关联到远程库：`git remote add origin git@github.com:username/learngit.git`
- 把本地库的内容推送到远程库：`git push -u origin master` 
  - `-u` 参数：Git不但会把本地的`master`分支内容推送的远程新的`master`分支，还会把本地的`master`分支和远程的`master`分支关联起来
- `git push origin master`

### 远程到本地

- 远程库克隆到本地 `git clone`
  - ssh 协议
  - https 协议



## 分支管理



- 每次提交，Git都把不同版本串成一条时间线，这条时间线就是一个分支。
- 截止到目前，只有一条时间线，在Git里，这个分支叫主分支，即`master`分支。
- `HEAD`严格来说不是指向提交，而是指向`master`，`master`才是指向提交的，所以，`HEAD`指向的就是当前分支。
- 每次提交，`master`分支都会向前移动一步，这样，随着你不断提交，`master`分支的线也越来越长



### 创建，合并和删除分支



- 创建分支时，新建一个指针指向当前提交的版本，Head 指针指向新建的分支
- 创建分支之后，对工作区的修改和提交只影响当前分支
- 合并时，把 `master`指针指向当前分支即可
- 创建分支的命令 `git branch <branchname>`
- 切换分支 `git checkout <branchname>`
- 创建并切换 `git checkout -b <branchname>`
- 列出所有分支 `git branch` 
  - 当前分支前有*号
- 合并分支 `git merge <branchname>` 指定 branch 与当前 branch 合并
  - Fast-forward 快进模式
- 删除分支 `git branch -d <branchname>`



### 解决冲突

- 在两个分支上分别提交修改了之后再合并，可能会产生冲突
- 也可用`git status`检测冲突
- Git用`<<<<<<<`，`=======`，`>>>>>>>`标记出不同分支的内容，
- 需要手动修改冲突的文件
- `git log --graph` 查看分支信息



#### --no-ff 模式

- 在合并的时候可以通过 `--no-ff` 参数禁用 Fast Forward 模式，Git就会在merge时生成一个新的commit
- `可以使用 git log` 查看分支历史



### 分支策略

- master 分支： 发布新版本
- dev 分支： 用于开发，稳定版本与 master 合并
- dev 分支下的子分支：用于各部分开发





