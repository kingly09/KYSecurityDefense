# 测试过程

### 传输安全

### 明文流量

### 不当的会话处理

### 正确验证SSL证书

### 编译器的保护

### 反破解保护

### PIE编译


### 用stack cookies编译

### 自动引用计数

### uiwebviews

###数据验证（输入，输出）

###  分析UIWebView的实现

### 不安全的数据存储

### SQLlite数据库

### 文件缓存

### 检查属性列表文件

### 请检查日志文件

### logging

### 自定义日志

### nslog报表

### 崩溃报告文件

### 二元分析

### 分解应用

### 检测的汇编代码保护混淆

### 检测防篡改保护

### 检测反调试保护

### 协议处理程序

### 客户端注入

### 第三方的库


# 黑盒分析结果

下列工具被用于黑盒分析：

1. otool (object file displaying tool)[1]
2. Burp pro (proxy tool)[2]
3. ssh (Secure Shell)

一般SDK是向下兼容的，如果保证SDK版本与越狱设备的版本一致或者高于越狱设备版本,使用xcrun --sdk iphoneos --show-sdk-path查看SDK版本。如下：SDK版本是8.3，设备是iOS 8.1


使用以下建议可以降低安全风险：

1、确保所有的连接都使用安全传输协议

2、用SSL证书检查客户端应用程序

3、使用iOS数据保护的API加密储存在客户端的敏感信息

4、检测设备是否有越狱


```
    - (BOOL)myIap_isJailbroken  
    {  
        //以下检测的过程是越往下，越狱越高级  
          
        //    /Applications/Cydia.app, /privte/var/stash  
        BOOL jailbroken = NO;  
        NSString *cydiaPath = @"/Applications/Cydia.app";  
        NSString *aptPath = @"/private/var/lib/apt/";  
        if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {  
            jailbroken = YES;  
        }  
        if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {  
            jailbroken = YES;  
        }  
          
        //可能存在hook了NSFileManager方法，此处用底层C stat去检测  
        struct stat stat_info;  
        if (0 == stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &stat_info)) {  
            jailbroken = YES;  
        }  
        if (0 == stat("/Applications/Cydia.app", &stat_info)) {  
            jailbroken = YES;  
        }  
        if (0 == stat("/var/lib/cydia/", &stat_info)) {  
            jailbroken = YES;  
        }  
        if (0 == stat("/var/cache/apt", &stat_info)) {  
            jailbroken = YES;  
        }  
        //    /Library/MobileSubstrate/MobileSubstrate.dylib 最重要的越狱文件，几乎所有的越狱机都会安装MobileSubstrate  
        //    /Applications/Cydia.app/ /var/lib/cydia/绝大多数越狱机都会安装  
        //    /var/cache/apt /var/lib/apt /etc/apt  
        //    /bin/bash /bin/sh  
        //    /usr/sbin/sshd /usr/libexec/ssh-keysign /etc/ssh/sshd_config  
          
        //可能存在stat也被hook了，可以看stat是不是出自系统库，有没有被攻击者换掉  
        //这种情况出现的可能性很小  
        int ret;  
        Dl_info dylib_info;  
        int (*func_stat)(const charchar *,struct stat *) = stat;  
        if ((ret = dladdr(func_stat, &dylib_info))) {  
            NSLog(@"lib:%s",dylib_info.dli_fname);      //如果不是系统库，肯定被攻击了  
            if (strcmp(dylib_info.dli_fname, "/usr/lib/system/libsystem_kernel.dylib")) {   //不相等，肯定被攻击了，相等为0  
                jailbroken = YES;  
            }  
        }  
          
        //还可以检测链接动态库，看下是否被链接了异常动态库，但是此方法存在appStore审核不通过的情况，这里不作罗列  
        //通常，越狱机的输出结果会包含字符串： Library/MobileSubstrate/MobileSubstrate.dylib——之所以用检测链接动态库的方法，是可能存在前面的方法被hook的情况。这个字符串，前面的stat已经做了  
          
        //如果攻击者给MobileSubstrate改名，但是原理都是通过DYLD_INSERT_LIBRARIES注入动态库  
        //那么可以，检测当前程序运行的环境变量  
        charchar *env = getenv("DYLD_INSERT_LIBRARIES");  
        if (env != NULL) {  
            jailbroken = YES;  
        }  
        return jailbroken;  
    }  
```


5、使用混淆汇编代码和反调试技巧，增加攻击者逆向的难度

6、删除所有调试语句和符号文件

7、删除应用程序中的开发信息