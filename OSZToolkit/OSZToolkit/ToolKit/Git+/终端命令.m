1 打开服务器   sudo apachectl -k restart

2 设置cocoapods   cd "拖入工程文件
                pod init  "创建pods
                pod search "afn
                pod install  或者 pod update
                pod install --verbose --no-repo-update


3 git操作    git init //初始化一个本地git代码仓库
            git confit user.name //配置用户名
            git config user.email //配置用户邮箱
            git status //查看 git 工作区和暂存区 文件状态
            git add . //将文件从工作区移到暂存区
            git diff //比较当前版本和之前版本的区别
            git commit -m "注释文字" //将文件从暂存区提交到代码区
            git log //查看截止到当前版本的历史记录
            git reset --hard HEAD^ //将代码回滚到之前版本
            git reflog //查看所有操作过的历史记录
            git clone https://github.com/AFNetworking/AFNetworking.git  克隆完整库


4 显示隐藏文件夹
        显示：defaults write com.apple.finder AppleShowAllFiles -bool true
        隐藏：defaults write com.apple.finder AppleShowAllFiles -bool false
        "重启finder


