<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

                <jsp:include page="../layout/layoutUp.jsp" />

                <div class="mt-5 container">
                    <div class="d-flex justify-content-between">
                        <h1>Manage Rooms</h1>
                        <!-- Button trigger modal -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#staticBackdrop">
                            Add new rooms
                        </button>
                    </div>
                    <hr />
                    <div class="row">
                        <div class="col-8 offset-2">
                            <div class="input-group">
                                <div class="input-group-btn search-panel">
                                    <button type="button" class="btn btn-outline-secondary dropdown-toggle"
                                        data-bs-toggle="dropdown" aria-expanded="false">
                                        <span id="search_concept">Filter by</span> <span class="caret"></span>
                                    </button>
                                    <ul class="dropdown-menu" role="menu">
                                        <li><a class="dropdown-item filter" data-filter="STANDARD">Standard</a></li>
                                        <li><a class="dropdown-item filter" data-filter="DELUXE">Deluxe</a></li>
                                        <li><a class="dropdown-item filter" data-filter="VIP">VIP</a></li>
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
                                <th scope="col">Customer ID</th>
                                <th scope="col">Name</th>
                                <th scope="col">Address</th>
                                <th scope="col">Phone Number</th>
                                <th scope="col">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="room" items="${roomList}" varStatus="loop">
                                <tr>
                                    <th scope="row">${loop.index + 1}</th>
                                    <td>${room.id}</td>
                                    <td>${room.roomName}</td>
                                    <td>${room.roomType}</td>
                                    <td>${room.area}</td>
                                    <td>${room.rentalPrice}</td>
                                    <td>
                                        <a class="btn btn-warning mx-2" href="room/update/${room.id}">Update</a>
                                        <button class="btn btn-danger delete-room" data-bs-toggle="modal"
                                            data-bs-target="#exampleModal" data-roomname="${room.roomName}"
                                            data-id="${room.id}">Delete</button>
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
                                            <c:url var="prevUrl" value="/room">
                                                <c:param name="pageNum" value="${currentPage - 1}" />
                                                <c:param name="searchTerm" value="${searchTerm}" />
                                                <c:param name="roomType" value="${roomType}" />
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
                                        <c:url var="pageUrl" value="/room">
                                            <c:param name="pageNum" value="${page}" />
                                            <c:param name="searchTerm" value="${searchTerm}" />
                                            <c:param name="roomType" value="${roomType}" />
                                        </c:url>
                                        <li class="page-item${currentPage == page ? ' active' : ''}">
                                            <a role="button" href="${pageUrl}" class="page-link">${page}</a>
                                        </li>
                                    </c:forEach>

                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <c:url var="nextUrl" value="/room">
                                                <c:param name="pageNum" value="${currentPage + 1}" />
                                                <c:param name="searchTerm" value="${searchTerm}" />
                                                <c:param name="roomType" value="${roomType}" />
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
                                        <form:form action="/room" method="post" modelAttribute="newRoom">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5" id="staticBackdropLabel">Add new room</h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <c:set var="errorName">
                                                <form:errors path="roomName" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorArea">
                                                <form:errors path="area" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorPrice">
                                                <form:errors path="rentalPrice" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorRoomType">
                                                <form:errors path="roomType" cssClass="invalid-feedback" />
                                            </c:set>

                                            <div class="modal-body">
                                                <div class="modal-body">
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="text" path="roomName"
                                                            class="form-control ${not empty errorName ? 'is-invalid' : ''}"
                                                            placeholder="Room Name" />
                                                        <label for="roomName">Room Name</label>
                                                        ${errorName}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="text" path="area"
                                                            class="form-control ${not empty errorArea ? 'is-invalid' : ''}"
                                                            placeholder="Area" />
                                                        <label for="area">Area</label>
                                                        ${errorArea}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="text" path="rentalPrice"
                                                            class="form-control ${not empty errorPrice ? 'is-invalid' : ''}"
                                                            id="rentalPrice" placeholder="Rental Price" />
                                                        <label for="rentalPrice">Rental Price</label>
                                                        ${errorPrice}
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:select path="roomType"
                                                            class="form-select ${not empty errorRoomType ? 'is-invalid' : ''}"
                                                            id="roomType">
                                                            <form:option value="" label="Select Room Type" />
                                                            <form:options items="${roomTypes}" />
                                                        </form:select>
                                                        <label for="roomType">Room Type</label>
                                                        ${errorRoomType}
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
                            <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel"
                                aria-hidden="true" data-bs-keyboard="false" data-bs-backdrop="static">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form id="deleteForm" action="/room/delete" method="post">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="exampleModalLabel">Modal delete</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                                <p>Delete room name: <span id="modal-roomname"></span></p>
                                                <input type="hidden" name="id" id="modal-room-id">
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
                    </div>
                </div>
                <script>
                    document.addEventListener("DOMContentLoaded", () => {
                        const modalElement = document.getElementById('exampleModal');
                        const modal = new bootstrap.Modal(modalElement);
                        // JavaScript mở modal khi người dùng nhấn nút xóa
                        const deleteButtons = document.querySelectorAll('.delete-room');
                        deleteButtons.forEach(button => {
                            button.addEventListener('click', () => {
                                // Lấy dữ liệu từ thuộc tính data-* của nút
                                const username = button.getAttribute('data-roomname');
                                const userId = button.getAttribute('data-id');

                                // Cập nhật tên người dùng vào modal
                                document.getElementById('modal-roomname').textContent = username;
                                document.getElementById('modal-room-id').value = userId;

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
                                if (item.getAttribute('data-filter') === 'any') {
                                    url.searchParams.delete('roomType')
                                    window.location.href = url
                                } else {
                                    url.searchParams.set('roomType', (item.getAttribute('data-filter')));
                                    window.location.href = url
                                }
                            })
                        })
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
                </script>


                <c:if test="${not empty errors.hasErrors()}">
                    <script>

                        const modal1 = new bootstrap.Modal(document.getElementById('staticBackdrop'));
                        modal1.show();

                    </script>
                </c:if>
                <jsp:include page="../layout/layoutDown.jsp" />