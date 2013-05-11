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
            scale: 2,
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
            tempi: raw.readInt16LE(1),
            tempo: (raw.readInt16LE(3) / 16).toFixed(1) * 10,
            press: raw.readInt32LE(5),
            lobat: raw[9] & 1
        });
    }

};
