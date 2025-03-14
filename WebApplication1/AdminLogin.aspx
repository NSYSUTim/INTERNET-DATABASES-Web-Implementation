<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="LibrarySystem.AdminLogin" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Login</title>
    <style>
        body {
            background-color: #E6F7FF; /* 淡藍色背景 */
            margin: 0; /* 移除預設邊距 */
            font-family: Arial, sans-serif; /* 設定字體樣式 */
            display: flex; /* 使用 Flexbox */
            justify-content: center; /* 水平置中 */
            align-items: center; /* 垂直置中 */
            height: 100vh; /* 全螢幕高度 */
        }

        form {
            text-align: center; /* 文字置中 */
            background-color: white; /* 背景白色 */
            padding: 20px; /* 內邊距 */
            border-radius: 10px; /* 圓角 */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* 淺陰影 */
        }

        input[type="text"], input[type="password"] {
            width: 250px; /* 輸入框寬度 */
            padding: 10px; /* 內邊距 */
            margin: 10px 0; /* 上下外邊距 */
            font-size: 16px; /* 字體大小 */
            border: 1px solid #ccc; /* 灰色邊框 */
            border-radius: 5px; /* 圓角 */
        }

        input[type="submit"], input[type="button"], button {
            background-color: #6699CC; /* 更深更飽滿的藍色 */
            color: white; /* 白色字體 */
            border: none; /* 無邊框 */
            border-radius: 5px; /* 圓角 */
            padding: 10px 20px; /* 內邊距 */
            font-size: 16px; /* 字體大小 */
            cursor: pointer; /* 滑鼠手勢 */
            margin-top: 10px; /* 與輸入框的間距 */
            transition: background-color 0.3s ease; /* 增加過渡效果 */
            height: 45px; /* 設置固定高度，確保兩個按鈕高度一致 */
        }

        input[type="submit"]:hover, input[type="button"]:hover {
            background-color: #4D88B3; /* 懸停時的顏色 */
        }

        /* 返回按鈕仍固定在右上角 */
        .back-to-home-button {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #6699CC; /* 深藍色 */
            color: white; /* 白色字體 */
            border: none;
            border-radius: 5px;
            padding: 10px 20px;
            cursor: pointer;
            font-size: 14px;
        }

        .back-to-home-button:hover {
            background-color: #4D88B3; /* 懸停顏色更深 */
        }

        /* 新增按鈕區域 */
        .button-group {
            margin-top: 15px; /* 增加按鈕間隔 */
            display: flex; /* 使用 Flexbox 排列按鈕 */
            justify-content: center; /* 水平置中 */
            align-items: center; /* 垂直對齊 */
        }

        .btn-container {
            margin-right: 10px; /* 讓按鈕之間有間隔 */
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Label ID="lblMessage" runat="server" Text="" CssClass="message-label"></asp:Label><br />
        <asp:Label ID="Label1" runat="server" Text="系統管理者登入" Style="font-size:20px; font-weight:bold; margin-bottom:20px;"></asp:Label><br />
        <asp:TextBox ID="txtUsername" runat="server" Placeholder="Username"></asp:TextBox><br />
        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox><br />
        
        <!-- 按鈕區域 -->
        <div class="button-group">
            <div class="btn-container">
                <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" />
            </div>
            <div class="btn-container">
                <asp:Button ID="btnForgotPassword" runat="server" Text="忘記密碼" OnClick="btnForgotPassword_Click" />
            </div>
        </div>

        <!-- 返回主頁面的按鈕 -->
        <asp:Button ID="btnBackToHome" runat="server" Text="回主頁面" OnClick="BtnBackToHome_Click" CssClass="back-to-home-button" type="button" />
    </form>
</body>
</html>
