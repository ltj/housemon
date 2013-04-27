module.exports = {

    announcer: 100,

    descriptions: {
        tempi: {
            title: 'Temperature indoor',
            unit: '°C',
            scale: 1,
            min: -50,
            max: 50
        },
        tempo: {
            title: 'Temperature outdoor',
            unit: '°C',
            scale: 1,
            min: -50,
            max: 50
        },
        press: {
            title: 'Pressure',
            unit: 'hPa',
            scale: 0,
            min: 800,
            max: 1200
        },
        lobat: {
            title: 'Low battery',
            min: 0,
            max: 1
        }
    },

    feed: 'rf12.packet',

    decode: function (raw, callback) {
        callback({
            tempi: raw.readFloatLE(0),
            tempo: raw.readFloatLE(4),
            press: raw.readFloatLE(8),
            lobat: raw[12]
        });
    }
    
};
