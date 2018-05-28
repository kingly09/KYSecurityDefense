#!/bin/bash
echo "#########################################"
echo  "File Name:KYConfuse.sh  "
echo  "Copyright (c) 2018 KYConfuse"
echo  "Email:362108564@qq.com"
echo  "Create:2018.05.28"
echo "#######################################"
echo "用户修改区－开始"
#要替换的源代码所在的根目录,该脚本文件与根目录处于同级文件夹
ROOTFOLDER ="KYSecurityDefenseDemo"
#要排除的文件夹,例如demo中用到的第三方库AFNetworking等
EXCLUDE_DIR ="--exclude-dir=Pods --exclude-dir=buildAppstore --exclude-dir=Carthage --exclude-dir=Images.xcassets  --exclude-dir=Certificates --exclude-dir=fastlane --exclude-dir=fastlanelog --exclude-dir=BCEAccountAPPTests --exclude-dir=BCEAccountAPPUITests  --exclude-dir=Vendor"
echo "用户修改区－结束"

#自定义的保留关键字,相当与白名单，添加到该文件中，一行一个，加入该文件的关键字将不被混淆;如工程中自定义的文件夹名称
RESCUSTOM="resCustom.txt"

#保留关键字文件不可删除
RESERVEDKEYWORDS="./reskeys.txt"
#最终的保留关键字＝保留关键字＋文件名
RESKEYSALL="./reskeysall.txt"
#提取的所有关键字
SOURCECODEKEYWORDS="./srckeys.txt"
#过滤后，最终要替换的关键字，混淆结束后，不删除，用于bug分析
REPLACEKEYWORDS="./replacekeys.txt"

#删除已经存在的临时文件
rm -f $SOURCECODEKEYWORDS
rm -f $REPLACEKEYWORDS
rm -f $RESKEYSALL
rm -f temp.res

#提取文件名列表
rm -f f.list
find $ROOTFOLDER -type f | sed "/\/\./d" >f.list
#根据要排除的文件目录，将文件列表分离
#Exclude=$(echo $EXCLUDE_DIR | sed "s/--exclude-dir\=//g" |sed "s/ $//g" | sed "s/[*.]//g" | sed "s/ /\\\|/g")
Exclude=$(echo $EXCLUDE_DIR | sed "s/--exclude-dir\=//g" |sed "s/ $//g" | sed "s/ /\\\|/g")
#保留文件列表
rm -f f_res.list
cat f.list | grep "$Exclude" >f_res.list
#混淆文件列表
rm -f f_rep.list
cat f.list | grep -v "$Exclude" >f_rep.list
rm -f f.list
#提取文件名
rm -f filter_file.txt
cat f_rep.list | awk -F/ '{print $NF;}'| awk -F. '{print $1;}' | sed "/^$/d" | sort | uniq >filter_file.txt

#从源代码目录中提取要过滤的函数关键字
rm -f filter_fun.txt
grep -h -r -I  "^[-+]" $ROOTFOLDER $EXCLUDE_DIR --include '*.[mh]' |sed "s/[+-]//g"|sed "s/[();,: *\^\/\{]/ /g"|sed "s/[ ]*</</"|awk '{split($0,b," ");print b[2];}'| sort|uniq |sed "/^$/d"|sed "/^init/d" >filter_fun.txt

#从源代码目录中提取要过滤的属性关键字
rm -f filter_property.txt
grep -r -h -I  ^@property $ROOTFOLDER  $EXCLUDE_DIR --include '*.[mh]' | sed "s/(.*)/ /g"  | sed "s/<.*>//g" |sed "s/[,*;]/ /g" | sed "s/IBOutlet/ /g" |awk '{split($0,s," ");print s[3];}'|sed "/^$/d" | sort |uniq >filter_property.txt

#从源代码目录中提取要过滤的类关键字
rm -f filter_class.txt
grep -h -r -I  "^@interface" $ROOTFOLDER  $EXCLUDE_DIR  --include '*.[mh]' | sed "s/[:(]/ /" |awk '{split($0,s," ");print s[2];}'|sort|uniq >filter_class.txt

#从源代码目录中提取要过滤的协议关键字
grep -h -r -I  "^@protocol" $ROOTFOLDER  $EXCLUDE_DIR  --include '*.[mh]'| sed "s/[\<,;].*$//g"|awk '{print $2;}' | sort | uniq >>filter_class.txt

#合并要过滤的关键字，并重新排序过滤
rm -f $SOURCECODEKEYWORDS
cat filter_fun.txt filter_property.txt filter_class.txt filter_file.txt |sed "/^$/d" | sort | uniq >$SOURCECODEKEYWORDS
rm -f filter_fun.txt
rm -f filter_class.txt
rm -f filter_file.txt

