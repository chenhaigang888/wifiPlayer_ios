//
//  Head.cpp
//  wifiPlayer_3.0_ios
//
//  Created by 陈 海刚 on 13-4-24.
//  Copyright (c) 2013年 陈 海刚. All rights reserved.
//

#include "Head.h"


Head::Head(int cmd_, int bodyLenth_, int channel_, int crc_)

{
    cmd = cmd_;
    bodyLenth = bodyLenth_;
    channel = channel_;
    crc = crc_;
}


void Head::setCmd(int cmd_)
{
    cmd = cmd_;
}

int Head::getCmd()
{
    return cmd;
}

void Head::setBodyLenth(int bodyLenth_)
{
    bodyLenth = bodyLenth_;
}

int Head::getBodyLenth()
{
    return bodyLenth;
}

void Head::setChannel(int channel_)
{
    channel = channel_;
}

int Head::getChannel()
{
    return channel;
}

void Head::setCrc(int crc_)
{
    crc = crc_;
}

int Head::getCrc()
{
    return crc;
}


char* Head::getHeadArray()
{
    headArray tt;
    tt.cmd_s = cmd;
    tt.bodyLenth_s = bodyLenth;
    tt.channel_s = channel;
    tt.crc_s = crc;
    

    u_long * c = (u_long *)&tt;
    
    u_long b[16];
//u_long b = htonl(*c);
    for (int i=0; i<4; i++) {
        b[i] = htonl(c[i]);
    }
    
    char* heardArr = new char[16];
    memcpy(heardArr, &b, 16);
    std::cout<<"Head.cpp中getHeadArray（）函数执行了"<<std::endl;
    return heardArr;
}

Head Head::resolveHead(uint8_t headArr[])
{
    Head head;
    uint8_t cmd[4];
    memcpy(cmd, headArr, 4);
    head.setCmd(byte2Int(cmd));
    memcpy(cmd, headArr+4, 4);
    head.setBodyLenth(byte2Int(cmd));
    memcpy(cmd, headArr+8, 4);
    head.setChannel(byte2Int(cmd));
    memcpy(cmd, headArr+12, 4);
    head.setCrc(byte2Int(cmd));
    return head;
}

int Head::byte2Int(uint8_t b[])
{
    int addr = b[3] & 0xFF;
    addr |= ((b[2] << 8) & 0xFF00);
    addr |= ((b[1] << 16) & 0xFF0000);
    addr |= ((b[0] << 24) & 0xFF000000);
    return addr;
}

