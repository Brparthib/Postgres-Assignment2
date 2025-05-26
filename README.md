# Bonus Section (Answers)

1. What is PostgreSQL?
   Answer: Postgresql হলো একটি শক্তিশালী ওপেন সোর্স অবজেক্ট রিলেশনাল ডেটাবেইস সিস্টেম যা নির্ভরযোগ্যতা, দৃঢ়তা এবং কর্মদক্ষতার সাথে ডাটা সংরক্ষণ, পুনরুদ্ধার এবং পরিচালনা করতে সক্ষম।

2. What is the purpose of a database schema in PostgreSQL?

Answer: Database Schema এর উদ্দেশ্য হলো এটি অবজেক্ট গুলোকে সুন্দরভাবে সংক্ষণ করে রাখতে সাহায্য করে। একটি ডেটাবেইস এ অসংখ্য টেবল, ফাংশন, ভিউ থাকতে পারে যা Schema এগুলোকে গুপ করে রাখে। আবার আলাদা আলাদা Schema তে একই নামে টেবল থাকতে পারে। Schema এর জন্য পারমিশন সেট করা যায়।

3. Explain the Primary Key and Foreign Key concepts in PostgreSQL.
   Answer: Primary Key: Primary Key হলো এমন একটি কলাম যা প্রতিটি রেকর্ডকে uniquely বা আলাদা আলাদা চিহ্নিত করে রাখে। একটি রেকর্ড এর জন্য একটি key তা পুনরায় অন্য রেকর্ড এ যুক্ত হবে না বা রিপিট হবে না। এবং কোনো column primary key হলে তার কোনো রো খালি থাকতে পারবে না অর্থাৎ NOT NULL হতে পারবে না। যেমনঃ id,

```
CREATE TABLE student(
    student_id PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE course(
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(50)
);
```

Foreign Key: Foreign Key হলো একটি টেবিলের সাথে অন্য টেবিলের সম্পর্ক স্থাপনের জন্য সেই টেবিলের Primary Key ব্যবহার করলে তা Foreign Key হিসেবে ব্যবহৃত হয়। আবার ডেটা পুনরাবৃত্তি বা redundancy কমানোর জন্য যখন Normalization বা ডেটাকে আলাদা টেবিল এ ভাগ করা হয়, তখন ডেটা না হারানোর জন্য সংযোগ স্থাপনের ক্ষেত্রে primary key কে অন্য টেবিলে foreign key হিসেবে ব্যবহার করা হয়। যেমনঃ উপরের student এবং course টেবিল এর সম্পর্ক স্থাপনের জন্য student_id এবং course_id কে নিচের enrollment টেবিল এ Foreign Key হিসেবে ব্যবহার করা হলো, যাতে বোঝা যায় যে কোন student কোন course এ enroll হয়ছে।

```
CREATE TABLE enrollment(
    enrollment_id SERIAL,
    student_id INT REFERENCES student(student_id),
    course_id INT REFERENCES course(course_id)
);
```

4. What is the difference between the VARCHAR and CHAR data types?
   Answer: VARCHAR এবং CHAR এর মধ্যে পার্থক্য হলো VARCHAR ফিক্সড সাইজ নেয় না। কিন্তু CHAR হলো ফিক্সড সাইজ। অর্থাৎ VARCHAR(10) নিয়ে স্ট্রিং নিলে তা শুধু স্ট্রিং এর সাইজ অনুযায়ী জায়গা নিবে। যেমনঃ 'Hero' এটির length হলো 4 তাই এখানের বাকি জায়াগা তৈরি হবে না, length 10 এর মধ্যে যতটুকু প্রয়োজন ততটুকু নিবে। কিন্তু CHAR(10) এর ক্ষেত্রে 'Hero ' পুরো জায়গা তৈরি করবে আর বাকি জায়গা খালি থেকে যাবে।
   VARCHAR ডাইনামিক এবং ব্যবহার উপযোগী। আর CHAR ছোটো ফিক্সড ডাটার জন্য ব্যবহার করা যায়, যেমনঃ status, country_code, etc.

5. Explain the purpose of the WHERE clause in a SELECT statement.
   Answer: SElECT স্টেইট্মেন্ট এ WHERE clause এর ব্যবহার এটি ডাটাকে ফিল্টার করতে সাহায্য করে। অর্থাৎ যে রেকর্ড গুলো প্রয়োজন তা নির্দিষ্ট শর্ত অনুযায়ী বের করে আনতে কাজ করে। যেমনঃ যদি সে সব ব্যক্তিদের রেকর্ড দেখতে চাওয়া হয় যাদের বয়স ১৮ এর উপরে তাহলে SELECT স্টেইট্মেন্ট এর সাথে WHERE age > 18 লিখতে হয়।

```
CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

INSERT INTO person(name, age)
VALUES
    ('person1', 17),
    ('person2', 20),
    ('person3', 19);

SELECT * FROM person WHERE age > 18;

output:
|     id      |    name     |     age     |
|-------------|-------------|-------------|
| 2           |  person2    |      20     |
| 3           |  person3    |      19     |
```

6. What are the LIMIT and OFFSET clauses used for?
   Answer: LIMIT clause এর ব্যবহার হলো কতোটি রেকর্ড দেখাবে তা নির্ধারণ করে দেওয়া। আর OFFSET হলো কতো এর পর থেকে কতোটি রেকর্ড দেখাবে তা নির্ধারন করে বা কতোটি রেকর্ড skip করবে তা নির্ধারণ করে। যেমনঃ person table এ যদি ১০ জন এর রেকর্ড থাকে LIMIT 5 set করলে প্রথম ৫ জনের রেকর্ড দেখাবে, আর সাথে OFFSET set করলে ৫ এর পর বাকি ৫ জনের রেকর্ড দেখাবে। এটি পেজিনেশন সেট করতে ব্যবহার করা হয়। অর্থাৎ, সব ডাটা fetch না করে শুধু প্রতি পেইজ এর জন্য নির্দিষ্ট ডাটা fetch করতে LIMIT এবং OFFSET ব্যবহৃত হয়।

```
CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INT
);

INSERT INTO person(name, age)
VALUES
    ('person1', 17),
    ('person2', 20),
    ('person3', 23),
    ('person4', 24),
    ('person5', 20),
    ('person6', 19),
    ('person7', 18),
    ('person8', 21),
    ('person9', 22),
    ('person9', 17);

SELECT * FROM person LIMIT 5;

output:
|     id      |    name     |     age     |
|-------------|-------------|-------------|
| 1           |  person1    |      17     |
| 2           |  person2    |      20     |
| 3           |  person3    |      23     |
| 4           |  person4    |      24     |
| 5           |  person5    |      20     |

SELECT * FROM person LIMIT 5 OFFSET 5;

output:
|     id      |    name     |     age     |
|-------------|-------------|-------------|
| 6           |  person6    |      19     |
| 7           |  person7    |      18     |
| 8           |  person8    |      21     |
| 9           |  person9    |      22     |
| 10          |  person10   |      17     |
```
