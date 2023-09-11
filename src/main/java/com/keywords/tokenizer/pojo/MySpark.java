package com.keywords.tokenizer.pojo;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaSparkContext;

/**
 * @author wangyue
 * @date 2023/8/14
 */
public class MySpark {
    private SparkConf conf;
    private JavaSparkContext sc;

    public MySpark() {
        SparkConf conf = new SparkConf()
                .setAppName("WordFrequency")
                .set("spark.executor.memory", "16g")
                .set("spark.driver.memory", "4g")
//                .set("spark.executor.instances", "6")
//                .set("spark.default.parallelism", "6")
                .setJars(new String[]{"D:\\SVNdownload\\analyzer\\target\\analyzer-1.0.jar"})
//                .setMaster("spark://192.168.93.131:7077");
                .setMaster("spark://192.168.161.155:7077");
//                .set("spark.driver.maxResultSize", "8g")
//                .set("spark.driver.memory","8g")
//                .set("spark.executor.memory","8g")
//                .setMaster("local[*]");
        this.conf=conf;
        this.sc = new JavaSparkContext(conf);
    }

    public SparkConf getSparkConf(){
        return conf;
    }

    public JavaSparkContext getSparkContext() {
        return sc;
    }
}
