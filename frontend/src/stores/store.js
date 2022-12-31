import {defineStore} from "pinia"


import axios from "axios";

// http://localhost:8888
const instance = axios.create({ 
    baseURL: '/api',
    headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        "Access-Control-Allow-Origin": "*"
    }

});

const config = {
    headers: {"Access-Control-Allow-Origin": "*"}
};

let user = localStorage.getItem("user");
if(!user){
    user= -1
}
else{
    try{
        user = JSON.parse(user);
        instance.defaults.headers.common['Authorization'] = user.token;
    }
    catch (ex) {
        user = {
        userId: -1,
        token: '',
        };
    }   
}
let cartShopping = localStorage.getItem("cartShopping");
if(!cartShopping){
    cartShopping= -1
}
else{
    try{
        cartShopping = JSON.parse(cartShopping);
        // instance.defaults.headers.common['Authorization'] = cartShopping.token;
    }
    catch (ex) {
        cartShopping = null;
    }   
}

export const storeAccount = defineStore("account", {
    state: () => ({
        stateUser: user,
        userInfo:{
            fullname:"",
            email:"",
        }
    }),
    actions: {
        createAccount(userInfo){
            this.stateUser = userInfo;
            this.logLocalSotre(userInfo)

            return new Promise((resolve, reject) => {
                instance.post('/createAccount', userInfo)
                .then(function (response){
                    resolve(response);
                    console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    console.log("errur",err);
                })
            })
        },
        logLocalSotre(userInfo) {
            user = userInfo
            instance.defaults.headers.common['Authorization'] = userInfo.token;
            localStorage.setItem('user', JSON.stringify(userInfo));
        },
        getUserInfo(){            
            instance.post("/userInfo")
            .then (function (response){
                this.userInfo = response
            })
        },
        update(userInfo){

            return new Promise((resolve, reject) => {
                instance.post('/updateAccount', userInfo)
                .then(function (response){
                    resolve(response);
                    this.logLocalSotre(userInfo);
                    console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    console.log("errur",err);
                })
            })

        },
        isConnected(){
            if(user != -1){
                return true
            }
            else{
                return false
            }
           
        },
        loginAccount(userInfo){
            return new Promise((resolve, reject) => {
                instance.post('/loginAccount', userInfo)
                .then(function (response){
                    resolve(response);
                    this.logLocalSotre(userInfo);
                    console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    console.log("errur",err);
                })
            })
        },
        disconnectAccount(){
            user = -1
            this.stateUser=""
            instance.defaults.headers.common['Authorization'] = "";
            localStorage.removeItem('user');
        }
    }
})


export const storeDisque = defineStore("disque", {
    state: () => ({
        disques: [],
        alldisk: [],
        cart: [],
        itemView: {},
        oldcart: [],
    }),
    actions: {
        addToCart(){

            this.cart.push({amount: 1, item: this.itemView})

            // instance.defaults.headers.common['Authorization'] = disque;
            this.oldcart = JSON.parse(localStorage.getItem("cartShopping"));
            if (Array.isArray(this.oldcart)) {
                this.oldcart.push({amount: 1, item: this.itemView})
            }
            else{
                if (this.oldcart == null){
                    this.oldcart = {amount: 1, item: this.itemView}
                }
                else{
                    this.oldcart = [this.oldcart,{amount: 1, item: this.itemView}]
                }
                
            }
            
            
            localStorage.setItem('cartShopping', JSON.stringify(this.oldcart));
        },
        removeFromCart(disque){
            this.cart = this.cart.filter((item) => item.item.name !== disque.name)
            localStorage.setItem('cartShopping', JSON.stringify(this.cart));
        },
        getCart(){
            //TODO: fix bug, can buy multip item ?
            
           
            const lenght = this.cart?.length || 0;
            if (lenght == 0) {
                this.cart = JSON.parse(localStorage.getItem("cartShopping"));
            }
            return this.cart
        },
        setDisk(name){
            this.itemView = this.cart.find((item) => item.item.name === name)
        },
        addAmount(name){
            if ((this.cart.find((item) => item.item.name === name).amount == 10) || 
            (this.cart.find((item) => item.item.name === name).amount == this.cart.find((item) => item.item.name === name).item.stock)){
                return
            }
            this.cart.find((item) => item.item.name === name).amount += 1
            localStorage.setItem('cartShopping', JSON.stringify(this.cart));
        },
        minusAmount(name){
            if (this.cart.find((item) => item.item.name === name).amount == 1){
                // this.removeFromCart(this.cart.find((item) => item.item.name === name).item)
                return
            }
            this.cart.find((item) => item.item.name === name).amount -= 1
            localStorage.setItem('cartShopping', JSON.stringify(this.cart));
        },
        emptyCart(){
            this.cart = []
            localStorage.removeItem('cartShopping');

        },
        getDisques(){
            return new Promise((resolve, reject) => {
                instance.get('/disques')
                .then(function (response){
                    resolve(response);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        getArtist(artist){
            return new Promise((resolve, reject) => {
                instance.get('/artist/'+artist+'')
                .then(function (response){
                    resolve(response.data);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        getArtists(){
            return new Promise((resolve, reject) => {
                instance.get('/artists')
                .then(function (response){
                    resolve(response.data);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        command(){
            localStorage.removeItem('cartShopping');
            return new Promise((resolve, reject) => {
                instance.post('/command', cart)
                .then(function (response){
                    resolve(response);
                    // console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    // console.log("errur",err);
                })
            })
        }
    }
})