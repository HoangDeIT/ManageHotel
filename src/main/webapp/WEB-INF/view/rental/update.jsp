<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Document</title>
                    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
                        integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
                        crossorigin="anonymous"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
                        integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
                        crossorigin="anonymous"></script>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet"
                        integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
                        crossorigin="anonymous">
                    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
                    <link rel="stylesheet" type="text/css"
                        href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
                    <style>
                        body {
                            font-family: 'Poppins', sans-serif;
                            background: #dfdfdf;
                        }

                        #sidebar {
                            background: #6d6d6d;
                            min-height: 100vh;
                            color: white;
                            transition: all 0.3s;
                            overflow-y: scroll;
                            top: 0;
                            height: 100vh;
                        }

                        #sidebar ul {
                            padding: 0;
                            list-style-type: none;
                        }

                        #sidebar .sidebar-header {
                            background: #333333;
                            padding: 20px;
                            cursor: pointer;
                        }

                        #sidebar .active {
                            margin-left: 0;
                            background-color: #7386D5;
                        }

                        #sidebar ul li a {
                            display: block;
                            padding: 10px;
                            color: white;
                            text-decoration: none;
                        }

                        #sidebar ul li a:hover {
                            background-color: white;
                            color: #7386D5;
                        }

                        .content {
                            width: 100%;
                            padding: 20px;
                        }

                        /* Sidebar toggle button on smaller screens */
                        @media (max-width: 992px) {
                            #sidebar {
                                margin-left: -250px;
                            }

                            #sidebar.active {
                                margin-left: 0;
                            }

                            #sidebarCollapse {
                                display: block;
                            }
                        }

                        /* Show sidebar and hide button on larger screens */
                        @media (min-width: 992px) {
                            #sidebarCollapse {
                                display: none;
                            }

                            #sidebar {
                                margin-left: 0;
                            }
                        }

                        .avatar {
                            vertical-align: middle;
                            width: 200px;
                            height: 200px;
                            border-radius: 50%;
                        }

                        main.container>.d-flex {
                            gap: 50px;
                        }
                    </style>
                </head>

                <body>
                    <div class="wrapper d-flex">

                        <nav id="sidebar" class="col-lg-2 col-md-4 position-sticky">
                            <div class="sidebar-header" onclick="window.location.replace(`/rental`)">
                                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor"
                                    class="bi bi-house" viewBox="0 0 16 16">
                                    <path
                                        d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z" />
                                </svg>
                                <h3>Rental Management</h3>
                            </div>
                            <ul class="list-unstyled components">

                                <c:forEach var="rental" items="${rentalList}">
                                    <li class="${rental.id == rentalById.id ? 'active' : ''}">
                                        <a href="/rental/update/${rental.id}">${rental.id} -
                                            - ${rental.room.roomName}</a>
                                    </li>
                                </c:forEach>

                            </ul>
                        </nav>

                        <div class="content flex-grow-1">
                            <nav class="navbar navbar-light">
                                <!-- Sidebar Toggle Button -->
                                <button type="button" id="sidebarCollapse" class="btn btn-info d-lg-none">
                                    <i class="fa fa-align-justify"></i>
                                </button>
                            </nav>
                            <div style="margin-top: 5vh;">
                                <main class="container">
                                    <div class="d-flex justify-content-center">
                                        <div
                                            class="p-5 col-8 rounded bg-white d-flex justify-content-center align-items-center flex-column">

                                            <form:form action="/rental/update" method="post" modelAttribute="rentalById"
                                                class="col-8">
                                                <form:input type="text" path="id" style="display: none;" />
                                                <c:set var="errorStartDate">
                                                    <form:errors path="startDate" cssClass="invalid-feedback" />
                                                </c:set>
                                                <c:set var="errorEndDate">
                                                    <form:errors path="endDate" cssClass="invalid-feedback" />
                                                </c:set>
                                                <c:set var="errorDeposit">
                                                    <form:errors path="deposit" cssClass="invalid-feedback" />
                                                </c:set>
                                                <c:set var="errorCustomerId">
                                                    <form:errors path="customers" cssClass="invalid-feedback" />
                                                </c:set>
                                                <c:set var="errorRoomId">
                                                    <form:errors path="room" cssClass="invalid-feedback" />
                                                </c:set>

                                                <div class="modal-body">
                                                    <div class="mb-3 col-12">
                                                        <label for="customers">Customer</label>
                                                        <form:select size="5" path="customers" multiple="multiple"
                                                            class="form-select ${not empty errorCustomerId ? 'is-invalid' : ''}"
                                                            id="customers">
                                                            <form:option value="" label="Select Customer" />
                                                            <form:options items="${customers}" itemValue="id"
                                                                itemLabel="idName" />
                                                        </form:select>

                                                        ${errorCustomerId}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:select path="room"
                                                            class="form-select ${not empty errorRoomId ? 'is-invalid' : ''}"
                                                            id="room">
                                                            <form:option value="" label="Select Room" />
                                                            <form:options items="${rooms}" itemValue="id"
                                                                itemLabel="idRoomName" />
                                                        </form:select>
                                                        <label for="room">Room</label>
                                                        ${errorRoomId}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="date" path="startDate"
                                                            class="form-control ${not empty errorStartDate ? 'is-invalid' : ''}"
                                                            placeholder="Start Date" />
                                                        <label for="startDate">Start Date</label>
                                                        ${errorStartDate}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="date" path="endDate"
                                                            class="form-control ${not empty errorEndDate ? 'is-invalid' : ''}"
                                                            placeholder="End Date" />
                                                        <label for="endDate">End Date</label>
                                                        ${errorEndDate}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="number" path="deposit"
                                                            class="form-control ${not empty errorDeposit ? 'is-invalid' : ''}"
                                                            placeholder="Deposit" />
                                                        <label for="deposit">Deposit</label>
                                                        ${errorDeposit}
                                                    </div>


                                                    <button type="submit" class="btn btn-warning">Update</button>
                                                </div>
                                            </form:form>

                                        </div>
                                        <div class="col-4 bg-white p-3">

                                            <h5 class="mb-3">Current Customers in Rental</h5>
                                            <ul class="list-group">
                                                <c:forEach var="customer" items="${rentalById.customers}">
                                                    <li
                                                        class="list-group-item list-group-item-action list-group-item-info">
                                                        <a class="text-decoration-none"
                                                            href="/customer/update/${customer.id}">${customer.name}</a>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </div>



                                    </div>
                                    <div class="bg-white my-3 col-12 p-5">
                                        <button class="btn btn-info service-rental" data-bs-toggle="modal"
                                            data-bs-target="#addServiceModal" data-rentalid="${rental.id}">Thêm dịch
                                            vụ</button>
                                        <table class="table table-hover my-4">
                                            <thead>
                                                <tr>
                                                    <th scope="col">#</th>
                                                    <th scope="col">Service ID</th>
                                                    <th scope="col">Service Name</th>
                                                    <th scope="col">Price</th>
                                                    <th scope="col">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="service" items="${rentalById.services}"
                                                    varStatus="loop">
                                                    <tr>
                                                        <th scope="row">${loop.index + 1}</th>
                                                        <td>${service.id}</td>
                                                        <td>${service.serviceName}</td>
                                                        <td>${service.price}</td>
                                                        <td>
                                                            <form action="/rental/removeService" method="post">
                                                                <input type="hidden" name="rentalId"
                                                                    value="${rentalById.id}">
                                                                <input type="hidden" name="serviceId"
                                                                    value="${service.id}">
                                                                <input type="hidden" name="_csrf"
                                                                    value="${_csrf.token}" />

                                                                <button type="submit"
                                                                    class="btn btn-danger">Delete</button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>

                            </div>
                            </main>
                        </div>
                    </div>
                    <div class="modal fade" id="addServiceModal" tabindex="-1" data-bs-backdrop="static"
                        aria-labelledby="addServiceModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="addServiceModalLabel">Thêm Dịch Vụ</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <form id="serviceForm" action="/rental/addService" method="post">
                                        <!-- Hidden field for rental ID -->
                                        <input type="hidden" id="modal-rental-service-id" name="rentalId"
                                            value="${rentalById.id}">
                                        <input type="hidden" name="_csrf" value="${_csrf.token}" />

                                        <div class="mb-3">
                                            <label for="serviceId" class="form-label">Chọn Dịch Vụ</label>
                                            <select name="serviceId" class="form-control" id="serviceId" required>
                                                <option value="">Chọn Dịch Vụ</option>
                                                <!-- Loop through services list -->
                                                <c:forEach var="service" items="${services}">
                                                    <option value="${service.id}">${service.serviceName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </form>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Đóng</button>
                                    <button type="submit" class="btn btn-info"
                                        onclick="document.getElementById('serviceForm').submit();">Thêm Dịch
                                        Vụ</button>
                                </div>
                            </div>
                        </div>
                    </div>


                </body>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        document.getElementById('sidebarCollapse').addEventListener('click', function () {
                            document.getElementById('sidebar').classList.toggle('active');
                        });
                    });
                </script>
                <c:if test="${not empty status}">
                    <script>
                        Toastify({
                            text: "${status}",
                            className: "info",
                            duration: 3000,
                            close: true,
                            gravity: "top", // `top` or `bottom`
                            position: "right",
                            style: {
                                background: "linear-gradient(to right, #00b09b, #96c93d)"
                            }
                        }).showToast();
                    </script>
                </c:if>

                <script src="/js/previewImgae.js" defer></script>

                </html>