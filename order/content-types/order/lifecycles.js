const axios = require("axios");
function generateString(length) {
  const characters =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  let result = "";
  const charactersLength = characters.length;
  for (let i = 0; i < length; i++) {
    result += characters.charAt(Math.floor(Math.random() * charactersLength));
  }

  return result;
}
module.exports = {
  // async beforeCreate(event) {
  //   const x = generateString(8);
  //   const { data, where, select, populate } = event.params;
  //   event.params.data.orderId = x;

  //   const response = await axios.post(
  //     "https://test.cashfree.com/api/v2/cftoken/order",
  //     {
  //       orderId: x,
  //       orderAmount: data.amount,
  //       orderCurrency: "INR",
  //     },
  //     {
  //       headers: {
  //         "x-client-id": process.env.CASHFREE_CLIENT_ID,
  //         "x-client-secret": process.env.CASHFREE_CLIENT_SECRET,
  //       },
  //     }
  //   );

  //   if (response.data.status == "OK") {
  //     event.params.data.cftoken = response.data.cftoken;
  //   }
  // },

  async beforeCreate(event){
        const { data, where, select, populate } = event.params;
        
        const pg_status = data['pg_status']

        if(pg_status=="CASHFREE"){
          event.params.data.pg_status = "CASHFREE"
            const x = generateString(8);

       event.params.data.orderId = x;

    const response = await axios.post(
      "https://test.cashfree.com/api/v2/cftoken/order",
      {
        orderId: x,
        orderAmount: data.amount,
        orderCurrency: "INR",
      },
      {
        headers: {
          "x-client-id": process.env.CASHFREE_CLIENT_ID,
          "x-client-secret": process.env.CASHFREE_CLIENT_SECRET,
        },
      }
    );

    if (response.data.status == "OK") {
      event.params.data.cftoken = response.data.cftoken;
    }
            

        }else{
          event.params.data.pg_status = "RAZORPAY"
          event.params.data.orderId = data.orderId;
        }
  }
};
