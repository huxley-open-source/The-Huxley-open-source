package com.thehuxley.container.pendency

import com.thehuxley.Cluster
import com.thehuxley.Institution
import com.thehuxley.Profile

/**
 * Created with IntelliJ IDEA.
 * User: romero
 * Date: 06/09/13
 * Time: 12:04
 * To change this template use File | Settings | File Templates.
 */
class PendencyGroup extends Pendency{
    private Cluster group;

    public PendencyGroup(int kind, int status, long userCreated, long group, Date dateCreated){
        this.kind = kind
        this.status = status
        this.userCreated = Profile.get(userCreated)
        dateLastUpdated = new GregorianCalendar().getTime()
        this.group = Cluster.get(group)
        this.institution = this.group.institution
        this.dateCreated = dateCreated
        observerList = new ArrayList<Profile>()
    }

    public Cluster getGroup() {
        return group
    }

    public void setGroup(Cluster group) {
        this.group = group
    }
}
