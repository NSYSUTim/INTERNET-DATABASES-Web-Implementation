<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyBorrow.aspx.cs" Inherits="LibrarySystem.MyBorrow" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>My Borrowed Books</title>
    <style>
        body {
            background-color: #E6F7FF; /* 淡藍色 */
            font-family: Arial, sans-serif;
            padding: 20px;
            display: flex;
            justify-content: center;
        }

        .content-container {
            width: 100%;
            max-width: 1000px;
            padding: 20px;
            margin: 0 auto;
        }

        /* 設定每本書的面板寬度為頁面寬度的 2/5 到 3/5 */
        .book-panel {
            padding: 20px;
            margin-bottom: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            /*width: 60%;*/ /* 設定面板寬度為 60% */
            max-width: 800px; /* 可設定最大寬度以防止過大 */
            min-width: 600px; /* 可設定最小寬度 */
            margin-left: auto; /* 居中顯示 */
            margin-right: auto;
        }

        .book-info {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
        }

        .action-btn {
            margin-right: 10px;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            display: inline-block;
        }

        .renew-btn {
            background-color: #4CAF50;
            color: white;
        }

        .renew-btn:hover {
            background-color: #45a049;
        }

        .return-btn {
            background-color: #f44336;
            color: white;
        }

        .return-btn:hover {
            background-color: #e53935;
        }

        .message {
            margin-top: 10px;
            color: blue;
        }

        .header {
            font-size: 22px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
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
        <div class="content-container">
            <asp:Label ID="lblBorrowedBooks" runat="server" CssClass="header"></asp:Label>
            <asp:PlaceHolder ID="phBookActions" runat="server"></asp:PlaceHolder>
        </div>
        <asp:Button ID="btnBackToHome" runat="server" Text="回主頁面" OnClick="BtnBackToHome_Click" CssClass="back-to-home-button" type="button" />
        <%--剩回主畫面按鈕的樣子調整--%>
    </form>
</body>
</html>
