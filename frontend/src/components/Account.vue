
<template>
<!-- <div class="">Lorem ipsum dolor, sit amet consectetur adipisicing elit. Fugit voluptates ex, voluptate consequuntur ipsum labore incidunt ullam dicta cum nulla soluta repellat magnam reiciendis tenetur repudiandae amet! Non, rem laboriosam.</div> -->
<div  class="modal-mask" v-on:click="close">
  <div class="modal-container" v-on:click.stop="">
    <div class="modal-header">
      <input type="radio" name=slider id=login checked=true>
      <input type="radio" name=slider id=create>
      <label for=login class="login change " v-on:click="logOrCre(true)">Se connecter</label>
      <label for=create class="create change " v-on:click="logOrCre(false)">Crée un compte</label>
      <div class="change-tab"></div>
    </div>
    <div class="moddal-body">
      <div v-show="islogin" class="login-menu">
        <h2>Identification</h2>
        <form v-on:submit.prevent="toLog()">
          <div class="form-item" >
            <span class="form-item-icon material-symbols-rounded">email</span>
            <input id=username type="text" name=username placeholder="email" v-model="login.username"  >
            <span class="error-message" v-for="error in v$.login.username.$errors" :key="error.$uid">{{error.$message}}</span>
            <!-- :style="{ backgroundColor: login.isSub && !login.username.trim() ? 'rgba(255, 0, 0, 0.80)': 'white' }" -->
          </div>
          <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">lock</span>
            <input id=password name=password type="password" placeholder="Mot de passe" v-model="login.password">
            <span class="error-message" v-for="error in v$.login.password.$errors" :key="error.$uid">{{error.$message}}</span>

          </div>
          <button type="submit" class="button" name=login value="Login">Connexion</button>
        </form>
      </div>
      <div v-show="!islogin" class="create-menu">
        <h2>Inscription</h2>
        <form v-on:submit.prevent="toSign()"> 
          <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">person</span>
            <input type="text" placeholder="Nom Prénom" v-model="signIn.fullname"><br>
            <span class="error-message" v-for="error in v$.signIn.fullname.$errors" :key="error.$uid">{{error.$message}}</span>

          </div>
          <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">email</span>            
            <input id=username type=text name=username placeholder="email" v-model="signIn.username"><br>
            <span class="error-message" v-for="error in v$.signIn.username.$errors" :key="error.$uid">{{error.$message}}</span>

          </div>
          <div class="form-item">
          <input id=password name=password type="password" placeholder="Mot de passe"  v-model="signIn.password"><br>
            <span class="error-message" v-for="error in v$.signIn.username.$errors" :key="error.$uid">{{error.$message}}</span>

            <span class="form-item-icon material-symbols-rounded">lock</span>                        
          </div>
          <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">lock</span>                        
            <input id=passwordConf name=passwordConf type="password" placeholder="Confirmé votre mot de passe" v-model="signIn.confirmPassword"><br>
            <span class="error-message" v-for="error in v$.signIn.confirmPassword.$errors" :key="error.$uid">{{error.$message}}</span>
          </div>
          <input type="submit" class="button" name=create value="Crée votre compte">
        </form>
      </div>
    </div>
    <div class="modal-footer">
      <!-- <button class="modal-default-button" v-on:click="close">OK</button> -->

    </div>
  </div>
</div>

</template>

<script >
import { storeAccount } from '../stores/store';
import useValidation from '@vuelidate/core';
import { required, email, sameAs } from '@vuelidate/validators';
import { helpers } from '@vuelidate/validators'

const rules = {
  required,
  email
}

