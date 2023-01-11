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
        listCommands: null,
        showEdit: false,
        article: null,
        ajout: false,
        commands: false,
        // [{name:"null", id:0}]
      }
    },
    mounted() {
      
    },
    async created() {
      this.store.getCollection().then((response) => {
        this.listArticle = response.data
      })
      this.store.getCommands().then((response) => {
        this.listCommands = response.data
      })
    },
    methods:{
      editThis(article){
        this.showEdit = true;
        this.article = article;
        document.body.classList.add("modal-open");
      },
      closeEdit(){
        this.showEdit = false;
        this.ajout = false;
      },
      deleteThis(article){
        this.store.deleteProduct(article)
      },
      switchCommBack(){
        this.commands=!this.commands
        console.log(this.commands)

      },
      valider(article){
        this.store.validerCommande(article)
      }
      
    }
  })
  
</script>

<template>
  <editProduct v-show="showEdit" @edit="closeEdit" :product="this.article" :ajout="this.ajout"></editProduct>
    <div class="container-table">
      <br>
      <div>
      <span type="button" class="button" v-on:click="editThis(article), this.ajout=true" >ajouter un produit</span> 

        <span v-show="!commands" type="button" class="button" v-on:click="switchCommBack()" >voir commande</span>
        <span v-show="commands" type="button" class="button" v-on:click="switchCommBack()" >voir ma liste article</span>
        
      </div>

      <table>
        <thead>
          <tr>
            <th>commands</th>
            <th>Artiste</th>
            <th>Genre</th>
            <th>Année</th>
            <th>Prix</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody >
          <tr  v-show="!commands" v-for="article in listArticle" :key="article.name">
            <td>{{ article.name }}</td>
            <td>{{ article.artist }}</td>
            <td>{{ article.genre }}</td>
            <td>{{ article.year }}</td>
            <td>{{ article.stock }}</td>
            <td>{{ article.price }}</td>
            <td>
              <input type="button" class="button" v-on:click="editThis(article), this.ajout=false" value="modifier">
              <input type="button" class="button" v-on:click="deleteThis(article)" value="Supprimer">
            </td>

          </tr>
          <tr  v-show="commands" v-for="article in listCommands" :key="article.name">
            <td>{{ article.name }}</td>
            <td>{{ article.artist }}</td>
            <td>{{ article.genre }}</td>
            <td>{{ article.year }}</td>
            <td>{{ article.stock }}</td>
            <td>{{ article.price }}</td>
            <td>
              <input type="button" class="button" v-on:click="valider(article), this.ajout=false" value="Valider">
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