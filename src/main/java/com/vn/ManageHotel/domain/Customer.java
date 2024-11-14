package com.vn.ManageHotel.domain;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Không được để trống")
    @Size(min = 2, message = "Tên không dưới 1 kí tự")
    private String name;
    private String address;
    private String phoneNumber;
    @ManyToMany(mappedBy = "customers", cascade = CascadeType.ALL)
    private List<Rental> rentals;

    @ManyToOne
    @JoinColumn(name = "created_by_id", referencedColumnName = "id")
    private Staff createdBy;

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public List<Rental> getRentals() {
        return rentals;
    }

    public void setRentals(List<Rental> rentals) {
        this.rentals = rentals;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getIdName() {
        return id + " - " + name;
    }

    public Staff getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Staff createdBy) {
        this.createdBy = createdBy;
    }

}
