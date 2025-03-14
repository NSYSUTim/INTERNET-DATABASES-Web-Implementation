using System;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using static System.Net.Mime.MediaTypeNames;

namespace LibrarySystem
{
    public partial class MyBorrow : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadBorrowedBooks();
        }

        private void LoadBorrowedBooks(string focusedBookId = null, string message = null)
        {
            string userId = Session["UserID"]?.ToString();

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                string userNameQuery = "SELECT name FROM Users WHERE user_id = @userId";
                SqlCommand userNameCmd = new SqlCommand(userNameQuery, conn);
                userNameCmd.Parameters.AddWithValue("@userId", userId);

                string userName = userNameCmd.ExecuteScalar()?.ToString() ?? "讀者";

                string query = "SELECT Book.book_id, Book.title, Book.author, Borrow_Record.due_date, Borrow_Record.overdue_status, Borrow_Record.renew_times " +
                               "FROM Borrow_Record " +
                               "JOIN Book ON Borrow_Record.book_id = Book.book_id WHERE Borrow_Record.user_id = @userId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@userId", userId);

                SqlDataReader reader = cmd.ExecuteReader();

                lblBorrowedBooks.Text = "";
                phBookActions.Controls.Clear();

                if (!reader.HasRows)
                {
                    lblBorrowedBooks.Text = $"{userName} 讀者目前無借閱中之書籍。<br /><br />";
                }
                else
                {
                    lblBorrowedBooks.Text = $"{userName} 讀者所借之書籍:<br /><br />";

                    while (reader.Read())
                    {
                        string bookId = reader["book_id"].ToString();
                        string title = reader["title"].ToString();
                        string author = reader["author"].ToString();
                        DateTime dueDate = Convert.ToDateTime(reader["due_date"]);
                        bool isOverdue = Convert.ToBoolean(reader["overdue_status"]);
                        int renewTimes = Convert.ToInt32(reader["renew_times"]);

                        // 如果設置了 focusedBookId，僅顯示該書
                        if (!string.IsNullOrEmpty(focusedBookId) && focusedBookId != bookId)
                        {
                            continue;
                        }

                        // 建立每本書的顯示面板
                        Panel bookPanel = new Panel
                        {
                            CssClass = "book-panel"
                        };

                        // 顯示書籍資訊
                        Label bookLabel = new Label
                        {
                            Text = isOverdue
                                ? $"<span style='color:red;'>{title} by {author} 已逾期<br /></span>"
                                : $"{title} by {author}<br />"
                        };
                        if (message == null)
                            bookLabel.Text += isOverdue
                                   ? $"<span style='color:red;'> - Due Date: {dueDate:yyyy-MM-dd}</span><br /><br />"
                                   : $"- Due Date: {dueDate:yyyy-MM-dd}<br /><br />";

                        bookPanel.Controls.Add(bookLabel);

                        // 顯示訊息或按鈕
                        if (focusedBookId == bookId && message != null)
                        {
                            Label messageLabel = new Label
                            {
                                Text = $"<span style='color:blue;'>{message}</span><br />"
                            };
                            bookPanel.Controls.Add(messageLabel);
                        }
                        else
                        {
                            // 顯示續借按鈕
                            if (renewTimes < 2 && !isOverdue)
                            {
                                Button renewButton = new Button
                                {
                                    Text = "續借",
                                    CssClass = "action-btn renew-btn",
                                    CommandArgument = bookId
                                };
                                renewButton.Click += RenewButton_Click;
                                bookPanel.Controls.Add(renewButton);
                            }
                            else
                            {
                                Label noRenewLabel = new Label
                                {
                                    Text = isOverdue
                                            ? "<span style='color:red;'>不可續借  </span>"
                                            : "<span style='color:gray;'>此書已達最大續借次數</span>"
                                };
                                bookPanel.Controls.Add(noRenewLabel);
                            }

                            // 顯示歸還按鈕
                            Button returnButton = new Button
                            {
                                Text = "歸還",
                                CssClass = "action-btn return-btn",
                                CommandArgument = bookId
                            };
                            returnButton.Click += ReturnButton_Click;
                            bookPanel.Controls.Add(returnButton);
                        }

                        // 把書籍面板加入頁面
                        phBookActions.Controls.Add(bookPanel);
                    }
                }

                conn.Close();
            }

            if (message == "書籍已成功歸還！")
            {
                Label messageLabel = new Label
                {
                    Text = "<br />書籍已成功歸還！"
                };
                phBookActions.Controls.Add(messageLabel);
                return;
            }
        }


        private void RenewButton_Click(object sender, EventArgs e)
        {
            Button button = (Button)sender;
            string bookId = button.CommandArgument;
            string userId = Session["UserID"]?.ToString();

            string message = null;

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                string checkRenewQuery = "SELECT renew_times, due_date FROM Borrow_Record WHERE user_id = @userId AND book_id = @bookId";
                SqlCommand cmd = new SqlCommand(checkRenewQuery, conn);
                cmd.Parameters.AddWithValue("@userId", userId);
                cmd.Parameters.AddWithValue("@bookId", bookId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    int renewTimes = Convert.ToInt32(reader["renew_times"]);
                    DateTime dueDate = Convert.ToDateTime(reader["due_date"]);
                    if (renewTimes < 2)
                    {
                        reader.Close();
                        string renewUpdateQuery = "UPDATE Borrow_Record SET renew_times = renew_times + 1, due_date = DATEADD(DAY, 14, @dueDate) WHERE user_id = @userId AND book_id = @bookId";
                        SqlCommand updateCmd = new SqlCommand(renewUpdateQuery, conn);
                        updateCmd.Parameters.AddWithValue("@dueDate", dueDate);
                        updateCmd.Parameters.AddWithValue("@userId", userId);
                        updateCmd.Parameters.AddWithValue("@bookId", bookId);
                        updateCmd.ExecuteNonQuery();

                        message = $"續借成功！新的歸還日期為：{dueDate.AddDays(14):yyyy-MM-dd}";
                    }
                }
                conn.Close();
            }

            LoadBorrowedBooks(bookId, message);
        }

        private void ReturnButton_Click(object sender, EventArgs e)
        {
            Button button = (Button)sender;
            string bookId = button.CommandArgument;
            string userId = Session["UserID"]?.ToString();

            string message = null;

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                string returnQuery = "DELETE FROM Borrow_Record WHERE user_id = @userId AND book_id = @bookId";
                SqlCommand cmd = new SqlCommand(returnQuery, conn);
                cmd.Parameters.AddWithValue("@userId", userId);
                cmd.Parameters.AddWithValue("@bookId", bookId);
                cmd.ExecuteNonQuery();

                string updateBookStatusQuery = "UPDATE Book SET borrow_status = 0 WHERE book_id = @bookId";
                SqlCommand updateCmd = new SqlCommand(updateBookStatusQuery, conn);
                updateCmd.Parameters.AddWithValue("@bookId", bookId);
                updateCmd.ExecuteNonQuery();

                message = "書籍已成功歸還！";
                conn.Close();
            }

            LoadBorrowedBooks(bookId, message);
        }

        protected void BtnBackToHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("Home.aspx");
        }
    }
}
