<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="LibrarySystem.AdminDashboard" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin Dashboard</title>
    <style>
        body {
            background-color: #E6F7FF;
            margin: 0; /* 移除預設邊距 */
            font-family: Arial, sans-serif; /* 設定字體樣式 */
        }

        /* 置中樣式 */
        .center-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh; /* 占滿整個視窗高度 */
            flex-direction: row; /* 讓內容排列 */
        }

        /* 按鈕樣式 */
        .custom-button {
            background-color: #6699CC; /* 按鈕背景色 */
            color: white; /* 文字顏色 */
            border: none; /* 移除邊框 */
            border-radius: 5px; /* 圓角 */
            padding: 12px 24px; /* 按鈕內距 */
            font-size: 16px; /* 字體大小 */
            margin: 10px 0; /* 每個按鈕的間距 */
            cursor: pointer; /* 鼠標樣式 */
            transition: background-color 0.3s ease; /* 動態效果 */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2); /* 按鈕陰影 */
        }

        .custom-button:hover {
            background-color: #4D88B3; /* 懸停時更深的藍色 */
        }

        /* 返回主頁面的按鈕 */
        .back-to-home-button {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 8px 16px; /* 調整內邊距 */
            background-color: #6699CC; /* 背景色 */
            color: white; /* 按鈕文字顏色 */
            border: none; /* 無邊框 */
            border-radius: 5px; /* 圓角 */
            font-size: 14px; /* 字體大小 */
            cursor: pointer; /* 滑鼠樣式 */
            transition: background-color 0.3s ease; /* 動態效果 */
            box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2); /* 按鈕陰影 */
        }

        .back-to-home-button:hover {
            background-color: #4D88B3; /* 懸停效果 */
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- 返回主頁面的按鈕 -->
        <asp:Button ID="btnBackToHome" runat="server" Text="回主頁面" OnClick="BtnBackToHome_Click" CssClass="back-to-home-button" type="button" />
        
        <!-- 置中容器 -->
        <div class="center-container">
            <asp:Button ID="btnEditUsers" runat="server" Text="Edit Users" OnClick="btnEditUsers_Click" CssClass="custom-button" />
            <%--模擬縮排--%>
            <div style="margin-left: 40px;">    <%--可放文字--%>
            </div>
            <asp:Button ID="btnEditBooks" runat="server" Text="Edit Books" OnClick="btnEditBooks_Click" CssClass="custom-button" />
        </div>
    </form>
</body>
</html>
