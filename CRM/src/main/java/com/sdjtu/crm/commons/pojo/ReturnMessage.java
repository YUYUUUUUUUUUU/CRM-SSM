package com.sdjtu.crm.commons.pojo;

/**
 * @PROJECT_NAME: CRM-SSM
 * @USER: YUYU
 * @DATE: 2023/2/13 21:35
 * @DESCRIPTION:    向网页返回的Message的实体对象
 */
public class ReturnMessage {
    private String code;
    private String message;
    private Object data;

    public ReturnMessage() {
    }

    public ReturnMessage(String code, String message, Object data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    @Override
    public String toString() {
        return "ReturnMessage{" +
                "code='" + code + '\'' +
                ", message='" + message + '\'' +
                ", data=" + data +
                '}';
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
