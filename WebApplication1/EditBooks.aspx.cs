using System;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Data;
using System.Linq;

namespace LibrarySystem
{
    public partial class EditBooks : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            LoadBooks();

            // Check for query string to handle delete request
            if (Request.QueryString["deleteBookId"] != null)
            {
                string bookIdToDelete = Request.QueryString["deleteBookId"];
                DeleteBook(bookIdToDelete);
            }
        }

        private void LoadBooks()
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Book ORDER BY category", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvBooks.DataSource = dt;
                gvBooks.DataBind();
                conn.Close();
            }
        }

        private void DeleteBook(string bookId)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                string query = "DELETE FROM Book WHERE book_id = @bookId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@bookId", bookId);

                cmd.ExecuteNonQuery();
                conn.Close();
            }
            LoadBooks();
        }

        protected void btnAddBook_Click(object sender, EventArgs e)
        {
            //string bookId = txtBookId.Text.Trim();
            string title = txtTitle.Text.Trim();
            string author = txtAuthor.Text.Trim();
            string category = txtCategory.Text.Trim();
            string isbn = txtISBN.Text.Trim();

            // 檢查是否有欄位未填寫
            //if (string.IsNullOrEmpty(bookId))
            //{
            //    ErrorMessage.Text = "請輸入書籍 ID";
            //}
            //else if (!IsPositiveInteger(bookId))  // 檢查 bookId 是否為大於 0 的數字
            //{
            //    ErrorMessage.Text = "bookId 格式錯誤，必須為大於 0 的數字";
            //}
            //else if (BookIdExists(bookId))
            //{
            //    ErrorMessage.Text = "bookId 已存在";
            //}
            if (string.IsNullOrEmpty(title))
            {
                ErrorMessage.Text = "請輸入書籍標題";
            }
            else if (string.IsNullOrEmpty(author))
            {
                ErrorMessage.Text = "請輸入作者名稱";
            }
            else if (string.IsNullOrEmpty(category))
            {
                ErrorMessage.Text = "請輸入書籍分類";
            }
            else if (!IsCategoryValid(category))  // 檢查 category 是否為 0 到 9 的數字
            {
                ErrorMessage.Text = "category 格式錯誤，須為 0 到 9 的單一數字，使用書籍常用之十進分類法";
            }
            else if (string.IsNullOrEmpty(isbn))
            {
                ErrorMessage.Text = "請輸入 ISBN";
            }
            else
            {
                // 如果所有欄位都已填寫，則插入書籍記錄
                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
                {
                    conn.Open();
                    string query = "INSERT INTO Book (title, author, category, isbn) VALUES ( @title, @Author, @Category, @ISBN)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@title", title);
                    cmd.Parameters.AddWithValue("@Author", author);
                    cmd.Parameters.AddWithValue("@Category", category);
                    cmd.Parameters.AddWithValue("@ISBN", isbn);

                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
                LoadBooks();  // 更新顯示的書籍列表
                ErrorMessage.Text = "書籍新增成功！";  // 成功訊息
                
                // 清空輸入框
                txtTitle.Text = "";
                txtAuthor.Text = "";
                txtCategory.Text = "";
                txtISBN.Text = "";
            }
        }
        private bool IsPositiveInteger(string value) // 檢查是否為大於 0 的數字
        {
            int result;
            return int.TryParse(value, out result) && result > 0;  // 檢查是否為正整數
        }
        private bool IsCategoryValid(string value)// 檢查 category 是否是 0 到 9 的單一數字
        {
            return value.Length == 1 && value.All(char.IsDigit) && int.Parse(value) >= 0 && int.Parse(value) <= 9;  // 檢查是否是單一數字並在 0 到 9 之間
        }
        private bool BookIdExists(string bookId)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                string query = "SELECT COUNT(*) FROM Book WHERE book_id = @bookId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@bookId", bookId);

                int count = (int)cmd.ExecuteScalar();
                conn.Close();
                return count > 0;  // 如果 count 大於 0，表示已經存在
            }
        }
        protected void BtnBackToHome_Click(object sender, EventArgs e)
        {
            // 導向主頁
            Response.Redirect("AdminDashboard.aspx");
        }
    }
}
