<script>
  import { defineComponent } from 'vue'
  import { storeDisque } from '../stores/store';


 export default defineComponent({
    props: {
        amount: Number,
        item: Object
    },
    emits: ["updateList"],
    setup(){
        const store = storeDisque()
        return {
            store
        }
      
    },
    methods: {
        removeFromCart(item){
            this.store.removeFromCart(item)
        },
        update(){
            this.$emit("updateList")
            
        }
    },

  })
</script>


<template>
<div class="container-shopping-cart">
    <img src="../img/Content.png" alt="Content of vynil" style="width: 150px; height: 150px;">
    <router-link class="blackLink" @click="this.store.setDisk(item.name)" :to="{name: 'detail-product', params: { name: item.name} }">
        <h2>{{ item.name }}</h2>
    </router-link>
    <!-- <router-link @click="setItemOnStore(music)" class="blackLink" :to="{name: 'detail-product', params: { name: music.name} }" > 
        <products  class="products" :titleMusic="music.name" price="10€" ></products>
    </router-link> -->
    
    <h2 class="price">12€</h2>
    <div>
        <span @click="this.store.addAmount(item.name),update()" class="material-symbols-rounded button-amount">add</span>
        <input :value="amount" type="text" title="amount" class="input-amount">
        <span  @click="this.store.minusAmount(item.name), update()" class="material-symbols-rounded button-amount">remove</span>
    </div>
    <span @click="removeFromCart(item),update()" class="material-symbols-rounded remove-shopping-cart">remove_shopping_cart</span>

</div>
</template>

<style>
.input-amount{
    width: 30px;
    height: 30px;
    border: none;
    text-align: center;
    font-size: 1em;
    background-color: #E1E8EE;
    border-radius: 6px;
    color: #43484D;
    font-weight: 300;
    margin-left: 0.5rem;
    margin-right: 0.5rem;

}
.button-amount{
    text-align: center;
    vertical-align: sub;
    width: 30px;
    height: 30px;
    background-color: #E1E8EE;
    border-radius: 6px;
    border: none;
    cursor: pointer;
}

.remove-shopping-cart { 
    font-size: 53px;
    cursor: pointer; 
}

.container-shopping-cart{
    display: flex;
    /* flex-direction: column; */
    justify-content: space-between;
    align-items: center;
    margin: 1.5rem;
    padding: 1.5rem;
    gap: 1rem;
    box-shadow: 5px 5px 0 0 rgb(0 0 0 / 10%);
    border: 1px solid #E8E8E8;
    border-radius: 100px;
    width: 58rem;
    /* height: 220px; */
}
.container img{
    /* width: 13.5rem; */
    width: 220px;
    /* height: 100%; */
}
.price{
    /* width: 83px; */
    /* padding-top: 27px; */
    text-align: center;
    /* font-size: 1em; */
    color: #43484D;
    font-weight: 300;
}
</style>>