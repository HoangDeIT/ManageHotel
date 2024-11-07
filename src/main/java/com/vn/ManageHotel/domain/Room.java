package com.vn.ManageHotel.domain;

import com.vn.ManageHotel.utils.constant.RoomType;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@Entity
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @NotBlank(message = "Không được để trống")
    private String roomName;

    @Enumerated(EnumType.STRING)
    @NotNull(message = "Bạn chưa chọn")
    private RoomType roomType;
    @Min(value = 1, message = "Diện tích phải ít nhất là 1")
    @NotNull(message = "Điền vào đi bạn")
    private Double area;
    @Min(value = 10, message = "Giá thuê phải ít nhất là 10")
    @NotNull(message = "Điền vào đi bạn")
    private Double rentalPrice;

    // Getters và setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public RoomType getRoomType() {
        return roomType;
    }

    public void setRoomType(RoomType roomType) {
        this.roomType = roomType;
    }

    public Double getArea() {
        return area;
    }

    public void setArea(Double area) {
        this.area = area;
    }

    public Double getRentalPrice() {
        return rentalPrice;
    }

    public void setRentalPrice(Double rentalPrice) {
        this.rentalPrice = rentalPrice;
    }
}
