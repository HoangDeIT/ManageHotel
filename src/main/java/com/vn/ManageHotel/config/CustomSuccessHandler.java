package com.vn.ManageHotel.config;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.service.StaffService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class CustomSuccessHandler implements AuthenticationSuccessHandler {
    private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
    @Autowired
    private StaffService staffService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        Staff staff = this.staffService.getStaffByPhoneNumber(authentication.getName()).get();
        session.setAttribute("fullName", staff.getFullName());
        session.setAttribute("fullName", authentication);
        redirectStrategy.sendRedirect(request, response, "/staff");

    }

}
