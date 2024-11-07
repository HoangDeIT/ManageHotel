
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

