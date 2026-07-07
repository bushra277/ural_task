class TaskModel {
  int? id;
  String title;
  String? description;
  String priority;
  String status;
  String? dueDate;
  String createdAt;
  String updatedAt;

  TaskModel({
    this.id , 
    required this.title , 
    this.description , 
    required this.priority , 
    required this.status , 
    this.dueDate ,
    required this.createdAt ,
    required this.updatedAt
    });

  factory TaskModel.fromMap(Map<String, dynamic> json) {
  return TaskModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    priority: json['priority'],
    status: json['status'],
    dueDate: json['due_date'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );
}

Map<String, dynamic> toMap() {
  return {
    'id': id,
    'title': title,
    'description': description,
    'priority': priority,
    'status': status,
    'due_date': dueDate,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
}