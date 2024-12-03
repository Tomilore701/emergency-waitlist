let selectedInjury = null;
let selectedPain = null;

// Handle injury selection
document.querySelectorAll('.injury-button').forEach(button => {
    button.addEventListener('click', function () {
        selectedInjury = this.getAttribute('data-injury'); // Get the injury type
        // Highlight the selected button
        document.querySelectorAll('.injury-button').forEach(btn => btn.classList.remove('selected'));
        this.classList.add('selected'); // Highlight selected button
        console.log(`Selected Injury: ${selectedInjury}`); // Debug log
    });
});

// Handle pain level selection
document.querySelectorAll('.pain-button').forEach(button => {
    button.addEventListener('click', function () {
        selectedPain = this.getAttribute('data-pain'); // Get the pain level
        // Highlight the selected button
        document.querySelectorAll('.pain-button').forEach(btn => btn.classList.remove('selected'));
        this.classList.add('selected'); // Highlight selected button
        console.log(`Selected Pain Level: ${selectedPain}`); // Debug log
    });
});

// Handle form submission
document.getElementById('register-button').addEventListener('click', async () => {
    // Collect patient details
    const name = document.getElementById('name').value.trim();
    const date_of_birth = document.getElementById('date_of_birth').value;
    const gender = document.getElementById('gender').value;

    // Validate inputs
    if (!name || !date_of_birth || !gender || !selectedInjury || !selectedPain) {
        alert('Please complete all fields and make a selection.');
        return;
    }

    // Automatically generate card number, room ID, and priority level
    const card_number = 'CN' + Math.floor(Math.random() * 100000); // Example: CN12345
    const room_id = Math.floor(Math.random() * 5) + 1; // Example: Random room ID between 1 and 5
    const priority_level = parseInt(selectedPain) <= 5 ? 'Low' : parseInt(selectedPain) <= 8 ? 'Medium' : 'High';

    // Prepare patient data
    const patientData = {
        name,
        date_of_birth,
        gender,
        injury: selectedInjury,
        pain_level: selectedPain,
        priority_level,
        card_number,
        room_id,
    };

    console.log('Patient Data Sent to Backend:', patientData); // Debug log

    try {
        // Send the data to the backend
        const response = await fetch('http://localhost:3000/registerPatient', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(patientData),
        });

        if (!response.ok) {
            throw new Error('Failed to register patient');
        }

        const result = await response.json(); // Parse backend response
        document.getElementById('result-display').innerHTML = `
            <p>Patient registered successfully! <br> Card Number: ${result.card_number}</p>
        `;
    } catch (error) {
        console.error('Error registering patient:', error);
        document.getElementById('result-display').innerHTML = `
            <p>Error: Could not register patient. Please try again.</p>
        `;
    }
});

