// profile.js
document.addEventListener('DOMContentLoaded', function() {
    const username = localStorage.getItem('currentUser');
    
    if (!username) {
        window.location.href = 'login.html'; // Redirect to login if not logged in
        return;
    }
    
    // Load user profile
    fetch('http://localhost:3000/getuser', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ username })
    })
    .then(response => response.json())
    .then(data => {
        if (data.success && data.data.length > 0) {
            const user = data.data[0];
            document.getElementById('username-display').textContent = user.username;
            document.getElementById('email-display').textContent = user.email;
            document.getElementById('phone-display').textContent = user.phone;
            document.getElementById('location-display').textContent = user.location;
            // Add other fields as needed
        } else {
            alert('Could not load user profile');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('An error occurred while loading profile');
    });
});