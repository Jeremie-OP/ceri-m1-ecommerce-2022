<template>
  <div class="disque">
    <div class="in-disque">
      <router-link to="/backoffice">
        <button :class="!isAdmin ? 'hidden' : 'deg140'">
          <span class="material-symbols-rounded bold" style="font-size: 57px;">inventory_2</span>
        </button>
      </router-link>

      <!-- transform: rotate(115deg) translate(24rem) rotate(-115deg);  -->
      <button :class="isAdmin ? 'deg115' : 'deg130'">
        <span class="material-symbols-rounded bold" style="font-size: 67px;">search</span>
      </button> <!-- class="deg115"  -->

      <router-link to="/">
        <!-- class="deg90" -->
        <button :class="isAdmin ? 'deg90' : 'deg105'">
          <span class="material-symbols-rounded bold"  style="font-size: 67px;">home</span>
        </button>
      </router-link>
      <!-- class="deg65" -->
      <button :class="isAdmin  ? 'deg65' : 'deg75'" id="show-modal" v-on:click="tryThis">
        <span class="material-symbols-rounded bold" style="font-size: 67px;">account_circle</span>
      </button>

      <!-- class="deg40" -->
      <router-link to="/shopping-cart">
        <button :class="isAdmin ? 'deg40' : 'deg50'">
          <span class="material-symbols-rounded bold" style="font-size: 57px;">shopping_cart</span>
        </button>
      </router-link>

      <!-- <button class="deg90">memnu</button> -->
    </div>
  </div>


</template>
  
<script >
import { defineComponent, ref } from 'vue';
import { storeAccount } from '../stores/store';

export default defineComponent({
  setup() {
    const store = storeAccount()
    return {
      store
    }
  },
  Component: {
  },
  emits: ["showModal"],
  data() {
    return {
      showModal: false,
      islog: false,
      isAdmin: this.store.isAdmin(),
    }
  },
  methods: {
    tryThis() {
      this.islog = this.store.isConnected()
      if (!this.islog) {
        document.body.classList.add("modal-open");
        this.$emit("showModal", "account");
      }
      else {
        document.body.classList.add("modal-open");
        this.$emit("showModal", "profile");
      }

    },
    ifadmin() {
      console.log(",qjsdfhkjqeshfduqshf")

    }
  },
  mounted() {
    this.islog = this.store.isConnected()
  }
})
</script>
  
<style>
.bold {
  font-variation-settings:
    'FILL' 1,
    'wght' 700,
    'GRAD' 0,
    'opsz' 48
}

.hidden {
  display: none;
}


@media (max-width: 900px) {
  .separate {
    padding-top: 18rem;
  }
}

.disque {
  z-index: 1;
  width: auto;

}


@media screen and (min-width: 900px) {
  
  .deg0 {
    transform: translate(24rem)
  }

  .deg40 {
    transform: rotate(40deg) translate(24rem) rotate(-40deg);
  }

  .deg50 {
    transform: rotate(50deg) translate(24rem) rotate(-50deg);
  }

  .deg65 {
    transform: rotate(65deg) translate(24rem) rotate(-65deg);
  }

  .deg75 {
    transform: rotate(75deg) translate(24rem) rotate(-75deg);
  }

  .deg105 {
    transform: rotate(105deg) translate(24rem) rotate(-105deg);
  }

  .deg115 {
    transform: rotate(115deg) translate(24rem) rotate(-115deg);
  }

  .deg130 {
    transform: rotate(130deg) translate(24rem) rotate(-130deg);
  }

  .deg140 {
    transform: rotate(140deg) translate(24rem) rotate(-140deg);
  }

  .deg90 {
    transform: rotate(90deg) translate(24rem) rotate(-90deg);
  }

  .data {
    position: relative;
    top: 40rem;
  }

  .disque {
    /*position: sticky;*/
    background:
      linear-gradient(30deg, transparent 40%, rgba(42, 41, 40, .85) 40%) no-repeat 100% 0,
      linear-gradient(60deg, rgba(42, 41, 40, .85) 60%, transparent 60%) no-repeat 0 100%,
      repeating-radial-gradient(#2a2928, #2a2928 4px, #ada9a0 5px, #2a2928 6px);
    background-size: 50% 100%, 100% 50%, 100% 100%;
    border-radius: 50%;
    border-top: 0;
    height: 55rem;
    width: 55rem;
    border: 1vh solid #17202a;
    margin-top: -40rem;
    margin-left: auto;
    margin-right: auto;
    left: 0;
    right: 0;

  }


  .in-disque {
    margin: 5%;
    border-radius: 50%;
    /*background-color: green;*/
    height: 50rem;
    width: 50rem;
    margin: 5% auto;
  }

  .in-disque button {
    /* backgroud-color: white; */
    border-radius: 50%;
    color: black;

    display: block;
    position: absolute;
    top: -11rem;
    left: 50%;
    width: 6em;
    height: 6em;
    margin: -3em;

    border: solid 1px #d9a388;
    border-radius: 50%;
    box-shadow: 0 0 0 4px #da5b33,
      inset 0 0 0 17px #da5b33;
    background: #b5ac9a;
  }

  .in-disque button:hover {
    box-shadow: 0 0 0 4px #b94522,
      inset 0 0 0 17px #b94522;
    background: #a0947e;
  }





}

@media screen and (max-width: 900px) {
  body {
    width: auto !important;
    overflow-x: hidden !important
  }

  .data {
    position: relative;
    top: 16rem;
  }

  .disque {
    position: relative;
    background:
      linear-gradient(30deg, transparent 40%, rgba(42, 41, 40, .85) 40%) no-repeat 100% 0,
      linear-gradient(60deg, rgba(42, 41, 40, .85) 60%, transparent 60%) no-repeat 0 100%,
      repeating-radial-gradient(#2a2928, #2a2928 4px, #ada9a0 5px, #2a2928 6px);
    background-size: 50% 100%, 100% 50%, 100% 100%;
    border-radius: 50%;
    height: 25rem;
    width: auto;
    border: 1vh solid #17202a;
    margin: -15rem auto;
    left: 0;
    right: 0;
    margin-bottom: 0;


  }

  .in-disque {
    position: absolute;
    top: 14rem;
    right: 0rem;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.5rem;



  }

  .in-disque button {
    /* backgroud-color: white; */
    border-radius: 50%;
    color: black;

    top: 50%;
    left: 50%;
    width: 5em;
    height: 5em;
    margin: 1rem;

    border: solid 1px #d9a388;
    border-radius: 50%;
    box-shadow: 0 0 0 4px #da5b33,
      inset 0 0 0 17px #da5b33;
    background: #b5ac9a;
  }

  .in-disque button:hover {
    box-shadow: 0 0 0 4px #b94522,
      inset 0 0 0 17px #b94522;
    background: #a0947e;
  }

}
</style>