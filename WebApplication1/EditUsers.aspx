<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditUsers.aspx.cs" Inherits="LibrarySystem.EditUsers" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Edit Users</title>
    <script type="text/javascript">
        function confirmDelete(userId) {
            var confirmation = confirm("確定刪除該使用者嗎?");
            if (confirmation) {
                window.location.href = "EditUsers.aspx?deleteUserId=" + userId;
            }
        }
    </script>
    <style>
        body {
            background-color: #E6F7FF; /* 淡藍色背景 */
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .container {
            max-width: 800px;
            margin: 50px auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        h2, h3 {
            text-align: center;
            color: #333;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-top: 10px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-align: center;
        }
        .btn:hover {
            background-color: #45a049;
        }
        .btn-delete {
            background-color: #D9534F; /* 柔和的紅色 */
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .btn-delete:hover {
            background-color: #C9302C;
        }
        .back-to-home-button {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 8px 16px;
            background-color: #6699CC;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .back-to-home-button:hover {
            background-color: #4D88B3;
        }
        .form-group {
            margin: 15px 30px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input {
            width: 97%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .gridview {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        .gridview th, .gridview td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        .gridview th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        .gridview .actions {
            width: 150px; /* 調整動作欄的寬度 */
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Users Management</h2>
            <asp:GridView ID="gvUsers" runat="server" CssClass="gridview" AutoGenerateColumns="False" DataKeyNames="user_id">
                <Columns>
                    <asp:BoundField DataField="user_id" HeaderText="User ID (學號)" ReadOnly="True" />
                    <asp:BoundField DataField="name" HeaderText="Name" />
                    <asp:BoundField DataField="email" HeaderText="Email" />
                    <asp:BoundField DataField="password" HeaderText="Password" />
                    <asp:TemplateField> <%-- HeaderText="Actions" ItemStyle-Width="150px"--%>
                        <ItemTemplate>
                            <button type="button" class="btn-delete" onclick="confirmDelete('<%# Eval("user_id") %>')">
                                刪除
                            </button>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <h3>Add New User</h3>
            <asp:Label ID="ErrorMessage" runat="server" ForeColor="Red" /><br />
            <div class="form-group">
                <label for="txtUserId">User ID(學號):</label>
                <asp:TextBox ID="txtUserId" runat="server" />
            </div>
            <div class="form-group">
                <label for="txtName">Name:</label>
                <asp:TextBox ID="txtName" runat="server" />
            </div>
            <div class="form-group">
                <label for="txtEmail">Email:</label>
                <asp:TextBox ID="txtEmail" runat="server" />
            </div>
            <div class="form-group">
                <label for="txtPassword">Password:</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" />
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnAddUser" runat="server" Text="Add User" CssClass="btn" OnClick="btnAddUser_Click" />

            <!-- 返回管理者頁面的按鈕 -->
            <asp:Button ID="btnBackToHome" runat="server" Text="回管理者頁面" CssClass="back-to-home-button" OnClick="BtnBackToHome_Click"/>
        </div>
    </form>
</body>
</html>
