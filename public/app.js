// --- Start of public/app.js ---

const firebaseConfig = {
    apiKey: "AIzaSyA30jtweS5A7YX0mwJOZS0xHqWpocJvtv8",
    authDomain: "scavenger-hunt-digital.firebaseapp.com",
    projectId: "scavenger-hunt-digital",
    storageBucket: "scavenger-hunt-digital.firebasestorage.app",
    messagingSenderId: "66049163776",
    appId: "1:66049163776:web:c1d63db55d7467daca4ee5"
};
firebase.initializeApp(firebaseConfig);

// --- Get references to our HTML elements ---
const loginContainer = document.getElementById('login-container');
const mainContent = document.getElementById('main-content');
const loginBtn = document.getElementById('login-btn');
const logoutBtn = document.getElementById('logout-btn');
const emailInput = document.getElementById('email');
const passwordInput = document.getElementById('password');
const userEmailSpan = document.getElementById('user-email');
const loginErrorP = document.getElementById('login-error');
const submissionsListDiv = document.getElementById('submissions-list');
const teamListDiv = document.getElementById('team-list');
const teamManagementHeader = document.getElementById('team-management-header');
const teamListContainer = document.getElementById('team-list-container');
const leaderboardToggle = document.getElementById('leaderboard-toggle');
const startTimeInput = document.getElementById('start-time');
const endTimeInput = document.getElementById('end-time');
const saveTimesBtn = document.getElementById('save-times-btn');
const createTeamHeader = document.getElementById('create-team-header');
const createTeamContainer = document.getElementById('create-team-container');
const createTeamForm = document.getElementById('create-team-form');
const newTeamNameInput = document.getElementById('new-team-name');
const newTeamEmailInput = document.getElementById('new-team-email');
const newTeamPasswordInput = document.getElementById('new-team-password');
const assignAdminSelect = document.getElementById('assign-admin-select');
const newTeamOrderInput = document.getElementById('new-team-order'); // Added this line

// --- Firebase service instances ---
const auth = firebase.auth();
const db = firebase.firestore();

// --- App State & Config ---
let unsubscribeSubmissions, unsubscribeTeams, unsubscribeGameStatus;
let loggedInAdminUid = null;
let assignedTeamIds = [];

const admins = {
    "e7Z0mODf2HPBKdwf9gnJ8LT8OzR2": "Admin 1 - Rahul",
    "EUky5guvOxNOqsiC8YsKzbV0lKV2": "Admin 2 - Shanky",
    "uczQzYnviZVfBUS3ZpsD4gRQnWz2": "Admin 3 - Shrine",
    "DrpAP8iNUFZJQFoEm41A1dSRYoI2": "Admin 4 - Dhruv",
    "3oi8hYIqu2TW8RCfq2Jbw71KEWG3": "Admin 5 - Prachi",
    "wrVa7Ho2goQkKG4Z618KaGzKIMt2": "Admin 6 - Tanvi",
    "kjGwC3eny4hBAcvSGgXONLUWNEy2": "Admin 7 - Archa",

};

// --- Event Listeners & Auth Logic ---

loginBtn.addEventListener('click', () => {
    const email = emailInput.value;
    const password = passwordInput.value;
    auth.signInWithEmailAndPassword(email, password)
        .catch(error => {
            console.error("Login failed:", error);
            loginErrorP.textContent = error.message;
        });
});

logoutBtn.addEventListener('click', () => {
    auth.signOut();
});

teamManagementHeader.addEventListener('click', () => {
    teamListContainer.classList.toggle('hidden');
    teamManagementHeader.classList.toggle('open');
});

createTeamHeader.addEventListener('click', () => {
    createTeamContainer.classList.toggle('hidden');
    createTeamHeader.classList.toggle('open');
});

auth.onAuthStateChanged(user => {
    if (user) {
        loggedInAdminUid = user.uid;
        loginContainer.style.display = 'none';
        mainContent.style.display = 'block';
        userEmailSpan.textContent = user.email;
        populateAdminDropdown();
        listenForGameStatus();
        listenForTeams();
    } else {
        loggedInAdminUid = null;
        assignedTeamIds = [];
        loginContainer.style.display = 'block';
        mainContent.style.display = 'none';
        if (unsubscribeSubmissions) unsubscribeSubmissions();
        if (unsubscribeTeams) unsubscribeTeams();
        if (unsubscribeGameStatus) unsubscribeGameStatus();
    }
});

// --- Create Team Feature Logic ---

function populateAdminDropdown() {
    assignAdminSelect.innerHTML = '<option value="" disabled selected>Assign to an Admin...</option>';
    for (const uid in admins) {
        const option = document.createElement('option');
        option.value = uid;
        option.textContent = admins[uid];
        assignAdminSelect.appendChild(option);
    }
}

