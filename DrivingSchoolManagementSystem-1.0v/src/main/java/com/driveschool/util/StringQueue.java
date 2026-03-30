package com.driveschool.util;

public class StringQueue {
    private String[] queue;
    private int front;
    private int rear;
    private int size;
    private int capacity;

    public StringQueue(int capacity) {
        this.capacity = capacity;
        this.queue = new String[capacity];
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

    public void enqueue(String item) throws IllegalStateException {
        if (isFull()) {
            throw new IllegalStateException("Queue is full");
        }
        rear = (rear + 1) % capacity;
        queue[rear] = item;
        size++;
    }

    public String dequeue() throws IllegalStateException {
        if (isEmpty()) {
            throw new IllegalStateException("Queue is empty");
        }
        String item = queue[front];
        queue[front] = null;
        front = (front + 1) % capacity;
        size--;
        return item;
    }

    public String peek() throws IllegalStateException {
        if (isEmpty()) {
            throw new IllegalStateException("Queue is empty");
        }
        return queue[front];
    }

    public int size() {
        return size;
    }

    public String[] getAllElements() {
        String[] elements = new String[size];
        int index = 0;
        int current = front;
        for (int i = 0; i < size; i++) {
            elements[index++] = queue[current];
            current = (current + 1) % capacity;
        }
        return elements;
    }
}