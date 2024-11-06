<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@taglib prefix="spring" uri="http://www.springframework.org/tags" %>
            <%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

                <jsp:include page="../layout/layoutUp.jsp" />

                <div class="mt-5 container">
                    <div class="d-flex justify-content-between">
                        <h1>Manage Employee</h1>
                        <!-- Button trigger modal -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#staticBackdrop">
                            Add new employee
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


                    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
                        <table class="table table-hover my-4">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Mã nhân viên</th>
                                    <th scope="col">Họ tên</th>
                                    <th scope="col">Ngày sinh</th>
                                    <th scope="col">Số điện thoại</th>
                                    <th scope="col">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="nhanVien" items="${nhanViens}" varStatus="loop">
                                    <tr>
                                        <th scope="row">${loop.index + 1}</th>
                                        <td>${nhanVien.maNhanVien}</td>
                                        <td>${nhanVien.hoTen}</td>
                                        <td>${nhanVien.ngaySinh}</td>
                                        <td>${nhanVien.soDienThoai}</td>
                                        <td>
                                            <a class="btn btn-secondary"
                                                href="/admin/nhanvien/detail?id=${nhanVien.maNhanVien}">Detail</a>
                                            <a class="btn btn-warning mx-2"
                                                href="/admin/nhanvien/update?id=${nhanVien.maNhanVien}">Update</a>
                                            <button class="btn btn-danger delete-nhanVien" data-bs-toggle="modal"
                                                data-bs-target="#exampleModal" data-username="${nhanVien.hoTen}"
                                                data-id="${nhanVien.maNhanVien}">Delete</button>
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
                                                <c:url var="prevUrl" value="/staff/show">
                                                    <c:param name="pageNum" value="${currentPage - 1}" />

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
                                            <c:url var="pageUrl" value="/staff">
                                                <c:param name="pageNum" value="${page}" />

                                            </c:url>
                                            <li class="page-item${currentPage == page ? ' active' : ''}">
                                                <a role="button" href="${pageUrl}" class="page-link">${page}</a>
                                            </li>
                                        </c:forEach>

                                        <c:choose>
                                            <c:when test="${currentPage < totalPages}">
                                                <c:url var="nextUrl" value="/staff/show">
                                                    <c:param name="pageNum" value="${currentPage + 1}" />
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
                                        <input type="number" class="form-control page-input"
                                            placeholder="Nhập số trang">
                                        <button class="btn btn-outline-secondary page" type="button">
                                            <i class="bi bi-list-ol"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </nav>
                        <!-- Modal -->
                        <div class="modal modal-xl fade" id="staticBackdrop" data-bs-backdrop="static"
                            data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel"
                            aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form:form action="/staff" method="post" modelAttribute="newStaff">
                                        <div class="modal-header">
                                            <h1 class="modal-title fs-5" id="staticBackdropLabel">Add new user</h1>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                        </div>


                                        <div class="modal-body">
                                            <div class="modal-body">
                                                <div class="form-floating mb-3 col-12">
                                                    <form:input type="text" path="hoTen"
                                                        class="form-control ${not empty newStaff.hoTen ? 'is-invalid' : ''}"
                                                        id="hoTen" placeholder="Họ tên" />
                                                    <label for="hoTen">Họ
                                                        tên</label>
                                                    <div class="invalid-feedback">
                                                        <form:errors path="hoTen" />
                                                    </div>
                                                </div>
                                                <div class="form-floating mb-3 col-12">
                                                    <form:input type="password" path="password"
                                                        class="form-control ${not empty newStaff.password ? 'is-invalid' : ''}"
                                                        id="password" placeholder="Password" /> <label
                                                        for="password">Password</label>
                                                    <div class="invalid-feedback">
                                                        <form:errors path="password" />
                                                    </div>
                                                </div>
                                                <div class="form-floating mb-3 col-12">
                                                    <form:input type="date" path="ngaySinh"
                                                        class="form-control ${not empty newStaff.ngaySinh ? 'is-invalid' : ''}"
                                                        id="ngaySinh" placeholder="Ngày sinh" /> <label
                                                        for="ngaySinh">Ngày sinh</label>
                                                    <div class="invalid-feedback">
                                                        <form:errors path="ngaySinh" />
                                                    </div>
                                                </div>
                                                <div class="form-floating mb-3 col-12">
                                                    <form:input type="text" path="soDienThoai"
                                                        class="form-control ${not empty newStaff.soDienThoai ? 'is-invalid' : ''}"
                                                        id="soDienThoai" placeholder="Số điện thoại" />
                                                    <label for="soDienThoai">Số điện thoại</label>
                                                    <div class="invalid-feedback">
                                                        <form:errors path="soDienThoai" />
                                                    </div>
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


                        <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModal"
                            aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <form id="deleteForm" action="/admin/user/delete" method="post">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Modal delete</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <p>Delete user name: <span id="modal-username"></span></p>
                                            <input type="hidden" name="user_id" id="modal-user-id">
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
                <script>
                    const modalElement = document.getElementById('exampleModal');
                    const modal = new bootstrap.Modal(modalElement);
                    const btn_deleteUser = document.querySelectorAll(".delete-user");
                    btn_deleteUser.forEach(button => {
                        button.addEventListener('click', () => {
                            const username = button.getAttribute('data-username');
                            const userId = button.getAttribute('data-id');

                            document.getElementById('modal-username').textContent = username;
                            document.getElementById('modal-user-id').value = userId;
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
                                url.searchParams.delete('filterBy')
                                window.location.href = url
                            } else {
                                url.searchParams.set('filterBy', (item.getAttribute('data-filter')));
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

                </script>


                <c:if test="${not empty errors}">
                    <script>

                        const modal1 = new bootstrap.Modal(document.getElementById('staticBackdrop'));
                        modal1.show();

                    </script>
                </c:if>
                <jsp:include page="../layout/layoutDown.jsp" />