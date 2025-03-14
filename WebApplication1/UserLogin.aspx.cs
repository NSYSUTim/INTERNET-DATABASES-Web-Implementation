using System;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;

namespace LibrarySystem
{
    public partial class UserLogin : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string userId = txtUserID.Text.Trim(); // 取得 User ID
            string password = txtPassword.Text.Trim(); // 取得密碼

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();
                // 查詢用戶 ID 和密碼是否匹配
                string query = "SELECT user_id FROM Users WHERE user_id = @UserID AND password = @Password";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId); // 傳入用戶 ID
                cmd.Parameters.AddWithValue("@Password", password); // 傳入密碼

                var result = cmd.ExecuteScalar(); // 執行查詢，取得單一值
                if (result != null) // 如果查詢結果不為 null，表示驗證成功
                {
                    Session["UserID"] = result.ToString(); // 將用戶 ID 儲存在 Session 中
                    Response.Redirect("MyBorrow.aspx"); // 導向 MyBorrow 頁面
                }
                else
                {
                    lblMessage.Text = "Invalid User ID or password."; // 登入失敗訊息
                }
                conn.Close();
            }
        }
        protected void BtnBackToHome_Click(object sender, EventArgs e)
        {
            // 導向主頁
            Response.Redirect("Home.aspx");
        }
        protected void btnForgotPassword_Click(object sender, EventArgs e)
        {
            Response.Redirect("Forgot_Password.aspx");
        }
    }
}
