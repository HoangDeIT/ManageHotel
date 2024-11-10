
---Staff
DELIMITER //

CREATE PROCEDURE getPaginatedStaff(
    IN searchTerm VARCHAR(255),
    IN pageNum INT,
    IN pageSize INT
)
BEGIN
    DECLARE offset INT;

    SET offset = (pageNum - 1) * pageSize;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        SELECT * FROM staff
        LIMIT pageSize OFFSET offset;
    ELSE
        SELECT * FROM staff
        WHERE fullName LIKE CONCAT('%', searchTerm, '%')
        LIMIT pageSize OFFSET offset;
    END IF;
END //

DELIMITER ;

//Procedure to get paginated staff with search

DELIMITER //

CREATE FUNCTION getTotalPagesForStaff(searchTerm VARCHAR(255), pageSize INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE totalRecords INT;
    DECLARE totalPages INT;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        SELECT COUNT(*) INTO totalRecords FROM staff;
    ELSE
        SELECT COUNT(*) INTO totalRecords FROM staff WHERE full_name LIKE CONCAT('%', searchTerm, '%');
    END IF;

    SET totalPages = CEIL(totalRecords / pageSize);

    RETURN totalPages;
END //

DELIMITER ;

 ----CUSTOMER
DELIMITER //

CREATE PROCEDURE getPaginatedCustomers(
    IN searchTerm VARCHAR(255),
    IN pageNum INT,
    IN pageSize INT
)
BEGIN
    DECLARE offset INT;

    SET offset = (pageNum - 1) * pageSize;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        SELECT * FROM customer
        LIMIT pageSize OFFSET offset;
    ELSE
        SELECT * FROM customer
        WHERE name LIKE CONCAT('%', searchTerm, '%')
        LIMIT pageSize OFFSET offset;
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION getTotalPagesForCustomers(searchTerm VARCHAR(255), pageSize INT) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE totalRecords INT;
    DECLARE totalPages INT;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        SELECT COUNT(*) INTO totalRecords FROM customer;
    ELSE
        SELECT COUNT(*) INTO totalRecords FROM customer WHERE name LIKE CONCAT('%', searchTerm, '%');
    END IF;

    SET totalPages = CEIL(totalRecords / pageSize);

    RETURN totalPages;
END //

DELIMITER ;




INSERT INTO customer (name, address, phone_number) VALUES
('Nguyễn Văn A', '123 Đường 1, Quận 1, TP.HCM', '0901234567'),
('Trần Thị B', '456 Đường 2, Quận 2, TP.HCM', '0902345678'),
('Lê Văn C', '789 Đường 3, Quận 3, TP.HCM', '0903456789'),
('Phạm Thị D', '101 Đường 4, Quận 4, TP.HCM', '0904567890'),
('Võ Văn E', '112 Đường 5, Quận 5, TP.HCM', '0905678901');

---
INSERT INTO Room (room_name, room_type, area, rental_price) VALUES
('Room 101', 'STANDARD', 30.0, 100.0),
('Room 102', 'DELUXE', 40.0, 150.0),
('Room 103', 'VIP', 50.0, 200.0),
('Room 104', 'STANDARD', 35.0, 120.0),
('Room 105', 'DELUXE', 45.0, 160.0),
('Room 106', 'VIP', 55.0, 220.0);

DELIMITER //

CREATE PROCEDURE getPaginatedRooms(
    IN searchTerm VARCHAR(255),
    IN pageNum INT,
    IN pageSize INT,
    IN roomType VARCHAR(255)
)
BEGIN
    DECLARE offset INT;

    SET offset = (pageNum - 1) * pageSize;

    IF (searchTerm IS NULL OR searchTerm = '') AND (roomType IS NULL OR roomType = '') THEN
        SELECT * FROM Room
        LIMIT pageSize OFFSET offset;
    ELSEIF (searchTerm IS NULL OR searchTerm = '') THEN
        SELECT * FROM Room
        WHERE room_type = roomType
        LIMIT pageSize OFFSET offset;
    ELSEIF (roomType IS NULL OR roomType = '') THEN
        SELECT * FROM Room
        WHERE room_name LIKE CONCAT('%', searchTerm, '%')
        LIMIT pageSize OFFSET offset;
    ELSE
        SELECT * FROM Room
        WHERE room_name LIKE CONCAT('%', searchTerm, '%')
        AND room_type = roomType
        LIMIT pageSize OFFSET offset;
    END IF;
END //

DELIMITER ;
----------
DELIMITER //

CREATE FUNCTION getTotalPagesForRooms(
    searchTerm VARCHAR(255),
    pageSize INT,
    roomType VARCHAR(255)
) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE totalRecords INT;
    DECLARE totalPages INT;

    IF (searchTerm IS NULL OR searchTerm = '') AND (roomType IS NULL OR roomType = '') THEN
        SELECT COUNT(*) INTO totalRecords FROM Room;
    ELSEIF (searchTerm IS NULL OR searchTerm = '') THEN
        SELECT COUNT(*) INTO totalRecords FROM Room
        WHERE room_type = roomType;
    ELSEIF (roomType IS NULL OR roomType = '') THEN
        SELECT COUNT(*) INTO totalRecords FROM Room
        WHERE room_name LIKE CONCAT('%', searchTerm, '%');
    ELSE
        SELECT COUNT(*) INTO totalRecords FROM Room
        WHERE room_name LIKE CONCAT('%', searchTerm, '%')
        AND room_type = roomType;
    END IF;

    SET totalPages = CEIL(totalRecords / pageSize);

    RETURN totalPages;
END //

DELIMITER ;



---Retal
DELIMITER //

CREATE TRIGGER set_default_start_date
BEFORE INSERT ON rental
FOR EACH ROW
BEGIN
    IF NEW.start_date IS NULL THEN
        SET NEW.start_date = CURDATE();
    END IF;
END //

DELIMITER ;
---Logic lay du lieu cho rentals



---
DELIMITER //

CREATE PROCEDURE getPaginatedRentals(
    IN searchTerm VARCHAR(255),
    IN pageNum INT,
    IN pageSize INT,
    IN startDate DATE,
    IN endDate DATE,
    IN status BOOLEAN
)
BEGIN
    DECLARE offset INT;

    -- Tính toán offset cho phân trang
    SET offset = (pageNum - 1) * pageSize;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        -- Truy vấn không có từ khóa tìm kiếm
        SELECT r.* 
        FROM rental r
        WHERE r.start_date BETWEEN startDate AND endDate
        AND r.status = status
        LIMIT pageSize OFFSET offset;
    ELSE
        -- Truy vấn có từ khóa tìm kiếm
        SELECT DISTINCT r.* 
        FROM rental r
        JOIN rental_customer rc ON r.id = rc.rental_id
        JOIN customer c ON rc.customer_id = c.id
        JOIN room ro ON r.room_id = ro.id
        WHERE r.start_date BETWEEN startDate AND endDate
        AND r.status = status
        AND (c.name LIKE CONCAT('%', searchTerm, '%') 
        OR ro.room_name LIKE CONCAT('%', searchTerm, '%'))
        LIMIT pageSize OFFSET offset;
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION getTotalPagesForRentals(
    searchTerm VARCHAR(255),
    pageSize INT,
    startDate DATE,
    endDate DATE,
    status BOOLEAN
) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE totalRecords INT;
    DECLARE totalPages INT;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        -- Truy vấn khi không có từ khóa tìm kiếm
        SELECT COUNT(*) INTO totalRecords 
        FROM rental r
        WHERE r.start_date BETWEEN startDate AND endDate
        AND r.status = status;
    ELSE
        -- Truy vấn với từ khóa tìm kiếm
        SELECT COUNT(DISTINCT r.id) INTO totalRecords 
        FROM rental r
        JOIN rental_customer rc ON r.id = rc.rental_id
        JOIN customer c ON rc.customer_id = c.id
        JOIN room ro ON r.room_id = ro.id
        WHERE r.start_date BETWEEN startDate AND endDate
        AND r.status = status
        AND (c.name LIKE CONCAT('%', searchTerm, '%') 
        OR ro.room_name LIKE CONCAT('%', searchTerm, '%'));
    END IF;

    -- Tính tổng số trang
    SET totalPages = CEIL(totalRecords / pageSize);

    RETURN totalPages;
END //

DELIMITER ;


----SERVICE
DELIMITER //

CREATE FUNCTION getTotalPagesServices(
    searchTerm VARCHAR(255),
    pageSize INT
) RETURNS INT
READS SQL DATA
BEGIN
    DECLARE totalRecords INT;
    DECLARE totalPages INT;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        SELECT COUNT(*) INTO totalRecords 
        FROM service s;
    ELSE
        SELECT COUNT(*) INTO totalRecords 
        FROM service s
        WHERE s.service_name LIKE CONCAT('%', searchTerm, '%');
    END IF;

    SET totalPages = CEIL(totalRecords / pageSize);

    RETURN totalPages;
END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE getPaginatedServices(
    IN searchTerm VARCHAR(255),
    IN pageNum INT,
    IN pageSize INT
)
BEGIN
    DECLARE offset INT;

    SET offset = (pageNum - 1) * pageSize;

    IF searchTerm IS NULL OR searchTerm = '' THEN
        SELECT s.* 
        FROM service s
        LIMIT pageSize OFFSET offset;
    ELSE
        SELECT s.* 
        FROM service s
        WHERE s.service_name LIKE CONCAT('%', searchTerm, '%')
        LIMIT pageSize OFFSET offset;
    END IF;
END //

DELIMITER ;
