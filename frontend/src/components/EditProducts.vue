
<template>
    <div class="modal-background-edit" v-on:click="close">
        <div  class="modal-mask-edit" >
            <div class="modal-container-edit" v-on:click.stop="">
                <div class="modal-header">
                    <h3 v-if="!this.ajout">{{ product?.name }}</h3>
                    <h3 v-if="this.ajout">Nouveau produit</h3>

                </div>
                <div class="moddal-body">
                    <form v-on:submit.prevent="edit()">
                        <div class="form-item">
                            <span class="form-item-icon material-symbols-rounded">album</span>
                            <input type="text" v-model="productToEdit.name"><br>
                            <!-- *:value="product.name" -->
                            <!-- <span class="error-message" v-for="error in v$.signIn.fullname.$errors" :key="error.$uid">{{error.$message}}</span> -->
                        </div>
                        <div class="form-item">
                            <span class="form-item-icon material-symbols-rounded">person</span>
                            <input type="text" v-model="productToEdit.artist"><br>
                            <!-- *:value="product.name" -->
                            <!-- <span class="error-message" v-for="error in v$.signIn.fullname.$errors" :key="error.$uid">{{error.$message}}</span> -->
                        </div>
                        <div class="form-item">
                            <span class="form-item-icon material-symbols-rounded">theater_comedy</span>
                            <input type="text" v-model="productToEdit.genre"><br>
                            <!-- *:value="product.name" -->
                            <!-- <span class="error-message" v-for="error in v$.signIn.fullname.$errors" :key="error.$uid">{{error.$message}}</span> -->
                        </div>
                        <div class="form-item">
                            <span class="form-item-icon material-symbols-rounded">today</span>
                            <input type="text" v-model="productToEdit.year"><br>
                            <!-- *:value="product.name" -->
                            <!-- <span class="error-message" v-for="error in v$.signIn.fullname.$errors" :key="error.$uid">{{error.$message}}</span> -->
                        </div>
                        <div v-if="!this.ajout">
                            <h3>Stock</h3>
                            <button type="button" class="button" v-on:click="minus()" name=add>
                                <span class="material-symbols-rounded">remove</span>
                            </button>
                            
                            <!--  -->
                            <span class="stock">{{ this.productToEdit.stock }}</span>
                            <button type="button" class="button"  v-on:click="this.productToEdit.stock++" name=add>
                                <span class="material-symbols-rounded">add</span>
                            </button>
                            
                        </div>
                        <div v-if="this.ajout">
                            <div class="form-item">
                                <span class="form-item-icon material-symbols-rounded">inventory</span>
                                <input type="text" v-model="productToEdit.stock"><br>
                                <!-- *:value="product.name" -->
                                <!-- <span class="error-message" v-for="error in v$.signIn.fullname.$errors" :key="error.$uid">{{error.$message}}</span> -->
                            </div>
                        </div>
                        <h3> List des piste</h3>
                        <div v-if="this.ajout">
                           
                            <input type="button" class="button" name=create v-on:click="ajoutTrack()" value="ajout d'un piste">
                            <!-- <input type="submit" class="button" name=create value="ajouter"></input> -->
                        </div>
                        <div class="form-item" v-for="(track, index) in productToEdit.tracks" :key="track.number">
                            <span class="form-item-icon material-symbols-rounded">music_note</span>
                            <input type="text" v-model="productToEdit.tracks[index].title"><br>
                            <!-- *:value="product.name" -->
                            <!-- <span class="error-message" v-for="error in v$.signIn.fullname.$errors" :key="error.$uid">{{error.$message}}</span> -->
                        </div>
                        <div v-if="!this.ajout">
                            <input type="submit" class="button" name=create value="editer">
                        </div>
                        <div v-if="this.ajout">
                            <input type="submit" class="button" name=create value="ajouter">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                <!-- <button class="modal-default-button" v-on:click="close">OK</button> -->
            
                </div>
            </div>
        </div>

    </div>
    
</template>

<script >
import { storeDisque } from '../stores/store';
import useValidation from '@vuelidate/core';
import { required, email, sameAs } from '@vuelidate/validators';
import { helpers } from '@vuelidate/validators'

