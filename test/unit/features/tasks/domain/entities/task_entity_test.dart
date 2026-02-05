import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/features/tasks/domain/entities/task_entity.dart';
import '../../../../../fixtures/task_fixture.dart';
import '../../../../../helpers/uuid_helpers.dart';

void main() {
  group('Task Entity', () {
    late Task testTask;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime(2024, 1, 15, 10, 30);
      testTask = Task(
        id: TestUuids.testTask1,
        title: 'Test Task',
        description: 'Test Description',
        status: TaskStatus.todo,
        priority: Priority.high,
        boardId: TestUuids.defaultBoard,
        order: 0,
        createdAt: testDate,
        updatedAt: testDate,
        userId: TestUuids.testUser1,
      );
    });

    test('should create task with all properties', () {
      expect(testTask.id, TestUuids.testTask1);
      expect(testTask.title, 'Test Task');
      expect(testTask.description, 'Test Description');
      expect(testTask.status, TaskStatus.todo);
      expect(testTask.priority, Priority.high);
      expect(testTask.boardId, TestUuids.defaultBoard);
      expect(testTask.order, 0);
      expect(testTask.createdAt, testDate);
      expect(testTask.updatedAt, testDate);
      expect(testTask.userId, TestUuids.testUser1);
    });

    test('should support value equality with same values', () {
      final task1 = TaskFixtures.createTask(
        id: TestUuids.testTask1,
        title: 'Same Task',
      );
      final task2 = TaskFixtures.createTask(
        id: TestUuids.testTask1,
        title: 'Same Task',
      );

      expect(task1, equals(task2));
    });

    test('should not be equal with different values', () {
      final task1 = TaskFixtures.createTask(id: TestUuids.testTask1);
      final task2 = TaskFixtures.createTask(id: TestUuids.testTask2);

      expect(task1, isNot(equals(task2)));
    });

    test('copyWith should update specific fields', () {
      final updated = testTask.copyWith(
        status: TaskStatus.done,
        priority: Priority.low,
      );

      expect(updated.status, TaskStatus.done);
      expect(updated.priority, Priority.low);
      // Other fields should remain unchanged
      expect(updated.id, testTask.id);
      expect(updated.title, testTask.title);
      expect(updated.description, testTask.description);
    });

    group('TaskStatus', () {
      test('should have correct string values', () {
        expect(TaskStatus.todo.value, 'todo');
        expect(TaskStatus.inProgress.value, 'inProgress');
        expect(TaskStatus.done.value, 'done');
      });

      test('should convert from string', () {
        expect(TaskStatus.fromString('todo'), TaskStatus.todo);
        expect(TaskStatus.fromString('inProgress'), TaskStatus.inProgress);
        expect(TaskStatus.fromString('done'), TaskStatus.done);
      });

      test('should return default (todo) for invalid string', () {
        expect(TaskStatus.fromString('invalid'), TaskStatus.todo);
      });
    });

    group('Priority', () {
      test('should have correct string values', () {
        expect(Priority.low.value, 'low');
        expect(Priority.medium.value, 'medium');
        expect(Priority.high.value, 'high');
      });

      test('should convert from string', () {
        expect(Priority.fromString('low'), Priority.low);
        expect(Priority.fromString('medium'), Priority.medium);
        expect(Priority.fromString('high'), Priority.high);
      });

      test('should return default (medium) for invalid string', () {
        expect(Priority.fromString('invalid'), Priority.medium);
      });
    });

    test('hashCode should be consistent', () {
      final task1 = TaskFixtures.createTask(id: TestUuids.testTask1);
      final task2 = TaskFixtures.createTask(id: TestUuids.testTask1);

      expect(task1.hashCode, equals(task2.hashCode));
    });

    test('toString should include key properties', () {
      final taskString = testTask.toString();

      expect(taskString, contains(testTask.id));
      expect(taskString, contains(testTask.title));
      expect(taskString, contains('todo'));
    });
  });
}
