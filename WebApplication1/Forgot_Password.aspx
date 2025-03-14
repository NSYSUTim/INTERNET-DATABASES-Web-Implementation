<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Forgot_Password.aspx.cs" Inherits="LibrarySystem.Forgot_Password" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Forgot_Password</title>
    <style>
        body {
            background-color: #E6F7FF; /* 淡藍色 */
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
            background-color: #6699CC; /* 修改為較暗的藍色 */
            color: white; /* 白色字體 */
            border: none; /* 無邊框 */
            border-radius: 5px; /* 圓角 */
            padding: 10px 20px; /* 內邊距 */
            font-size: 16px; /* 字體大小 */
            cursor: pointer; /* 滑鼠手勢 */
            margin-top: 10px; /* 與輸入框的間距 */
        }

        input[type="submit"]:hover, input[type="button"]:hover {
            background-color: #4D88B3; /* 懸停時使用更深的藍色 */
        }

        /* 返回按鈕仍固定在右上角 */
        .back-to-home-button {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: none;
            color: black;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .back-to-home-button:hover {
            background-color: #D3D3D3; /* 懸停背景顏色 */
        }
    </style>
    <script>
    function clearMessage() {
        setTimeout(function () {
            var messageElement = document.getElementById("message");
            if (messageElement) {
                messageElement.innerHTML = ""; // 清空訊息內容
            }
        }, 3000); // 延遲 3 秒
    }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:Label ID="Label1" runat="server" Text="請輸入使用者ID" Style="font-size:20px; font-weight:bold; margin-bottom:20px;"></asp:Label><br />
        <asp:Label ID="lblMessage" runat="server" Text="" CssClass="message-label"></asp:Label><br />
        <br />
        <asp:TextBox ID="txtUserID" runat="server" Placeholder="User ID"></asp:TextBox><br />
        <asp:Button ID="btnSend" runat="server" Text="送出" OnClick="btnSend_ac_ps_Click" />
        <!-- 返回管理者頁面的按鈕 -->
        <asp:Button ID="btnBackToHome" runat="server" Text="回主頁面" OnClick="BtnBackToHome_Click" CssClass="back-to-home-button" type="button" />
    </form>
</body>
</html>
