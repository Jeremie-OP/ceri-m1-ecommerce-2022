import {defineStore} from "pinia"

import axios from "axios";

const instance = axios.create({
    baseURL: 'http://localhost:8888'
});

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
    }),
    actions: {
        getDisques(){
            return new Promise((resolve, reject) => {
                instance.get('/disques')
                .then(function (response){
                    resolve(response);
                    console.log("wordk",response);
                })
                .catch(function (err){
                    reject(err)
                    console.log("errur",err);
                })
            })
        }
    }
})