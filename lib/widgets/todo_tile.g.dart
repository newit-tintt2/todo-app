// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_tile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class todolistAdapter extends TypeAdapter<todolist> {
  @override
  final int typeId = 0;

  @override
  todolist read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return todolist(
      title: fields[1] as String,
      dateStart: fields[2] as DateTime,
      dateEnd: fields[3] as DateTime,
      isDone: fields[4] as bool,
    )..index = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, todolist obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateStart)
      ..writeByte(3)
      ..write(obj.dateEnd)
      ..writeByte(4)
      ..write(obj.isDone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is todolistAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
