<script >
  import { onMounted } from "@vue/runtime-core";
  import axios from "axios";
  import { defineComponent } from 'vue'
  import  shoppingProducts from '../components/ShoppingProducts.vue';
  import { storeDisque }  from '../stores/store';
  
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
        shoppingProducts
    },
    data() {
      return {
        cart:null,
        price: 0,
        amount: 0,
        // listArtist: null
        // [{name:"null", id:0}]
      }
    },
    created() {
      this.updateList()
      
    },
    mounted() {
    },
    methods:{
      updateList(){
        console.log("update")
        this.cart = this.store.getCart()
        this.price = 0
        this.amount = 0
        if (this.cart == null)
          return
        for (let i = 0; i < this.cart.length; i++) {
          if(this.cart[i].item.price == null)
            this.cart[i].item.price = 0
          this.price += this.cart[i].item.price * this.cart[i].amount;
          this.amount += this.cart[i].amount;
        }
      },
      command(){
        this.store.command()
        this.store.cart=[]
      }
    }
  })
  
</script>

<template>
<div class="container-cart">
  <div class="contnaire-list"  >
    <shoppingProducts @updateList="updateList" @updateAmount="updateAmount" v-if="cart != null" v-for="disk in cart" :amount="disk.amount" :item="disk.item"></shoppingProducts>

  </div>
  <div class="summary">
    <h2>Résumé de la commande</h2>
    
    <div class="textbox">
      <h3 class="alignleft">Nombre d'articles : </h3>
      <h3 class="alignright">{{ this.amount }}</h3>
    </div>
    <div class="textbox">
      <h3  class="alignleft">Total a payer : </h3>
      <h3  class="alignright">{{ price }}€</h3>
    </div>
    <div style="clear: both;"></div>
    <button class="button-command" @click="command()" >Passer commande</button>
  </div>

</div>




</template>

<style>
.textbox{
  border-top: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
  width: 90%;
}
.alignleft{
  text-align: left;
  float: left;
}

.alignright{
  text-align: right;
  float: right;
}

.summary
{
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 1.5rem;
    padding: 0.5rem;

    /* flex-direction: column; */
    background-color: rgb(0 0 0 / 10%);
    margin: 1.5rem;
    padding: 1.5rem;
    gap: 1rem;
    border: 1px solid black;
    box-shadow: 5px 5px 0 0 rgb(0 0 0 / 20%);
    border: 1px solid #E8E8E8;
    border-radius: 5px;
    width: 18rem;
}
.container-cart{
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: flex-start;
    margin: 1.5rem;
    padding: 0.5rem;
}
.container-list{
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    margin: 1.5rem;
}

.button-command{
    height: 3rem;
    background-color:  rgb(0 0 0 / 80%);
    border: none;
    /* border-radius: 0.5rem; */
    border-radius: 100px;
    color: white;
    font-size: 1.5rem;
    font-weight: bold;
    margin-top: 1rem;
    margin-bottom: 1rem;
    cursor: pointer;
}
</style>
