"use strict";

const order = require("./order");
const {validateWebhookSignature} = require('razorpay/dist/utils/razorpay-utils')
const Razorpay = require('razorpay')
const crypto = require("crypto");

module.exports =  {
    async webhook(ctx) {
          var id = ctx.request.body.data.order.order_id;
          var status = ctx.request.body.data.payment.payment_status;
        
        const idResponse = await strapi.query('api::order.order').findOne({
          where:{orderId:id},
          populate: true,
        });

        //check status
        console.log(status);
        if(status!="SUCCESS")
        return ctx.send({message: 'Payment Failed'}, 400);

        const response  = await strapi.service('api::order.order').update(
          idResponse.id,
          {
            data:{
              "txStatus":status
            }
          }
        );

        //  TODO: Reduce the user's coupon based on type (NORMAL, SPECIAL)

    const userWallet = await strapi.query('api::wallet.wallet').findOne({
      where:{users_permissions_user:idResponse.users_permissions_user.id},
      select: ['id','normal_coupons','special_coupons'],
  });


  var normal=0; var special=0;

  // Checking plan
  if(idResponse.plan!=null){
     normal = idResponse.plan.normal_coupon;
     special  = idResponse.plan.special_coupon;
  }
   else{
    normal = idResponse.normal_coupon;
    special  = idResponse.special_coupon;
   }

   //update wallet
  const updateWallet = await strapi.service('api::wallet.wallet').update(
    userWallet.id,
    {
      data:{
        "normal_coupons":  userWallet.normal_coupons+normal,
        "special_coupons": userWallet.special_coupons+special,
      }
    }
  );

    return updateWallet;
      },

      async notify(ctx){

        console.log(ctx.request)
        console.log(ctx.request.body);
        
      const webhookSecret= 'casaworld'
      var status = ctx.request.body.event;
      if(status=='payment.captured'){

         console.log("PAID")

         var id = ctx.request.body.payload.payment.entity.order_id;
         console.log(id);

         const idResponse = await strapi.query('api::order.order').findOne({
          where:{orderId:id},
          populate: true,
        });

       

        const response  = await strapi.service('api::order.order').update(
          idResponse.id,
          {
            data:{
              "txStatus":"SUCCESS"
            }
          }
        );

        //  TODO: Reduce the user's coupon based on type (NORMAL, SPECIAL)

    const userWallet = await strapi.query('api::wallet.wallet').findOne({
      where:{users_permissions_user:idResponse.users_permissions_user.id},
      select: ['id','normal_coupons','special_coupons'],
  });


  var normal=0; var special=0;

  // Checking plan
  if(idResponse.plan!=null){
     normal = idResponse.plan.normal_coupon;
     special  = idResponse.plan.special_coupon;
  }
   else{
    normal = idResponse.normal_coupon;
    special  = idResponse.special_coupon;
   }

   //update wallet
  const updateWallet = await strapi.service('api::wallet.wallet').update(
    userWallet.id,
    {
      data:{
        "normal_coupons":  userWallet.normal_coupons+normal,
        "special_coupons": userWallet.special_coupons+special,
      }
    }
  );

    return updateWallet;
      }
        
       //check status
        console.log(status);
        return ctx.send({message: 'Payment Failed'}, 400);

      },

      async orderId(ctx){
        const {key,secret,amount}=ctx.request.body.data;
        console.log(key);
        console.log(secret);
        // console.log(req.body);
    
        var instance = new Razorpay({ key_id: key, key_secret: secret })

        try{
          
          var response =  await instance.orders.create({
            amount: amount,
            currency: "INR",
            receipt: "receipt#1",
            notes: {
              key1: "value3",
              key2: "value2"
            }
          })
          console.log(response);
          return ctx.send({'orderId':response.id})

        }catch(err){
          console.log(err);
          return ctx.badRequest("Error");
        }
      }

}