## CREATING DATABASE 
DROP schema foodie;
CREATE database foodie;
USE FOODIE;

# CREATE TABLE
CREATE TABLE Plans(plan_id INTEGER ,
plan_name VARCHAR(255) ,
price float )

SELECT * FROM PLANS;

# INSERT COLUMNS IN THE TABLE
INSERT INTO plans(plan_id,plan_name,price)
VALUES(0,"trail",0);
INSERT INTO plans(plan_id,plan_name,price) 
VALUES(1,"basic monthly", 9.90);
INSERT INTO plans(plan_id,plan_name,price)
VALUES(2,"pro monthly",19.90);
INSERT INTO plans(plan_id,plan_name,price)
VALUES(3,"pro annual",199);
INSERT INTO plans(plan_id,plan_name,price)
VALUES(4,"churn",null);

##############################################################################################################
CREATE TABLE Subscription(customer_id INTEGER,
plan_id INTEGER,
start_date DATE);

INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(1,0,"2020-08-01");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(1,1,"2020-08-08");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(2,0,"2020-09-20");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(2,3,"2020-09-27");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(11,0,"2020-11-19");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(11,4,"2020-11-26");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(13,0,"2020-12-15");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(13,1,"2020-12-22");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(13,2,"2021-03-29");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(15,0,"2020-03-17");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(15,2,"2020-03-24");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(15,4,"2020-04-29");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(16,0,"2020-05-31");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(16,1,"2020-06-07");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(16,3,"2020-10-21");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(18,0,"2020-07-06");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(18,2,"2020-07-13");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(19,0,"2020-06-22");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(19,2,"2020-06-29");
INSERT INTO Subscription(customer_id,plan_id,start_date)
VALUES(19,3,"2020-08-29");

SELECT * FROM subscription;



