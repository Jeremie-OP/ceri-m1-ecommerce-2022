<template>
    <div class="container">
        <img src="../img/Content.png" alt="Content of vynil" width="420" height="420">
        <div class="description">
            <h2>Titre</h2>
            <h5>Prisx</h5>

            <p>Detail:Aenean vulputate orci eu augue aliquet, aliquam molestie sapien iaculis. Pellentesque lobortis turpis et sem viverra ultrices. Proin laoreet nulla at semper hendrerit. Sed ut eros in tortor tempor sollicitudin. Morbi vel ultricies tortor. Phasellus ullamcorper magna et sagittis ornare. Nulla facilisi. Aenean hendrerit ipsum quis nibh rhoncus, sed tempus sapien feugiat. Cras auctor, elit a volutpat blandit, lacus erat molestie tortor, gravida condimentum justo nulla a nunc. In bibendum nisl diam, vitae blandit justo pellentesque quis. Fusce in placerat erat. Praesent nulla odio, venenatis sed libero ut, iaculis elementum sem. Integer ornare eget tortor nec malesuada. Sed porttitor ligula in mauris dignissim, id tristique odio ullamcorper. Morbi vel dolor ut nibh vehicula euismod. Cras facilisis leo eget rutrum porta.

</p>   
        </div>
    </div>
</template>

<script setup lang="ts">

</script>

<style>
.container
{
    display: flex;
    justify-content: center;
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