module.exports = {

    announcer: 102,

    descriptions: {
        power: {
            title: 'Power',
            unit: 'W',
            min: 0,
            max: 36000
        },
        pulse: {
            title: 'Elapsed Wh',
            unit: 'Wh',
            min: 0,
            max: 100
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
            power: raw.readInt16LE(1),
            pulse: raw.readInt16LE(3),
            lobat: raw[5] & 1
        });
    }

};