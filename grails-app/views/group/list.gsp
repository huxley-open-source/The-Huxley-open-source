<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main-head" />
    <script src="${resource(dir:'js', file:'hx-ui-group-0.0.1.js')}"></script>
    <style type="text/css">
        .arrow-top {
            border-color: transparent;
            border-style: dashed dashed solid;
            border-width: 0 8px 8px;
            width: 8px;
        }
        .arrow-top div {
            border-color: transparent;
            border-bottom-color: black;
            border-style: dashed dashed solid;
            border-width: 0 8px 8px;
            position: absolute;
            right: 19px;
        }
        .group-access-key {
            float:right;
            position: relative;
        }
        .access-key-container {
            display: none;
            position: absolute;
            right: 0px;
            top: 18px;

        }
        .access-key-box {
            color: white;
            font-size: 12px;
            background-color: #000000;
            text-align: center;
            width: 160px;
            padding: 10px;

        }
        .access-key-box input {
            margin-bottom: 0px;
            width: 90px;
            text-align: center;
            border: 1px solid #61ABEC;
            background-color: #C1D4E5;
            color: #767676;
        }
        .access-key-box.error span {
            color: #CC2229 !important;
        }
        .access-key-box.error input {
            border: 1px solid #CC2229;
            background-color: white;
        }


    </style>
</head>
<body>
    <div id="box-content" class="box"></div>
</body>
</html>