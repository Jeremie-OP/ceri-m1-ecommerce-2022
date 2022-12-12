<script>
import Flickity from '../library/Flickity.vue';
import Products from '../components/Products.vue';
import axios from "axios";
import { defineComponent } from 'vue';


export default defineComponent({
    props: {
        title: String
    },
    components: {
        Flickity,
        Products
    },
    data(){
        return{
            listMusic: null
            // [{name:null}]
            // [{name: "null",artist: "Queen"}]
        }
    },
    setup(){
        if (window.innerWidth <=900)
        {
            // console.log("yesqdss",window.innerWidth)
            return {
                flickityOptions: {
                initialIndex: 0,
                draggable: true,
                prevNextButtons: true,
                pageDots: true,
                wrapAround: false
                }
            }
        }
        else{
            return {
                flickityOptions: {
                initialIndex: 0,
                groupeCells: true,
                groupCells: 4, "cellAlign": "center",
                prevNextButtons: true,
                pageDots: true,
                wrapAround: false,
                fade : true,
                }
            }
        }
       
    },
    created() {
        axios.get("http://localhost:8888/artist/"+this.title+"").then(response => (this.listMusic = response.data));
    }
})
</script>

<template>
    <div class="wrapper">
        <h2> {{title}}</h2>
        <flickity v-if="listMusic != null" ref="flickity" :options='flickityOptions' class="flickity" >
            <!-- repalce carousel by carousel-cell -->
            <div class="carousel-cell" v-for="music in listMusic" > 

                    <router-link class="blackLink" :to="{name: 'detail-product', params: { info:music.name} }" > 
                    <!-- :to="{name: 'detail-product', parmas: {id : n} }"  -->
                        <products  class="products" :titleMusic="music.name" price="10€"></products>

                    </router-link>
            </div>
            <router-view />

        </flickity>
    </div>
    
</template>


<style>
@media (max-width: 900px) {
    .carousel-cell {
        /* width: 50%; half-width */
        /* margin: 2rem; */
        display: flex;
        align-items: center;    
        justify-content: center;

    }
}
.wrapper{
    width: 100%;
}

.flickity{
    margin-bottom: 5rem;
}
.carousel-cell {
     visibility: hidden;
     opacity: 0;
    /* align-items: center; */
    /* background-color: lightgray; */
    /* display: flex; */
    font-size: 17px;
    /* justify-content: center; */
    width: 320px;
    margin-right: 1rem;
    transition: visibility 300ms linear 300ms, opacity 300ms;
    /* animation: fadeIn 0.6s;  */

    
}
/* 
@keyframes fadeIn {
  0% {
    opacity:1;
  }
  100% {
    opacity:0;
  }
}
.carousel-cell.none {
  display:none
} */

.carousel-cell.is-selected 
{
    visibility: visible;
    /* background-color: yellow; */
    opacity: 1;
    transition: visibility 300ms linear 300ms, opacity 300ms;

    
}

.blackLink{
    color: #000000;
  text-decoration: none;
}

h2{
    text-align: center;
}
</style>