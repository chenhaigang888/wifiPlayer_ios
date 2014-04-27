//
//  Head.h
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-24.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#ifndef __wifiPlayer_3_0_ios__Head__
#define __wifiPlayer_3_0_ios__Head__

#include <iostream>



const int CONN_SERVER = 0x1001;//连接服务器
const int CONN_SERVER_REPLY = 0x1002;//连接服务器返回
const int OPEN_FILE = 0x2001;//打开电脑的文件
const int OPEN_FILE_REPLY = 0x2002;//打开电脑的文件返回
const int DEL_FILE = 0x2003;//删除电脑上的文件
const int DEL_FILE_REPLY = 0x2004;// 删除电脑上的文件返回
const int COPY_FILE_2_PHONE = 0x2005;//拷贝电脑上的文件到手机
const int COPY_FILE_2_PHONE_REPLY = 0x2006;//拷贝电脑上的文件到手机返回
const int OPEN_DIR = 0x2007;//打开文件夹
const int OPEN_DIR_REPLY = 0x2008;//打开文件夹返回


class Head {
    private:
        int cmd;
        int bodyLenth;
        int  channel;
        int crc;

    
    public:
        Head(int cmd_, int bodyLenth_, int channel_, int crc_);
    Head(){};
    ~Head(){};
public:
    void setCmd(int cmd_);
    int getCmd();
    void setBodyLenth(int bodyLenth_);
    int getBodyLenth();
    void setChannel(int channel_);
    int getChannel();
    void setCrc(int crc_);
    int getCrc();
    Head resolveHead(uint8_t headArr[]);
    char* getHeadArray();
    
   typedef struct {
        int cmd_s;
        int bodyLenth_s;
        int channel_s;
        int crc_s;
    }headArray;
    
    
    
private:
    int byte2Int(uint8_t b[]);

};

#endif /* defined(__wifiPlayer_3_0_ios__Head__) */
