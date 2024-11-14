package com.vn.ManageHotel.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

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
import com.vn.ManageHotel.domain.Service;
import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.service.CustomerService;
import com.vn.ManageHotel.service.RentalService;
import com.vn.ManageHotel.service.RoomService;
import com.vn.ManageHotel.service.ServiceService;
import com.vn.ManageHotel.service.StaffService;
import com.vn.ManageHotel.utils.PaginationUtils;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/rental")
public class RentalController {
    private final RentalService rentalService;
    private final RoomService roomService;
    private final CustomerService customerService;
    private final ServiceService serviceService;
    private final StaffService staffService;

    public RentalController(
            RentalService rentalService,
            RoomService roomService,
            CustomerService customerService,
            ServiceService serviceService,
            StaffService staffService) {
        this.rentalService = rentalService;
        this.roomService = roomService;
        this.customerService = customerService;
        this.serviceService = serviceService;
        this.staffService = staffService;
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
            List<Customer> customerList,
            Boolean status,
            List<Service> services,
            List<BigDecimal> totalRentals) {
        List<Integer> pageArray = PaginationUtils.getPagination(totalPages, currentPage, 10);
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
        model.addAttribute("status1", status);
        model.addAttribute("services", services);
        model.addAttribute("totalRentals", totalRentals);
    }

