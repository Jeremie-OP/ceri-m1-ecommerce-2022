<template>
    <div class="container-product">
        <img src="../img/Content.png" alt="Content of vynil" width="420" height="420">
        <div class="description">
            <!-- {{ store.itemView }} -->
            <h2>{{name}} par {{ disk.artist }}</h2>
            <h5>disk.price</h5>
            <p>Album de {{ disk.artist }}, de {{ disk.year }}. Contenant les musics suivante</p>
            <ul>
                <li v-for="track in disk.tracks" :key="track.id" style="font-weight: bold;">{{ track.title }}</li>
            </ul>

        </div>
        <span @click="store.addToCart()" class="material-symbols-rounded add-shopping-cart">add_shopping_cart</span>
    </div>
</template>

<script >
  import { defineComponent, onMounted } from 'vue'
  import { storeDisque } from '../stores/store';

 export default defineComponent({
    setup(){
        const store = storeDisque()
        return {
            store,
            disk: store.itemView
        }
      
    },
    props: {
        name:String
    },
    onMounted(){
        console.log(this.info)
        
    }

  })
</script>

<style>
.add-shopping-cart{
    font-size: 73px;
    cursor: pointer;
}
.container-product
{
    display: flex;
    /* flex-direction: column; */
    justify-content: center;

    align-items: center;
    margin-top: 1.5rem;
    /* margin-left: 18.5rem;
    margin-right: 18.5rem; */
    margin-left: auto;
    margin-right: auto;

    padding: 1.5rem;
    gap: 1rem;
    border: 1px solid black;
    box-shadow: 5px 5px 0 0 rgb(0 0 0 / 10%);
    border: 1px solid #E8E8E8;
    border-radius: 5px;
    width: 65rem;
}
.description
{
    width: 100%; /* 500px*/
    max-width: 500px;
}
img{
    /* marche pas le ration est pas respecter  */
    max-width: 100%;
    width: 420px;

}
* {
    /* border: 1px solid red; */
}

@media (max-width: 900px) {
    .container{
        flex-direction: column;
    }    
}
</style>