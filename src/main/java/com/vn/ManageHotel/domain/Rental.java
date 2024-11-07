package com.vn.ManageHotel.domain;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotNull;

@Entity
public class Rental {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    @NotNull(message = "Khách hàng không được để trống")
    private Customer customer;
    @ManyToOne
    @JoinColumn(name = "room_id", nullable = false)
    @NotNull(message = "Phòng không được để trống")
    private Room room;
    @Column(nullable = false)
    private LocalDate startDate;
    @Column(nullable = false)
    @NotNull(message = "Ngày ra không được để trống")
    private LocalDate endDate;
    @Column(nullable = false)
    @NotNull(message = "Đặt cọc không được để trống")
    private Double deposit;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
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

    public double getDeposit() {
        return deposit;
    }

    public void setDeposit(double deposit) {
        this.deposit = deposit;
    }
}
