import 'package:flutter/material.dart';
import 'package:hive_practice/model/student_model.dart';
import 'package:hive_practice/service/student_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_practice/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  StudentService service = StudentService();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<Student> students = [];
  @override
  void initState() {
    super.initState();
    getStudents();
  }
  // list students
  void getStudents() {
    setState(() {
      students = service.list();
    });
  }
  // Add student
  void addStudent() async {
    Student newStudent = Student(
      name: nameController.text,
      age: ageController.text,
    );
    await service.save(newStudent);
    nameController.clear();
    ageController.clear();
    getStudents();
  }
  // Delete student
  void deleteStudent(int index) async {
    await service.delete(index);
    getStudents();
  }
  // Update student
  void updateStudent(int index) {
    nameController.text = students[index].name;
    ageController.text = students[index].age;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: "Name"),
              ),
              TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: "Age"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Student updatedStudent = Student(
                  name: nameController.text,
                  age: ageController.text,
                );
                await service.update(index, updatedStudent);
                nameController.clear();
                ageController.clear();
                Navigator.pop(context);
                getStudents();
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }
  // Clear all students
  void clearStudents() async {
    await service.clear();
    getStudents();
  }
  // Logout
  void logout() async {
   final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", false);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Management"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(padding: EdgeInsets.all(12),
     child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Enter student name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
       SizedBox(height: 5,),
          TextField(
            controller: ageController,
            decoration: InputDecoration(
              hintText: "Enter student age",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
          ElevatedButton(
            onPressed: addStudent,
            child: Text("Add Student"),
          ),
          ElevatedButton(
            onPressed: clearStudents,
            child: Text("Clear All"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(students[index].name),
                  subtitle: Text(students[index].age),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          updateStudent(index);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteStudent(index);
                        },
                        icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}