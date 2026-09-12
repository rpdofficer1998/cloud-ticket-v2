# CloudTicket

A simple cloud-native ticket booking backend application built with **Node.js**, **Express**, **PostgreSQL**, and **Docker Compose**.

## Features

- View available events
- Ticket reservation with expiration
- Ticket cancellation and restoration
- Automatic ticket restoration for expired orders
- PostgreSQL persistent storage
- Transaction management and row-level locking with `SELECT FOR UPDATE`
- RESTful API
- Dockerized backend and database
- Easy local and cloud deployment

## Tech Stack

- Node.js
- Express
- PostgreSQL
- Docker
- Docker Compose
- Terraform
- AWS
- REST API

## Project Structure

```text
cloud-ticket/
├── backend/
│   ├── Dockerfile
│   ├── src/
│   └── package.json
├── docker/
│   └── docker-compose.yml
├── frontend/
├── infrastructure/
├── docs/
└── README.md