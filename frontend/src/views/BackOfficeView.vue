<script >
  import { onMounted } from "@vue/runtime-core";
  import carousel from "../components/Carousel.vue";
  import { defineComponent } from 'vue'
  
  export default defineComponent({
    setup(){
      
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
    mounted() {
      
    }
  })
  
</script>

<template>
    vue du backoffice en tableau ? je pense
    
</template>

<style>
</style>
