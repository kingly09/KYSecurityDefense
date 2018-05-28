//
//  main.c
//  KYReplacewords
//
//  Created by kingly on 2018/5/28.
//  Copyright © 2018年 kingly. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *g_dictWords = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";

//单词替换
char *kyWordsReplace(char *src, char *old, char *new);
//字符串替换
char *kyStringReplace(char *src, char *old, char *new);


int main(int argc, const char * argv[]) {
  // insert code here...
  if (argc != 4) {
    printf("Arguments error.For example:./KYReplacewords \"This is test cases.\" is are\n");
    return 0;
  }
  
#if 1
  char *rawString = (char *)argv[1];
  char *old = (char *)argv[2];
  char *new = (char *)argv[3];
#else
  char *rawString = "    9854747A1BA00B5600A892C8 /* CollectViewController.m in Sources */ = {isa = PBXBuildFile; fileRef = 985474791BA00B5600A892C8 /* CollectViewController.m */; };";
  char *old = "CollectViewController";
  char *new = "aaaaaaaaaaaa";
#endif
  
  //单词替换
  char *newString = kyWordsReplace(rawString, old, new);
  char *retString = newString;
  
  printf("%s\n", retString);
  if (rawString != retString) {
    free(retString);
  }
  
  return 0;
}

//单词替换，如:This is a good news.==>is -> are ==> This are a good news.
char *kyWordsReplace(char *src, char *old, char *new)
{
  int iReplaceCount = 0;
  //char *olds = src;
  char pre = '\0';
  char aft = '\0';
  char *pFindChar = NULL;
  char *pStart = src;
  
  char *newString = src;
  char *newStringTmp = NULL;
  //step :首先统计要替换的单词数量
  char *pFindWord = strstr(pStart, old);
  while (pFindWord != NULL) {
    //取出前后字符
    if (pFindWord == pStart) {
      pre = '\0';
    }
    else
    {
      pre = *(pFindWord - 1);
    }
    aft = *(pFindWord + strlen(old));
    
    pFindChar = strchr(g_dictWords, pre);
    if (!pFindChar || pre == '\0') {
      pFindChar = strchr(g_dictWords, aft);
      if (!pFindChar || aft == '\0') {
        //printf("i am here: pPre=%c find=%s pAft=%c\n", pre, find, aft);
        iReplaceCount++;
      }
    }
    //查找位置向前移动
    pFindWord = strstr(pFindWord + strlen(old), old);
    pre = '\0';
    aft = '\0';
  }
  
  if (iReplaceCount > 0) {
    //step :根据统计大小，为新的字符串申请空间
    unsigned long iNewLenght = strlen(src) + (strlen(new) - strlen(old)) * iReplaceCount;
    //printf("iReplaceCount is %d totol lenth = %lu\n", iReplaceCount, iNewLenght);
    newString = (char *)calloc(iNewLenght, 1);
    newStringTmp = newString;
    
    //step :根据原始字符串，填充新的字符串
    pStart = src;
    pFindWord = strstr(pStart, old);
    while (pFindWord != NULL) {
      //取出前后字符
      if (pFindWord == pStart) {
        pre = '\0';
      }
      else
      {
        pre = *(pFindWord - 1);
      }
      aft = *(pFindWord + strlen(old));
      
      pFindChar = strchr(g_dictWords, pre);
      if (!pFindChar || pre == '\0') {
        pFindChar = strchr(g_dictWords, aft);
        if (!pFindChar || aft == '\0') {
          //拷贝找到的字符串之前的字符串
          strncpy(newStringTmp, pStart, pFindWord - pStart);
          //向新自负串中追加替换后的字符串
          strcat(newStringTmp, new);
          //printf("i am here: pPre=%c find=%s pAft=%c newString=%s\n", pre, pFindWord, aft, newStringTmp);
          //开始位置向前移动
          pStart = pFindWord + strlen(old);
          newStringTmp = newString + strlen(newString);
        }
      }
      //查找位置向前移动
      pFindWord = strstr(pFindWord + strlen(old), old);
      pre = '\0';
      aft = '\0';
    }
    
    //step :追加最后一部分字符串
    if (pStart != src) {
      strcat(newString, pStart);
    }
    
    //printf("last string is :%s\n", newString);
    //free(newString);
  }
  
  return newString;
}

//字符串替换，如:This is a good news.==>is -> are ==> Thare are a good news.
char *kyStringReplace(char *src, char *old, char *new)
{
  int iReplaceCount = 0;
  char *pStart = src;
  
  char *newString = src;
  char *newStringTmp = NULL;
  //step :首先统计要替换的字符串数量
  char *pFindWord = strstr(pStart, old);
  while (pFindWord != NULL) {
    iReplaceCount++;
    //查找位置向前移动
    pFindWord = strstr(pFindWord + strlen(old), old);
    
  }
  
  if (iReplaceCount > 0) {
    //step :根据统计大小，为新的字符串申请空间
    unsigned long iNewLenght = strlen(src) + (strlen(new) - strlen(old)) * iReplaceCount;
    //printf("iReplaceCount is %d totol lenth = %lu\n", iReplaceCount, iNewLenght);
    newString = (char *)calloc(iNewLenght, 1);
    newStringTmp = newString;
    
    //step :根据原始字符串，填充新的字符串
    pStart = src;
    pFindWord = strstr(pStart, old);
    while (pFindWord != NULL) {
      //拷贝找到的字符串之前的字符串
      strncpy(newStringTmp, pStart, pFindWord - pStart);
      //向新自负串中追加替换后的字符串
      strcat(newStringTmp, new);
      //printf("i am here: pPre=%c find=%s pAft=%c newString=%s\n", pre, pFindWord, aft, newStringTmp);
      //开始位置向前移动
      pStart = pFindWord + strlen(old);
      newStringTmp = newString + strlen(newString);
      
      //查找位置向前移动
      pFindWord = strstr(pFindWord + strlen(old), old);
    }
    
    //step :追加最后一部分字符串
    if (pStart != src) {
      strcat(newString, pStart);
    }
    
    //printf("last string is :%s\n", newString);
    //free(newString);
  }
  
  return newString;
}