// THIS IS THE MODIFIED createTeamForm listener
createTeamForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const teamName = newTeamNameInput.value;
    const email = newTeamEmailInput.value;
    const password = newTeamPasswordInput.value;
    const assignedAdminUid = assignAdminSelect.value;
    const mysteryOrderString = newTeamOrderInput.value;

    if (!teamName || !email || !password || !assignedAdminUid || !mysteryOrderString) {
        alert('Please fill out all fields.');
        return;
    }

    // Validate and convert the mystery order string into an array of numbers
    const mysteryOrder = mysteryOrderString.split(',')
        .map(numStr => parseInt(numStr.trim(), 10))
        .filter(num => !isNaN(num));

    if (mysteryOrder.length !== 17) { // Assuming 17 total mysteries
        alert(`Error: The mystery order must contain exactly 17 comma-separated numbers. You entered ${mysteryOrder.length}.`);
        return;
    }

    if (!confirm(`Are you sure you want to create team "${teamName}"?`)) return;

    const secondaryAppName = 'secondary-auth-app';
    let secondaryApp;
    try {
        secondaryApp = firebase.app(secondaryAppName);
    } catch (error) {
        secondaryApp = firebase.initializeApp(firebaseConfig, secondaryAppName);
    }
    const secondaryAuth = secondaryApp.auth();

    try {
        const userCredential = await secondaryAuth.createUserWithEmailAndPassword(email, password);
        const newUserUid = userCredential.user.uid;
        const newTeam = {
            id: newUserUid,
            teamName: teamName,
            currentMysteryIndex: 0,
            currentPart: 'riddle',
            assignedAdminUid: assignedAdminUid,
            mysteryOrder: mysteryOrder // Use the array from the input field
        };
        await db.collection('teams').doc(newUserUid).set(newTeam);
        alert(`Successfully created team "${teamName}"!`);
        createTeamForm.reset();
    } catch (error) {
        console.error("Error creating team:", error);
        alert(`Failed to create team: ${error.message}`);
    } finally {
        await secondaryAuth.signOut();
        await secondaryApp.delete();
    }
});

// --- Game Status Logic ---

function listenForGameStatus() {
    const gameStatusRef = db.collection('game_status').doc('status');
    unsubscribeGameStatus = gameStatusRef.onSnapshot(doc => {
        if (doc.exists) {
            const status = doc.data();
            leaderboardToggle.checked = status.isLeaderboardEnabled;
            if (status.startTime) {
                const startDate = status.startTime.toDate();
                const tzoffset = (new Date()).getTimezoneOffset() * 60000;
                const localISOTime = (new Date(startDate - tzoffset)).toISOString().slice(0, 16);
                startTimeInput.value = localISOTime;
            }
            if (status.endTime) {
                const endDate = status.endTime.toDate();
                const tzoffset = (new Date()).getTimezoneOffset() * 60000;
                const localISOTime = (new Date(endDate - tzoffset)).toISOString().slice(0, 16);
                endTimeInput.value = localISOTime;
            }
        }
    });
}

saveTimesBtn.addEventListener('click', () => {
    const startTimeValue = startTimeInput.value;
    const endTimeValue = endTimeInput.value;
    if (!startTimeValue || !endTimeValue) {
        return alert('Please select both a start and an end time.');
    }
    const startDate = new Date(startTimeValue);
    const endDate = new Date(endTimeValue);
    const startTimestamp = firebase.firestore.Timestamp.fromDate(startDate);
    const endTimestamp = firebase.firestore.Timestamp.fromDate(endDate);
    db.collection('game_status').doc('status').set({
        startTime: startTimestamp,
        endTime: endTimestamp,
    }, { merge: true })
        .then(() => alert('Start and End times have been saved successfully!'))
        .catch(error => console.error("Error saving times:", error));
});

leaderboardToggle.addEventListener('change', () => {
    const isEnabled = leaderboardToggle.checked;
    db.collection('game_status').doc('status').set(
        { isLeaderboardEnabled: isEnabled },
        { merge: true }
    ).catch(error => console.error("Error updating leaderboard status:", error));
});

// --- Team Management Logic ---

function listenForTeams() {
    if (!loggedInAdminUid) return;
    unsubscribeTeams = db.collection('teams')
        .where('assignedAdminUid', '==', loggedInAdminUid)
        .onSnapshot(snapshot => {
            teamListDiv.innerHTML = '';
            assignedTeamIds = [];
            if (snapshot.empty) {
                teamListDiv.innerHTML = '<p>No teams assigned to you.</p>';
                listenForSubmissions();
                return;
            }
            snapshot.forEach(doc => {
                assignedTeamIds.push(doc.id);
                const team = doc.data();
                const card = createTeamCard(doc.id, team);
                teamListDiv.appendChild(card);
            });
            listenForSubmissions();
        }, error => {
            console.error("Error listening to teams:", error);
            teamListDiv.innerHTML = '<p style="color:red;">Error loading teams. Check console.</p>';
        });
}

