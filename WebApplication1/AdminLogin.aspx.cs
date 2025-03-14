using System;
using System.IO;
using System.Net.Mail;

namespace LibrarySystem
{
    public partial class AdminLogin : System.Web.UI.Page
    {
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (username == "NSYSU_asp.net" && password == "MF")
            {
                Session["AdminLoggedIn"] = true;
                Response.Redirect("AdminDashboard.aspx");
            }
            else
            {
                lblMessage.Text = "Invalid admin credentials.";
            }
        }
        protected void BtnBackToHome_Click(object sender, EventArgs e)
        {
            // 導向主頁
            Response.Redirect("Home.aspx");
        }
        protected void btnForgotPassword_Click(object sender, EventArgs e)
        {
            ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('系統管理者帳密已寄至信箱，請確認。');", true);
            SendEmail();
        }
        private void SendEmail()
        {
            try
            {
                MailMessage mail = new MailMessage
                {
                    From = new MailAddress("0402tim@gmail.com"), // 發件人
                    Subject = "圖書館系統管理者帳號密碼",
                    Body = "<div style='font-size: 30px;'>帳號 : NSYSU_asp.net<br />密碼 : MF</div>" +
                    "<div style='text-align:right; font-size: 10px;'>再忘記試試看</div>",
                    IsBodyHtml = true // 可改為 true，若要支援 HTML 格式的郵件內容
                };
                mail.To.Add("0402tim@gmail.com"); // 收件人

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
