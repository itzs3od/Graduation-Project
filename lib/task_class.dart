class TaskClass{
  late final String taskName;
  late final String taskValue;
  late final String taskType;

  TaskClass({required this.taskName,required this.taskType,required this.taskValue});

  String? setTaskName(taskName){
    this.taskName = taskName;
  }

  String? setTaskValue(taskValue){
    this.taskValue = taskValue;
  }
  String? setTaskType(taskType){
    this.taskType = taskType;
  }
  String? getTaskName(){
    return taskName;
  }
  String? getTaskValue(){
    return taskValue;
  }
  String? getTaskType(){
    return taskType;
  }

}