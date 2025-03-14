USE LibraryDB;
DELETE FROM Borrow_Record;
DELETE FROM Users;
DELETE FROM Book;
INSERT INTO Users(user_id,name,email,password)
values
    ('B123245021',N'江威廷','0402tim@gmail.com','MF')

INSERT INTO Book(title, author, category, isbn, borrow_status)
values
    (N'競賽程式演算法',N'吳永輝','3','9786263243965',0),
    (N'演算法(0)',N'江威廷帥哥','3','0000',1),
    (N'演算法(1)',N'江威廷','3','000',0),
    (N'演算法(2)',N'江威廷','3','00',0),
    (N'演算法(3)',N'江威廷','3','0',0),
    (N'The Linux programming interface國際中文版(上)',N'Kerrisk, Michael','3','9789864761678',0),
    (N'The Linux programming interface國際中文版(下)',N'Kerrisk, Michael','3','9789864761685',0),
    (N'Digital design',N'Mano, M. Morris,. Ciletti, Michael D.','3','9781292231167',0)

INSERT INTO Borrow_Record(user_id, book_id, borrow_date, due_date, return_date, renew_times, overdue_status)
values
    ('B123245021',2, '2024-11-17','2024-11-18',NULL,0,1)