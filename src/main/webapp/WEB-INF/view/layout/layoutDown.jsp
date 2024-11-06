</div>
<footer></footer>
</body>
<c:if test="${not empty status}">
    <script>
        Toastify({
            text: "${ status }",
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
</body>

</html>