using System;

namespace LibrarySystem
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminLoggedIn"] == null || !(bool)Session["AdminLoggedIn"])
            {
                Response.Redirect("AdminLogin.aspx");
            }
        }

        protected void btnEditUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditUsers.aspx");
        }

        protected void btnEditBooks_Click(object sender, EventArgs e)
        {
            Response.Redirect("EditBooks.aspx");
        }
        protected void BtnBackToHome_Click(object sender, EventArgs e)
        {
            // 導向主頁
            Response.Redirect("Home.aspx");
        }
    }
}
