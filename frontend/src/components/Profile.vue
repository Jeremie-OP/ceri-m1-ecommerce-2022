
<template>
<!-- <div class="">Lorem ipsum dolor, sit amet consectetur adipisicing elit. Fugit voluptates ex, voluptate consequuntur ipsum labore incidunt ullam dicta cum nulla soluta repellat magnam reiciendis tenetur repudiandae amet! Non, rem laboriosam.</div> -->
<div  class="modal-mask" v-on:click="close">
  <div class="modal-container" v-on:click.stop="">
    <div class="modal-header header">
     <h2>Profils</h2>
    </div>
    <div class="moddal-body">

     <form v-on:submit.prevent="toEdit()"> 
      <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">person</span>
            <input type="text" placeholder="Nom" v-model="user.first"><br>
          </div>
          <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">person</span>
            <input type="text" placeholder="Prénom" v-model="user.last"><br>
          </div>
          <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">email</span>            
            <input id=login type=text name=login placeholder="email" v-model="user.login"><br>
          </div>
          <div class="form-item">
            <span class="form-item-icon material-symbols-rounded">home</span>
            <input type="text" placeholder="adresse" v-model="user.address"><br>
          </div><div class="form-item">
            <span class="form-item-icon material-symbols-rounded">home_pin</span>
            <input type="text" placeholder="code postal" v-model="user.zip"><br>
          </div><div class="form-item">
            <span class="form-item-icon material-symbols-rounded">location_city</span>
            <input type="text" placeholder="ville" v-model="user.city"><br>
          </div>
      <div class="profilsButton">
        <input @click="disconnect"  type="button" class="button" name=disconnect value="déconnetion">
        <input type="submit" class="button" name=create value="éditer compte">
      </div>
    </form>

    </div>
    <div class="modal-footer">
    
    </div>
  </div>
</div>

</template>


<script > 
import axios from "axios";
import { storeAccount } from '../stores/store';

export default {
  props: {
    show: {
      type: Boolean,
      required: true
    }
  },
    setup(){
      const store = storeAccount()
      return {
        store
      }
    },
    data(){
      return{
        islogin: true,
        user: {
          first: this.store.stateUser.first,
          last: this.store.stateUser.last,
          login: this.store.stateUser.login,
          address: this.store.stateUser.address,
          zip: this.store.stateUser.zip,
          city: this.store.stateUser.city,
          id: this.store.stateUser.id,
          // password: ''
        },
      }
    },
    methods: {
      close() {
        this.$emit("profile", "close");
        document.body.classList.remove("modal-open");
      },
      async toEdit(){
        const res = await this.store.update(this.user);
        console.log("res",res)
        if (res?.success == 1)
        {
          console.log(res)
          this.store.this.store.logLocalSotre(isConnected)
        }
        else{
          console.log(res)

          this.close()
          alert("les proiclemet")
          return
        }
        // this.isLog()
        // let result = axios.post("http://localhost:8888/Sign", this.signIn);
        // console.log(result);
      },
      disconnect(){
        this.store.disconnectAccount();
        this.close();

      },
      watch:{
        show(balue){
          console.log('show',balue)
        }

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
  width: auto;
  height: 620px;
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
  justify-content: center;
  align-items: center;
  border: 1px solid gray;
  border-radius: 5px;
  overflow: hidden;
  height: 40px;

}
.modal-header header{
  background-color: #2a2928;
  color: white;
}
/* .modal-header .change{
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
} */

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
  align-items: center;
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

.profilsButton{
  display: flex;
  justify-content: center;
  gap: 10px;
}

</style>