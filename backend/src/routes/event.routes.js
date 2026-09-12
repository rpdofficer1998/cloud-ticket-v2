const express = require('express');
const router = express.Router();

const {
    getAllEvents,
    getEventById,
    createEvent,
    updateEventById,
    deleteEventById
    
} = require('../controllers/event.controller');

router.get('/', getAllEvents);

router.get('/:id', getEventById);

router.post('/', createEvent);

router.put('/:id', updateEventById);

router.delete('/:id', deleteEventById);

module.exports = router;