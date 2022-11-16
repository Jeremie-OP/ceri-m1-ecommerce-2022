
<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router";
import menuDisque from "./components/Menu.vue";

// definir si on se sert d'une request pour get all disque on mutiple

// create account
// log
// add album to cart
// view the cart
// can pay the cart


// api to get gerne ? 
// doockerignore -> npde_modules
components: {
  menuDisque
}
</script>

<template>
  <menuDisque/>
  <router-view/>
</template>


<style>
  #app{
    font-family: "Sofia", sans-serif; 
    width: 100%;

  }
</style>

