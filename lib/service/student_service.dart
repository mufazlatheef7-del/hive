import 'package:hive/hive.dart';
import 'package:hive_practice/model/student_model.dart';

class StudentService {
  Box<Student>box=Hive.box<Student>("students");

  // save
  Future <void>save(Student saves)async{
  await box.add(saves);
  }

  // list
  List <Student>list(){
    return box.values.toList();
  }

  // delete
  Future<void>delete(int index)async{
    await box.deleteAt(index);
  }

  // update

  Future<void>update( int index, Student saves)async{
 await box.putAt(index, saves);
  }

  //clear

  Future<void> clear() async {
  await box.clear();
}
}