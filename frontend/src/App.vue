
<script setup lang="ts">
import { RouterLink, RouterView } from "vue-router";
import menuDisque from "./components/Menu.vue"

// definir si on se sert d'une request pour get all disque on mutiple

// /artists to get list of artiste + queenn to get all element
// /collection to get all
// menu-> home
//rajoyté une étiquette au centre du disque comme les vynil pour le titre   
//icon de page vinyl ou note de music 

// button mon compte -> modale de connection
// pge info du compte
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

