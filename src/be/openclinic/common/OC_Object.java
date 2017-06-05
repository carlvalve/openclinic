package be.openclinic.common;

import java.util.Date;

public class OC_Object {
    private String uid;
    private Date createDateTime;
    private String updateUser;
    private Date updateDateTime;
    private int version;
    private Date cacheDate;
    private String tag;

    public Date getCacheDate() {
        return cacheDate;
    }

    public String getTag() {
		return tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public void setCacheDate(Date cacheDate) {
        this.cacheDate = cacheDate;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public Date getCreateDateTime() {
        return createDateTime;
    }

    public void setCreateDateTime(Date createDateTime) {
        this.createDateTime = createDateTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }
    
    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public Date getUpdateDateTime() {
        return updateDateTime;
    }

    public void setUpdateDateTime(Date updateDateTime) {
        this.updateDateTime = updateDateTime;
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }
    
    public boolean hasValidUid(){
    	return getUid()!=null && getUid().split("\\.").length==2;
    }
}
