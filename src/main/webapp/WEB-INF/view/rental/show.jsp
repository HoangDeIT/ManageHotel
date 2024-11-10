<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

                <jsp:include page="../layout/layoutUp.jsp" />

                <div class="mt-5 container">
                    <div class="d-flex justify-content-between">
                        <h1>Manage Rentals</h1>
                        <!-- Button trigger modal -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#staticBackdrop">
                            Add new rentals
                        </button>
                    </div>
                    <hr />
                    <div class="row">
                        <form id="dateForm" class="col-2">
                            <label for="startDate">Start Date:</label>
                            <input type="date" id="startDate" value="${startDate}" class="form-control"
                                placeholder="Start Date" />

                            <label for="endDate" class="mt-2">End Date:</label>
                            <input type="date" id="endDate" value="${endDate}" class="form-control my-2"
                                placeholder="End Date" />

                            <button type="button" class="btn btn-secondary" onclick="updateQueryString()">Lọc
                                ngày</button>
                        </form>

                        <div class="col-10">

                            <div class="input-group">
                                <div class="input-group-btn search-panel mx-2">
                                    <button type="button" class="btn btn-outline-secondary dropdown-toggle"
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                        <span id="search_concept">Filter by</span> <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu" role="menu">
                                        <li><a class="dropdown-item filter" data-filter="0">Not Paid</a></li>
                                        <li><a class="dropdown-item filter" data-filter="1">Paid</a></li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li><a class="dropdown-item filter" data-filter="anything">Anything</a></li>
                                    </ul>


                                </div>
                                <input type="text" id="search-bar" class="form-control" placeholder="Search term...">
                                <button class="btn btn-outline-secondary" type="button" id="search-button">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor"
                                        class="bi bi-search" viewbox="0 0 16 16">
                                        <path
                                            d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001q.044.06.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1 1 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                    </div>

                    <table class="table table-hover my-4">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Rental ID</th>
                                <th scope="col">Customers</th>
                                <th scope="col">Room Name</th>
                                <th scope="col">Start Date</th>
                                <th scope="col">End Date</th>
                                <th scope="col">Deposit</th>
                                <th scope="col">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="rental" items="${rentalList}" varStatus="loop">
                                <tr>
                                    <th scope="row">${loop.index + 1}</th>
                                    <td>${rental.id}</td>
                                    <td>
                                        <ul>
                                            <c:forEach var="customer" items="${rental.customers}">
                                                <li>${customer.name}</li>
                                            </c:forEach>
                                        </ul>
                                    </td>
                                    <td>${rental.room.roomName}</td>
                                    <td>${rental.startDate}</td>
                                    <td>${rental.endDate}</td>
                                    <td>${rental.deposit}</td>
                                    <td>
                                        <c:if test="${rental.status}">
                                            <a class="btn btn-secondary mx-2"
                                                href="rental/detail/${rental.id}">Detail</a>
                                            <button class="btn btn-danger delete-rental" data-bs-toggle="modal"
                                                data-bs-target="#deleteRentalModal" data-rentalid="${rental.id}"
                                                data-customername="${rental.id}">Delete</button>
                                        </c:if>

                                        <!-- Nếu rental chưa thanh toán (status = false) -->
                                        <c:if test="${!rental.status}">
                                            <a class="btn btn-warning mx-2" href="rental/update/${rental.id}">Update</a>
                                            <button class="btn btn-danger delete-rental" data-bs-toggle="modal"
                                                data-bs-target="#deleteRentalModal" data-rentalid="${rental.id}"
                                                data-customername="${rental.id}">Delete</button>
                                            <button class="btn btn-success payment-rental" data-bs-toggle="modal"
                                                data-bs-target="#paymentRentalModal" data-rentalid="${rental.id}">Thanh
                                                Toán</button>
                                            <button class="btn btn-info service-rental" data-bs-toggle="modal"
                                                data-bs-target="#addServiceModal" data-rentalid="${rental.id}">Thêm dịch
                                                vụ</button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>


                    <nav aria-label="Page navigation">
                        <div class="d-flex justify-content-center gap-4">
                            <div>

                                <ul class="pagination d-flex justify-content-center">
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <c:url var="prevUrl" value="/rental">
                                                <c:param name="pageNum" value="${currentPage - 1}" />
                                                <c:param name="searchTerm" value="${searchTerm}" />
                                                <c:param name="endDate" value="${endDate}" />
                                                <c:param name="status1" value="${status1}" />
                                                <c:param name="startDate" value="${startDate}" />
                                            </c:url>
                                            <li class="page-item">
                                                <a role="button" href="${prevUrl}" class="page-link">
                                                    <span>&laquo;</span>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item disabled">
                                                <a role="button" href="#" class="page-link">
                                                    <span>&laquo;</span>
                                                </a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:forEach var="page" items="${pageArray}">
                                        <c:url var="pageUrl" value="/rental">
                                            <c:param name="pageNum" value="${page}" />
                                            <c:param name="searchTerm" value="${searchTerm}" />
                                            <c:param name="endDate" value="${endDate}" />
                                            <c:param name="startDate" value="${startDate}" />

                                            <c:param name="status1" value="${status1}" />

                                        </c:url>
                                        <li class="page-item${currentPage == page ? ' active' : ''}">
                                            <a role="button" href="${pageUrl}" class="page-link">${page}</a>
                                        </li>
                                    </c:forEach>

                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <c:url var="nextUrl" value="/rental">
                                                <c:param name="pageNum" value="${currentPage + 1}" />
                                                <c:param name="searchTerm" value="${searchTerm}" />
                                                <c:param name="endDate" value="${endDate}" />
                                                <c:param name="startDate" value="${startDate}" />
                                                <c:param name="status1" value="${status1}" />
                                            </c:url>
                                            <li class="page-item">
                                                <a role="button" href="${nextUrl}" class="page-link">
                                                    <span>&raquo;</span>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item disabled">
                                                <a role="button" href="#" class="page-link">
                                                    <span>&raquo;</span>
                                                </a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>


                            </div>
                            <div class="col-2">
                                <div class="input-group">
                                    <input type="number" class="form-control page-input" placeholder="Nhập số trang">
                                    <button class="btn btn-outline-secondary page" type="button">
                                        <i class="bi bi-list-ol"></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                    </nav>
                    <!-- Modal -->
                    <div>
                        <div>
                            <div class="modal modal-xl fade" id="staticBackdrop" data-bs-backdrop="static"
                                data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel"
                                aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form:form action="/rental" method="post" modelAttribute="newRental">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5" id="staticBackdropLabel">Add new rental
                                                </h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <c:set var="errorCustomer">
                                                <form:errors path="customers" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorRoom">
                                                <form:errors path="room" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorStartDate">
                                                <form:errors path="startDate" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorEndDate">
                                                <form:errors path="endDate" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorDeposit">
                                                <form:errors path="deposit" cssClass="invalid-feedback" />
                                            </c:set>

                                            <div class="modal-body">
                                                <div class="modal-body">
                                                    <div class="mb-3 col-12">
                                                        <label for="customers">Customers</label>
                                                        <form:select size="5" aria-label="multiple select example"
                                                            path="customers" multiple="multiple"
                                                            class="form-control ${not empty errorCustomer ? 'is-invalid' : ''}">
                                                            <form:option value="" label="Select Customers" />
                                                            <form:options items="${customers}" itemValue="id"
                                                                itemLabel="idName" />
                                                        </form:select>
                                                        ${errorCustomer}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:select path="room"
                                                            class="form-control ${not empty errorRoom ? 'is-invalid' : ''}">
                                                            <form:option value="" label="Select Room" />
                                                            <form:options items="${rooms}" itemValue="id"
                                                                itemLabel="idRoomName" />
                                                        </form:select>
                                                        <label for="room">Room</label>
                                                        ${errorRoom}
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
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Close</button>
                                                    <button type="submit" class="btn btn-primary">Add</button>
                                                </div>
                                            </div>
                                        </form:form>



                                    </div>
                                </div>
                            </div>

                        </div>
                        <div>
                            <div class="modal fade" id="deleteRentalModal" tabindex="-1"
                                aria-labelledby="deleteRentalModalLabel" aria-hidden="true" data-bs-keyboard="false"
                                data-bs-backdrop="static">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form id="deleteForm" action="/rental/delete" method="post">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="deleteRentalModalLabel">Delete Rental</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Delete rental for customer: <span id="modal-customer-name"></span>
                                                </p>
                                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                                <input type="hidden" name="id" id="modal-rental-id">
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Close</button>
                                                <button type="submit" class="btn btn-danger">Delete</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>


                        </div>


                        <div class="modal fade" id="paymentRentalModal" tabindex="-1" data-bs-backdrop="static"
                            aria-labelledby="paymentRentalModalLabel" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="paymentRentalModalLabel">Thanh Toán</h5> <button
                                            type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="paymentForm" action="/rental/payment" method="post">
                                            <input type="hidden" id="modal-rental-payment-id" name="rentalId" />

                                            <div class="mb-3">
                                                <label for="amount" class="form-label">Thành Tiền</label>
                                                <input type="number" class="form-control" id="amount" name="amount"
                                                    required />
                                            </div>

                                            <div class="mb-3">
                                                <label for="paymentMethod" class="form-label">Hình Thức Thanh
                                                    Toán</label>
                                                <input type="text" class="form-control" id="paymentMethod"
                                                    name="paymentMethod" required />
                                            </div>

                                            <div class="mb-3">
                                                <label for="notes" class="form-label">Ghi Chú</label>
                                                <textarea class="form-control" id="notes" name="notes"></textarea>
                                            </div>

                                            <div class="mb-3">
                                                <label for="paymentDate" class="form-label">Ngày Thanh Toán</label>
                                                <input type="date" class="form-control" id="paymentDate"
                                                    name="paymentDate" required />
                                            </div>

                                            <input type="hidden" name="_csrf" value="${_csrf.token}" />

                                        </form>

                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary"
                                            data-bs-dismiss="modal">Đóng</button>
                                        <button type="submit" class="btn btn-success"
                                            onclick="document.getElementById('paymentForm').submit();">Thanh
                                            Toán</button>
                                    </div>
                                </div>
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
                                            <input type="hidden" id="modal-rental-service-id" name="rentalId" value="">
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





                    </div>
                </div>
                <script>
                    document.addEventListener("DOMContentLoaded", () => {
                        const modalElement = document.getElementById('deleteRentalModal');
                        const modal = new bootstrap.Modal(modalElement);

                        // JavaScript mở modal khi người dùng nhấn nút xóa
                        const deleteButtons = document.querySelectorAll('.delete-rental');
                        deleteButtons.forEach(button => {
                            button.addEventListener('click', () => {
                                // Lấy dữ liệu từ thuộc tính data-* của nút
                                const customerName = button.getAttribute('data-customername');
                                const rentalId = button.getAttribute('data-rentalid');

                                // Cập nhật tên khách hàng vào modal
                                document.getElementById('modal-customer-name').textContent = customerName;
                                document.getElementById('modal-rental-id').value = rentalId;

                                // Hiển thị modal
                                modal.show();
                            });
                        });
                        const paymentButtons = document.querySelectorAll('.payment-rental');
                        paymentButtons.forEach(button => {
                            const paymentModal = new bootstrap.Modal(document.getElementById('paymentRentalModal'));
                            button.addEventListener('click', () => { // Lấy dữ liệu từ thuộc tính data-* của nút 
                                const rentalId = button.getAttribute('data-rentalid'); // Cập nhật rental id vào modal thanh toán 
                                document.getElementById('modal-rental-payment-id').value = rentalId; // Hiển thị modal thanh toán 

                                //paymentModal.show();
                            });
                        });
                        const serviceButtons = document.querySelectorAll('.service-rental');
                        serviceButtons.forEach(button => {
                            const serviceModal = new bootstrap.Modal(document.getElementById('addServiceModal'));
                            button.addEventListener('click', () => {
                                // Lấy dữ liệu từ thuộc tính data-* của nút
                                const rentalId = button.getAttribute('data-rentalid');
                                // Cập nhật rental id vào modal thêm dịch vụ
                                document.getElementById('modal-rental-service-id').value = rentalId;
                                // Hiển thị modal thêm dịch vụ
                                //  serviceModal.show();
                            });
                        });

                        // /

                        const getSearchValue = () => {
                            return document.getElementById('search-bar').value;
                        }
                        const searchButton = document.getElementById('search-button')
                        searchButton.addEventListener('click', () => {
                            let fullLink = window.location.href;
                            const url = new URL(fullLink);
                            if (getSearchValue() === '' || getSearchValue() === null) {
                                url.searchParams.delete('searchTerm')
                                window.location.href = url
                            } else {
                                url.searchParams.set('searchTerm', getSearchValue());
                                window.location.href = url
                            }

                        });
                        const dropdown = document.querySelectorAll(".filter");
                        dropdown.forEach((item) => {
                            item.addEventListener('click', (e) => {
                                let fullLink = window.location.href;
                                const url = new URL(fullLink);
                                if (item.getAttribute('data-filter') === 'anything') {
                                    url.searchParams.delete('status1');
                                    window.location.href = url;
                                } else {
                                    url.searchParams.set('status1', item.getAttribute('data-filter'));
                                    window.location.href = url;
                                }
                            });
                        });

                        const pageButton = document.querySelector('.page');
                        const pageInput = document.querySelector('.page-input');
                        pageButton.addEventListener('click', () => {
                            let fullLink = window.location.href;
                            const url = new URL(fullLink);
                            let pageNum = pageInput.value;
                            if (pageNum < 0 || pageNum === '' || pageNum === null || pageNum === ' ') {
                                pageNum = 1;
                            }
                            url.searchParams.set('pageNum', pageNum)
                            window.location.href = url
                        })
                        ///tu dong them vao input
                        let fullLink = window.location.href;
                        let url = new URL(fullLink);
                        if (url.searchParams.has('pageNum')) {
                            let pageValue = url.searchParams.get('pageNum');
                            pageInput.value = pageValue;
                        }
                        if (url.searchParams.has('searchTerm')) {
                            let pageValue = url.searchParams.get('searchTerm');
                            document.getElementById('search-bar').value = pageValue;
                        }



                    })

                    function updateQueryString() {
                        const startDate = document.getElementById("startDate").value;
                        const endDate = document.getElementById("endDate").value;

                        const url = new URL(window.location.href);
                        const params = url.searchParams;

                        if (startDate) {
                            params.set('startDate', startDate);
                        }

                        if (endDate) {
                            params.set('endDate', endDate);
                        }

                        window.location.href = url.toString();
                    }
                </script>


                <c:if test="${not empty errors.hasErrors()}">
                    <script>

                        const modal1 = new bootstrap.Modal(document.getElementById('staticBackdrop'));
                        modal1.show();

                    </script>
                </c:if>
                <jsp:include page="../layout/layoutDown.jsp" />