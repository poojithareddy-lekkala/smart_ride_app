# Flutter Assignment

**Flutter Developer Technical Assignment**

---

## **Smart Ride Booking & Trip Management App – Technical Assignment**

**Duration:** 48 hrs

---

## **Objective**

Build a **cross-platform Flutter app** that simulates a **real-time ride booking platform (similar to Ola/Uber)** with trip management, live updates, and basic analytics.

This assignment evaluates **Flutter widgets, state management, local storage, real-time UI updates, responsive design, clean architecture, and testing**.

---

## **1. Core Features (Must-Have)**

### **Dashboard**

- Home screen showing:
    - **Total trips completed**
    - **Total amount spent**
    - **Recent trips** (last 5–10)
    - **Simple pie or bar chart** showing trips by ride type (Mini, Sedan, Auto, Bike)
- **Real-time dashboard updates** when a new trip is booked or completed
- Responsive layout for mobile screens

---

### **Trips (Bookings)**

- Add, edit, delete trips with:
    - Pickup location
    - Drop location
    - Ride type (Mini, Sedan, Auto, Bike)
    - Fare amount
    - Date & time
- Input validation and error handling
- Store trip data locally using **Hive or SQLite** for offline access
- **Live trip status updates**:
    - Requested
    - Driver Assigned
    - Ride Started
    - Ride Completed
    - Cancelled
- Swipe-to-delete trip with undo (optional bonus)

---

### **Ride Spending Limits (Simplified Budgets)**

- Allow user to set **monthly spending limit per ride type**
- Visual alert (color-coded) when spending approaches limit
- Highlight **over-limit ride categories**
- **Real-time limit recalculation** as soon as a ride status changes to *Completed*

---

## **2. Real-Time Features (High Importance)**

### **Live Ride Status Simulation**

- Simulate **real-time ride progression** using:
    - Timers / Streams / StateNotifier updates
- Status transitions happen automatically:
    - Booking → Driver Assigned → Ride Started → Completed
- UI updates instantly without app restart

---

### **Live Fare Updates (Simulation)**

- Fare dynamically updates based on:
    - Ride duration
    - Distance (mocked value)
    - Surge multiplier (simulated)
- Fare changes reflected **in real time on the booking screen**

---

### **Driver Tracking (Mocked Real-Time)**

- Show a **mock live driver location movement** on UI (no real maps required)
- Update driver ETA every few seconds
- Emphasize **state-driven UI refresh**

---

### **Instant Notifications (In-App)**

- Show real-time in-app notifications/snackbars for:
    - Driver assigned
    - Ride started
    - Ride completed
- Notification triggered via state changes (not manual refresh)

---

## **3. Technical Requirements**

- Flutter 3.x+ and Dart
- **State management:** Provider, Riverpod, or Bloc (**mandatory**)
- Architecture must support **real-time state updates** using:
    - Streams
    - StateNotifiers
    - Bloc events
- Clean, modular architecture:
    - UI
    - State / Controllers
    - Models
    - Local Storage
- **Unit and widget tests** for:
    - Trip CRUD
    - Ride status transitions
    - Dashboard live updates
- Git repository with **meaningful, incremental commits**
- Follow **Flutter lints and code formatting**

---

## **4. Brownie Points / Optional Features**

- Light / Dark mode toggle
- Smooth animations for:
    - Ride status changes
    - Fare updates
    - Driver movement indicator
- Export trip history to **CSV**
- Simulated **network latency handling**
- Pull-to-refresh with real-time state sync

---

## **5. Deliverables**

1. GitHub repository containing the full Flutter project
2. `README.md` including:
    - Setup instructions
    - Architecture overview
    - State management choice
    - Explanation of real-time simulation approach
    - Test coverage summary
3. Screenshots or screen recording of the app running on Android / iOS

---

## **6. Evaluation Criteria**

| Criteria | Description |
| --- | --- |
| **State Management** | Clean, scalable handling of real-time updates |
| **Offline Storage** | Correct persistence with Hive / SQLite |
| **Real-Time Behavior** | Live UI updates, state-driven changes |
| **UI/UX** | Responsive, intuitive ride-booking experience |
| **Code Quality** | Modular, readable, production-ready |
| **Testing** | Unit & widget tests covering real-time logic |
| **Bonus Features** | Animations, dark mode, CSV export |

---

## **7. Submit Your Assignment**

---

## **Submission Requirements (Mandatory)**

---

### **1. Loom Video**

Record a short Loom walkthrough demonstrating:

- Project open in IDE with folder structure overview
- Explanation of real-time architecture & state management
- Running `git log --oneline` and explaining **3–5 commits**
- Live app demo:
    - Book a ride
    - Observe live status changes
    - View real-time dashboard updates
    - Run tests

---

### **2. Git Commit Verification**

- Repository must contain **minimum 6 incremental commits**
- Each commit should represent a logical development step
    
    Examples:
    
    - `feat: add real-time ride status simulation`
    - `feat: live dashboard updates`
    - `fix: fare recalculation on status change`
- **No single bulk “final” commit**