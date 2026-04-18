// ============================================
// Online Exam Portal - Countdown Timer
// ============================================

let timerInterval;
let totalSeconds;
let startTime;

function initTimer(minutes) {
    totalSeconds = minutes * 60;
    startTime = Date.now();
    
    // Check if there's a saved start time in sessionStorage
    const savedStartTime = sessionStorage.getItem('examStartTime');
    if (savedStartTime) {
        const elapsed = Math.floor((Date.now() - parseInt(savedStartTime)) / 1000);
        totalSeconds = Math.max(0, totalSeconds - elapsed);
    } else {
        sessionStorage.setItem('examStartTime', Date.now().toString());
    }
    
    updateTimerDisplay();
    timerInterval = setInterval(tick, 1000);
}

function tick() {
    totalSeconds--;
    
    if (totalSeconds <= 0) {
        clearInterval(timerInterval);
        totalSeconds = 0;
        updateTimerDisplay();
        autoSubmit();
        return;
    }
    
    updateTimerDisplay();
}

function updateTimerDisplay() {
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    
    const display = document.getElementById('timerDisplay');
    if (display) {
        display.textContent = 
            String(minutes).padStart(2, '0') + ':' + 
            String(seconds).padStart(2, '0');
        
        // Change timer color based on remaining time
        const timerContainer = document.getElementById('timerContainer');
        if (timerContainer) {
            timerContainer.classList.remove('warning', 'danger');
            
            if (totalSeconds <= 60) {
                timerContainer.classList.add('danger');
            } else if (totalSeconds <= 180) {
                timerContainer.classList.add('warning');
            }
        }
    }
}

function autoSubmit() {
    // Show alert
    alert('Time is up! Your exam will be submitted automatically.');
    
    // Clean up sessionStorage
    sessionStorage.removeItem('examStartTime');
    
    // Submit the form
    const form = document.getElementById('examForm');
    if (form) {
        form.submit();
    }
}

// Track answered questions for navigation dots
function updateQuestionNav() {
    const questions = document.querySelectorAll('.question-card');
    questions.forEach((card, index) => {
        const radios = card.querySelectorAll('input[type="radio"]');
        const dot = document.getElementById('qdot_' + (index + 1));
        let answered = false;
        
        radios.forEach(radio => {
            if (radio.checked) answered = true;
        });
        
        if (dot) {
            if (answered) {
                dot.classList.add('answered');
            } else {
                dot.classList.remove('answered');
            }
        }
    });
}

// Highlight selected option
function selectOption(element) {
    // Remove selected class from siblings
    const parent = element.closest('.options-list');
    if (parent) {
        parent.querySelectorAll('.option-item').forEach(item => {
            item.classList.remove('selected');
        });
    }
    element.classList.add('selected');
    
    // Update navigation dots
    updateQuestionNav();
}

// Confirm before submit
function confirmSubmit() {
    const totalQuestions = document.querySelectorAll('.question-card').length;
    let answeredCount = 0;
    
    document.querySelectorAll('.question-card').forEach(card => {
        const radios = card.querySelectorAll('input[type="radio"]');
        radios.forEach(radio => {
            if (radio.checked) answeredCount++;
        });
    });
    
    const unanswered = totalQuestions - answeredCount;
    
    let message = 'Are you sure you want to submit the exam?';
    if (unanswered > 0) {
        message = `You have ${unanswered} unanswered question(s). Are you sure you want to submit?`;
    }
    
    if (confirm(message)) {
        clearInterval(timerInterval);
        sessionStorage.removeItem('examStartTime');
        document.getElementById('examForm').submit();
    }
}

// Smooth scroll to question
function scrollToQuestion(questionNum) {
    const element = document.getElementById('question_' + questionNum);
    if (element) {
        element.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
}

// Clean up on page unload
window.addEventListener('beforeunload', function(e) {
    // Only if exam is in progress
    const form = document.getElementById('examForm');
    if (form && totalSeconds > 0) {
        e.preventDefault();
        e.returnValue = 'You have an exam in progress. Are you sure you want to leave?';
    }
});
