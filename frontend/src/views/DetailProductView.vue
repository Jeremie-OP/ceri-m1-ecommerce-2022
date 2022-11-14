
<template>
  id: {{id}}
  <DetailProductsVue/>
</template>

<script setup lang="ts">
import { useRoute } from 'vue-router'
import DetailProductsVue from "../components/Detail-Products.vue";
const route = useRoute();
const id = route.params.id; // pass id of abulm or all info

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