const healthCheck = (req, res) => {
    res.json({
        status: "healthy",
        service: "CloudTicket API",
        timestamp: new Date()
    });
};

module.exports = {
    healthCheck
};