
package com.financeflow.model;

public class AdminAccount extends Account {

    public AdminAccount(int id, String fullName, String email) {
        super(id, fullName, email);
    }

    @Override
    public String getAccountType() {
        return "ADMIN";
    }
}
