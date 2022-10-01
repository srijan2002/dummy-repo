"use strict";

/**
 *  order controller
 */

const { createCoreController } = require("@strapi/strapi").factories;

module.exports = createCoreController("api::order.order", ({ strapi }) => ({
  async create(ctx) {
    const { id } = ctx.state.user;
    // Inject user id into the request body
    ctx.request.body.data.users_permissions_user = id;

    const response = await strapi.service('api::order.order').create(ctx.request.body);
    return ctx.created(response);
  },
}));
