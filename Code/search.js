// search.js
document.addEventListener('DOMContentLoaded', function() {
    const searchForm = document.getElementById('search-form');
    const resultsContainer = document.getElementById('search-results');
    
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const searchTerm = document.getElementById('search-input').value;
            
            fetch('http://localhost:3000/search', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ username: searchTerm }) // Note: API uses username parameter for search
            })
            .then(response => response.json())
            .then(data => {
                resultsContainer.innerHTML = ''; // Clear previous results
                
                if (data.success && data.recordset && data.recordset.length > 0) {
                    data.recordset.forEach(car => {
                        const carElement = document.createElement('div');
                        carElement.className = 'car-item';
                        carElement.innerHTML = `
                            <h3>${car.car_name}</h3>
                            <p>Mileage: ${car.car_miles} miles</p>
                            <p>Price: $${car.car_booking_price}</p>
                            <button class="book-now" data-car="${car.car_name}" data-price="${car.car_booking_price}">Book Now</button>
                        `;
                        resultsContainer.appendChild(carElement);
                    });
                    
                    // Add event listeners for book now buttons
                    document.querySelectorAll('.book-now').forEach(button => {
                        button.addEventListener('click', function() {
                            const carName = this.getAttribute('data-car');
                            const price = this.getAttribute('data-price');
                            // Store car details in localStorage or redirect to booking page with parameters
                            localStorage.setItem('selectedCar', carName);
                            localStorage.setItem('carPrice', price);
                            window.location.href = 'car-details.html';
                        });
                    });
                } else {
                    resultsContainer.innerHTML = '<p>No cars found matching your search.</p>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                resultsContainer.innerHTML = '<p>An error occurred during search. Please try again.</p>';
            });
        });
    }
});