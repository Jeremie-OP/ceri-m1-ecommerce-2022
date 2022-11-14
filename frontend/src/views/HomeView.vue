<script setup lang="ts">
  import { onMounted } from "@vue/runtime-core";
  import axios from "axios";
  import carousel from "../components/Carousel.vue";

  onMounted(() => {
    let result = axios.get("https://reqres.in/api/users?page=1"); //no await
    console.log(result);

    })
</script>

<template>
  <!-- <div class="separate"></div> -->
   <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
    <div class="warpper"> 
      <carousel class="menu" title="test"/>
    </div>
</template>

<style>
  @media (max-width: 900px) {
    /* .separate{
      padding-top: 18rem;
    } */
    .warpper{
      /* background-color: aqua; */
      padding: 1.5rem;
    }
  }

  @media (min-width: 900px){
    .warpper
    {
      /* background-color: brown; */
      /* padding: 15px; */
   
    }

    .menu{
      margin-top: 3.5rem;
    }
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
</style>