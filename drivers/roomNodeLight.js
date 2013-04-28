module.exports = {

    announcer: 101,

    descriptions: {
        temp: {
            title: 'Temperature',
            unit: '°C',
            scale: 1,
            min: -50,
            max: 50
        },
        hum: {
            title: 'Relative humidity',
            unit: '%',
            min: 0,
            max: 100
        },
        light: {
            title: 'Light intensity',
            unit: 'Lux'
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
            temp: raw.readInt16LE(1),
            hum: raw.readInt16LE(3),
            light: raw.readUInt16LE(5),
            lobat: raw[7] & 1
        });
    }

};