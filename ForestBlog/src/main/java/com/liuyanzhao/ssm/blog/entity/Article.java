package com.liuyanzhao.ssm.blog.entity;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

/**
 * @author liuyanzhao
 */
@Data
public class Article implements Serializable{

    private static final long serialVersionUID = 5207865247400761539L;

    private Integer articleId;              // 文章ID

    private Integer articleUserId;          // 文章作者ID

    private String articleTitle;            // 文章名称

    private Integer articleViewCount;       // 文章观看数

    private Integer articleCommentCount;    // 文章评论数

    private Integer articleLikeCount;       // 文章喜欢的人数

    private Date articleCreateTime;         // 文章创建时间

    private Date articleUpdateTime;         // 文章更新时间

    private Integer articleIsComment;       // 文章是否评论

    private Integer articleStatus;          // 文章状态

    private Integer articleOrder;           // 文章命令

    private String articleContent;          // 文章内容

    private String articleSummary;          // 文章概要

    private String articleThumbnail;        // 文章缩略图

    private User user;                      // 文章作者

    private List<Tag> tagList;              // 标签列表

    private List<Category> categoryList;    // 类别列表

}