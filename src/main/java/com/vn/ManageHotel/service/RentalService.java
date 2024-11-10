package com.vn.ManageHotel.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.vn.ManageHotel.domain.Rental;
import com.vn.ManageHotel.domain.Staff;
import com.vn.ManageHotel.repository.RentalRepository;
import com.vn.ManageHotel.repository.ServiceRepository;

import jakarta.transaction.Transactional;

@Service
public class RentalService {
    private final RentalRepository rentalRepository;
    private final ServiceRepository serviceRepository;

    public RentalService(RentalRepository rentalRepository, ServiceRepository serviceRepository) {
        this.rentalRepository = rentalRepository;
        this.serviceRepository = serviceRepository;
    }

    @Transactional
    public List<Rental> getPaginatedRentals(
            String searchTerm,
            int pageNum,
            int pageSize,
            String startDate,
            String endDate,
            Boolean status) {
        return rentalRepository.getPaginatedRentals(
                searchTerm,
                pageNum,
                pageSize,
                startDate,
                endDate,
                status);
    }

    @Transactional
    public int getTotalPagesForRentals(
            String searchTerm,
            int pageSize,
            String startDate,
            String endDate,
            Boolean status) {
        return rentalRepository.getTotalPagesForRentals(
                searchTerm,
                pageSize,
                startDate,
                endDate,
                status);
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

    @Transactional
    public boolean addServiceToRental(Long rentalId, Long serviceId) {
        Optional<Rental> rentalOpt = rentalRepository.findById(rentalId);
        Optional<com.vn.ManageHotel.domain.Service> serviceOpt = serviceRepository.findById(serviceId);

        if (rentalOpt.isPresent() && serviceOpt.isPresent()) {
            Rental rental = rentalOpt.get();
            com.vn.ManageHotel.domain.Service service = serviceOpt.get();
            rental.getServices().add(service);
            rentalRepository.save(rental);
            return true;

        }
        return false;
    }

    @Transactional
    public boolean removeServiceFromRental(Long rentalId, Long serviceId) {
        Optional<Rental> rentalOpt = rentalRepository.findById(rentalId);
        Optional<com.vn.ManageHotel.domain.Service> serviceOpt = serviceRepository.findById(serviceId);

        if (rentalOpt.isPresent() && serviceOpt.isPresent()) {
            Rental rental = rentalOpt.get();
            com.vn.ManageHotel.domain.Service service = serviceOpt.get();

            if (rental.getServices().contains(service)) {
                rental.getServices().remove(service);
                rentalRepository.save(rental);
                return true;
            }
        }
        return false;
    }

    public boolean processPayment(Long rentalId, BigDecimal amount, String paymentMethod, String notes,
            LocalDate paymentDate, Staff staff) {
        Optional<Rental> optionalRental = rentalRepository.findById(rentalId);

        if (optionalRental.isPresent()) {
            Rental rental = optionalRental.get();
            rental.setStatus(true);
            rental.setAmount(amount);
            rental.setPaymentMethod(paymentMethod);
            rental.setNotes(notes);
            rental.setPaymentDate(paymentDate);
            rental.setCreatedBy(staff);
            rentalRepository.save(rental);
            return true;
        }

        return false;
    }
}
