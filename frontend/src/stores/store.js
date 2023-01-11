import { defineStore } from "pinia"


import axios from "axios";

// http://localhost:8888
console.log(import.meta.env.VITE_BACKEND_URL)
const instance = axios.create({
    // baseURL: "/api",
    baseURL: import.meta.env.VITE_BACKEND_URL,    
    headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        "Access-Control-Allow-Origin": "*"
    },
    cors: true
});

const config = {
    headers: { "Access-Control-Allow-Origin": "*" }
};

let user = localStorage.getItem("user");
if (!user) {
    user = -1
}
else {
    try {
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
if (!cartShopping) {
    cartShopping = -1
}
else {
    try {
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
        userInfo: {
            fullname: "",
            email: "",
            admin: false
        },
        admin: user.admin,
    }),
    actions: {
        createAccount(userInfo) {
            this.stateUser = userInfo;
            this.logLocalSotre(userInfo)

            return new Promise((resolve, reject) => {
                instance.post('/createAccount', userInfo)
                    .then(function (response) {
                        resolve(response);
                        console.log("wordk", response);
                    })
                    .catch(function (err) {
                        reject(err)
                        console.log("errur", err);
                    })
            })
        },
        logLocalSotre(userInfo) {
            if (userInfo.admin == true) {
                this.admin = true;
            }
            else {
                this.admin = false;// false
            }
            console.log("java",userInfo)
            this.userInfo = userInfo
            // instance.defaults.headers.common['Authorization'] = userInfo.token;
            localStorage.setItem('user', JSON.stringify(userInfo));
            this.stateUser = userInfo
        },
        isAdmin() {
            if (this.stateUser?.admin == true) {
                return true
            }
            else {
                return false
            }
        },
        getUserInfo() {
            instance.post("/userInfo")
                .then(function (response) {
                    this.userInfo = response
                })
        },

        update(userInfo){//err cros
            console.log("update",userInfo)
            return new Promise((resolve, reject) => {
                instance.post('/updateAccount', userInfo)
                .then(function (response){
                    resolve(response.data);
                    // this.logLocalSotre(userInfo);
                    console.log("wordk",response.data);
                })
                .catch(function (err){
                    reject(err)
                    console.log("errur",err);
                })
            })

        },
        isConnected(){
            if(this.stateUser != -1){
                return true
            }
            else {
                return false
            }

        },
        loginAccount(userInfo){
            // this.logLocalSotre(userInfo);
            console.log("login",userInfo)
            return new Promise((resolve, reject) => {
                instance.post('/connect', userInfo)
                .then(function (response){
                    if( response?.erreur){
                        console.log("erreur",response.erreur);
                        reject(response)
                    }
                    else{
                        
                        // this.logLocalSotre(userInfo);
                        console.log("wordk",response.data);
                        resolve(response.data);
                    }
                })
                .catch(function (err){
                    reject(err)
                    console.log("errur",err);
                })
            })
        },
        disconnectAccount() {
            user = -1
            this.stateUser=-1  
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
        getCollection(){
            return new Promise((resolve, reject) => {
                instance.get('/collection')
                .then(function (response){
                    resolve(response);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        addToCart(){
            this.cart.push({ amount: 1, item: this.itemView })

            // instance.defaults.headers.common['Authorization'] = disque;
            this.oldcart = JSON.parse(localStorage.getItem("cartShopping"));
            if (Array.isArray(this.oldcart)) {
                this.oldcart.push({ amount: 1, item: this.itemView })
            }
            else {
                if (this.oldcart == null) {
                    this.oldcart = { amount: 1, item: this.itemView }
                }
                else {
                    this.oldcart = [this.oldcart, { amount: 1, item: this.itemView }]
                }

            }


            localStorage.setItem('cartShopping', JSON.stringify(this.oldcart));
        },
        removeFromCart(disque) {
            this.cart = this.cart.filter((item) => item.item.name !== disque.name)
            localStorage.setItem('cartShopping', JSON.stringify(this.cart));
        },
        getCart() {
            //TODO: fix bug, can buy multip item ?


            const lenght = this.cart?.length || 0;
            if (lenght == 0) {
                this.cart = JSON.parse(localStorage.getItem("cartShopping"));
            }
            return this.cart
        },
        setDisk(name) {
            this.itemView = this.cart.find((item) => item.item.name === name)
        },
        addAmount(name) {
            if ((this.cart.find((item) => item.item.name === name).amount == 10) ||
                (this.cart.find((item) => item.item.name === name).amount == this.cart.find((item) => item.item.name === name).item.stock)) {
                return
            }
            this.cart.find((item) => item.item.name === name).amount += 1
            localStorage.setItem('cartShopping', JSON.stringify(this.cart));
        },
        minusAmount(name) {
            if (this.cart.find((item) => item.item.name === name).amount == 1) {
                // this.removeFromCart(this.cart.find((item) => item.item.name === name).item)
                return
            }
            this.cart.find((item) => item.item.name === name).amount -= 1
            localStorage.setItem('cartShopping', JSON.stringify(this.cart));
        },
        emptyCart() {
            this.cart = []
            localStorage.removeItem('cartShopping');

        },
        getDisques() {
            return new Promise((resolve, reject) => {
                instance.get('/disques')
                    .then(function (response) {
                        resolve(response);
                    })
                    .catch(function (err) {
                        reject(err)
                    })
            })
        },
        getArtist(artist) {
            return new Promise((resolve, reject) => {
                instance.get('/artist/'+artist+'')
                .then(function (response){
                    resolve(response.data);//.data
                    // console.log("wordk",response.data);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        getStock(){
            return new Promise((resolve, reject) => {
                instance.get('/stock/'+this.itemView.id+'')
                .then(function (response){
                    resolve(response.data);
                })
                .catch(function (err){
                    console.log("errur",err);
                    reject(err)
                })
            })
        },
        getArtists() {
            return new Promise((resolve, reject) => {
                instance.get('/artists')
                    .then(function (response) {
                        resolve(response.data);
                    })
                    .catch(function (err) {
                        reject(err)
                    })
            })
        },
        command(){
            console.log(this.cart)
            let user = JSON.parse(localStorage.getItem('user'));
            let tosend = [{user_id: user.id}]
            this.cart.map((item) => {
                tosend.push({id: item.item.id, amount: item.amount})
            })
            tosend = Object.assign({}, tosend)
            console.log(tosend)
            // localStorage.removeItem('cartShopping');// TODO: remove this
            return new Promise((resolve, reject) => {
                instance.post('/checkout', tosend)
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
        editProduct(product){
            return new Promise((resolve, reject) => {
                instance.post('/editProduct', product)
                .then(function (response){
                    resolve(response);
                    // console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    // console.log("errur",err);
                })
            })
        },
        deleteProduct(product){
            return new Promise((resolve, reject) => {
                instance.post('/removeProduct', product)
                .then(function (response){
                    resolve(response);
                    // console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    // console.log("errur",err);
                })
            })
        },
<<<<<<< HEAD
        editProduct(product){
=======
        addProduct(product){
            return new Promise((resolve, reject) => {
                instance.post('/addProduct', product)
                .then(function (response){
                    resolve(response);
                    // console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    // console.log("errur",err);
                })
            })
        },
        getCommands(){
>>>>>>> 041898ef62fbfc3f12210ae7d57b6ffa5f22269c
            return new Promise((resolve, reject) => {
                instance.get('/commands')
                .then(function (response){
                    resolve(response);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        validerCommand(command){
            return new Promise((resolve, reject) => {
                instance.post('/validerCommand', command)
                .then(function (response){
                    resolve(response);
                })
                .catch(function (err){
                    reject(err)
<<<<<<< HEAD
                    // console.log("errur",err);
                })
            })
        },
        addProduct(product){
            console.log(product);
            return new Promise((resolve, reject) => {
                instance.post('/newAlbum', product)
                .then(function (response){
                    resolve(response);
                    // console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    // console.log("errur",err);
=======
>>>>>>> 041898ef62fbfc3f12210ae7d57b6ffa5f22269c
                })
            })
        },
        getCommands(){
            return new Promise((resolve, reject) => {
                instance.get('/orders')
                .then(function (response){
                    resolve(response.data);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        validerCommand(command){
            return new Promise((resolve, reject) => {
                instance.post('/validerCommand', command)
                .then(function (response){
                    resolve(response);
                })
                .catch(function (err){
                    reject(err)
                })
            })
        },
        changeStock(stock,id){
            return new Promise((resolve, reject) => {
                instance.post('/editStock', {stock: stock, id: id})
                .then(function (response){
                    resolve(response.data);
                })
                .catch(function (err){
                    console.log("errur",err);
                    reject(err)
                })
            })
        }
    }
})