
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

<<<<<<< HEAD
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
      }
    },
    closeAccount(){
      this.showModal = false;
    },
    closeProfile(){
      this.showProfile = false;
    }
  }
});


=======

// api to get gerne ? 
// doockerignore -> npde_modules
components: {
  menuDisque
}
>>>>>>> 621e08ee1f5676866a186faaa9d013f84d37df3c
</script>

<template>
  <menuDisque @showModal="showModals" />
  <account v-show="showModal" @account="closeAccount" />
  <profile v-show="showProfile" @profile="closeProfile" />
  <router-view/>
</template>


<style>

@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');

  #app{
    /* font-family: "Sofia", sans-serif;  */
    width: 100%;

  }
  .modal-open{
    overflow: hidden;
  }
</style>