function createTeamCard(docId, team) {
    const card = document.createElement('div');
    card.className = 'team-card';
    card.innerHTML = `
    <h3>${team.teamName}</h3>
    <p><strong>Status:</strong> Mystery #${team.currentMysteryIndex + 1} (${team.currentPart})</p>
    <button class="advance-btn">Manually Advance Team</button>
  `;
    const advanceBtn = card.querySelector('.advance-btn');
    advanceBtn.addEventListener('click', () => handleManualAdvance(docId, team));
    return card;
}

async function handleManualAdvance(docId, team) {
    if (!confirm(`Are you sure you want to advance ${team.teamName}? This is for a bypass.`)) return;
    let newMysteryIndex = team.currentMysteryIndex;
    let newPart = team.currentPart;
    if (team.currentPart === 'riddle') {
        newPart = 'imageTask';
    } else {
        newPart = 'riddle';
        newMysteryIndex++;
    }
    const totalMysteries = 15;
    if (newMysteryIndex >= totalMysteries) {
        return alert(`${team.teamName} has already finished the hunt!`);
    }
    try {
        await db.collection('teams').doc(docId).update({
            currentMysteryIndex: newMysteryIndex,
            currentPart: newPart,
        });
        alert(`${team.teamName} has been advanced successfully.`);
    } catch (error) {
        console.error("Error advancing team:", error);
        alert("An error occurred. Check console.");
    }
}

// --- Submission Logic ---

function listenForSubmissions() {
    if (unsubscribeSubmissions) unsubscribeSubmissions();
    if (assignedTeamIds.length === 0) {
        submissionsListDiv.innerHTML = '<p>No pending submissions for your teams.</p>';
        return;
    }
    unsubscribeSubmissions = db.collection('submissions')
        .where('status', '==', 'pending')
        .where('teamId', 'in', assignedTeamIds)
        .orderBy('timestamp', 'asc')
        .onSnapshot(snapshot => {
            submissionsListDiv.innerHTML = '';
            if (snapshot.empty) {
                submissionsListDiv.innerHTML = '<p>No pending submissions for your teams. Great job!</p>';
                return;
            }
            snapshot.forEach(doc => {
                const submission = doc.data();
                const card = createSubmissionCard(doc.id, submission);
                submissionsListDiv.appendChild(card);
            });
        }, error => {
            console.error("Error listening to submissions:", error);
            submissionsListDiv.innerHTML = '<p style="color:red;">Error loading submissions. Check console.</p>';
        });
}

function createSubmissionCard(docId, submission) {
    const baseUrl = "https://oyvpxeeupctvhpwmdejq.supabase.co/storage/v1/object/public/mysteries/";
    const partNumber = submission.part === 'riddle' ? 1 : 2;
    const mysteryNumber = submission.mysteryIndex;
    const answerImageFilename = `m${mysteryNumber}${partNumber}.jpg`;
    const answerImageUrl = baseUrl + answerImageFilename;

    const card = document.createElement('div');
    card.className = 'submission-card';
    card.innerHTML = `
    <p><strong>Team:</strong> ${submission.teamName}</p>
    <p><strong>Mystery:</strong> #${submission.mysteryIndex} (${submission.part})</p>
    <div class="image-comparison">
      <div class="image-container">
        <h4>Player's Submission</h4>
        <a href="${submission.imageUrl}" target="_blank"><img src="${submission.imageUrl}" alt="Submission Image"></a>
      </div>
      <div class="image-container">
        <h4>Correct Answer</h4>
        <a href="${answerImageUrl}" target="_blank"><img src="${answerImageUrl}" alt="Correct Answer Image"></a>
      </div>
    </div>
    <div class="actions">
      <button class="approve-btn">Approve</button>
      <button class="reject-btn">Reject</button>
    </div>
  `;
    const approveBtn = card.querySelector('.approve-btn');
    const rejectBtn = card.querySelector('.reject-btn');
    approveBtn.addEventListener('click', () => handleApproval(docId, submission));
    rejectBtn.addEventListener('click', () => handleRejection(docId));
    return card;
}

async function handleApproval(docId, submission) {
    try {
        const teamRef = db.collection('teams').doc(submission.teamId);
        const teamDoc = await teamRef.get();
        if (!teamDoc.exists) return;
        const teamData = teamDoc.data();
        let newMysteryIndex = teamData.currentMysteryIndex;
        let newPart = teamData.currentPart;
        if (teamData.currentPart === 'riddle') {
            newPart = 'imageTask';
        } else {
            newPart = 'riddle';
            newMysteryIndex++;
        }
        await teamRef.update({ currentMysteryIndex: newMysteryIndex, currentPart: newPart });
        await db.collection('submissions').doc(docId).update({ status: 'approved' });
    } catch (error) {
        console.error("Error approving submission:", error);
        alert("An error occurred. Check console.");
    }
}

async function handleRejection(docId) {
    await db.collection('submissions').doc(docId).update({ status: 'rejected' });
}