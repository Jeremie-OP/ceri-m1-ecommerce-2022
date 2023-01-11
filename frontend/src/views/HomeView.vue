<script >
  import { onMounted } from "@vue/runtime-core";
  import axios from "axios";
  import carousel from "../components/Carousel.vue";
  import { defineComponent } from 'vue';
  import { storeDisque } from '../stores/store';
  
  // let listArtist = axios.get("http://localhost:8888/artists");
  // console.log(listArtist);
  export default defineComponent({
    setup(){
      const store = storeDisque()
      return {
        store
      }
      
    },
    components:{
      carousel
    },
    data() {
      return {
        listArtist: null
        // [{name:"null", id:0}]
      }
    },
    async created() {
      // axios.get("http://localhost:8888/artists").then(response => (this.listArtist = response.data));
      this.listArtist = await this.store.getArtists();
    }
  })
  
</script>

<template>
  <!-- <div class="separate"></div> -->
  <!-- v-for="n in 10" :key="n" -->
  <!-- {{listArtist}} -->
  <div class="warpper" v-for="artiste in listArtist" > 
    <carousel class="menu" :title="artiste.name"/>
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
