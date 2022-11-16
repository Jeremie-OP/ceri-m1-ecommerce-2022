<template>
  <div class="products" alt="disque">
    </div>
    <div class="info">
      <h5>{{titleMusic}}</h5>
      <p>{{price}}</p>
    </div>

</template>

<script lang="ts">

import Vue from 'vue'
export default({
   props: {
        titleMusic: String,
        price: String
    },
    created(){
   
    }

    
})
// ../img/CoverArt.webp
// probleme size img
</script>

<style>
.products{
  border-radius: 50%;
  width: 300px;
  height: 300px;
  background-color: aqua;
  background-image: url("../img/CoverArt.png");
  background-size: 300px;
  transition: 0.6s;


}
.products:hover {
  background-image: url("../img/Content.png");
  background-size: 300px;
  transition: 0.6s;
}

p, h5
{
  

  text-align: center;
  margin: 0.5rem;
}

@media (max-width:960px) {
  .products{
    width: 220px;
    height: 220px;
    background-size: 220px;

  }
  .products:hover{
    background-size: 220px;
  }
}
</style>


