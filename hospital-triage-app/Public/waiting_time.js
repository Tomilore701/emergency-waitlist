// Function to check the waiting time
document.getElementById('check-wait-time-form').addEventListener('submit', function (e) {
    e.preventDefault();  // Prevent default form submission

    const cardNumber = document.getElementById('card_number').value.trim();

    if (!cardNumber) {
        alert('Please enter a valid card number');
        return;
    }

    fetch('http://localhost:3000/checkWaitTime', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ card_number: cardNumber })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Failed to fetch waiting time');
        }
        return response.json();
    })
    .then(data => {
        document.getElementById('wait-time-display').innerHTML = `<h3>Estimated Wait Time: ${data.wait_time} minutes</h3>`;
    })
    .catch(error => {
        console.error('Error fetching waiting time:', error);
        document.getElementById('wait-time-display').innerHTML = '<h3>Error: Could not calculate waiting time. Please try again.</h3>';
    });
});
