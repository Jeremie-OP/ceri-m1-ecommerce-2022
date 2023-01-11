
<script >
import { defineComponent } from 'vue';
import { RouterLink, RouterView } from "vue-router";
import menuDisque from "./components/Menu.vue";
import Account from "./components/Account.vue";
import Profile from "./components/Profile.vue";
import { onMounted } from "@vue/runtime-core";
// import { defineComponent } from 'vue';

// definir si on se sert d'une request pour get all disque on mutiple

// create account
// log
// add album to cart
// view the cart
// can pay the cart

// button mon compte -> modale de connection
// pge info du compte

export default({
  components:{
    menuDisque,
    Account,
    Profile
  },
  data() {
    return {
      showModal: false,
      showProfile: false,
      isadmin: false
    }
  },
  methods:{
    showModals(args){
      if(args == "account")
      {
        this.showModal = true;
      }
      else if(args == "profile")
      {
        this.showProfile = true;
        console.log("profile");
      }
      
    },
    closeAccount(args){
      this.isadmin = args;

      this.showModal = false;
    },
    closeProfile(){
      this.showProfile = false;
      console.log("profile2");

    }
  }
});


</script>

<template>
  <menuDisque @showModal="showModals" v-bind:key="{isAdmin: this.isadmin}" :isAdmin="this.args"  />
  <account v-show="showModal" @account="closeAccount" />
  <profile v-show="showProfile" :showProfils="this.showProfile" @profile="closeProfile" />
  <router-view/>
</template>


<style>
@import url('https://fonts.googleapis.com/css2?family=Nunito&display=swap');

  #app{
    /* font-family: "Sofia", sans-serif;  */
    width: 100%;
    font-family: 'Nunito', sans-serif;

  }
  .modal-open{
    overflow: hidden;
  }
</style>

