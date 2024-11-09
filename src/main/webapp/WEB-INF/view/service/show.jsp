<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

                <jsp:include page="../layout/layoutUp.jsp" />

                <div class="mt-5 container">
                    <div class="d-flex justify-content-between">
                        <h1>Manage Services</h1>
                        <!-- Button trigger modal -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#staticBackdrop">
                            Add new services
                        </button>
                    </div>
                    <hr />
                    <div class="row">

                        <div class="col-8 offset-2">

                            <div class="input-group">
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
                                <th scope="col">Service ID</th>
                                <th scope="col">Service Name</th>
                                <th scope="col">Price</th>
                                <th scope="col">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="service" items="${serviceList}" varStatus="loop">
                                <tr>
                                    <th scope="row">${loop.index + 1}</th>
                                    <td>${service.id}</td>
                                    <td>${service.serviceName}</td>
                                    <td>${service.price}</td>
                                    <td>
                                        <a class="btn btn-warning mx-2" href="service/update/${service.id}">Update</a>
                                        <button class="btn btn-danger delete-service" data-bs-toggle="modal"
                                            data-bs-target="#deleteServiceModal" data-serviceid="${service.id}"
                                            data-servicename="${service.serviceName}">Delete</button>
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
                                            <c:url var="prevUrl" value="/service">
                                                <c:param name="pageNum" value="${currentPage - 1}" />
                                                <c:param name="searchTerm" value="${searchTerm}" />

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
                                        <c:url var="pageUrl" value="/service">
                                            <c:param name="pageNum" value="${page}" />
                                            <c:param name="searchTerm" value="${searchTerm}" />

                                        </c:url>
                                        <li class="page-item${currentPage == page ? ' active' : ''}">
                                            <a role="button" href="${pageUrl}" class="page-link">${page}</a>
                                        </li>
                                    </c:forEach>

                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <c:url var="nextUrl" value="/service">
                                                <c:param name="pageNum" value="${currentPage + 1}" />
                                                <c:param name="searchTerm" value="${searchTerm}" />

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
                                        <form:form action="/service" method="post" modelAttribute="newService">
                                            <div class="modal-header">
                                                <h1 class="modal-title fs-5" id="staticBackdropLabel">Add New Service
                                                </h1>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>

                                            <c:set var="errorServiceName">
                                                <form:errors path="serviceName" cssClass="invalid-feedback" />
                                            </c:set>
                                            <c:set var="errorPrice">
                                                <form:errors path="price" cssClass="invalid-feedback" />
                                            </c:set>

                                            <div class="modal-body">
                                                <div class="form-floating mb-3 col-12">
                                                    <form:input type="text" path="serviceName"
                                                        class="form-control ${not empty errorServiceName ? 'is-invalid' : ''}"
                                                        placeholder="Service Name" />
                                                    <label for="serviceName">Service Name</label>
                                                    ${errorServiceName}
                                                </div>
                                                <div class="form-floating mb-3 col-12">
                                                    <form:input type="number" path="price"
                                                        class="form-control ${not empty errorPrice ? 'is-invalid' : ''}"
                                                        placeholder="Price" />
                                                    <label for="price">Price</label>
                                                    ${errorPrice}
                                                </div>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Close</button>
                                                <button type="submit" class="btn btn-primary">Add</button>
                                            </div>
                                        </form:form>




                                    </div>
                                </div>
                            </div>

                        </div>
                        <div>
                            <div class="modal fade" id="deleteServiceModal" tabindex="-1"
                                aria-labelledby="deleteServiceModalLabel" aria-hidden="true" data-bs-keyboard="false"
                                data-bs-backdrop="static">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <form id="deleteServiceForm" action="/service/delete" method="post">
                                            <div class="modal-header">
                                                <h5 class="modal-title" id="deleteServiceModalLabel">Delete Service</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <p>Delete service: <span id="modal-service-name"></span></p>
                                                <input type="hidden" name="_csrf" value="${_csrf.token}" />
                                                <input type="hidden" name="id" id="modal-service-id">
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
                    document.addEventListener('DOMContentLoaded', function () {
                        const modalElement = document.getElementById('deleteServiceModal');
                        const modal = new bootstrap.Modal(modalElement);

                        // JavaScript mở modal khi người dùng nhấn nút xóa
                        const deleteButtons = document.querySelectorAll('.delete-service');
                        deleteButtons.forEach(button => {
                            button.addEventListener('click', () => {
                                // Lấy dữ liệu từ thuộc tính data-* của nút
                                const serviceName = button.getAttribute('data-servicename');
                                const serviceId = button.getAttribute('data-serviceid');

                                // Cập nhật tên dịch vụ vào modal
                                document.getElementById('modal-service-name').textContent = serviceName;
                                document.getElementById('modal-service-id').value = serviceId;

                                // Hiển thị modal
                                modal.show();
                            });
                        });



                        console.log("dasdasd");

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