

<template>
    <flickity ref="flickity" :options='{"initialIndex": 0,
            "groupCells": true,
            }'>
        <div v-for="n in 10" :key="n">
            <div class="carousel-cell">{{n}}</div>
        </div>
    </flickity>
</template>
<script lang="ts">
import Flickity from './Flickity.vue';

export default({
    Data() {
        return {
            flickityOptions: {
            initialIndex: 0,
            groupCells: true,
            draggable: false,
            prevNextButtons: true,
            pageDots: true,
            wrapAround: false
            }
        }
    },
    components: {
        Flickity
    },
    
    mounted() {
    this.resize();
    },
    methods: {
        resize() {
            this.$refs.flickity.resize();
        }
    }
})
</script>

<style>
.carousel-cell {
  align-items: center;
  background-color: lightgray;
  display: flex;
  font-size: 32px;
  height: 300px;
  justify-content: center;
  width: 500px;
}
</style>