package com.vn.ManageHotel.controller;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;

@ControllerAdvice
public class ExceptionController {

    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handle404(NoHandlerFoundException ex, Model model) {
        model.addAttribute("errorMessage", "Trang bạn tìm không tồn tại!");
        return "error/404"; // Trang HTML tùy chỉnh cho lỗi 404
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handle500(Exception ex, Model model) {
        model.addAttribute("errorMessage", "Có lỗi xảy ra trong hệ thống!");
        return "error/500"; // Trang HTML tùy chỉnh cho lỗi 500
    }

    @ExceptionHandler(org.springframework.web.HttpRequestMethodNotSupportedException.class)
    @ResponseStatus(HttpStatus.METHOD_NOT_ALLOWED)
    public String handle405(Exception ex, Model model) {
        model.addAttribute("errorMessage", "Phương thức truy cập không hợp lệ!");
        return "error/405"; // Trang HTML tùy chỉnh cho lỗi 405
    }

    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public String handle403(AccessDeniedException ex, Model model) {
        model.addAttribute("errorMessage", "Bạn không có quyền truy cập vào trang này!");
        return "error/403"; // Trang HTML tùy chỉnh cho lỗi 403
    }

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<Object> handleResponseStatusException(ResponseStatusException ex) {
        // Nếu lỗi là METHOD_NOT_ALLOWED, trả về mã lỗi 405
        if (ex.getStatusCode() == HttpStatus.METHOD_NOT_ALLOWED) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.METHOD_NOT_ALLOWED);
        }
        return new ResponseEntity<>(ex.getMessage(),
                HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ExceptionHandler(Throwable.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleAllErrors(Throwable ex, Model model) {
        model.addAttribute("errorMessage", "Đã xảy ra lỗi không xác định.");
        return "error/generic";
    }
}