    private BigDecimal getTotalRental(Rental rental) {
        BigDecimal serviceTotal = rental.getServices().stream()
                .map(Service::getPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal roomCost = rental.getRoom().getRentalPrice();

        BigDecimal deposit = rental.getDeposit();

        BigDecimal expectedTotal = serviceTotal.add(roomCost).subtract(deposit);
        if (expectedTotal.compareTo(BigDecimal.ZERO) < 0) {
            return BigDecimal.ZERO;
        }
        return expectedTotal;
    }

    @GetMapping("")
    public String getRentals(Model model,
            @RequestParam(value = "searchTerm", required = false) String searchTerm,
            @RequestParam(value = "pageNum", required = false, defaultValue = "1") int pageNum,
            @RequestParam(value = "size", required = false, defaultValue = "10") int size,
            @RequestParam(value = "startDate", required = false, defaultValue = "2020-01-01") String startDate,
            @RequestParam(value = "endDate", required = false, defaultValue = "2025-01-01") String endDate,
            @RequestParam(value = "status1", required = false) boolean status) {
        if (model.containsAttribute("currentPage")) {
            pageNum = (int) model.asMap().get("currentPage");
        }

        int totalPages = rentalService.getTotalPagesForRentals(searchTerm, size, startDate, endDate, status);
        if (pageNum > totalPages)
            pageNum = totalPages;
        else if (pageNum <= 0)
            pageNum = 1;
        List<Rental> rentalList = rentalService.getPaginatedRentals(searchTerm,
                pageNum, size, startDate, endDate,
                status);
        // List<Rental> rentalList = rentalService.getAllRentals();
        List<Room> roomList = roomService.getAllRooms(); // Assuming you have a RoomService
        List<Customer> customerList = customerService.getAllCustomers(); // Assuming you have a CustomerService
        List<Service> services = this.serviceService.getAllServices();
        List<BigDecimal> totalRentals = rentalList.stream().map(this::getTotalRental).collect(Collectors.toList());
        setupRentalModel(model, rentalList, totalPages, pageNum, searchTerm, new Rental(), startDate, endDate, roomList,
                customerList, status, services, totalRentals);
        return "rental/show";
    }

    @PostMapping("")
    public String addRental(Model model, @ModelAttribute("newRental") @Valid Rental rental,
            BindingResult bindingResult) {
        // boolean isHave = this.roomService.isRoomAvailable(rental.getRoom().getId(),
        // rental.getStartDate() == null ? rental.getStartDate() : LocalDate.now(),
        // rental.getEndDate());

        if (bindingResult.hasErrors()) {
            // if (!isHave) {
            // bindingResult.rejectValue("room", "error.room", "Thời gian này phòng đã có
            // người đặt");
            // }
            int pageNum = 1;
            int size = 10;
            String startDate = "2020-01-01";
            String endDate = "2025-01-01";
            Boolean status = null; // Default status to null
            List<Rental> rentalList = rentalService.getPaginatedRentals(null, pageNum, size, startDate, endDate,
                    status);
            int totalPages = rentalService.getTotalPagesForRentals(null, size, startDate, endDate, status);
            List<Room> roomList = roomService.getAllRooms();
            List<Customer> customerList = customerService.getAllCustomers();
            List<BigDecimal> totalRentals = rentalList.stream().map(this::getTotalRental).collect(Collectors.toList());
            List<Service> services = this.serviceService.getAllServices();
            setupRentalModel(model, rentalList, totalPages, pageNum, null, rental, startDate, endDate, roomList,
                    customerList, status, services, totalRentals);
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
        List<Service> services = this.serviceService.getAllServices();

        model.addAttribute("rentalById", rentalById);
        model.addAttribute("rooms", roomList);
        model.addAttribute("customers", customerList);
        model.addAttribute("rentalList", rentalList);
        model.addAttribute("services", services);

        return "rental/update";
    }

    @PostMapping("/update")
    public String updateRental(@ModelAttribute("rentalById") @Valid Rental rental, BindingResult bindingResult,
            RedirectAttributes redirectAttributes, Model model) {
        boolean isHave = this.roomService.isRoomAvailable(rental.getRoom().getId(), rental.getStartDate(),
                rental.getEndDate())
                || rental.getRoom().getId() == rentalService.getRentalById(rental.getId()).getRoom().getId();
        if (bindingResult.hasErrors() || !isHave) {
            if (!isHave) {
                bindingResult.rejectValue("room", "error.room", "Thời gian này phòng đã có người đặt");
            }
            int pageSize = 10;
            int pageNum = 1;
            String searchTerm = null;
            String startDate = "2020-01-01";
            String endDate = "2025-01-01";
            Boolean status = null; // Default status to null

            List<Rental> rentalList = rentalService.getPaginatedRentals(searchTerm,
                    pageNum, pageSize, startDate,
                    endDate, status);
            int totalPages = rentalService.getTotalPagesForRentals(searchTerm, pageSize,
                    startDate, endDate, status);
            List<Room> roomList = roomService.getAllRooms();
            List<Customer> customerList = customerService.getAllCustomers();
            List<Service> services = this.serviceService.getAllServices();
            List<BigDecimal> totalRentals = rentalList.stream().map(this::getTotalRental).collect(Collectors.toList());

            setupRentalModel(model, rentalList, totalPages, pageNum, searchTerm, rental,
                    startDate, endDate, roomList,
                    customerList, status, services, totalRentals);
            model.addAttribute("errors", bindingResult);
            return "rental/update";
        }

        rentalService.saveRental(rental);
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

    @PostMapping("/addService")
    public String addServiceToRental(
            @RequestParam("rentalId") Long rentalId,
            @RequestParam("serviceId") Long serviceId,
            RedirectAttributes redirectAttributes) {

        boolean isAdded = rentalService.addServiceToRental(rentalId, serviceId);

        if (isAdded) {
            redirectAttributes.addFlashAttribute("successMessage", "Dịch vụ đã được thêm thành công.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Không thể thêm dịch vụ.");
        }

        return "redirect:/rental/update/" + rentalId; // Redirect back to the rentals page or the appropriate view
    }

    @PostMapping("/removeService")
    public String removeServiceFromRental(
            @RequestParam("rentalId") Long rentalId,
            @RequestParam("serviceId") Long serviceId,
            RedirectAttributes redirectAttributes) {

        boolean isRemoved = rentalService.removeServiceFromRental(rentalId, serviceId);
        if (isRemoved) {
            redirectAttributes.addFlashAttribute("message", "Service deleted successfully");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to delete service");
        }

        return "redirect:/rental/update/" + rentalId;
    }

    @PostMapping("/payment")
    public String processPayment(
            @RequestParam("rentalId") Long rentalId,
            @RequestParam("amount") BigDecimal amount,
            @RequestParam("paymentMethod") String paymentMethod,
            @RequestParam(value = "notes", required = false) String notes,
            @RequestParam("paymentDate") LocalDate paymentDate,
            RedirectAttributes redirectAttributes,
            HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        long idStaff = (long) session.getAttribute("staffId");
        Staff staffCreate = staffService.getStaffById(idStaff);
        boolean paymentSuccess = rentalService.processPayment(
                rentalId,
                amount,
                paymentMethod,
                notes,
                paymentDate,
                staffCreate);

        if (paymentSuccess) {
            redirectAttributes.addFlashAttribute("message", "Thanh toán thành công.");
        } else {
            redirectAttributes.addFlashAttribute("error", "Thanh toán thất bại.");
        }

        // Redirect lại đến trang chi tiết rental
        return "redirect:/rental/detail/" + rentalId;
    }

    @GetMapping("/detail/{sid}")
    public String detailRental(@PathVariable String sid, Model model, RedirectAttributes redirectAttributes) {
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
            return "redirect:/rental";
        }

        BigDecimal serviceTotal = rentalById.getServices().stream()
                .map(Service::getPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        BigDecimal roomCost = rentalById.getRoom().getRentalPrice();

        BigDecimal deposit = rentalById.getDeposit();

        BigDecimal expectedTotal = serviceTotal.add(roomCost).subtract(deposit);

        BigDecimal surchargeOrDiscount = BigDecimal.ZERO;
        surchargeOrDiscount = rentalById.getAmount().subtract(expectedTotal);

        List<Room> roomList = roomService.getAllRooms();
        List<Customer> customerList = customerService.getAllCustomers();
        List<Rental> rentalList = rentalService.getAllRentals();
        List<Service> services = serviceService.getAllServices();

        // Pass all calculated values to the model
        model.addAttribute("rentalById", rentalById);
        model.addAttribute("rooms", roomList);
        model.addAttribute("customers", customerList);
        model.addAttribute("rentalList", rentalList);
        model.addAttribute("services", services);
        model.addAttribute("serviceTotal", serviceTotal);
        model.addAttribute("roomCost", roomCost);
        model.addAttribute("deposit", deposit);
        model.addAttribute("surcharge", surchargeOrDiscount);
        model.addAttribute("expectedTotal", expectedTotal);

        return "rental/detail";
    }

}
