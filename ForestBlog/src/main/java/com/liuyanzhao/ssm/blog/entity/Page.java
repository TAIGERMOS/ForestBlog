package com.liuyanzhao.ssm.blog.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @author liuyanzhao
 */
@Data
public class Page implements Serializable{

    private static final long serialVersionUID = 3927496662110298634L;
    private Integer pageId;         // 页面ID

    private String pageKey;         // 页面密匙

    private String pageTitle;       // 页面名称

    private String pageContent;     // 页面内容

    private Date pageCreateTime;    // 页面创建时间

    private Date pageUpdateTime;    // 页面更新时间

    private Integer pageViewCount;  // 页面观看数

    private Integer pageCommentCount;   // 页面评论数

    private Integer pageStatus;     // 页面状态

}