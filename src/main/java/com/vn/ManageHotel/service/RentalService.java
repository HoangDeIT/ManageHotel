package com.vn.ManageHotel.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.vn.ManageHotel.domain.Rental;
import com.vn.ManageHotel.repository.RentalRepository;

import jakarta.transaction.Transactional;

@Service
public class RentalService {

    public RentalService(RentalRepository rentalRepository) {
        this.rentalRepository = rentalRepository;
    }

    private final RentalRepository rentalRepository;

    @Transactional
    public List<Rental> getPaginatedRentals(String searchTerm, int pageNum, int pageSize, String startDate,
            String endDate) {
        return rentalRepository.getPaginatedRentals(searchTerm, pageNum, pageSize, startDate, endDate);
    }

    @Transactional
    public int getTotalPagesForRentals(String searchTerm, int pageSize, String startDate, String endDate) {
        return rentalRepository.getTotalPagesForRentals(searchTerm, pageSize, startDate, endDate);
    }

    public void saveRental(Rental rental) {
        rentalRepository.save(rental);
    }

    public Rental getRentalById(long id) {
        return rentalRepository.findById(id).orElse(null);
    }

    public List<Rental> getAllRentals() {
        return rentalRepository.findAll();
    }

    public void deleteRentalById(long id) {
        rentalRepository.deleteById(id);
    }
}
