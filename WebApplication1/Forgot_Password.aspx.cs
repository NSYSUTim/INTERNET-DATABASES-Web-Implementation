using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LibrarySystem
{
    public partial class Forgot_Password : System.Web.UI.Page
    {
        protected void btnSend_ac_ps_Click(object sender, EventArgs e)
        {
            string userId = txtUserID.Text.Trim();

            // 使用資料庫查詢名稱、帳號與密碼
            string userName = "";
            string useremail = "";
            string userPassword = "";

            using (SqlConnection conn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["LibraryDB"].ConnectionString))
            {
                conn.Open();

                // 查詢使用者名稱
                string userQuery = "SELECT name, email, password FROM Users WHERE user_id = @userId";
                SqlCommand userCmd = new SqlCommand(userQuery, conn);
                userCmd.Parameters.AddWithValue("@userId", userId);

                SqlDataReader reader = userCmd.ExecuteReader();

                if (reader.Read())
                {
                    userName = reader["name"].ToString();
                    useremail = reader["email"].ToString();
                    userPassword = reader["password"].ToString();
                }
                else
                {
                    lblMessage.Text = "<span id='message' style='color:red;'>無此使用者。</span>";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), "ClearMessage", "clearMessage();", true);
                    txtUserID.Text = string.Empty;
                    return;
                }

                conn.Close();
            }

            // 建立郵件內容
            string subject = "讀者帳號密碼資訊";
            string body = "<div style='font-size: 18px;'>親愛的 " + userName + " 讀者您好，</div>" +
                          "<div style='font-size: 16px;'>您的帳號資訊如下：<br /><br />" +
                          "<b>帳號：</b>" + userId + "<br />" +
                          "<b>密碼：</b>" + userPassword + "<br /><br />" +
                          "<div style='font-size: 10px;'>如果您有任何疑問，請不要與我們聯繫，謝謝。</div></div>"
                          + "<div style='text-align:right; font-size: 10px;'>小心老人癡呆</div>"; ;
                            

            // 呼叫發送郵件的函式
            SendEmail(useremail, subject, body);
            lblMessage.Text = "<span style='color:green;'>密碼已寄送至您的電子郵件。</span>";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "ClearMessage", "clearMessage();", true);
            txtUserID.Text = string.Empty;

            return;
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
            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                "alert('密碼已寄送至您的電子郵件。'); window.location='Home.aspx';", true);
             //Response.Redirect("Home.aspx");
        }
        protected void BtnBackToHome_Click(object sender, EventArgs e)
        {
            // 導向主頁
            Response.Redirect("Home.aspx");
        }
    }
}