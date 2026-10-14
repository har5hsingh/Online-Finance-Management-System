
package com.financeflow.model;

public class UserAccount extends Account {

    public UserAccount(int id, String fullName, String email) {
        super(id, fullName, email);
    }

    @Override
    public String getAccountType() {
        return "USER";
    }
}
