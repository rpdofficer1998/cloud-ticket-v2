const API_BASE = "/api";

/* ---------- Page Navigation ---------- */

function showHomePage() {
    document.getElementById("home-page").classList.remove("hidden");
    document.getElementById("events-page").classList.add("hidden");
    document.getElementById("orders-page").classList.add("hidden");
}

function showEventsPage() {
    document.getElementById("home-page").classList.add("hidden");
    document.getElementById("events-page").classList.remove("hidden");
    document.getElementById("orders-page").classList.add("hidden");

    loadEvents();
}

function showOrdersPage() {
    document.getElementById("home-page").classList.add("hidden");
    document.getElementById("events-page").classList.add("hidden");
    document.getElementById("orders-page").classList.remove("hidden");

    loadOrders();
}

/* ---------- Events ---------- */

async function loadEvents() {

    const response = await fetch(`${API_BASE}/events`);
    const events = await response.json();

    const container = document.getElementById("events");
    container.innerHTML = "";

    events.forEach(event => {

        const card = document.createElement("div");
        card.className = "event-card";

        card.innerHTML = `
            <h3>${event.title}</h3>
            <p>📍 ${event.city}</p>
            <p>📅 ${event.date}</p>
            <p>🎫 Remaining: ${event.available_tickets}</p>

            <input type="text"
                   id="name-${event.id}"
                   placeholder="Your name">

            <input type="number"
                   id="qty-${event.id}"
                   value="1"
                   min="1">

            <button onclick="bookTicket(${event.id})">
                Book Ticket
            </button>
        `;

        container.appendChild(card);
    });
}

async function bookTicket(eventId) {

    const customerName =
        document.getElementById(`name-${eventId}`).value;

    const quantity =
        parseInt(document.getElementById(`qty-${eventId}`).value);

    if (!customerName) {
        alert("Please enter your name");
        return;
    }

    const response = await fetch(`${API_BASE}/orders`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            event_id: eventId,
            customer_name: customerName,
            quantity
        })
    });

    const result = await response.json();

    if (response.ok) {
        alert("🎉 Booking Accepted!\nPlease complete your payment within 3 minutes.");
        loadEvents();
    } else {
        alert(`❌ ${result.message}`);
    }
}

/* ---------- Orders ---------- */

async function loadOrders() {

    const response = await fetch(`${API_BASE}/orders`);
    const orders = await response.json();

    const container = document.getElementById("orders");
    container.innerHTML = "";

    orders.forEach(order => {

        const card = document.createElement("div");
        card.className = "event-card";

        let actionButtons = "";

        if (order.status === "PENDING") {

            actionButtons = `
                <button onclick="payOrder(${order.id})">
                    Pay Now
                </button>

                <button onclick="cancelOrder(${order.id})">
                    Cancel Order
                </button>
            `;
        }

        card.innerHTML = `
            <h3>Order #${order.id}</h3>
            <p>🎫 Event ID: ${order.event_id}</p>
            <p>👤 Customer: ${order.customer_name}</p>
            <p>🔢 Quantity: ${order.quantity}</p>
            <p>📌 Status: <strong>${order.status}</strong></p>

            ${actionButtons}
        `;

        container.appendChild(card);
    });
}

async function cancelOrder(orderId) {

    const confirmed =
        confirm("Cancel this order?");

    if (!confirmed) return;

    const response = await fetch(
        `${API_BASE}/orders/${orderId}/cancel`,
        {
            method: "POST"
        }
    );

    const result = await response.json();

    if (response.ok) {
        alert("✅ Order cancelled");
        loadOrders();
        loadEvents();
    } else {
        alert(`❌ ${result.message}`);
    }
}

async function payOrder(orderId) {

    const confirmed =
        confirm("Are you sure to pay the order?");

    if (!confirmed) return;

    const response = await fetch(
        `${API_BASE}/orders/${orderId}/pay`,
        {
            method: "POST"
        }
    );

    const result = await response.json();

    if (response.ok) {

        alert("💳 Order has been PAID!");

        loadOrders();

    } else {

        alert(`❌ ${result.message}`);
    }
} 

/* ---------- Start ---------- */

showHomePage();