package com.driveschool.util;

import com.driveschool.model.Lesson;

public class LessonQueue {
    private Lesson[] queue;
    private int front;
    private int rear;
    private int size;
    private int capacity;

    public LessonQueue(int capacity) {
        this.capacity = capacity;
        this.queue = new Lesson[capacity];
        this.front = 0;
        this.rear = -1;
        this.size = 0;
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public boolean isFull() {
        return size == capacity;
    }

    public void enqueue(Lesson item) throws IllegalStateException {
        if (isFull()) {
            throw new IllegalStateException("Queue is full");
        }
        rear = (rear + 1) % capacity;
        queue[rear] = item;
        size++;
    }

    public Lesson dequeue() throws IllegalStateException {
        if (isEmpty()) {
            throw new IllegalStateException("Queue is empty");
        }
        Lesson item = queue[front];
        queue[front] = null;
        front = (front + 1) % capacity;
        size--;
        return item;
    }

    public Lesson peek() throws IllegalStateException {
        if (isEmpty()) {
            throw new IllegalStateException("Queue is empty");
        }
        return queue[front];
    }

    public int size() {
        return size;
    }

    public Lesson[] getAllElements() {
        Lesson[] elements = new Lesson[size];
        int index = 0;
        int current = front;
        for (int i = 0; i < size; i++) {
            elements[index++] = queue[current];
            current = (current + 1) % capacity;
        }
        return elements;
    }
}