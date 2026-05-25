package com.jiangsu.tcm.module.user.service;

public interface WxSessionService {

    WxSession resolve(String code);

    record WxSession(String openid, String unionid) {}
}
