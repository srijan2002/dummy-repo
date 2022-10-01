'use strict';

module.exports = {
    routes: [
      {
        method: 'POST',
        path: '/notify',
        handler: 'custom.webhook',
        config: {
            policies:[],

        },
      },
      {
        method: 'POST',
        path: '/payment/notify',
        handler: 'custom.notify',
        config: {
            policies:[],

        },
      },

      {
        method: 'POST',
        path: '/order',
        handler: 'custom.orderId',
        config: {
            policies:[],

        },
      },
    ],
  }; 