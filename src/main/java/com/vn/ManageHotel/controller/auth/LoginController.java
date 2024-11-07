package com.vn.ManageHotel.controller.auth;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
    @GetMapping("/login")
    public String getMethodName() {
        return "auth/login";
    }

}
