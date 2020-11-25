package com.thehuxley.container.pendency

import com.thehuxley.Institution
import com.thehuxley.Profile

/**
 * Created with IntelliJ IDEA.
 * User: MRomero
 * Date: 16/07/13
 * Time: 19:46
 * To change this template use File | Settings | File Templates.
 */
class Pendency {
    public static final int STATUS_WAITING = 0
    public static final int STATUS_ACCEPTED = 1
    public static final int STATUS_REJECTED = 2
    public static final int STATUS_USER_BLOCKED = 2
    public static final int KIND_DOCUMENT_INSTITUTION = 1
    public static final int KIND_DOCUMENT_MASTER = 2
    public static final int KIND_CADASTRE_INSTITUTION = 3
    public static final int KIND_CADASTRE_MASTER = 4
    //Professor convida o aluno
    public static final int KIND_STUDENT_INVITE = 5
    //Aluno requere a participação
    public static final int KIND_STUDENT_REQUEST_INVITE = 6

    private String id
    private String relatedPendency
    private int kind
    private Date dateLastUpdated
    private Date dateCreated
    private int status
    private ArrayList<Profile> observerList
    private Profile userCreated
    private Institution institution
    private ArrayList<String> document

    public Pendency(){
        kind = 0
        dateLastUpdated = new GregorianCalendar().getTime()
        dateCreated = new GregorianCalendar().getTime()
        status = 0
        observerList = new ArrayList<Profile>()
        userCreated = new Profile()
        institution = new Institution()

    }
    public Pendency(int kind, int status, long userCreated, long institution, Date dateCreated){
        this.kind = kind
        this.status = status
        this.userCreated = Profile.get(userCreated)
        dateLastUpdated = new GregorianCalendar().getTime()
        this.institution = Institution.get(institution)
        this.dateCreated = dateCreated
        observerList = new ArrayList<Profile>()
    }
    public String getId() {
        return id
    }

    public void setId(String id) {
        this.id = id
    }

    public int getKind() {
        return kind
    }

    public void setKind(int kind) {
        this.kind = kind
    }

    public Date getDateLastUpdated() {
        return dateLastUpdated
    }

    public void setDateLastUpdated(Date dateLastUpdated) {
        this.dateLastUpdated = dateLastUpdated
    }

    public Date getDateCreated() {
        return dateCreated
    }

    public void setDateCreated(Date dateCreated) {
        this.dateCreated = dateCreated
    }

    public int getStatus() {
        return status
    }

    public void setStatus(int status) {
        this.status = status
    }

    public ArrayList<Profile> getObserverList() {
        return observerList
    }

    public void setObserverList(ArrayList<Profile> observerList) {
        this.observerList = observerList
    }

    public Profile getUserCreated() {
        return userCreated
    }

    public void setUserCreated(Profile userCreated) {
        this.userCreated = userCreated
    }

    public Institution getInstitution() {
        return institution
    }

    public void setInstitution(Institution institution) {
        this.institution = institution
    }

    public String toString(){
        return userCreated.name + " para instituição " + institution.name + " tipo " + kind + " status " + status + " id: " + id
    }

    public ArrayList<String> getDocument() {
        return document
    }

    public void setDocument(ArrayList<String> document) {
        this.document = document
    }

    public void pushDocument(String document) {
        if (this.document == null){
            this.document = new ArrayList<String>()
        }
        this.document.add(document)
    }

    public String getRelatedPendency() {
        return relatedPendency
    }

    public void setRelatedPendency(String relatedPendency) {
        this.relatedPendency = relatedPendency
    }


}