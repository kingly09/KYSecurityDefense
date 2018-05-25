# iOS应用程序安全

# 目录

* [iOS应用程序安全(1)-搭建移动渗透测试平台](#markdown-aq01)
* [iOS应用程序安全(2)-获得iOS应用程序的类信息](#markdown-aq02)
* [iOS应用程序安全(3)-理解Objective-C Runtime](#markdown-aq03)
* [iOS应用程序安全(4)-用Cycript进行运行时分析(Yahoo天气应用)](#markdown-aq04)




### <a name="markdown-aq01"></a>iOS应用程序安全(1)-搭建移动渗透测试平台

作者：Prateek Gianchandani

译者：吴发伟

原文网址：http://resources.infosecinstitute.com/ios-application-security-part-1-setting-up-a-mobile-pentesting-platform/

版权声明：自由转载-非商用-保持署名

引言

在本系列文章中，我们将开始学习对iOS应用程序进行渗透测试和漏洞评估的一系列工具和技巧。


#### 越狱你的设备

如果你真的对iOS安全很感兴趣，有一个越狱设备是非常有必要的。在本节，我们将介绍如何越狱iOS设备。越狱之后有很多好处，你可以安装很多工具，例如nmap, metasploit，甚至在设备上运行自己写的python代码。想像一下，你在手掌中通过手持设备就能对网站进行漏洞扫描的能力还是很酷的。为了更多的了解越狱和这样做的好处，我推荐你看看这篇[文章](http://www.ibtimes.com/why-jailbreak-your-iphone-5-reasons-you-should-download-evasi0n-jailbreak-ios-6-1080412)。

越狱非常简单，下载一个越狱软件，然后点击越狱就可以了。如果你的设备运行的是iOS 6.x的系统，我推荐你使用[evasi0n](http://evasi0n.com/)，如果你的设备运行的是iOS 5.x，那推荐用[redsn0w](http://www.redsn0w.us/)。

本文我将对我的new iPad （3代，运行 iOS 6.0.1）越狱。一旦你下载evasi0n并运行，它就会自动检测设备并且告诉你这个设备是否可以越狱。 如图：


![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat1.png)

你需要做的仅仅是点击jailbeak(越狱)，然后让evasi0n做剩下的事情。


![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat2.png)

 你可以看到，越狱已经开始了。过一段时间之后，evasi0n将会重启设备，然后运行exploit（利用程序）。
 
 
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat3.png)
 
 一旦利用程序（exploit）运行完毕，它就会安装Cydia和Cydia的包列表到设备上。Cydia是一个图形界面，使得你能在越狱设备上下载和安装软件包和应用，这些应用通常你在App store是找不到的。基本上所有的越狱程序都会默认安装Cydia。你可以认为Cydia就是越狱设备上的App Store。
 
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat4.png)
 等待一段时间，直到你得到下面的提示。
 
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat5.png)
 
 解锁你的设备，你可以看到桌面上有个新的app图标，叫做Jailbreak。点击它以完成越狱过程。
 
 
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat6.png)
 
  你可以看到你的设备将会重启。请耐心等待这个过程的完成。一旦设备完成重启，你可以看到一个叫做Cydia的新app在桌面上。这个就表明你已经成功越狱。

祝贺你，你已经在iOS hacking领域跨出了第一步。



#### 建立一个移动审计平台

现在你已经完成了设备的越狱，那么下一步就是安装一些重要的命令行工具，例如 wget, ps, apt-get等用来审计iOS应用的工具。第一个要安装的就是OpenSSH。安装这个工具可以让你从mac登录进越狱设备。

进入Cydia，点击底部的搜索tab，然后搜索：OpenSSH.

![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat7.png)


点击OpenSSH，然后点击安装，

![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat8.png)


然后OpenSSH就会安装在你的设备上。 在我们用ssh登录进设备之前，我们 还需要安装其他一些命令行工具。几乎所有流行的黑客工具都可以在 BigBoss Recommendation tools这个包中找到。安装BigBoss Recommendation tools，在Cydia中搜索，然后点击安装。

![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat9.png)


 有些重要的命令行工具例如: APT 0.6 Transitional, Git, GNU Debugger, less, make, unzip, wget 和 SQLite 3.x会被安装好。

还有一个工具需要被安装: MobileTerminal，它能够让你在设备上直接运行命令行，而不是需要通过ssh登录设备运行命令。

在Cydia上搜索 MobileTerminal,然后安装。
 
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat10.png)

 
 
 一旦安装好MobileTerminal,你就可以在桌面上看到一个新的app图标，名字叫做Terminal.
 
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat11.png)
 
 
 点击它，你可以得到一个终端，试试运行几个Unix命令。在这里，我们简单的用ps列举下正在运行的进程。
 
  
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat12.png)
 
 
  你可以看到，ps这个命令成功执行。

让我们看看我们是否能够通过ssh登录进这个越狱设备。确保你的电脑和越狱设备连接在同一个网络，找到越狱设备的IP地址。为了找到设备的IP地址，到设置（settings）- WiFi中选择设备现在连接的网络。

 
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat13.png)
 

可以看到，IP地址是192.168.2.3。让我们试试以root用户登录进去。在命令行中运行如下命令。root的默认密码是：alpine。推荐的做法是：一旦你安装好了OpenSSH, 马上改掉root的默认密码。这是因为有些恶意软件利用默认的用户名和密码登录进入设备[译者注1]。为了改密码，在ssh登录上之后，在命令行输入passwd这个命令，然后输入2次新密码。然后你的root秘密就已修改了。这一系列命令可以参见下图：

 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat14.png)

 备注：确保在运行时，Cydia在后台运行而不是在前台。这是因为Cydia以root运行，因此，如果Cydia在前台，而此时我们需要lock一个进程，而恰好此时该进程被Cydia lock，命令就不会运行成功。

运行一下 apt-get update, 获得最新的包列表

 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat15.png)

接下来安装class-dump-z, 可以用它来导出（dump）iOS应用的类信息（class infomation）。先到其[官方地址](https://code.google.com/p/networkpx/wiki/class_dump_z)，然后复制最新版本的地址，在写本文的时候，最新版本是 0.2a

 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat17.png)

现在，ssh进入你的设备，然后用wget下载class-dump-z.
 ![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat18.png)

另一个选择就是先下载到你电脑上，然后利用stfp上传到越狱设备上。一旦下载完成，使用tar来解压。
![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat19.png)

一旦解压完成，进入目录iphone_armv6,然后复制class-dump-z的执行文件到/usr/bin目录。这样你可以在设备上的任何目录都运行class-dump-z。拷贝完成之后，输入class-dump-z。你可以得到如下的输出，这就意味着class-dump-z已经成功安装。
![](https://raw.githubusercontent.com/kingly09/KYSecurityDefense/master/images/aq/042413_1342_IOSApplicat20.png)

总结

本文我们学习了如何越狱设备上搭建一个移动审计环境。在接下来的文章中我们将介绍如何使用class-dump-z来分析应用的类信息（class information）。


[译者注1]，在iPhone上的第一个蠕虫，ikee利用了默认的密码，具体参见对ikee的详细分析报告：[An Analysis of the iKeeB (duh) iPhone botnet (Worm)](http://mtc.sri.com/iPhone/)
 
