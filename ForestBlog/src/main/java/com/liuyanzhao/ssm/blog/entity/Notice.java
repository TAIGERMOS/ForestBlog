package com.liuyanzhao.ssm.blog.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;

/**
 * @author liuyanzhao
 */
@Data
public class Notice implements Serializable{

    private static final long serialVersionUID = -4901560494243593100L;
    private Integer noticeId;          // 笔记ID

    private String noticeTitle;         // 笔记名称

    private String noticeContent;       // 笔记内容

    private Date noticeCreateTime;      // 笔记创建时间

    private Date noticeUpdateTime;      // 笔记更新时间

    private Integer noticeStatus;       // 笔记状态

    private Integer noticeOrder;        // 笔记命令----？？？

}