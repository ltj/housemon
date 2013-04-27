module.exports = {

    announcer: 100,

    descriptions: {
        tempi: {
            title: 'Temperature indoor',
            unit: '°C',
            scale: 0,
            min: -50,
            max: 50
        },
        tempo: {
            title: 'Temperature outdoor',
            unit: '°C',
            scale: 0,
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
        ti = raw.readInt16LE(1) / 10.0;
        to = raw.readInt16LE(3) / 16.0;
        p = raw.readInt32LE(5) / 100.0;
        lb = raw[9] & 1;
        callback({
            tempi: ti,
            tempo: to,
            press: p,
            lobat: lb
        });
    }

};
