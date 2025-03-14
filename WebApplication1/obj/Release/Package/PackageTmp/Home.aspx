<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="LibrarySystem.Home" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Library System - Home</title>
    <style>
        body {
            background-color: #E6F7FF; /* 淡藍色 */
            margin: 0; /* 移除預設邊距 */
            font-family: Arial, sans-serif; /* 設定字體樣式 */
        }
        /* 保持原有的按鈕樣式 */
        .borrow-btn { 
            color: black;
            border: none; /* 去掉邊框 */
            padding: 10px 20px;
            cursor: pointer;
            font-size: 14px;
        }
        .borrow-btn2 {
            color: black;
            border: none; /* 去掉邊框 */
            padding: 10px 20px;
            cursor: pointer;
            font-size: 14px;
        }

        .borrow-btn:hover {
            background-color: #D3D3D3; /* 滑鼠懸停時變色 */
        }

        /* 搜尋欄置中，並稍微加大 */
        #searchContainer {
            text-align: center; /* 搜尋欄置中 */
            margin-top: 100px; /* 偏上 */
        }
        #txtSearchBook {
            width: 300px; /* 搜尋欄寬度 */
            height: 30px; /* 搜尋欄高度 */
            font-size: 16px; /* 調整文字大小 */
        }
        #btnSearch {
            font-size: 16px; /* 調整按鈕文字大小 */
            padding: 5px 15px; /* 調整按鈕內距 */
        }

        /* 搜尋結果置左，位於搜尋欄正下方 */
        #searchResults {
            width: 390px; /* 統一寬度與搜尋欄對齊 */
            margin: 10px auto 0 auto; /* 與搜尋欄的間距 */
            text-align: left; /* 文字置左 */
        }

        /* 漢堡菜單 */
        #menuToggle {
            display: flex;
            flex-direction: column;
            width: 30px;
            height: 25px;
            justify-content: space-between;
            cursor: pointer;
            position: absolute;
            top: 20px;
            right: 20px;
            z-index: 999; /* 確保漢堡菜單在最上層 */
        }
        #menuToggle div {
            width: 100%;
            height: 5px;
            background-color: black;
        }

        /* 側邊欄 */
        #sidebar {
            position: fixed;
            top: 0;
            right: -300px; /* 初始隱藏 */
            width: 250px; /* 寬度是頁面寬度的1/3 */
            height: 100%;
            background-color: #4682B4 ; /* 深藍色背景 */
            color: white;
            padding-top: 50px;
            transition: right 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: flex-start; /* 將按鈕置左對齊 */
            z-index: 1000; /* 確保側邊欄在最上層 */
        }

        
        /* 側邊欄按鈕樣式 */
        .sidebar-button {
            display: block;
            color: white;
            padding: 15px 25px;
            font-size: 18px;
            margin: 10px 0;
            width: 100%; /* 按鈕寬度佔滿側邊欄 */
            text-align: left; /* 文字靠左對齊 */
            border: none; /* 無邊框 */
            background: none; /* 無背景 */
            cursor: pointer; /* 滑鼠變為點擊手勢 */
        }

        .sidebar-button:hover {
            background-color: #1E3A5F; /* 滑鼠懸停時背景變色 */
        }



        /* 顯示側邊欄 */
        #sidebar.open {
            right: 0;
        }

        /* 讓頁面內容隱藏，避免漢堡菜單出現時仍然可點擊 */
        .content {
            transition: filter 0.3s ease;
        }

        /* 背景模糊效果：只有當側邊欄沒有顯示時才啟用 */
        .blurred {
    filter: blur(5px); /* 模糊效果 */
    pointer-events: none; /* 禁用點擊 */
}

        /*登入狀態字樣*/
        .message-box {
            position: fixed; /* 固定位置 */
            bottom: 15px; /* 距離頁面頂部10px */
            right: 20px; /* 距離頁面左邊10px */
            font-size: 16px; /* 設定字體大小 */
            color: black; /* 字體顏色 */
            background-color: transparent; /* 背景透明 */
            border: none; /* 沒有邊框 */
            text-align: left; /* 文字靠左對齊 */
        }

        /* 最新消息輪播區域樣式 */
        #latestNews {
            position: relative;
            margin: 20px auto; /* 中央置中 */
            width: 80%; /* 寬度 */
            text-align: center; /* 內容置中 */
        }
        .carousel {
            position: relative;
            overflow: hidden; /* 隱藏超出範圍的內容 */
            width: 100%; /* 占滿最新消息區域 */
            height: 300px; /* 固定高度 */
        }
        .carousel a {
            display: none; /* 預設隱藏所有圖片 */
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        .carousel a img {
            width: 100%;
            height: 100%;
            object-fit: cover; /* 圖片適應區域，保持比例 */
            border-radius: 10px; /* 圓角效果 */
            transition: opacity 0.5s ease; /* 淡入淡出過渡 */
        }
        .carousel a.active {
            display: block; /* 只有當前圖片顯示 */
        }

        /* 左右箭頭長方形 */
        .arrow-container {
            position: absolute;
            top: 50%; /* 垂直居中 */
            transform: translateY(-50%); /* 垂直居中 */
            width: 16.66%; /* 1/6的寬度 */
            height: 100%;
            background: rgba(0, 0, 0, 0.5); /* 半透明灰色 */
            z-index: 1;
            cursor: pointer;
            display: none; /* 默認隱藏 */
        }

        /* 左邊的長方形漸層 */
        .left-arrow {
            left: 0;
            background: linear-gradient(to right, rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.025)); /* 漸層效果 */
        }

        /* 右邊的長方形漸層 */
        .right-arrow {
            right: 0;
            background: linear-gradient(to left, rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.025)); /* 反向漸層效果 */
        }

        /* 滑鼠懸停顯示長方形 */
        .carousel:hover .arrow-container {
            display: block;
        }

        /* 箭頭符號樣式 */
        .arrow-symbol {
            font-size: 50px;
            font-weight: bold;
            color: rgba(255, 255, 255, 0.8);
            position: absolute;
            top: 50%; /* 垂直居中 */
            transform: translateY(-50%); /* 調整至完美居中 */
            /* 左右箭頭符號位置 */
            left: 2px; /* 左邊箭頭，距離容器邊緣一定距離 */
            right: 2px; /* 右邊箭頭，距離容器邊緣一定距離 */
            text-align: center;
        }


        /* 當滑鼠懸停在長方形上時，顯示較高透明度的箭頭 */
        .arrow-container:hover .arrow-symbol {
            color: rgba(255, 255, 255, 0.6);
        }

        /* 點擊時切換圖片 */
        .carousel .arrow-area:hover {
            background: linear-gradient(to right, rgba(0, 0, 0, 0.8) 0%, rgba(0, 0, 0, 0) 100%); /* 滑鼠懸停時背景變深 */
        }
        .pagination {
            position: absolute;
            bottom: 10px; /* 底部距離 */
            left: 50%; /* 水平居中 */
            transform: translateX(-50%);
            display: flex;
            gap: 10px; /* 泡泡之間的距離 */
        }
        .dot {
            width: 10px;
            height: 10px;
            background-color: rgba(0, 0, 0, 0.5); /* 半透明黑色 */
            border-radius: 50%; /* 圓形 */
            cursor: pointer; /* 滑鼠為點擊手勢 */
            transition: background-color 0.3s ease; /* 滑鼠懸停變色 */
        }
        .dot.active {
            background-color: rgba(255, 255, 255, 0.8); /* 當前泡泡為亮色 */
        }
        .dot:hover {
            background-color: rgba(255, 255, 255, 0.5); /* 滑鼠懸停時效果 */
        }
        /**/

        /* 保持原有的按鈕樣式 */
        .borrow-btn, .borrow-btn2 {
            color: black;
            border: none; /* 去掉邊框 */
            padding: 10px 20px;
            cursor: pointer;
            font-size: 14px;
        }

        .borrow-btn:hover {
            background-color: #D3D3D3; /* 滑鼠懸停時變色 */
        }

        /* 搜尋欄置中，並稍微加大 */
        #searchContainer {
            text-align: center; /* 搜尋欄置中 */
            margin-top: 20px; /* 偏上 */
        }
        #txtSearchBook {
            width: 300px; /* 搜尋欄寬度 */
            height: 30px; /* 搜尋欄高度 */
            font-size: 16px; /* 調整文字大小 */
        }
        #btnSearch {
            font-size: 16px; /* 調整按鈕文字大小 */
            padding: 5px 15px; /* 調整按鈕內距 */
        }

        /* 搜尋結果置左，位於搜尋欄正下方 */
        #searchResults {
            width: 390px; /* 統一寬度與搜尋欄對齊 */
            margin: 10px auto 0 auto; /* 與搜尋欄的間距 */
            text-align: left; /* 文字置左 */
        }

    </style>

    <script>
        function toggleSidebar() {
            var sidebar = document.getElementById("sidebar");
            var content = document.querySelector(".content");

            // 切換側邊欄顯示狀態
            sidebar.classList.toggle("open");

            // 添加或移除禁用交互的樣式
            if (sidebar.classList.contains("open")) {
                content.classList.add("blurred");
                content.style.pointerEvents = "none"; // 禁用交互
            } else {
                content.classList.remove("blurred");
                content.style.pointerEvents = "auto"; // 恢復交互
            }
        }

        // 點擊頁面其他地方隱藏側邊欄
        window.onclick = function (event) {
            var sidebar = document.getElementById("sidebar");
            var menuToggle = document.getElementById("menuToggle");
            var content = document.querySelector(".content");

            // 如果點擊的不是側邊欄或漢堡菜單，則關閉側邊欄
            if (!sidebar.contains(event.target) && !menuToggle.contains(event.target)) {
                sidebar.classList.remove("open");
                content.classList.remove("blurred");
                content.style.pointerEvents = "auto"; // 恢復交互
            }
        };
        //

        function checkEnter(event) {
            if (event.key === "Enter") {
                event.preventDefault(); // 阻止表單自動提交
                document.getElementById('<%= btnSearch.ClientID %>').click(); // 觸發搜尋按鈕的 click 事件
            }
        }

        // 最新消息輪播功能
        let currentSlide = 0;   //當前顯示圖片索引
        let slides, dots;

        window.onload = function () {
            slides = document.querySelectorAll(".carousel a");
            dots = document.querySelectorAll(".dot");
            showSlide(currentSlide);

            setInterval(() => {
                changeSlide((currentSlide + 1) % slides.length);
            }, 4000); // 每4秒切換一次
        };

        function changeSlide(index) {
            currentSlide = index;
            showSlide(currentSlide);
        }

        function showSlide(index) {
            slides.forEach((slide, i) => {
                slide.classList.toggle("active", i === index);
            });
            dots.forEach((dot, i) => {
                dot.classList.toggle("active", i === index);
            });
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <!-- 漢堡菜單 -->
        <div id="menuToggle" onclick="toggleSidebar()">
            <div></div>
            <div></div>
            <div></div>
        </div>

        <!-- 側邊欄 -->
        <div id="sidebar">
            <asp:Button ID="btnMyBorrow" runat="server" Text="我的借閱" OnClick="btnMyBorrow_Click" CssClass="sidebar-button" />
            <br />
            <asp:Button ID="btnAdmin" runat="server" Text="系統管理者登入" OnClick="btnAdmin_Click" CssClass="sidebar-button" />
            <br />
            <asp:Button ID="btnLogout" runat="server" Text="讀者登出" OnClick="btnLogout_Click" CssClass="sidebar-button" />
        </div>

        <!-- 主要頁面內容區域 -->
        <div class="content">
          <!-- 最新消息輪播區域 -->
            <div id="latestNews">
                <div class="carousel">
                    <!-- 左箭頭區域 -->
                    <div class="arrow-container left-arrow" onclick="changeSlide((currentSlide - 1 + slides.length) % slides.length)">
                        <div class="arrow-symbol">&#60;</div> <!-- 小於符號 -->
                    </div>
                    <!-- 右箭頭區域 -->
                    <div class="arrow-container right-arrow" onclick="changeSlide((currentSlide + 1) % slides.length)">
                        <div class="arrow-symbol">&#62;</div> <!-- 大於符號 -->
                    </div>

                    <!-- Carousel images圖片連結 -->
                    <a href="https://youtu.be/gNRf6Am2Yn8?si=lIw8dtW6NiVSeFhK" target="_blank">
                        <img src="https://th.bing.com/th/id/OIP.cVDZ_5ITNGvWw451_xUx6gHaEJ?rs=1&pid=ImgDetMain" alt="News 1">
                    </a>
                    <a href="https://youtu.be/gNRf6Am2Yn8?si=lIw8dtW6NiVSeFhK" target="_blank">
                        <img src="https://img.zcool.cn/community/012a3863e4c43c000e411000d48ad0.png?x-oss-process=image/auto-orient,1/resize,m_lfit,w_1280,limit_1/sharpen,100" alt="News 2">
                    </a>
                    <a href="https://youtu.be/gNRf6Am2Yn8?si=lIw8dtW6NiVSeFhK" target="_blank">
                        <img src="https://th.bing.com/th/id/OIP.gYiyem4fGVo--tJccrl7gQAAAA?rs=1&pid=ImgDetMain">
                    </a>
                </div>
                <div class="pagination">
                    <span class="dot active" onclick="changeSlide(0)"></span>
                    <span class="dot" onclick="changeSlide(1)"></span>
                    <span class="dot" onclick="changeSlide(2)"></span>
                </div>
            </div>

            <!-- 搜尋欄區域 -->
            <div id="searchContainer">
                <asp:TextBox ID="txtSearchBook" runat="server" Placeholder="Enter book title or author" onkeydown="checkEnter(event)" />
                <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
            </div>

            <!-- 搜尋結果區域，與搜尋欄對齊 -->
            <div id="searchResults">
                <asp:Label ID="lblSearchResult" runat="server"></asp:Label>
                <asp:PlaceHolder ID="searchResultsContainer" runat="server">
                    <!-- 動態生成的按鈕會放置在這裡 -->
                </asp:PlaceHolder>
            </div>
        </div>


    </form>
</body>
</html>
