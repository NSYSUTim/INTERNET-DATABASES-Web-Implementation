using System;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Data;

namespace LibrarySystem
{
    public partial class EditUsers : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             LoadUsers();

            // Check for query string to handle delete request
            if (Request.QueryString["deleteUserId"] != null)
            {
                string userIdToDelete = Request.QueryString["deleteUserId"];
                DeleteUser(userIdToDelete);
            }
        }

        private void LoadUsers()
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Users", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
                conn.Close();
            }
        }

        private void DeleteUser(string userId)
        {
            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                string query = "DELETE FROM Users WHERE user_id = @userId";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@userId", userId);

                cmd.ExecuteNonQuery();
                conn.Close();
            }
            LoadUsers();
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            string userId = txtUserId.Text.Trim();
            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            // 檢查欄位是否為空
            if (string.IsNullOrEmpty(userId))
            {
                ErrorMessage.Text = "請輸入使用者ID";
            }
            else if (!char.IsLetter(userId[0]) || userId.Length != 10)
            {
                ErrorMessage.Text = "User_id 格式錯誤";  // userId 以字母開頭且長度為10
            }
            else if (string.IsNullOrEmpty(name))
            {
                ErrorMessage.Text = "請輸入姓名";
            }
            else if (string.IsNullOrEmpty(email))
            {
                ErrorMessage.Text = "請輸入Email";
            }
            else if (!IsValidEmail(email))
            {
                ErrorMessage.Text = "email 格式錯誤";  // 檢查 email 格式
            }
            else if (string.IsNullOrEmpty(password))
            {
                ErrorMessage.Text = "請輸入密碼";
            }
            else
            {
                // 若所有欄位均已填寫，則執行資料庫插入操作
                using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
                {
                    conn.Open();
                    string query = "INSERT INTO Users (user_id, name, email, password) VALUES (@userId, @name, @Email, @Password)";
                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@userId", userId);
                    cmd.Parameters.AddWithValue("@name", name);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", password);

                    cmd.ExecuteNonQuery();
                    conn.Close();
                }
                LoadUsers();
                ErrorMessage.Text = "使用者新增成功！";
                txtUserId.Text="";
                txtName.Text="";
                txtEmail.Text="";
                txtPassword.Text="";
            }
        }
        private bool IsValidEmail(string email)
        {
            try
            {
                var addr = new System.Net.Mail.MailAddress(email);
                return addr.Address == email;
            }
            catch
            {
                return false;
            }
        }
        protected void BtnBackToHome_Click(object sender, EventArgs e)
        {
            // 導向主頁
            Response.Redirect("AdminDashboard.aspx"); 
        }

    }
}

