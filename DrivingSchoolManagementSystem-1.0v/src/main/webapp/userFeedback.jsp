<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.driveschool.model.Student" %>
<%@ page import="com.driveschool.util.FileUtil" %>
<%@ page import="java.util.List" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    FileUtil fileUtil = new FileUtil(application);
    List<Student> students = fileUtil.readStudents();
    Student student = null;
    for (Student s : students) {
        if (s.getUsername().equals(username)) {
            student = s;
            break;
        }
    }
    if (student == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<String[]> allFeedback = fileUtil.readFeedback();
    List<String[]> userFeedback = new java.util.ArrayList<>();
    for (String[] feedback : allFeedback) {
        if (feedback[0].equals(username)) {
            userFeedback.add(feedback);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Feedback - DriveWise Academy</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        .glass {
            background-color: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .stars {
            color: #facc15;
            font-size: 1.2rem;
        }
        .star-rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
        }
        .star-rating input[type="radio"] {
            display: none;
        }
        .star-rating label {
            cursor: pointer;
            font-size: 1.5rem;
            padding: 0 0.2rem;
            color: #3b82f6; /* Blue labels */
            transition: all 0.3s ease;
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label,
        .star-rating input[type="radio"]:checked ~ label {
            color: #ffffff; /* White on hover */
            transform: scale(1.2); /* Animation: scale up */
        }
    </style>
</head>
<body class="bg-black text-white font-sans min-h-screen flex flex-col"> <!-- Changed background to black -->

<!-- Navbar -->
<nav class="bg-gradient-to-r from-blue-800 to-yellow-500 shadow-md glass">
    <div class="max-w-7xl mx-auto px-4 flex justify-between h-16 items-center">
        <div class="text-white text-2xl font-bold tracking-wide flex items-center space-x-2">
            <span>DriveWise Academy</span>
        </div>
        <div class="hidden md:flex space-x-6 text-white font-medium">
            <a href="aboutyou.jsp" class="hover:text-yellow-300 transition">👤 About You</a>
            <a href="Feedback.jsp" class="hover:text-yellow-300 transition">📝 Submit Feedback</a>
            <a href="userFeedback.jsp" class="text-yellow-300 font-semibold">📋 My Feedback</a>
            <a href="login.jsp" class="hover:text-yellow-300 transition">🚪 Logout</a>
        </div>
    </div>
</nav>

<!-- Main Content -->
<main class="flex-grow py-10 px-4 sm:px-6 lg:px-8">
    <div class="max-w-6xl mx-auto p-6 rounded-xl shadow-2xl glass">
        <h2 class="text-3xl font-bold mb-6 border-b border-yellow-400 pb-2 text-yellow-300">My Feedback History</h2>

        <!-- Success/Error Messages -->
        <% if(request.getParameter("success") != null) { %>
        <div id="successMessage" class="bg-green-600 text-white p-4 rounded mb-4 flex items-center justify-between">
            <span><%= request.getParameter("success") %></span>
            <button onclick="closeMessage('successMessage')" class="text-white hover:text-gray-200">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <% } %>
        <% if(request.getParameter("error") != null) { %>
        <div id="errorMessage" class="bg-red-600 text-white p-4 rounded mb-4 flex items-center justify-between">
            <span>Error: <%= request.getParameter("error") %></span>
            <button onclick="closeMessage('errorMessage')" class="text-white hover:text-gray-200">
                <i class="fas fa-times"></i>
            </button>
        </div>
        <% } %>

        <div class="overflow-x-auto">
            <table class="min-w-full bg-transparent text-white border border-blue-300 rounded-lg">
                <thead class="bg-blue-800 bg-opacity-90">
                <tr>
                    <th class="py-3 px-6 text-left">Type</th>
                    <th class="py-3 px-6 text-left">Rating</th>
                    <th class="py-3 px-6 text-left">Date</th>
                    <th class="py-3 px-6 text-left">Message</th>
                    <th class="py-3 px-6 text-center">Actions</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-blue-500 bg-white/5">
                <%
                    for (String[] feedback : userFeedback) {
                        String stars = "★".repeat(Integer.parseInt(feedback[4])) + "☆".repeat(5 - Integer.parseInt(feedback[4]));
                %>
                <tr class="hover:bg-blue-900/30 transition duration-200">
                    <td class="py-3 px-6"><%= feedback[3] %></td>
                    <td class="py-3 px-6"><span class="stars"><%= stars %></span></td>
                    <td class="py-3 px-6"><%= feedback[5] %></td>
                    <td class="py-3 px-6"><%= feedback[6] %></td>
                    <td class="py-3 px-6 text-center">
                        <button onclick="editFeedback('<%= feedback[0] %>', '<%= feedback[3] %>', '<%= feedback[4] %>', '<%= feedback[6].replace("'", "\\'") %>')"
                                class="bg-yellow-500 hover:bg-yellow-600 text-white px-3 py-1 rounded-full text-sm transition-colors duration-200 mr-2">
                            <i class="fas fa-edit mr-1"></i>Edit
                        </button>
                        <button onclick="confirmDelete('<%= feedback[0] %>')"
                                class="bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded-full text-sm transition-colors duration-200">
                            <i class="fas fa-trash-alt mr-1"></i>Delete
                        </button>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-gradient-to-r from-blue-800 to-yellow-500 text-white text-center py-6 mt-10 glass">
    <p class="text-lg font-semibold tracking-wider">🚗 DriveWise Academy — Speed Meets Safety</p>
    <p class="text-sm text-yellow-100">© 2025 All rights reserved. Built with care and innovation.</p>
</footer>

<!-- Edit Feedback Modal -->
<div id="editModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center">
    <div class="bg-gray-800 p-6 rounded-lg shadow-xl max-w-md w-full mx-4">
        <h3 class="text-xl font-bold text-yellow-400 mb-4">Edit Feedback</h3>
        <form id="editForm" action="EditFeedbackServlet" method="POST">
            <input type="hidden" id="editUsername" name="username">
            <div class="mb-4">
                <label class="block text-white mb-2">Type</label>
                <select id="editType" name="type" class="w-full px-3 py-2 bg-gray-700 text-white rounded">
                    <option value="General">General</option>
                    <option value="Instructor">Instructor</option>
                    <option value="Lesson">Lesson</option>
                    <option value="Website">Website</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="mb-4">
                <label class="block text-white mb-2">Rating</label>
                <div class="star-rating flex gap-1">
                    <div class="rating-group">
                        <input type="radio" id="edit-star1" name="rating" value="1" class="hidden">
                        <label for="edit-star1" class="stars cursor-pointer text-2xl px-1">★</label>
                    </div>
                    <div class="rating-group">
                        <input type="radio" id="edit-star2" name="rating" value="2" class="hidden">
                        <label for="edit-star2" class="stars cursor-pointer text-2xl px-1">★</label>
                    </div>
                    <div class="rating-group">
                        <input type="radio" id="edit-star3" name="rating" value="3" class="hidden">
                        <label for="edit-star3" class="stars cursor-pointer text-2xl px-1">★</label>
                    </div>
                    <div class="rating-group">
                        <input type="radio" id="edit-star4" name="rating" value="4" class="hidden">
                        <label for="edit-star4" class="stars cursor-pointer text-2xl px-1">★</label>
                    </div>
                    <div class="rating-group">
                        <input type="radio" id="edit-star5" name="rating" value="5" class="hidden">
                        <label for="edit-star5" class="stars cursor-pointer text-2xl px-1">★</label>
                    </div>
                </div>
            </div>
            <div class="mb-4">
                <label class="block text-white mb-2">Message</label>
                <textarea id="editMessage" name="message" rows="4"
                          class="w-full px-3 py-2 bg-gray-700 text-white rounded"></textarea>
            </div>
            <div class="flex justify-end space-x-4">
                <button type="button" onclick="closeEditModal()"
                        class="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors">
                    Cancel
                </button>
                <button type="submit"
                        class="px-4 py-2 bg-yellow-500 text-white rounded hover:bg-yellow-600 transition-colors">
                    Save Changes
                </button>
            </div>
        </form>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div id="deleteModal" class="fixed inset-0 bg-black bg-opacity-50 hidden items-center justify-center">
    <div class="bg-gray-800 p-6 rounded-lg shadow-xl max-w-md w-full mx-4">
        <h3 class="text-xl font-bold text-yellow-400 mb-4">Confirm Deletion</h3>
        <p class="text-white mb-6">Are you sure you want to delete this feedback? This action cannot be undone.</p>
        <div class="flex justify-end space-x-4">
            <button onclick="closeDeleteModal()"
                    class="px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700 transition-colors">
                Cancel
            </button>
            <form id="deleteForm" action="DeleteFeedbackServlet" method="POST" class="inline">
                <input type="hidden" id="deleteUsername" name="username" value="">
                <button type="submit"
                        class="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 transition-colors">
                    Delete
                </button>
            </form>
        </div>
    </div>
</div>

<script>
    function editFeedback(username, type, rating, message) {
        document.getElementById('editUsername').value = username;
        document.getElementById('editType').value = type;
        document.getElementById('edit-star' + rating).checked = true;
        document.getElementById('editMessage').value = message.replace(/"/g, '"');
        document.getElementById('editModal').style.display = 'flex';
        updateStarRating(rating);
    }

    function updateStarRating(rating) {
        const stars = document.querySelectorAll('.star-rating label');
        stars.forEach((star, index) => {
            if (index < rating) {
                star.style.color = '#facc15';
            } else {
                star.style.color = '#3b82f6'; /* Blue when not selected */
            }
        });
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
        updateStarRating(0);
    }

    function confirmDelete(username) {
        document.getElementById('deleteUsername').value = username;
        document.getElementById('deleteModal').style.display = 'flex';
    }

    function closeDeleteModal() {
        document.getElementById('deleteModal').style.display = 'none';
    }

    function closeMessage(messageId) {
        document.getElementById(messageId).remove();
    }

    const starLabels = document.querySelectorAll('.star-rating label');

    starLabels.forEach((label, index) => {
        label.addEventListener('mouseover', () => {
            const rating = 5 - index;
            updateStarRating(rating);
        });

        label.addEventListener('click', () => {
            const rating = 5 - index;
            const radioInput = document.getElementById('edit-star' + rating);
            radioInput.checked = true;
            updateStarRating(rating);
        });

        label.addEventListener('mouseout', () => {
            const checkedInput = document.querySelector('.star-rating input:checked');
            const rating = checkedInput ? checkedInput.value : 0;
            updateStarRating(rating);
        });
    });

    window.addEventListener('click', (event) => {
        const editModal = document.getElementById('editModal');
        const deleteModal = document.getElementById('deleteModal');

        if (event.target === editModal) {
            closeEditModal();
        }
        if (event.target === deleteModal) {
            closeDeleteModal();
        }
    });

    window.addEventListener('load', () => {
        const messages = document.querySelectorAll('#successMessage, #errorMessage');
        messages.forEach(message => {
            setTimeout(() => {
                message.remove();
            }, 5000);
        });
    });
</script>
</body>
</html>