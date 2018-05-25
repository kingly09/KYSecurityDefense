# iOS应用程序安全

# 目录

* [iOS应用程序安全(1)-搭建移动渗透测试平台](#markdown-aq01)
* [iOS应用程序安全(2)-获得iOS应用程序的类信息](#markdown-aq02)
* [iOS应用程序安全(3)-理解Objective-C Runtime](#markdown-aq03)
* [iOS应用程序安全(4)-用Cycript进行运行时分析(Yahoo天气应用)](#markdown-aq04)




### <a name="markdown-aq01"></a>iOS应用程序安全(1)-搭建移动渗透测试平台

作者：Prateek Gianchandani

译者：吴发伟

原文网址：[http://resources.infosecinstitute.com/ios-application-security-part-1-setting-up-a-mobile-pentesting-platform/](http://resources.infosecinstitute.com/ios-application-security-part-1-setting-up-a-mobile-pentesting-platform/)

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
 
### <a name="markdown-aq02"></a>iOS应用程序安全(2)-获得iOS应用程序的类信息



作者：Prateek Gianchandani

译者：吴发伟

原文网址：[http://resources.infosecinstitute.com/ios-application-security-part-2-getting-class-information-of-ios-apps/](http://resources.infosecinstitute.com/ios-application-security-part-2-getting-class-information-of-ios-apps/)

版权声明：自由转载-非商用-保持署名

#### 介绍

你是否下载过非常cool的app（不管它是预装应用还是从`App store`下载的应用），然后想知道它是如何编写的，它使用了哪些第3方库呢？是否想知道这个app内部代码是如何组织的？你是否想导出它内部的图片（images）、plist文件？如果答案是想的话，那你来对地方了，本文就将解答这些信息。

本文我们将分析应用（不管是预装应用还是从`App store`下载的应用）内部的类`（class）`是如何使用的，它的`view controller`使用的`view`的名称，它内部使用的库，甚至更复杂的，例如变量和方法的名称。我们将解密`（decrypt）`从`App store`下载的应用，导出它所有的`image`、`plist`文件。

点击 [此查看上一篇文章](#markdown-aq01)。


#### 导出设备上预装应用的类信息

现在我们能够分析应用的类信息了，先试试导出`Apple`的`Maps`应用。第一步是定位`Apple Maps`应用的可执行文件的位置。 所有iOS预装的应用都位于`/Applications`目录下。因此，先转到那个目录。


在这你可以看到所有预装的应用。进入`Maps`应用的目录然后执行`list`命令:

正如你所见，我们可以看到Maps应用使用的所有的`image`、`plist`文件。随后我们将讨论如何获取一个特定的应用的所有image文件或者其他文件。如下图所示，Maps.app目录里面有个文件叫做`Maps`。请注意可执行程序的名称和app的名称相同。


为了导出类信息，在命令行下输入 `class-dump-z Maps `


你会在命令行看到太多输出，最好是输出到一个文件，这里我们把它输出到名叫`class-dump-Maps`的文件。


你可以使用sftp登录设备然后下载这个文件。你可以使用命令`get`，如下图所示。


现在文件已经下载到电脑上，可以用`TextMate`打开。


我们从接口文件看到代码是如何设计的。例如，在这你可以看到一个`InfoCardController`。或许你已经猜到，当我们点击下面图片中的位置信息的向右箭头的时候，就是这个VC用来展示这个地址的更多信息的。


 我们看看应用中的这个`view`。这一页实际上是`InfoCardViewController`展示的。

 如果你看到这个图以及上面导出的类信息，你可以很容易的知道当你点击上面的按钮的时候，哪些对应的方法会被调用。例如，如果你点击了`“Direction to herev`, 那

`
-(void)_directionsTo:(id)to person:(void*)person property:(int)property identifier:(int)identifier;`

这个方法会被调用。

类似的，如果点击了`“Add to Bookmarks” `, 那

`
-(void)_addToBookmarks:(id)bookmarks person:(void*)person property:(int)property identifier:(int)identifier;`

这个方法会被调用。

你也可以从这个应用里找出很多其他信息，例如有个`UserLocationSearchResults`继承自`SearchResult`。


你能获得多少信息，完全在于你的好奇心有多少！


####导出从`App store`下载的`app`的类信息

如果你想分析从`App store`下载的`app`，有2个重要的事情你要先知道：

* 这些应用存放在另一个地方，`/var/mobile/Applications/`
* 和预装的app不同，这些应用是加密了的，因此你首先需要解密一下。

为了解密这些应用，我们将使用一个叫做`Clutch`的命令行工具。请注意提供`Clutch`的Hackuous已经于数月前被关闭。但是在网上能够找到`Clutch`的可执行文件。

如果你已经下载到了`Clutch`，现在要做的事情就是把它上传到你的越狱设备上。可以使用`sftp`，使用的方法如图：


现在用`ssh`登录设备，然后输入`clutch`。然后你可以得到所有可以被破解的应用列表。


为了破解某个应用，输入 “`clutch` 应用名称” 即可。例如，如果我们想破解`Facebook`这个应用，输入`clutch Facebook`



一旦破解完成，`clutch`会告诉你它保存`ipa`文件的位置。现在ipa只是整个`app`文件的压缩版本。使用命令行`unzip`解压，用`-d`指定解压的目录，如下图所示。你也可以用`sftp`把`ipa`拷贝到你电脑上，然后解压。



现在我们已经获得了解密之后的文件，我们就可以使用 `class-dump-z` 来导出类信息，并把它保存到 `class-info-Facebook` 目录。



一旦导出完成，你可以退出`ssh`，然后用`sftp`登录并下载`class-info-Facebook`文件。




现在你可以用文本编辑器查看这个文件。例如，这里有个名叫`FBFacebookRequestSender`的协议用来发送异步请求，并且有一个方法用来验证`session`是否有效。



#### 从应用获得图片和其他文件

正如前文讨论的，你可以使用`sftp`从应用中下载你需要的所有文件。不过，有更方便的方法来下载文件，例如使用[iExplorer](www.macroplant.com/iexplorer/download-ie3-mac.php)。从其官方网站上下载，安装之后打开它，确保你的设备通过USB连接到系统。


要查看文件系统，点击`files`.


要查看某个特定的应用，点击`Apps`.


 如你所见，浏览文件和上传、下载文件都非常容易。在这里，要下载`Facebook`应用中的`image`和其他文件。在左边栏，点击`Facebook`，然后在右边右键，就可以导出所有文件。
 
 
 
 总结

在本文的前两部分，我们学习了如何在越狱设备上搭建一个移动审计环境。然后我们学到了如何导出任意应用的类信息，利用类信息来学习理解代码的设计和内部是如何工作的。我们也学到了如何解密和审计从`App store`下载的应用。我们也学到了如何使用`sftp`和`iExplorer`来下载、上传文件。

通过使用`class-dump-z`导出类信息, 能够获得所有的调用方法。有没有可能通过某种方式来进行运行时的修改呢？

例如，如果一个方法如`(BOOL)isFacebookSessionValid` 在某种情况下返回`false`，是否有可能操作应用，使得它返回`YES`，因此让应用去做一些未知的事情？进一步的，是否有可能创建我们自己的方法并且在`isFacebookSessionValid` 执行时执行我们自己的方法呢？ 是否有可能在运行时、或者某个特定指令之后修改一个应用的实例变量呢？

这个答案是：可以`（YES）`。我们将在接下来的文章中学习。


本文原文是 [IOS Application security Part 2 – Getting class information of IOS apps](http://resources.infosecinstitute.com/ios-application-security-part-2-getting-class-information-of-ios-apps/)


### <a name="markdown-aq03"></a>iOS应用程序安全(3)-理解Objective-C Runtime


作者：Prateek Gianchandani

译者：吴发伟

原文网址：[http://resources.infosecinstitute.com/ios-application-security-part-3-understanding-the-objective-c-runtime/](http://resources.infosecinstitute.com/ios-application-security-part-3-understanding-the-objective-c-runtime/)

版权声明：自由转载-非商用-保持署名

#### 引言

基本上所有的`iOS`应用都是用`Objective-C`编写的。所有这些应用都使用`Cocoa`，`Cocoa`在`Objective-C`上面，提供更高层次的`API`，使得`Mac`和`iOS`开发变得更容易一些。`Cocoa`也给应用提供了一个运行时环境。本文我们将着重理解`Objective-C`的运行时和关于内部函数如何运行的错综复杂的细节。这会让我们能够更深入的理解应用程序。


#### Objective-C runtime

`Objective-C`是一个面向运行时的语言。所以问题就是，什么是一个运行时语言？一个运行时语言就是在应用程序运行的时候来决定函数内部实现什么以及做出其它决定的语言。`Objective-C`是一个运行时语言吗？不是。它是一个面向运行时的语言，这意味着只要有可能，它就把做决定的时间从编译时和链接时延迟到这段代码真正执行的时候。正如前面指出的，`Cocoa`提供了`iOS`应用程序所需要的运行时环境。下面的截图来自苹果官方的文档，说的非常清楚。你可以到这阅读这个文档。




我们来看看运行时库是否被工程引入了。理想情况下，它应该存在于每个iOS应用中。登录进设备，然后进入到应用程序目录。





在命令行中输入`ls *`


现在来看看`BADLAND iOS`应用程序。`BADLAND`是一个流行的`iOS`游戏。进入到`BadLand`的目录内，一旦进入到`BADLAND.app`目录内，对`BadLand`的二进制文件使用`otool`。


可以看到引入了很多的`framework`以及库文件。`objc-runtime`也在其中，如图：


这个运行时库使得在`Objective-C`中进行运行时操作变得可能。默认所有iOS应用都包含这个库。下面是对`Google Maps`应用使用`otool`得到的结果，你可以看到，它也包含了`Objective-C` 运行时库。


#### 使用GDB进行运行时分析

在本节，我们将使用`GDB`来观察程序的流程。第一件事情就是安装一个合适版本的`gdb`。从`Cydia`能获得的`gdb`版本并不能工作正常。因此，确保你从其他地方获得`gdb`，然后可以通过`sftp`安装到设备上。如图：


确保你有能够运行的权限。


为了能够挂钩（`hook`）进一个运行的进程，第一件事就是确保这个进程正在运行。在这里，我们将在`Google Maps`应用上测试。首先我们启动应用，然后获得它的进程id。确保它在前台运行。如下图所示，`Google Maps`的进程id是661。请注意这个id在你的设备上可能不同。


现在，我们用`GDB` 挂钩这个进程。




你可以看到，我们成功挂钩进入这个进程。目前我们可以忽略其中的警告。

`Objective-C`是基于消息的，一旦一个消息被发出，`objc_msgSend`就会被调用。为了能够分析应用的运行流程，我将给一个最基本的调用下一个断点，例如`objc_msgSend`, 并且打印出$r0和$r1的值。从`$r0`我们可以知道这个方法对应的类是什么，从`$r1`我们可以知道`selector`。请注意，即使是这样，也可能会打印出太多的细节信息，因为`objc_msgSend`在消息发出的每个地方都会被调用。在接下来的文章里，我们将看看如何能够更有效使用它。因此，基本上只要断点断下来，我就将打印出`$r0`和`$r1`的值然后继续运行程序。下面是如何做的。



输入 `c` 继续运行程序




####Method Swizzling

我们已经学到许多iOS应用都使用运行时环境、并且在运行时再做决定。正如其名，`method swizzling`是我们用来修改iOS程序的另一个武器，我们可以用它来调用我们自己的方法。在下一篇文章中，我们将详细介绍`Method Swizzling`。


参考:

[The Dark art of IOS Application hacking](http://www.slideshare.net/daniel_bilar/blackhat2012-zdziarskidarkarti-osapplicationhacking/)

[The Objective-C runtime](http://www.slideshare.net/mobiledatasolutions/objectivec-runtime)


本文原文是 [IOS Application security Part 3 – Understanding the Objective-C Runtime]()



###  <a name="markdown-aq04"></a>iOS应用程序安全(4)-用Cycript进行运行时分析(Yahoo天气应用)