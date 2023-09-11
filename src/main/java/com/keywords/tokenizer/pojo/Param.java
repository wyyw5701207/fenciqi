package com.keywords.tokenizer.pojo;

import lombok.Data;

/**
 * @author wangyue
 * @date 2023/8/11
 */
@Data
public class Param {
    private String analyzerType;
    private String rowName;
    private Integer keyWordNum;
    private Integer wordLength;

    public Param(String analyzerType, String rowName, Integer keyWordNum, Integer wordLength, String folderPath) {
        this.analyzerType = analyzerType;
        this.rowName = rowName;
        this.keyWordNum = keyWordNum;
        this.wordLength = wordLength;
        this.folderPath = folderPath;
    }

    private String folderPath;
}
