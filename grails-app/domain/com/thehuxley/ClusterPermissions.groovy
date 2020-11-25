package com.thehuxley

import java.io.Serializable;
import java.util.Hashtable;

class ClusterPermissions implements Serializable{

	public static final int QUESTIONNAIRE_VIEW = 2;
	public static final int QUESTIONNAIRE_MANAGE = 4;
	public static final int USER_VIEW = 8;
	public static final int USER_MANAGE = 16;
	public static final int FORUM_VIEW = 32;
	public static final int FORUM_MANAGE = 64;
	public static final int GROUP_VIEW = 128;


	public static final int STUDENT_PERMISSON = 0
	public static final int MONITOR_PERMISSION = STUDENT_PERMISSON
	public static final int MASTER_PERMISSION = MONITOR_PERMISSION | QUESTIONNAIRE_MANAGE | USER_MANAGE

    public static final int USER_ACTIVE = 0;
    public static final int USER_QUITTER = 1;

	ShiroUser user
	Cluster group
	int permission
    short statusUser = USER_ACTIVE

	static mapping = {
		cache true
	}

    static constraints = {
        statusUser(nullable: true)
    }

	public static def listByInstitution(long institution, long user){
		def clusterList = Cluster.findAllByInstitution(Institution.get(institution))
		return ClusterPermissions.findAllByGroupInListAndUser(clusterList,ShiroUser.get(user))

	}

	public static boolean check(int permission){

	}

	public static boolean isStudent(int permission){
		return (permission==STUDENT_PERMISSON);
	}

	public static boolean isMonitor(int permission){
		return (permission==MONITOR_PERMISSION);
	}

	public static boolean isMaster(int permission){
		return (permission==MASTER_PERMISSION);
	}

    def updateUserInstitution() {
        Profile profile = Profile.findByUser(this.user)
        if (profile && !profile.institution) {
            profile.institution = this.group.institution
            profile.save()
        }

    }
}
