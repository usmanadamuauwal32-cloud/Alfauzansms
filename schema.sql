-- Al-Fauzan SMS PostgreSQL schema
-- Backend also auto-creates these tables on startup.

CREATE TABLE IF NOT EXISTS users(id SERIAL PRIMARY KEY,name TEXT NOT NULL,username TEXT UNIQUE NOT NULL,email TEXT,password_hash TEXT NOT NULL,role TEXT NOT NULL CHECK(role IN('admin','teacher','student')),status TEXT NOT NULL DEFAULT 'pending',created_at TIMESTAMP DEFAULT now());
CREATE TABLE IF NOT EXISTS classes(id SERIAL PRIMARY KEY,name TEXT UNIQUE NOT NULL);
CREATE TABLE IF NOT EXISTS subjects(id SERIAL PRIMARY KEY,name TEXT UNIQUE NOT NULL);
CREATE TABLE IF NOT EXISTS students(id SERIAL PRIMARY KEY,name TEXT NOT NULL,class_id INT REFERENCES classes(id) ON DELETE SET NULL,user_id INT UNIQUE REFERENCES users(id) ON DELETE SET NULL,admission_no TEXT UNIQUE,created_at TIMESTAMP DEFAULT now());
CREATE TABLE IF NOT EXISTS teacher_assignments(id SERIAL PRIMARY KEY,teacher_id INT REFERENCES users(id) ON DELETE CASCADE,class_id INT REFERENCES classes(id) ON DELETE CASCADE,subject_id INT REFERENCES subjects(id) ON DELETE CASCADE,UNIQUE(teacher_id,class_id,subject_id));
CREATE TABLE IF NOT EXISTS marks(id SERIAL PRIMARY KEY,student_id INT REFERENCES students(id) ON DELETE CASCADE,subject_id INT REFERENCES subjects(id) ON DELETE CASCADE,test1 NUMERIC DEFAULT 0,test2 NUMERIC DEFAULT 0,exam NUMERIC DEFAULT 0,total NUMERIC DEFAULT 0,manual_total NUMERIC,manual_grade TEXT,updated_by INT REFERENCES users(id),updated_at TIMESTAMP DEFAULT now(),UNIQUE(student_id,subject_id));
CREATE TABLE IF NOT EXISTS attendance(id SERIAL PRIMARY KEY,student_id INT REFERENCES students(id) ON DELETE CASCADE,date DATE NOT NULL DEFAULT current_date,status TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS settings(id INT PRIMARY KEY,school_name TEXT,school_address TEXT,session TEXT,term TEXT,report_date DATE,developer_name TEXT,developer_year TEXT,system_open BOOLEAN DEFAULT TRUE,report_hold BOOLEAN DEFAULT FALSE,payment_link TEXT DEFAULT '',maintenance_message TEXT DEFAULT 'The school portal is temporarily closed by the Administrator.');
ALTER TABLE settings ADD COLUMN IF NOT EXISTS system_open BOOLEAN DEFAULT TRUE;
ALTER TABLE settings ADD COLUMN IF NOT EXISTS report_hold BOOLEAN DEFAULT FALSE;
ALTER TABLE settings ADD COLUMN IF NOT EXISTS payment_link TEXT DEFAULT '';
ALTER TABLE settings ADD COLUMN IF NOT EXISTS maintenance_message TEXT DEFAULT 'The school portal is temporarily closed by the Administrator.';
CREATE TABLE IF NOT EXISTS fees(id SERIAL PRIMARY KEY,student_id INT REFERENCES students(id) ON DELETE CASCADE,description TEXT NOT NULL,amount NUMERIC DEFAULT 0,paid_amount NUMERIC DEFAULT 0,due_date DATE,status TEXT DEFAULT 'Unpaid',created_at TIMESTAMP DEFAULT now());
CREATE TABLE IF NOT EXISTS notices(id SERIAL PRIMARY KEY,title TEXT NOT NULL,message TEXT NOT NULL,audience TEXT DEFAULT 'all',created_at TIMESTAMP DEFAULT now());
CREATE TABLE IF NOT EXISTS inventory(id SERIAL PRIMARY KEY,item_name TEXT UNIQUE NOT NULL,quantity NUMERIC DEFAULT 0,unit TEXT DEFAULT 'pcs',reorder_level NUMERIC DEFAULT 5,updated_at TIMESTAMP DEFAULT now());
CREATE TABLE IF NOT EXISTS report_meta(id SERIAL PRIMARY KEY,student_id INT UNIQUE REFERENCES students(id) ON DELETE CASCADE,position TEXT,out_of TEXT,attendance_override TEXT,teacher_remarks TEXT DEFAULT '',headmaster_remarks TEXT DEFAULT '',report_date DATE,updated_at TIMESTAMP DEFAULT now());

