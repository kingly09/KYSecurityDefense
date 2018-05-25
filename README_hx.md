# iOS应用安全之代码混淆

代码混淆，文件名混淆，文件名混淆，类名混淆，协议名混淆，属性名混淆，函数名混淆等混淆方式。


关于iOS应用安全之代码混淆专题分为以下篇章：

* [iOS应用安全之代码混淆 - 01 理论篇](#mark-01)
* [iOS应用安全之代码混淆 - 02 实现篇](#mark-02)
* [iOS应用安全之代码混淆 - 03 使用篇](#mark-03)


### <a name="mark-01"></a>iOS应用安全之代码混淆 - 01 理论篇




iOS应用安全随着各种事件的曝出，越来越受到重视。那针对iOS应用安全方面能做点什么呢？如何让我们开发的应用更安全一点呢？要知道如何才能安全，就要了解iOS应用怎么就不安全了呢？现在随着越狱技术的提高和各种工具的完善，使得逆向分析一款iOS应用变成了一个轻而易举的事情。因此，要使的iOS应用更安全，那就从逆向工程的各个阶段进行层层阻拦。当然，这个只是增加逆向到难度而已～。

iOS应用逆向分析分为静态分析和动态分析。分析的前提是先有一部越狱过的设备，然后再应用去壳，将去壳后的应用利用工具`class－dump`导出头文件(先透漏下，本文就是针对它的，哈哈～)，用于分析程序逻辑及设计实现,利用`IDA` 或`Hoper`进行反汇编。以上两种方法为静态分析。利用`LLDB`对应用进行动态调试验证，那这个方法就是动态分析了。逆向的事也不多说了（就知道这些-_-|），本文的设计就是为了增加导出头文件分析的难度，让逆向人员看着头文件两眼冒金星～～

为了达到看一眼两眼冒金星的效果，现打算将以下内容进行混淆：

1.文件名

2.类名

3.协议名

4.属性名

5.函数名

元芳，你怎么看？将以上内容混淆后，然后编译发布。这样使用`class－dump`导出的头文件，应该也是混淆后的了。这样也就达到了我们的目的。

采用何种方式混淆呢？混淆无非就是将原来字解释的关键字变的不可读，那就简单点，直接调用系统自带的md5加密算法加密就可以了。


那混淆就简单的很了，混淆看来是指日可待了～


混淆原理：将以上需要混淆的内容关键字提取去来，然后md5加密，然后再替换工程中出现的关键字。


原理很简单，要考虑哪些问题呢？

1.如何提取关键字？

2.混淆算法就简单了，这个不是问题...

3.混淆后的关键字，怎么替换原来的关键字呢？

4.混淆后的工程还要还原回去吗？

5.混淆程序采用何种方式实现？

...

1.如何提取关键字？

提取关键字，当然是根据各种关键字自己的特性使用工具自动完成提取的。人工提取那还不疯了！！！如果工具提取，那符合规则的关键字包括系统的，不就都提取出来了？这样程序还能编译通过吗？也就是说提取关键字，只能提取自定义的，不能把系统自己生成的或使用的也提取出来。这个有点麻烦～～～～～。

2.混淆算法

md5，这个是不可逆的，所以混淆后，要保留关键字和加密后的对应表，方便后续排除bug用。

3.混淆后的关键字，怎么替换原来的关键字呢？

这个当然是使用工具批量替换了，如果遇到以下情况怎么办？

原字符串：“This is my fish.” 要将is” 替换为”is not“。我们希望的当然是：“This is not my fish.” 而不是“This not is not my fis noth.” 。也就是说，要达到想要的目的，必须是单词匹配替换，这个很重要。

4.混淆后的工程还要还原回去吗？

能混淆，当然能还原回去，但是好像没有必要哦～～，那就不考虑还原回去了，我的地盘听我的，呵呵。

5.混淆程序采用何种方式实现？

首先当然是脚本了，命令行工具丰富的很，拿来用即可。只是可惜，还要一个个学习而已。


还整点啥景呢？没了就开始整呗～


### <a name="mark-02"></a>iOS应用安全之代码混淆 - 02 实现篇


针对设计篇描述的大致思路，现在针对各个问题点，给出实现方法

该脚本大致使用的工具如下：`vi`、`grep`、`sed`、`find`、`awk`、`cut`、`sort`、`uniq`、`cat`、`md5`等。

针对要加密的内容，分别给出关键字提取脚本命令。

脚本中`$ROOTFOLDER`代表工程根目录，`$EXCLUDE_DIR` 代表要排除的目录，举例如下：

```
    ROOTFOLDER="demoProject"  
    EXCLUDE_DIR="--exclude-dir=*.framework --exclude-dir=include --exclude-dir=libraries --exclude-dir=Libs --exclude-dir=lib"    
```


####关键字提取
###1.文件名

第一步先将包含路径的文件名写入文件

```
find $ROOTFOLDER -type f | sed "/\/\./d" >f.list  
```


####第二步文件中提取文件名

```
cat f_rep.list | awk -F/ '{print $NF;}'| awk -F. '{print $1;}' | sed "/^$/d" | sort | uniq  
```    

但从文件名提取的功能上，上面两个步骤完全可以合并为一步，但是在实际功能实现中还是要求将上面分为两步的 


####2.类名

```
grep -h -r -I  "^@interface" $ROOTFOLDER  $EXCLUDE_DIR  --include '*.[mh]' | sed "s/[:(]/ /" |awk '{split($0,s," ");print s[2];}'|sort|uniq  
``` 

其中sort，排序；uniq 去除重复的。 


####3.协议名

```
grep -h -r -I  "^@protocol" $ROOTFOLDER  $EXCLUDE_DIR  --include '*.[mh]'| sed "s/[\<,;].*$//g"|awk '{print $2;}' | sort | uniq    
```

4.属性名


```
grep -r -h -I  ^@property $ROOTFOLDER  $EXCLUDE_DIR --include '*.[mh]' | sed "s/(.*)/ /g"  | sed "s/<.*>//g" |sed "s/[,*;]/ /g" | sed "s/IBOutlet/ /g" |awk '{split($0,s," ");print s[3];}'|sed "/^$/d" | sort |uniq  

```

其中

```
sed "/^$/d"  
```

是去除空行。

5.函数名

```
grep -h -r -I  "^[-+]" $ROOTFOLDER $EXCLUDE_DIR --include '*.[mh]' |sed "s/[+-]//g"|sed "s/[();,: *\^\/\{]/ /g"|sed "s/[ ]*</</"|awk '{split($0,b," ");print b[2];}'| sort|uniq |sed "/^$/d"|sed "/^init/d"  
    
```

函数名提取，目前只是提取函数名第一段的名称，如：


```
－(void)funName:(NSString *)param1 secondParam:(NSString *)param2;  
```

那么该脚本只会提取出`funName`。脚本中


是将函数中的以
init`开头的函数去除，因为，`oc`中初始化函数默认是以`init`开头的，如果把该类的函数也混淆的话，会有问题的。


那么，以上脚本即可实现各种关键词的收集，收集后合并成一个文件，然后再排序去重复。


####小小结

上述脚本提取出来的关键字包括系统自带的，也包括我们自己自定添加的，如果全部拿出混淆，那么我们混淆后的程序肯定是无法运行的，甚至无法通过编译。那么我们该怎么办？这个问题就是设计篇中提出的比较麻烦多事。最容易想到点方法就是，判断该关键字是否是系统自用的，如果是就不去混淆，相反就去混淆。那怎么系统用了哪些关键字？简单的很了，就是用上述提到的脚本，将系统使用的关键字，提取出来，作为系统自用的保留字。这样用排除法就可以解决这个麻烦的问题了，虽然比较笨拙，但是管用。

那么第一步就需要制作一个系统保留字字典库。用上述脚本即可完成。

那么第二步就是提取要替换的关键字，同样是用上述脚本，仔细看，你会发现个问题。提取文件名的时候，是将所有文件名都提取出来了，包括排除的目录，因此，在这个地方会有问题。我们要在文件名提取时，排除已经排除的目录或者将排除的目录文件名作为临时保留字。

####过滤并加密保留字

将以上两步获取的关键字进行过滤。

```
    cat $SOURCECODEKEYWORDS |   
    while read line  
    do  
    if grep $line $RESKEYSALL  
    then  
    echo filter1: $line  
    else  
    md5 -r -s $line  | sed s/\"//g >> $REPLACEKEYWORDS  
    fi  
    done  
    
```

其中`$SOURCECODEKEYWORDS`是从`ROOTFOLDER`中提取的要混淆的关键字


####替换工程中关键字

该步骤是本功能的核心，要实现文件中的关键字替换，不对，准确的说，应该是文件中的关键字单词替换。这个就是设计篇中提到的问题。

愿字符串："This is my fish.” 要将is” 替换为”is not“。我们希望的当然是：“This is not my fish.” 而不是“This not is not my fis noth.” 。也就是说，要达到想要的目的，必须是单词匹配替换，这个很重要。经过实践证明，OS X版的sed并没有实现单词匹配替换，只能是将匹配正则表达式的行，进行字符串替换，也就是替换后是我们不想要的结果。这个可肿么办？还好经过一番挖掘，找到一种比较笨拙的办法，效果如下，又要发挥愚公精神了。

```
    sed -i '' '  
    '"$v2"'s/)'"$var2"':/)'"$var1"':/g  
    '"$v2"'s/('"$var2"':/('"$var1"':/g  
    '"$v2"'s/ '"$var2"':/ '"$var1"':/g  
    '"$v2"'s/\"'"$var2"':/\"'"$var1"':/g  
    ' $v1  
```

其中，v2代表行号；var2代表要替换的关键字，即例子中的“is”；var1是混淆后的字符串；v1 是指文件路径，包括文件名；－i表示直接修改文件，后面必须带两个单引号,要不然会有错误，单引号内容应该是要备份的文件名，在此不需要备份所以为空；在第一行和最后一行之间的意思是，描述单词出现时的各种场景，要想达到单词匹配的效果，那就在此必须列举所有情景，这个真够蛋疼的～～，愚公上吧！！！ 


####替换属性设置方法

```
    cat repProperty.txt |  
    while read line  
    do  
    ar=(`echo "$line"|cut -f 1-2 -d " "`)  
    first=`echo ${ar[1]}|cut -c -1| sed "y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/"`  
    second=`echo ${ar[1]}|cut -c 2-`  
    lastFind=`echo set$first$second`  
    lastRep=`echo setZ${ar[0]}m`  
    rm -f rep.tmp  
    if grep -r -n -I -w "$lastFind"  $ROOTFOLDER $EXCLUDE_DIR   --include="*.[mhc]" --include="*.mm" --include="*.storyboard" --include="*.xib" >rep.tmp  
    then  
    cat rep.tmp |  
    while read l  
    do  
    v1=$(echo "$l"|cut -d: -f 1 )  
    v2=$(echo "$l"|cut -d: -f 2 )  
    sed -i '' ''"$v2"'s/'"$lastFind"'/'"$lastRep"'/g' $v1  
    echo "step3:"$l  
    done  
    else  
    echo "step3:do not find:"$lastFind  
    fi  
    done  
    
```

这个也是相对比较麻烦的，因为oc的属性系统是可以自动合成setter函数的，所以属性的混淆需要额外多考虑点。上面的做法是，根据提取的过滤后的属性关键字，生成属性设置函数，然后查找过程中是否有用到，有就混淆掉。 


#### 文件名混淆

  
```
    cat f_rep.list |  
    while read line  
    do  
    echo "old name:"$line  
    v1=$(echo "$line" | sed "s/\// /g" | awk '{print $NF}')  
    echo "v1="$v1  
    v2=$(echo $v1 | sed "s/\./ /g" | awk '{print $1}')  
    echo "v2="$v2  
    if grep -w $v2 $RESKEYSALL  
    then  
    echo "find."  
    else  
    v3=$(echo $v1 | sed "s/\./ /g" | awk '{print "."$2}')  
    echo "v3="$v3  
    v4=$(md5 -q -s "$v2" | sed "s/.*/z&m/g")  
    echo "v4="$v4  
    v5=$(echo "$line" | sed "s/"$v1"//g")  
    echo "v5="$v5  
    mv $line $v5$v4$v3  
    echo "new name:"$v5$v4$v3  
    fi  
    done  
      
```   

文件名混淆的原理就是将需要混淆的文件路径，提取出要混淆的部分，然后组合成最终的文件名，使用`mv`命令完成文件名混淆。


至此，设计篇中提及的要混淆的内容已经全部完成混淆。

注意事项

1.需要将工程名称作为临时保留关键字

如：工程名称`demoProject`，那么`demoProject`要作为保留字，否则混淆后，可能`target`的名称也会被混淆掉，这个不是我们期望的；

2.需要将工程中的子目录名称作为临时保留关键字

如：在工程目录下有子文件夹`AFNetworking`，在Xcode工程的导航里也可以看到`AFNetworking`的分组，此时，如果`AFNetworking`也被混淆，那么工程中的分组会变成混淆后的字符串，但是工程目录下的子文件夹AFNetworking并没有改变，所以此时，会找不到响应的文件；根本原因是我们的混淆没有对文件夹名进行混淆。

3.需要将访问网络时组织的参数名称作为临时保留关键字

如：有一个属性名为：`passport`；恰好在组织网络参数时，有一个字段也叫`passport`，如果作为属性关键字`passport`被混淆了，那么组织网络参数时用的`passport`也会被混淆掉，所以此时传给后台的关键字`passport`就变了，导致后台无法识别；因此，出现这个情况时，要添加到临时的保留字中；如果编码规范的话，不用添加临时保留字也会避免～

4......

### <a name="mark-03"></a>iOS应用安全之代码混淆 - 03 使用篇