export default {
    setup(){
      const store = storeAccount()
      return {
        store,
        v$: useValidation()
      }
    },
    props: {
        show: {
            type: Boolean,
            required: true
        }
    },
    data(){
      return{
        islogin: true,
        msg: [],
        login: {
          username: '',
          password: '',
          isSub: false,
        },
        signIn: {
          fullname: '',
          username: '',
          password: '',
          confirmPassword:'',
        }
        
      }
    },
    validations() {
      return{
        login: {
            username: {
              required: helpers.withMessage('Le champs ne peut pas etre vide', required),
              email: helpers.withMessage('format de l\'email est incorrect', email)
            },
            password: { required: helpers.withMessage('Le champs ne peut pas etre vide', required), }
        },
        signIn: {
            fullname: { required: helpers.withMessage('Le champs ne peut pas etre vide', required) },
            username: { required: helpers.withMessage('le champs ne peut pas etre vide', required) , 
            email: helpers.withMessage('format de l\'email est incorrect', email) },
            password: { required: helpers.withMessage('Le champs ne peut pas etre vide', required) },
            confirmPassword: { 
              required: helpers.withMessage('Le champs ne peut pas etre vide', required),
              sameAs: helpers.withMessage('Les mots de passe ne sont pas identiques', sameAs(this.password))
            }
        }
      }
    },
    watch: {
      email(value){
        // binding this to the data value in the email input
        console.log(value);
        this.email = value;
        this.validateEmail(value);
      }
    },
    methods: {
      close() {
        this.$emit("account", "close");
        document.body.classList.remove("modal-open");
      },
      logOrCre(state){
        this.islogin=state

      },
      async toLog(){
        const result = await this.v$.login.$validate()
        if(!result){
          console.log('error', result)
          return
        }
        this.store.loginAccount(this.login)

        
        this.isLog()
      },
      async toSign(){
        const result = await this.v$.signIn.$validate()
        if(!result){
          console.log('error', result)
          return
        }

        this.store.createAccount(this.signIn)
        this.isLog()
        // let result = axios.post("http://localhost:8888/Sign", this.signIn);
        // console.log(result);
        this.close()
      },
      isLog(){
        // console.log("islog",this.store.isConnected())
      }
  },
}
</script>


<style>

.modal-mask {
  position: fixed;
  z-index: 4;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.3);
  /* background-color: black; */
  /* display: table; */
  display: flex;
  align-items: center;    
  justify-content: center;
  
  transition: opacity 0.3s ease;
}

.modal-container {
  width: 350px;
  height: 530px;
  border-radius: 10% ;
  /* margin: 0px auto; */
  padding: 20px 30px;
  background-color: rgba(255, 255, 255, 0.8);
  border-color: #2a2928;
  border-radius: 10px;
  /* box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33); */
  /* transition: all 0.3s ease; */
  position: relative;
}
.modal-container::before {
  content: '';
  position: absolute;
  background-color: rgba(255, 255, 255, 0.6);
  inset: 0;
  transform: rotate(5deg);
  z-index: -1;
}

.modal-default-button {
  float: right;
}

.modal-header{
  position: relative;
  display: flex;
  justify-content: space-between;
  border: 1px solid gray;
  border-radius: 5px;
  overflow: hidden;
  height: 40px;
}
.modal-header .change{
  z-index: 1;
  text-align: center;
  height: 100%;
  width: 100%;
  font-size: 18px;
  line-height: 40px;
  cursor: pointer;
  color: black;
}

.modal-header .change-tab{
  position: absolute;
  height: 100%;
  width: 50%;
  left: 0;
  z-index: 0;
  background-color: #2a2928;
}

input[type="radio"]{
  display: none;
}
#create:checked ~ .change-tab{
  left: 50%;
  /* color: black; */
}
#login:checked ~ .login{
  color: white;
}
#create:checked ~ .create{
  color: white;
}

.error-message {
  font-weight: bold; 
  color: red;
  top:1rem;
  margin: 1rem;
}

.form-item{
  position: relative;
}

.form-item .form-item-icon{
  position: absolute;
  top: 0.85rem;
  left: 1.4rem;
  font-size: 1.3rem;
  opacity: .4;
}

.form-item input[type=text],
.form-item input[type=password]{
  border: none;
  outline: none;
  background-color: rgba(255 , 255, 255, 0.95);
  padding: 1rem 1.5rem;
  padding-left: calc(1rem *3.5);
  border-radius: 100px;
}




.modal-mask input{
  /* outline: none;
  border-radius: 100px;
  border-width: 2px;
  font-size: 22px; */

}

.modal-mask form{
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin: 1rem;
  padding: 1rem;
}


.modal-mask .button{
  background: black;
  color: white;
  padding: 1rem 1.5rem;
  border-radius: 100px;
  text-transform: uppercase;
  letter-spacing: 2px;
  /* transition: background .5s; */
}

.modal-mask button:hover{
  background-color: rgba(0, 0, 0, 0.85);

}
</style>