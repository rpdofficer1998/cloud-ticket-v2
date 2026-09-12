const eventService = require('../services/event.service');

const getAllEvents = async (req, res) => {
    try {

    const events = await eventService.getAllEvents();

    res.json(events);
    } catch (error){
        console.error(error);

        res.status(500).json({
            message: "Internal Server Error"
        });
    }

};

const getEventById = async (req, res) => {
    try {

    const event = await eventService.getEventById(req.params.id);

    if (!event) {
    return res.status(404).json({
        message: "Event not found"
    });
}
    res.json(event);
    } catch (error){
        console.error(error);

        res.status(500).json({
            message: "Internal Server Error"
        });
    }

};


const createEvent = async (req, res) => {

    try {

        const {
            title,
            city,
            date,
            available_tickets
        } = req.body;

        const event = await eventService.createEvent({
            title,
            city,
            date,
            available_tickets
        });

        res.status(201).json(event);

    } catch (error) {

        console.error(error);

        res.status(500).json({
            message: "Internal Server Error"
        });

    }

};

const updateEventById = async (req, res) => {
    try {
        const { id } = req.params;
        const { title, city, date, available_tickets } = req.body;

        const updatedEvent = await eventService.updateEventById(id, {
            title,
            city,
            date,
            available_tickets
        });

        if (!updatedEvent) {
            return res.status(404).json({ message: "Event not found" });
        }

        res.json(updatedEvent);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal Server Error" });
    }
};

const deleteEventById = async (req, res) => {
    try {
        const { id } = req.params;

        const deletedEvent = await eventService.deleteEventById(id);

        if (!deletedEvent) {
            return res.status(404).json({ message: "Event not found" });
        }

        res.json({ message: "Event deleted successfully" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal Server Error" });
    }
};

module.exports = {
    getAllEvents,
    getEventById,
    createEvent,
    updateEventById,
    deleteEventById
};