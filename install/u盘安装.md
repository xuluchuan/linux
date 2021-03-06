U盘安装CentOS7的最终解决方案
2017年12月20日 11:06:07 jony0303 阅读数：1293
终于将CentOS7装上笔记本了，过程无比艰辛，因为我发现网上大家提到的所有U盘安装CentOS7时碰到的问题几乎都被我碰到了，像什么：
1.刻录镜像的时候只能刻录一个6MBEFI文件夹到U盘，U盘变成只有6MB容量;
2.开机卡在Press thekey to begin the installation process界面;
3.不能识别NTFS分区;
4.不能挂载U盘/光驱;
5.安装进行到图形化配置界面时提示错误退出;
等等问题，虽然最终都找到解决办法了，但是走了不少弯路，因为网上好多文章都存在误导的嫌疑，直接导致我浪费了半夜再加第二天大半天的时间，其实归根结底还是对Linux不熟的原因。。。

下面唠叨一下解决问题的过程，算是备份。

其实最初本打算用光盘安装的，可是等到光盘都刻好了却发现笔记本的光驱坏了，没办法，只好改用U盘装了。

在将ISO刻录到U盘的时候就碰到了第一个问题：刻录镜像的时候只能刻录一个6MB大小的EFI文件夹到U盘，并且U盘变成只有6MB容量，格式化都不能找回原来的空间。

我用的刻录软件是UltraISO9.3.6，仔细看了下，打开光盘镜像之后看到里面只有一个EFI文件夹。这肯定不对嘛，因为在虚拟光驱下查看ISO里面的文件是完整的，并且我下载完成后也校验过MD5。
然后我试着用UltraISO打开加载到虚拟光驱的ISO，这回文件完整了，并且刻录成功。但是在把U盘插到电脑上准备安装系统的时候第二个问题来了：
开机卡在Press thekey to begin the installation process界面
网上找到的办法是说要将vesamenu.c32文件替换，我照做了，真的能进入安装界面了。后来我发现这么做是多么的多余!因为我到后来才发现这根本就是UltraISO刻录文件的时候造成的错误。但悲催的是，这一切后来才发现。。。

（其实当时能进入安装界面之后我是无比的兴奋，我以为我马上就要成功了，我以为这个东西跟windows差不多，能进入安装界面就肯定离安装成功不远了啊。但是没想到的是后面还有好些个问题在等着我。。。）

再继续回忆整个过程又要码好多字，并且你也不会愿意看，so直接上结果吧：

准备工作：
8G以上U盘;
最新版UltraISO;
CentOS7光盘镜像;
CentOS7的镜像文件可以在网易的开源镜像站或者阿里云的开源镜像站下载，地址分别是：
http://mirrors.163.com/centos/7.1.1503/isos/x86_64/
http://mirrors.aliyun.com/centos/7.1.1503/isos/x86_64/
直接下载CentOS-7-x86_64-DVD-1503-01.iso文件就可以，如果速度慢的话也可以下载种子文件CentOS-7-x86_64-DVD-1503-01.torrent之后再用迅雷之类的bt下载工具来下载。

然后就是刻录软件，网上很多文章都在说不要用UltraISO，但是经过我的实际使用，之前提到的9.3.6版的确实会出现问题，但是最新版的UltraISO是完全可用的。还有PowerISO和USBwriter我都试过，最终都失败了，要不就是碰到上面说的第一个问题，要不就是刻录后无法启动。

好了，开始吧：

1. 使用最新版UltraISO将ISO镜像刻录到U盘
一定要是最新版，试用版都可以，按下图操作：

centos001

centos002

老毛桃的u盘需要将iso文件放到/lmt里
将iso解压后放到根目录

2. U盘启动电脑进入安装界面
正常情况下你应该会看到下面的这个界面：

centos01
选择第一项，然后按TAB键（在评论区有朋友踫到没有按TAB键的提示，经derogg解答，原来是UEFI模式下提示的是按E，所以这一步大家根据自己的情况看好提示再操作），然后会看到下面这个：

centos02
3.修改第二步中按TAB键出来的命令
将命令修改为：>vmlinuz initrd=initrd.img linux dd quiet

这里注意了：网上很多文章都说这一步改成“>vmlinuz initrd=initrd.img inst.stage2=hd:/dev/sdb
quiet”什么的，然后失败了再cd
/dev命令查看U盘盘符啥的，别这样了，我就是在这里浪费了好多时间，把dev目录下的所有设备都试了几遍也没成功，主要是笔记本硬盘就有两个，再加上U盘，搞得我实在是不认识哪个设备是哪个啊。。。

所以这里我们直接将按TAB键之后出来的文字修改为：>vmlinuz initrd=initrd.img linux dd quiet。改好之后回车，然后就会列出你的设备列表了，在这个列表里面，不懂Linux的我都能很清楚的辨认哪个是我的U盘，不信你看下面这张图：

linuxdd
很明显，sdb1就是我的U盘了，当然你得看看你自己的到底是什么，然后记下来之后就可以直接关机了(因为我曾经试着在这里按提示输入序号，没想到之后是个死循环，不知道是哪里出错了还是怎么地，所以我后来直接关机)。
据网友king反馈，在这里输入C可以不用关机而直接进入系统安装界面，大家可以试一下。由于我之前的截图不完整，看不到关于按C的提示了。。。

4.再次通过U盘启动电脑，继续修改第2步中出现的命令
重复第2步，然后将底下的命令改成：>vmlinuz initrd=initrd.img inst.stage2=hd:/dev/sdb1 quiet

Sdb1得改成你自己的U盘所对应的名称，然后回车。如果你没有输错的话就应该会来到选择语言的界面了，再接着就是图形化设置界面了。

进入图形化配置界面之后没有出现报错的话那就可以算是大功告成了，剩下的就是根据提示进行配置系统了。

但凡事总有例外的时候，如果在载入完图形化界面之后出现下面的报错的话，那么重启之后从步骤3开始，仔细的再来一遍。