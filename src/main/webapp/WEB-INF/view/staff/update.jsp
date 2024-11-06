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

                            <div class="sidebar-header" onclick="window.location.replace(`{{appURL}}/admin/brand`);">
                                <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor"
                                    class="bi bi-house" viewBox="0 0 16 16">
                                    <path
                                        d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293zM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5z" />
                                </svg>
                                <h3>Email brand</h3>
                            </div>
                            <ul class="list-unstyled components">

                                <c:forEach var="staff" items="${staffList}">
                                    <li class="${staff.id == staffById.id ? 'active' : ''}">
                                        <a href="/staff/update/${staff.id}">${staff.fullName}</a>
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
                            <div style="margin-top: 25vh;">
                                <main class="container">
                                    <div class="d-flex justify-content-center">
                                        <div
                                            class="p-5 col-8 rounded bg-white d-flex justify-content-center align-items-center flex-column">
                                            <form:form action="/staff/update" method="post" modelAttribute="staffById"
                                                class="col-8">
                                                <form:input type="text" path="id" style="display: none;" />
                                                <c:set var="errorName">
                                                    <form:errors path="fullName" cssClass="invalid-feedback" />
                                                </c:set>
                                                <c:set var="errorPhone">
                                                    <form:errors path="phoneNumber" cssClass="invalid-feedback" />
                                                </c:set>

                                                <div class="modal-body">
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="text" path="fullName"
                                                            class="form-control ${not empty errorName ? 'is-invalid' : ''}"
                                                            placeholder="Full Name" />
                                                        <label for="fullName">Full Name</label>
                                                        ${errorName}
                                                    </div>
                                                    <form:input type="hidden" path="password"
                                                        class="form-control ${not empty errorName ? 'is-invalid' : ''}"
                                                        placeholder="Full Name" value="thisIsNotPassss" />
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="date" path="birthDate" class="form-control"
                                                            placeholder="Birth Date" />
                                                        <label for="birthDate">Birth Date</label>
                                                    </div>
                                                    <div class="form-floating mb-3 col-12">
                                                        <form:input type="text" path="phoneNumber"
                                                            class="form-control ${not empty errorPhone ? 'is-invalid' : ''}"
                                                            id="phoneNumber" placeholder="Phone Number" />
                                                        <label for="phoneNumber">Phone Number</label>
                                                        ${errorPhone}
                                                    </div>

                                                    <button type="submit" class="btn btn-warning">Update</button>
                                                </div>
                                            </form:form>



                                        </div>
                                    </div>
                                </main>
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
                {% if status %}
                <script>
                    Toastify({
                        text: "{{ status }}",
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
                {% endif %}
                <script src="/js/previewImgae.js" defer></script>

                </html>