export default {
    setup(){
        const store = storeDisque()
        return {
            store,
        }
    },
    props: {
        show: {
            type: Boolean,
            required: true
        },
        product: {
            type: Object,
            required: true
        },
        ajout: {
            type: Boolean,
            required: true
        }
    },
    data(){
        return{
        islogin: true,
        msg: [],
        productToEdit: {
            name: '',
            artist: '',
            genre: '',
            year: '',
            number_of_tracks: '',
            tracks: [],
            stock: 0,
            id:0
        }
        }
    },
    watch: {
        product(value){
            //if product change, update the productToEdit
            this.productToEdit = {
                name: value.name,
                artist: value.artist,
                genre: value.genre,
                year: value.year,
                number_of_tracks: value.number_of_tracks,
                tracks: value.tracks,
                stock: 1,
                id: value.id
            }
            this.getStock()
            
        },
        ajout(value){
            this.productToEdit = {
                name: 'nom du disque',
                artist: 'nom de l\'artiste',
                genre: 'gernre du disque',
                year: 'année de sortie',
                number_of_tracks: 0,
                tracks: [],
                stock: "stocke du produit",
                
            }
        }
    },
    methods: {
        minus(){
            if (this.productToEdit.stock > 1)
            {
                this.productToEdit.stock--
                this.store.changeStock(this.productToEdit.stock, this.productToEdit.id)
            }
        },
        add(){
            this.productToEdit.stock++
            this.store.changeStock(this.productToEdit.stock, this.productToEdit.id)
        },
        close() {
            this.$emit("edit", "close");
            document.body.classList.remove("modal-open");
            
        },
        edit(){
            if (this.ajout == true)
            {
                this.store.addProduct(this.productToEdit)

            }
            else
            {
                this.store.editProduct(this.productToEdit)
            }

        },
        ajoutTrack(){
            this.productToEdit.tracks.push({
                number: this.productToEdit.tracks.length + 1,
                title: 'nom de la piste'
            })
            this.productToEdit.number_of_tracks = this.productToEdit.tracks.length+1
        },
        async getStock()
        {
            this.productToEdit.stock = await this.store.getStock(this.product.id)
        }
    },
}
</script>


<style>

.stock{
    margin: 25px;
    font-size: 20px;
}

.body.modal-container-edit{
    position: fixed;
}

.modal-background-edit {
    position: fixed;
    z-index: 3;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.3);
    display: table;
    transition: opacity 0.3s ease;
}

.modal-mask-edit {
    position: fixed;
    z-index: 4;
    top: 0;
    left: 0;
    width: 100%;
    height: 90%;
    /* background-color: black; */
    /* display: table; */
    display: flex;
    align-items: flex-start;    
    justify-content: center;
    padding-top: 100px;
    overflow: auto;

    transition: opacity 0.3s ease;
}


.modal-container-edit {

    width: auto;/* auto ou 350*/
    height: auto;/* auto 520 */
    border-radius: 10% ;
    /* margin: 0px auto; */
    padding: 20px 30px;
    background-color: rgba(255, 255, 255, 0.8);
    border-color: #2a2928;
    border-radius: 10px;
    /* box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33); */
    /* transition: all 0.3s ease; */
    position: relative;

}
.modal-container-edit::before {
    
    content: '';
    position: absolute;
    background-color: rgba(255, 255, 255, 0.6);
    inset: 0;
    /* 5deg */
    transform: rotate(5deg);  /* calc((100% * 5deg)/520px) */
    z-index: -1;
}

.modal-default-button {
    float: right;
}

.modal-header{
    position: relative;
    display: flex;
    justify-content: space-between;
    border: 1px solid gray;
    border-radius: 5px;
    overflow: hidden;
    height: 40px;
}
.modal-header .change{
    z-index: 1;
    text-align: center;
    height: 100%;
    width: 100%;
    font-size: 18px;
    line-height: 40px;
    cursor: pointer;
    color: black;
}

.modal-header .change-tab{
    position: absolute;
    height: 100%;
    width: 50%;
    left: 0;
    z-index: 0;
    background-color: #2a2928;
}

input[type="radio"]{
    display: none;
}
#create:checked ~ .change-tab{
    left: 50%;
    /* color: black; */
}
#login:checked ~ .login{
    color: white;
}
#create:checked ~ .create{
    color: white;
}

.error-message {
    font-weight: bold; 
    color: red;
    top:1rem;
    margin: 1rem;
}

.form-item{
    position: relative;
}

.form-item .form-item-icon{
    position: absolute;
    top: 0.85rem;
    left: 1.4rem;
    font-size: 1.3rem;
    opacity: .4;
}

.form-item input[type=text],
.form-item input[type=password]{
    border: none;
    outline: none;
    background-color: rgba(255 , 255, 255, 0.95);
    padding: 1rem 1.5rem;
    padding-left: calc(1rem *3.5);
    border-radius: 100px;
}




.modal-mask input{
    /* outline: none;
    border-radius: 100px;
    border-width: 2px;
    font-size: 22px; */

}

.modal-mask-edit form{
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 1.5rem;
    margin: 1rem;
    padding: 1rem;
}


.modal-mask-edit .button{
    background: black;
    color: white;
    padding: 1rem 1.5rem;
    border-radius: 100px;
    text-transform: uppercase;
    letter-spacing: 2px;
    /* transition: background .5s; */
}

.modal-mask-edit .button:hover{
    background-color: rgba(0, 0, 0, 0.85);

}
</style>