<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Rental Details</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            </head>

            <body>
                <div class="container mt-4">
                    <div class="card">
                        <div class="card-body">
                            <h3 class="card-title">Rental Details</h3>
                            <p class="text-muted">Invoice ID: #${rentalById.id}</p>
                            <hr>

                            <!-- Room Information -->
                            <h5>Room Information</h5>
                            <p><strong>Room:</strong> ${rentalById.room.roomName}</p>

                            <!-- Customer Information -->
                            <h5>Customer Information</h5>
                            <ul>
                                <c:forEach var="customer" items="${rentalById.customers}">
                                    <li>Name: ${customer.name}, Address: ${customer.address}, Phone:
                                        ${customer.phoneNumber}
                                    </li>
                                </c:forEach>
                            </ul>

                            <!-- Rental Information -->
                            <h5>Rental Information</h5>
                            <ul>
                                <li><strong>Start Date:</strong> ${rentalById.startDate}</li>
                                <li><strong>End Date:</strong> ${rentalById.endDate}</li>
                                <li><strong>Deposit:</strong> ${deposit} VND</li>
                                <li><strong>Payment Method:</strong> ${rentalById.paymentMethod}</li>
                                <li><strong>Notes:</strong> ${rentalById.notes}</li>
                                <li><strong>Payment Date:</strong> ${rentalById.paymentDate}</li>
                                <li><strong>Status:</strong> ${rentalById.status ? 'Paid' : 'Unpaid'}</li>
                            </ul>

                            <!-- Service Information -->
                            <h5>Service Information</h5>
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Service Name</th>
                                        <th>Price (VND)</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="service" items="${rentalById.services}" varStatus="status">
                                        <tr>
                                            <td>${status.count}</td>
                                            <td>${service.serviceName}</td>
                                            <td>${service.price}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>

                            <!-- Summary Section -->
                            <h5>Summary</h5>
                            <ul>
                                <li><strong>Service Total:</strong> ${serviceTotal} VND</li>
                                <li><strong>Room Cost:</strong> ${roomCost} VND</li>
                                <li><strong>Deposit:</strong> ${deposit} VND</li>



                                <c:if test="${surcharge < 0}">
                                    <li><strong>Discount:</strong> ${surcharge} VND</li>
                                </c:if>
                                <c:if test="${surcharge > 0}">
                                    <li><strong>Surcharge:</strong> ${surcharge} VND</li>
                                </c:if>


                                <li><strong>Total Expected Amount:</strong> ${expectedTotal} VND</li>



                                <li><strong>Amount:</strong> ${rentalById.amount} VND</li>

                            </ul>

                            <!-- Back and Confirm Payment Buttons -->
                            <div class="mt-3 d-flex justify-content-between">
                                <a class="btn btn-secondary" href="/rental">Back to Rentals</a>

                            </div>
                        </div>

                    </div>
                </div>
            </body>

            </html>