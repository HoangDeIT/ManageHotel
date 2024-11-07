package com.vn.ManageHotel.service;

import java.util.Collections;
import java.util.Optional;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.vn.ManageHotel.domain.Staff;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final StaffService staffService;

    public CustomUserDetailsService(StaffService staffService) {
        this.staffService = staffService;
    }

    @Override
    public UserDetails loadUserByUsername(String phone) throws UsernameNotFoundException {
        Optional<Staff> staffOptional = this.staffService.getStaffByPhoneNumber(phone);
        if (!staffOptional.isPresent()) {
            throw new UsernameNotFoundException("user not found");
        }
        Staff staff = staffOptional.get();
        return new User(staff.getPhoneNumber(), staff.getPassword(), Collections.emptyList() // Danh sách quyền trống );
        );
    }
}