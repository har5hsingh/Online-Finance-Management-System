
package com.financeflow.model;

public abstract class Account {

    protected int id;
    protected String fullName;
    protected String email;

    public Account(int id, String fullName, String email) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
    }

    public int getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public String getEmail() {
        return email;
    }

    public abstract String getAccountType();
}
