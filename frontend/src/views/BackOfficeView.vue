<script >
  import { onMounted } from "@vue/runtime-core";
  import carousel from "../components/Carousel.vue";
  import { defineComponent } from 'vue'
  import { storeDisque } from '../stores/store';
  import  editProduct  from '../components/EditProducts.vue';
  
  export default defineComponent({
    setup(){
      const store = storeDisque()
      return {
        store,
      }
      
    },
    components:{
      editProduct
    },
    data() {
      return {
        listArticle: null,
        showEdit: false,
        article: null,
        ajout: false,
        // [{name:"null", id:0}]
      }
    },
    mounted() {
      this.store.getCollection().then((response) => {
        this.listArticle = response.data
      })
    },
    methods:{
      editThis(article){
        this.showEdit = true;
        this.article = article;
      },
      closeEdit(){
        this.showEdit = false;
        this.ajout = false;
      },
      deleteThis(article){
        this.store.deleteProduct(article)
      }
    }
  })
  
</script>

<template>
  <editProduct v-show="showEdit" @edit="closeEdit" :product="this.article" :ajout="this.ajout"></editProduct>
    vue du backoffice en tableau ? je pense
    <div class="container-table">
      <input type="button" class="button" v-on:click="editThis(article), this.ajout=true" value="ajouter un produit">

      <table >
        <thead>
          <tr>
            <th>Titre</th>
            <th>Artiste</th>
            <th>Genre</th>
            <th>Année</th>
            <th>Stock</th>
            <th>Prix</th>
            <th>Image</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody >
          <tr v-for="article in listArticle" :key="article.name">
            <td>{{ article.name }}</td>
            <td>{{ article.artist }}</td>
            <td>{{ article.genre }}</td>
            <td>{{ article.year }}</td>
            <td>{{ article.stock }}</td>
            <td>{{ article.price }}</td>
            <td>{{ article.image }}</td>
            <td>
              <input type="button" class="button" v-on:click="editThis(article), this.ajout=false" value="modifier">
              <input type="button" class="button" v-on:click="deleteThis(article)" value="Supprimer">
            </td>

          </tr>
        </tbody>
      </table>
    </div>
    
</template>

<style>
.container-table .button{
    background: rgb(41, 41, 41);
    color: white;
    padding: 1rem 1.5rem;
    border-radius: 100px;
    text-transform: uppercase;
    letter-spacing: 2px;
    margin: 0.5rem;
    /* transition: background .5s; */
}

.container-table .button:hover{
    background-color: rgba(41, 41, 41, 0.85);

}

table{
  border-collapse: collapse;
  width: 70%; /* 100% de la largeur de la page  a voir */
  box-shadow: 5px 5px 0 0 rgb(0 0 0 / 10%);

  /* border: 5px solid #E8E8E8;
  border-radius: 5px; */

  border-collapse: collapse;
  border-radius: 1rem;
  overflow: hidden;

  background: rgb(0 0 0 / 5%);

}
thead{
  background: rgb(0 0 0 / 7%);
}
th, td{
  padding: 8px;
  text-align: center;
}
.container-table{
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  gap: 1.5rem;
  /* height: 100vh; */
}
</style>
