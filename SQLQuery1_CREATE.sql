USE LibraryDB; 
-- 1. 使用者表（User）
DROP TABLE IF EXISTS Borrow_Record;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
    user_id VARCHAR(100) PRIMARY KEY,          -- 使用者唯一ID
    name NVARCHAR(100) NOT NULL,       -- 使用者姓名 要支援中文
    email VARCHAR(100) NOT NULL,      -- 使用者Email
    password VARCHAR(100) NOT NULL    -- 密碼
);

-- 2. 書籍表（Book）
CREATE TABLE Book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,           -- 書籍唯一ID
    title NVARCHAR(255) NOT NULL,       -- 書籍標題 要支援中文
    author NVARCHAR(100),               -- 作者姓名 要支援中文
    category VARCHAR(50),              -- 書籍分類
    isbn VARCHAR(20) UNIQUE,           -- 國際標準書號
    borrow_status BIT DEFAULT 0    -- 借閱狀態 (0 表示可借，1 表示已借出)
);

-- 3. 借閱紀錄表（Borrow_Record）
CREATE TABLE Borrow_Record (
    borrow_id INT IDENTITY(1,1) PRIMARY KEY,         -- 借閱紀錄唯一ID
    user_id VARCHAR(100),                       -- 使用者ID (外鍵)
    book_id INT,                       -- 書籍ID (外鍵)
    borrow_date DATE NOT NULL,         -- 借閱日期
    due_date DATE NOT NULL,            -- 預計歸還日期
    return_date DATE,                  -- 實際歸還日期
    renew_times INT DEFAULT 0,
    overdue_status BIT DEFAULT 0,  -- 是否逾期 (0 表示未逾期，1 表示逾期)
    FOREIGN KEY (user_id) REFERENCES Users(user_id),  -- 外鍵，連結到 User 表
    FOREIGN KEY (book_id) REFERENCES Book(book_id)   -- 外鍵，連結到 Book 表
);
