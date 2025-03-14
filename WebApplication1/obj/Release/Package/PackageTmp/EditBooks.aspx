<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditBooks.aspx.cs" Inherits="LibrarySystem.EditBooks" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Edit Books</title>
    <script type="text/javascript">
        function confirmDelete(bookId) {
            var confirmation = confirm("確定刪除該書籍嗎?");
            if (confirmation) {
                window.location.href = "EditBooks.aspx?deleteBookId=" + bookId;
            }
        }
    </script>
    <style>
        body {
            background-color: #E6F7FF; /* 更深的藍色背景 */
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .container {    /*白色面板*/
            max-width: 800px;
            margin: 50px auto; /* 垂直和水平置中 */
            background-color: white; /* 白色背景 */
            padding: 20px;
            border-radius: 10px; /* 圓角 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 卡片樣式陰影 */
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
            text-align: center;
            cursor: pointer;
            font-size: 14px;
        }
        .btn:hover {
            background-color: #45a049;
        }

        .btn-delete {
            background-color: #F08080; /* 柔和的紅色 */
            color: white; /* 字體顏色設為白色 */
            padding: 6px 12px;  /* 上下和左右邊距 */
            border: none; /* 無邊框 */
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px; /* 調整文字大小 */
            text-align: center; /* 文字水平置中 */
            display: inline-block; /* 保持按鈕行內塊樣式 */
        }

        .btn-delete:hover {
            background-color: #CD5C5C; /* 懸停時的紅色更暗一些 */
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
            margin: 10px 0;
        }
        .gridview th, .gridview td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
            font-size: 14px;
        }
        .gridview th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Books Management</h2>
            <asp:GridView ID="gvBooks" runat="server" CssClass="gridview" AutoGenerateColumns="False" DataKeyNames="book_id">
                <Columns>
                    <asp:BoundField DataField="book_id" HeaderText="Book ID" ReadOnly="True" />
                    <asp:BoundField DataField="title" HeaderText="Title" />
                    <asp:BoundField DataField="author" HeaderText="Author" />
                    <asp:BoundField DataField="category" HeaderText="Category" />
                    <asp:BoundField DataField="isbn" HeaderText="ISBN" />
                   <asp:TemplateField ItemStyle-Width="70px">      <%--可改欄位寬度 ItemStyle-Width--%>
                        <ItemTemplate>
                            <!-- 刪除按鈕 -->
                            <button type="button" class="btn-delete" onclick="confirmDelete('<%# Eval("book_id") %>')">
                                刪除
                            </button>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

            <h3>Add New Book</h3>
            <asp:Label ID="ErrorMessage" runat="server" ForeColor="Red" /><br />
            <div class="form-group">
                <label for="txtTitle">Title:</label>
                <asp:TextBox ID="txtTitle" runat="server" />
            </div>
            <div class="form-group">
                <label for="txtAuthor">Author:</label>
                <asp:TextBox ID="txtAuthor" runat="server" />
            </div>
            <div class="form-group">
                <label for="txtCategory">Category (int):</label>
                <asp:TextBox ID="txtCategory" runat="server" />
            </div>
            <div class="form-group">
                <label for="txtISBN">ISBN:</label>
                <asp:TextBox ID="txtISBN" runat="server" />
            </div>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="btnAddBook" runat="server" Text="Add Book" CssClass="btn" OnClick="btnAddBook_Click" />

            <!-- 返回管理者頁面的按鈕 -->
            <asp:Button ID="btnBackToHome" runat="server" Text="回管理者頁面" CssClass="back-to-home-button" OnClick="BtnBackToHome_Click"/>
        </div>
    </form>
</body>
</html>
