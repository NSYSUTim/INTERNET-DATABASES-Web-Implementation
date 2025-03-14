using System;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;
using System.Threading;
using System.Web;
using System.Web.UI.WebControls;

namespace LibrarySystem
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                GenerateDynamicButtons();
            }
            string message;
            if (Session["UserID"] != null)
            {
                message = "讀者已登入";
            }
            else
            {
                message = "讀者尚未登入";
            }

            // 包裝輸出的訊息，並設定類別名為"message-box"
            Response.Write("<div class='message-box'>" + message + "</div>");

            ////  逾期發送email測試，需使用則取消註解
            if (!IsPostBack && Request.UrlReferrer == null)
            {                        //只會在第一次開啟時發送
                SendOverdueEmailReminder();
            }
        }

        // 主頁搜尋按鈕
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchKeyword = txtSearchBook.Text.Trim();
            searchResultsContainer.Controls.Clear();

            // 檢查是否輸入搜尋關鍵字
            if (string.IsNullOrEmpty(searchKeyword))
            {
                lblSearchResult.Text = "Please enter book title or author.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();

                string query = @"SELECT 
                                    Book.book_id, 
                                    Book.title, 
                                    Book.author, 
                                    Book.category, 
                                    Book.isbn, 
                                    Book.borrow_status
                                FROM 
                                    Book 
                                WHERE 
                                    Book.title LIKE @keyword OR Book.author LIKE @keyword";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@keyword", "%" + searchKeyword + "%");

                SqlDataReader reader = cmd.ExecuteReader();

                // 動態生成按鈕並顯示結果
                if (reader.HasRows)
                {
                    lblSearchResult.Text = "<br />Search Results:";
                    while (reader.Read())
                    {
                        string bookId = reader["book_id"].ToString();
                        string title = reader["title"].ToString();
                        string author = reader["author"].ToString();
                        string category = reader["category"].ToString();
                        string isbn = reader["isbn"].ToString();
                        bool borrowStatus = Convert.ToBoolean(reader["borrow_status"]);

                        // 動態生成按鈕並加入到 PlaceHolder
                        Button borrowButton = new Button
                        {
                            Text = borrowStatus ? "Borrowed" : "Borrow",
                            CssClass = borrowStatus ? "borrow-btn2" : "borrow-btn",
                            Enabled = !borrowStatus,
                            CommandArgument = bookId
                        };
                        borrowButton.Click += BorrowButton_Click;

                        // 包裝書籍信息
                        Literal bookInfo = new Literal
                        {
                            Text = $"<div><br />Book: {title}<br />Author: {author}<br />Category: {category}<br />ISBN: {isbn}<br /></div>"
                        };

                        // 添加到容器
                        searchResultsContainer.Controls.Add(bookInfo);
                        searchResultsContainer.Controls.Add(borrowButton);
                    }
                }
                else
                {
                    lblSearchResult.Text = "No books found.";
                }

                conn.Close();
            }
        }

        // 借閱按鈕的點擊事件
        private void BorrowButton_Click(object sender, EventArgs e)
        {
            Button clickedButton = (Button)sender;
            int bookId = int.Parse(clickedButton.CommandArgument);

            string userId = Session["UserID"]?.ToString();
            if (string.IsNullOrEmpty(userId))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please log in first.'); window.location='UserLogin.aspx';", true);
                return;
                lblSearchResult.Text = "Please log in first.";  //Thread.Sleep(3000); // 暫停 3 秒
                Response.Redirect("UserLogin.aspx");
                return;
            }

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();

                string borrowQuery = "UPDATE Book SET borrow_status = 1 WHERE book_id = @bookId";
                SqlCommand borrowCmd = new SqlCommand(borrowQuery, conn);
                borrowCmd.Parameters.AddWithValue("@bookId", bookId);
                borrowCmd.ExecuteNonQuery();

                string insertBorrowRecordQuery = @"INSERT INTO Borrow_Record 
                                                    (user_id, book_id, borrow_date, due_date) 
                                                   VALUES 
                                                    (@userId, @bookId, GETDATE(), DATEADD(DAY, 28, GETDATE()))";
                SqlCommand insertCmd = new SqlCommand(insertBorrowRecordQuery, conn);
                insertCmd.Parameters.AddWithValue("@userId", userId);
                insertCmd.Parameters.AddWithValue("@bookId", bookId);
                insertCmd.ExecuteNonQuery();

                //lblSearchResult.Text = "You have successfully borrowed the book.";
                // 使用 JavaScript 彈窗通知用戶
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('You have successfully borrowed the book.');", true);    //window.location='Home.aspx';

                conn.Close();
            }

            // 重新生成動態按鈕，更新狀態
            GenerateDynamicButtons();
        }

        // 動態生成按鈕的方法
        private void GenerateDynamicButtons()
        {
            // 如果有查詢結果時才生成按鈕
            if (!string.IsNullOrEmpty(lblSearchResult.Text) && lblSearchResult.Text != "No books found.")
            {
                btnSearch_Click(null, null);
            }
        }

        // 主頁 我的借閱 按鈕
        protected void btnMyBorrow_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null) // 檢查是否存在登入的 UserID
            {
                Response.Redirect("UserLogin.aspx"); // 未登入則導向登入頁面
            }
            else
            {
                Response.Redirect("MyBorrow.aspx");
            }
        }
        //管理者登入按鈕
        protected void btnAdmin_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");
        }
        //登出按鈕
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            if(Session["UserID"] == null)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                                "alert('No user has logged in yet.');", true);
            }
            else{
                // 清空Session中的UserID，實現登出
                Session["UserID"] = null;
                // 重新導向至登入頁面
                Response.Redirect("Home.aspx");
            }
           
        }
        private void SendOverdueEmailReminder()
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                string query = "SELECT Users.email, Book.title, Borrow_Record.due_date FROM Borrow_Record " +
                               "JOIN Users ON Borrow_Record.user_id = Users.user_id " +
                               "JOIN Book ON Borrow_Record.book_id = Book.book_id " +
                               "WHERE Borrow_Record.overdue_status = 1 AND Borrow_Record.return_date IS NULL";
                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    string email = reader["email"].ToString();
                    string bookTitle = reader["title"].ToString();
                    string dueDate = Convert.ToDateTime(reader["due_date"]).ToString("yyyy-MM-dd");

                    string subject = "借閱書籍逾期催還";
                    string body = $"您借閱的書籍 \"{bookTitle}\" 已於 \"{dueDate}\" 到期，請盡速歸還。<br /><br />" +
                                  "提醒 : 逾期未還罰金一天為5元/本，無累計上限。<br /><br />" +
                                  "<div style='text-align:right; font-size: 10px;'>有夠貴媽的</div>";
                    SendEmail(email, subject, body);
                }
                conn.Close();
            }
        }

        private void SendEmail(string to, string subject, string body)
        {
            try
            {
                MailMessage mail = new MailMessage
                {
                    From = new MailAddress("0402tim@gmail.com"), // 發件人
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = true // 可改為 true，若要支援 HTML 格式的郵件內容
                };
                mail.To.Add(to); // 收件人

                // 配置 SMTP
                SmtpClient client = new SmtpClient("smtp.gmail.com", 587) // Gmail SMTP 主機與埠號
                {
                    Credentials = new System.Net.NetworkCredential("0402tim@gmail.com", "grpw chdg dfxl pxjr"), // 使用你的 Gmail 地址與應用程式密碼
                    EnableSsl = true // 啟用 SSL 加密
                };

                client.Send(mail); // 發送郵件
            }
            catch (SmtpException smtpEx)
            {
                throw new InvalidOperationException($"SMTP error: {smtpEx.Message}", smtpEx);
            }
            catch (IOException ioEx)
            {
                throw new InvalidOperationException($"IO error: {ioEx.Message}", ioEx);
            }
            catch (Exception ex)
            {
                throw new InvalidOperationException($"General error: {ex.Message}", ex);
            }
        }


    }
}