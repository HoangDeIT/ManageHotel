package com.vn.ManageHotel.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.vn.ManageHotel.domain.Customer;
import com.vn.ManageHotel.domain.Rental;
import com.vn.ManageHotel.domain.Room;
import com.vn.ManageHotel.service.CustomerService;
import com.vn.ManageHotel.service.RentalService;
import com.vn.ManageHotel.service.RoomService;
import com.vn.ManageHotel.utils.PaginationUtils;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/rental")
public class RentalController {
    private final RentalService rentalService;
    private final RoomService roomService;
    private final CustomerService customerService;

    public RentalController(RentalService rentalService, RoomService roomService, CustomerService customerService) {
        this.rentalService = rentalService;
        this.roomService = roomService;
        this.customerService = customerService;
    }

    private void setupRentalModel(Model model,
            List<Rental> rentalList,
            int totalPages,
            int currentPage,
            String searchTerm,
            Rental newRental,
            String startDate,
            String endDate,
            List<Room> roomList,
            List<Customer> customerList) {
        List<Integer> pageArray = PaginationUtils.getPagination(totalPages, currentPage, 5);
        model.addAttribute("rentalList", rentalList);
        model.addAttribute("pageArray", pageArray);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("searchTerm", searchTerm);
        model.addAttribute("newRental", newRental);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("rooms", roomList);
        model.addAttribute("customers", customerList);
    }

    @GetMapping("")
    public String getRentals(Model model,
            @RequestParam(value = "searchTerm", required = false) String searchTerm,
            @RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum,
            @RequestParam(value = "size", required = false, defaultValue = "2") int size,
            @RequestParam(value = "startDate", required = false, defaultValue = "2020-01-01") String startDate,
            @RequestParam(value = "endDate", required = false, defaultValue = "2025-01-01") String endDate) {
        if (model.containsAttribute("currentPage")) {
            pageNum = (int) model.asMap().get("currentPage");
        }

        int totalPages = rentalService.getTotalPagesForRentals(searchTerm, size, startDate, endDate);
        List<Rental> rentalList = rentalService.getPaginatedRentals(searchTerm, pageNum, size, startDate, endDate);
        List<Room> roomList = roomService.getAllRooms(); // Assuming you have a RoomService
        List<Customer> customerList = customerService.getAllCustomers(); // Assuming you have a CustomerService

        setupRentalModel(model, rentalList, totalPages, pageNum, searchTerm, new Rental(), startDate, endDate, roomList,
                customerList);
        return "rental/show";
    }

    @PostMapping("")
    public String addRental(Model model, @ModelAttribute("newRental") @Valid Rental rental,
            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            int pageNum = 1;
            int size = 2;
            String startDate = "2020-01-01";
            String endDate = "2025-01-01";
            List<Rental> rentalList = rentalService.getPaginatedRentals(null, pageNum, size, startDate, endDate);
            int totalPages = rentalService.getTotalPagesForRentals(null, size, startDate, endDate);
            List<Room> roomList = roomService.getAllRooms();
            List<Customer> customerList = customerService.getAllCustomers();
            setupRentalModel(model, rentalList, totalPages, pageNum, null, rental, startDate, endDate, roomList,
                    customerList);
            model.addAttribute("errors", bindingResult);
            return "rental/show";
        }
        rentalService.saveRental(rental);
        return "redirect:/rental";
    }

    @GetMapping("/update/{sid}")
    public String getUpdateRental(@PathVariable String sid, Model model, RedirectAttributes redirectAttributes) {
        long id;
        try {
            id = Long.parseLong(sid);
        } catch (NumberFormatException e) {
            redirectAttributes.addFlashAttribute("status", "ID không hợp lệ. Vui lòng kiểm tra lại.");
            return "redirect:/rental";
        }
        Rental rentalById = rentalService.getRentalById(id);
        if (rentalById == null) {
            redirectAttributes.addFlashAttribute("status", "Rental không tồn tại.");
            return "redirect:/rentals";
        }
        List<Room> roomList = roomService.getAllRooms();
        List<Customer> customerList = customerService.getAllCustomers();
        List<Rental> rentalList = rentalService.getAllRentals();
        model.addAttribute("rentalById", rentalById);
        model.addAttribute("rooms", roomList);
        model.addAttribute("customers", customerList);
        model.addAttribute("rentalList", rentalList);
        return "rental/update";
    }

    @PostMapping("/update")
    public String updateRental(@ModelAttribute("rentalById") @Valid Rental rental, BindingResult bindingResult,
            RedirectAttributes redirectAttributes, Model model) {
        if (bindingResult.hasErrors()) {
            int pageSize = 2;
            int pageNum = 1;
            String searchTerm = null;
            String startDate = "2020-01-01";
            String endDate = "2025-01-01";

            List<Rental> rentalList = rentalService.getPaginatedRentals(searchTerm, pageNum, pageSize, startDate,
                    endDate);
            int totalPages = rentalService.getTotalPagesForRentals(searchTerm, pageSize, startDate, endDate);
            List<Room> roomList = roomService.getAllRooms();
            List<Customer> customerList = customerService.getAllCustomers();

            setupRentalModel(model, rentalList, totalPages, pageNum, searchTerm, rental, startDate, endDate, roomList,
                    customerList);
            model.addAttribute("errors", bindingResult);
            return "rental/update";
        }

        rentalService.saveRental(rental);
        int pageSize = 2;
        int pageNum = 1;
        List<Rental> rentalList = rentalService.getAllRentals();

        // Find the position of the updated rental in the list
        int rentalIndex = -1;
        for (int i = 0; i < rentalList.size(); i++) {
            if (rentalList.get(i).getId().equals(rental.getId())) {
                rentalIndex = i;
                break;
            }
        }

        // If the rental is found in the list
        if (rentalIndex != -1) {
            // Calculate the page number where this rental is located
            pageNum = (rentalIndex / pageSize) + 1;
        }

        // Add flash attributes to retain state after redirect
        redirectAttributes.addFlashAttribute("currentPage", pageNum);
        redirectAttributes.addFlashAttribute("status", "Cập nhật rental thành công.");
        return "redirect:/rental";
    }

    @PostMapping("/delete")
    public String deleteRental(@RequestParam("id") long id, RedirectAttributes redirectAttributes) {
        try {
            rentalService.deleteRentalById(id);
            redirectAttributes.addFlashAttribute("status", "Xóa rental thành công.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("status", "Có lỗi xảy ra khi xóa rental.");
        }
        return "redirect:/rental";
    }

}
