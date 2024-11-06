package com.vn.ManageHotel;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// @SpringBootApplication
@SpringBootApplication(exclude = org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class)
public class ManageHotelApplication {

	public static void main(String[] args) {
		SpringApplication.run(ManageHotelApplication.class, args);
	}

}
