package com.vn.ManageHotel.controller.auth;

import java.time.LocalDate;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.domain.DTO.RegisterDTO;
import com.vn.ManageHotel.service.StaffService;

@Controller
public class LoginController {
    private final PasswordEncoder passwordEncoder;

    private final StaffService staffService;

    public LoginController(StaffService staffService, PasswordEncoder passwordEncoder) {
        this.staffService = staffService;
        this.passwordEncoder = passwordEncoder;
        ;
    }

    @GetMapping("/login")
    public String getMethodName() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("registerDTO", new RegisterDTO());
        model.addAttribute("status", "");
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute("registerDTO") RegisterDTO registerDTO,
            RedirectAttributes redirectAttributes, Model model) {
        if (registerDTO.getPassword().length() <= 8) {
            model.addAttribute("status", "Password không nhỏ hơn 8 kí tự");
            return "auth/register";
        }
        if (!registerDTO.getPassword().equals(registerDTO.getConfirmPassword())) {
            model.addAttribute("status", "Password không giống confirm password");
            return "auth/register";
        }
        if (staffService.isHavePhone(registerDTO.getPhoneNumber())) {
            model.addAttribute("status", "Số điện thoại đã tồn tại");
            return "auth/register";
        }
        if (registerDTO.getBirthDate().isAfter(LocalDate.now())) {
            model.addAttribute("status", "Ngày sinh phải nhỏ hơn ngày hiện tại");
            return "auth/register";
        }
        Staff staff = new Staff();
        staff.setApproved(false);
        staff.setBirthDate(registerDTO.getBirthDate());
        staff.setFullName(registerDTO.getFullName());
        staff.setPhoneNumber(registerDTO.getPhoneNumber());
        staff.setPassword(passwordEncoder.encode(registerDTO.getPassword()));
        redirectAttributes.addFlashAttribute("status", "Đăng kí thành công");
        staff = staffService.saveStaff(staff);
        return "redirect:/login";
    }

}