#自动获取保留字，工程名等
rm -f temp.res
cat `cat f_rep.list | grep project.pbxproj` | grep -w productName | sed "s/;//g"|awk '{print $NF;}'>temp.res
#提取要保留的文件名
cat f_res.list | awk -F/ '{print $NF;}'| awk -F. '{print $1;}' | sed "/^$/d" | sort | uniq >>temp.res
rm -f f_res.list
#合并自定义保留字
#判断自定义保留字文件是否存在，不存在即创建一个空的
if [ ! -f "$RESCUSTOM" ]; then 
touch "$RESCUSTOM" 
fi 
cat $RESERVEDKEYWORDS $RESCUSTOM temp.res | sort |uniq >$RESKEYSALL
rm -f temp.res

#过滤保留字，将需要混淆的关键字加密后写入文件
rm -f $REPLACEKEYWORDS
cat $SOURCECODEKEYWORDS | 
while read line
do
if grep $line $RESKEYSALL
then
echo filter1: $line
else
#使用md5对关键字进行加密
md5 -r -s $line  | sed s/\"//g >> $REPLACEKEYWORDS
fi
done
rm -f $SOURCECODEKEYWORDS

#开始混淆，替换源代码中的关键字为加密后的,防止开头为数字的情况
cat $REPLACEKEYWORDS |
while read line
do
var1=$(echo "$line"|awk '{print "z"$1"m"}')
var2=$(echo "$line"|awk '{print $2}')
rm -f rep.tmp
if grep -r -n -I -w "[_]\{0,1\}$var2"  $ROOTFOLDER $EXCLUDE_DIR   --include="*.[mhc]" --include="*.mm" --include="*.pch" --include="*.storyboard" --include="*.xib" --include="*.nib" --include="contents" --include="*.pbxproj" >rep.tmp
then
cat rep.tmp |
while read -r l
do
#获取文件路径
v1=$(echo "$l"|cut -d: -f 1 )
#获取行号
v2=$(echo "$l"|cut -d: -f 2 )
#获取指定行数据
v3=$(sed -n "$v2"p "$v1")
##sed自带文件文本替换功能，不符合我们的期望，故放弃使用；有无适合的脚本命令，还希望脚本高手予以指点～
#sed -i '' ''"$v2"'s/'"$var2"'/'"$var1"'/g' $v1
#特殊字符转义替换，echo中 输出的变量 一定要加双引号！！！
v4=$(echo "$v3" | awk '{gsub(/"/, "\\\"", $0);gsub(/</, "\\\<", $0);gsub(/>/, "\\\>", $0);gsub(/\*/, "\\\*", $0);gsub(/\//, "\\\/", $0);gsub(/\[/, "\\\[", $0);gsub(/\]/, "\\\]", $0);gsub(/\{/, "\\\{", $0);gsub(/\}/, "\\\}", $0);gsub(/\&/, "\\\\\&", $0); print $0;}')
#单词替换
var3=$(./KYReplacewords.run "$v4" "$var2" "$var1")
#整行替换
sed -i '' "$v2"'s/.*/'"$var3"'/g' "$v1"
echo "step2:$l"
done
else
echo "step2:do not find:$var2"
fi
done
rm -f tmp.txt

#过滤保留字，用于属性设置函数混淆，将需要混淆的关键字加密后写入文件
rm -f repProperty.txt
cat filter_property.txt | 
while read line
do
if grep $line $RESKEYSALL
then
echo filter1: $line
else
md5 -r -s $line  | sed s/\"//g >> repProperty.txt
fi
done
rm -f filter_property.txt

#开始混淆，替换属性前带下划线的地方
cat repProperty.txt |
while read line
do
ar=(`echo "$line"|cut -f 1-2 -d " "`)
lastFind=`echo _${ar[1]}`
lastRep=`echo _z${ar[0]}m`
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
rm -f rep.tmp

#开始混淆，替换属性设置函数
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
rm -f rep.tmp
rm -f repProperty.txt

cat f_rep.list |
while read line
do
echo "old name:"$line
#获取文件名，带后缀
v1=$(echo "$line" | sed "s/\// /g" | awk '{print $NF}')
echo "v1="$v1
#获取文件名，不带后缀
v2=$(echo $v1 | sed "s/\./ /g" | awk '{print $1}')
echo "v2="$v2
if grep -w $v2 $RESKEYSALL
then
echo "find."
else
#获取后缀
v3=$(echo $v1 | sed "s/\./ /g" | awk '{print "."$2}')
echo "v3="$v3
#对不带后缀的文件名加密
v4=$(md5 -q -s "$v2" | sed "s/.*/z&m/g")
echo "v4="$v4
#获取路径
v5=$(echo "$line" | sed "s/"$v1"//g")
echo "v5="$v5
#修改文件名
mv $line $v5$v4$v3
echo "new name:"$v5$v4$v3
fi
done

rm -f f_rep.list
rm -f $RESKEYSALL

echo "###########################  恭喜您，代码混淆完成！  ###########################"

exit
