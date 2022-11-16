
<template>
  <DetailProductsVue :info="info[0]"/>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router'
import DetailProductsVue from "../components/Detail-Products.vue";
const route = useRoute();
// name: music.name, gerne: music.gerne, year: music.year, trackNb: music.number_of_tracks, track: music.track} }"> 
const info = route.params.info



</script>

<style>

  .warpper
  {
    /* background-color: brown; */
    /* padding: 2rem; */
  }

  .warpper:nth-child(6n+1){
    background-color: hsla(0, 100%, 90%, 1);
  }

  .warpper:nth-child(6n+3){
    background-color: hsla(215, 100%, 90%, 1);
  }

  

  .warpper:nth-child(6n+5){
    background-color: hsla(64, 100%, 90%, 1)
  } 

  .menu{
    margin-top: 3.5rem;
    
 
  }
</style>