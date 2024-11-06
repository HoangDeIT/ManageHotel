<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>
                Document
            </title>
            <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
                integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
                crossorigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
                integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy"
                crossorigin="anonymous"></script>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
                integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
                crossorigin="anonymous">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
            <link href="/css/sitebar.css" rel="stylesheet" />
            <script src="/js/sitebar.js" defer></script>
            <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
            <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
        </head>

        <body>
            <div class="wrapper">
                <aside id="sidebar">
                    <div class="d-flex">
                        <button class="toggle-btn" type="button">
                            <i class="bi bi-grid-fill"></i>
                        </button>
                        <div class="sidebar-logo">
                            <a href="#">
                                Admin
                            </a>
                        </div>
                    </div>
                    <ul class="sidebar-nav">
                        <li class="sidebar-item">
                            <a href="{{ appUrl }}\admin\dashboard" class="sidebar-link">
                                <i class="bi bi-speedometer"></i>
                                <span>
                                    Dashboard
                                </span>
                            </a>
                        </li>
                        <li class="sidebar-item">
                            <a href="{{ appUrl }}\admin\user" class="sidebar-link">
                                <i class="bi bi-person"></i>
                                <span>
                                    Manage User
                                </span>
                            </a>
                        </li>
                        <li class="sidebar-item">
                            <a href="{{ appUrl }}\admin\product" class="sidebar-link">
                                <i class="bi bi-box-seam-fill"></i>
                                <span>
                                    Manage product
                                </span>
                            </a>
                        </li>
                        <li class="sidebar-item">
                            <a href="{{ appUrl }}\admin\order" class="sidebar-link">
                                <i class="bi bi-bag-check-fill position-relative">
                                    <span style="font-size: 10px;"
                                        class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                        {{pendingOrders}}
                                        <span class="visually-hidden">
                                            unread messages
                                        </span>
                                    </span>
                                </i>
                                <span>
                                    Manage Orders
                                </span>
                            </a>
                        </li>
                        <li class="sidebar-item">
                            <a href="{{ appUrl }}\admin\brand" class="sidebar-link">
                                <i class="bi bi-watch"></i>
                                <span>
                                    Manage Brand
                                </span>
                            </a>
                        </li>
                </aside>
                <div class="main">
                    <div class="d-flex justify-content-end w-100 shadow-lg p-3 dropdown">
                        <p>
                            Hello admin
                        </p>
                        <img id="dropdownMenuButton1" data-bs-toggle="dropdown" src="/uploads/avatars/avatar.png"
                            alt="Avatar" class="avatar">
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                            <li>
                                <a class="dropdown-item" href="#">
                                    Logout
                                </a>
                            </li>
                        </ul>
                    </div>