package com.vn.ManageHotel.domain;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;

@Entity
public class Rental {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToMany
    @JoinTable(name = "rental_customer", joinColumns = @JoinColumn(name = "rental_id"), inverseJoinColumns = @JoinColumn(name = "customer_id"))
    private List<Customer> customers;

    @ManyToMany
    @JoinTable(name = "rental_service", joinColumns = @JoinColumn(name = "rental_id"), inverseJoinColumns = @JoinColumn(name = "service_id"))
    private List<Service> services;

    @ManyToOne
    @JoinColumn(name = "room_id", nullable = false)
    @NotNull(message = "Phòng không được để trống")
    private Room room;

    @ManyToOne
    @JoinColumn(name = "created_by_id", referencedColumnName = "id")
    private Staff createdBy;

    @Column(nullable = true)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate startDate;

    @Column(nullable = false)
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @FutureOrPresent(message = "Ngày ra không được nhỏ hơn ngày hiện tại")
    @NotNull(message = "Ngày ra không được để trống")
    private LocalDate endDate;

    @Column(nullable = false)
    @NotNull(message = "Đặt cọc không được để trống")
    private BigDecimal deposit;

    @Column(nullable = true)
    private BigDecimal amount; // Thành Tiền

    @Column(nullable = true)
    private String paymentMethod; // Hình Thức Thanh Toán

    @Column(nullable = true)
    private String notes; // Ghi Chú

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @Column(nullable = true)
    private LocalDate paymentDate; // Ngày Thanh Toán

    @Column(nullable = false)
    private boolean status;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public List<Customer> getCustomers() {
        return customers;
    }

    public void setCustomers(List<Customer> customers) {
        this.customers = customers;
    }

    public List<Service> getServices() {
        return services;
    }

    public void setServices(List<Service> services) {
        this.services = services;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public LocalDate getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public LocalDate getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDate paymentDate) {
        this.paymentDate = paymentDate;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Staff getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Staff createdBy) {
        this.createdBy = createdBy;
    }

    @AssertTrue(message = "Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu")
    public boolean isEndDateValid() {
        startDate = startDate == null ? LocalDate.now() : startDate;
        return endDate != null && !endDate.isBefore(startDate);
    }

    // Getters and Setters

}
