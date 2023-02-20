<script setup lang="ts">
import Header from './components/Header.vue'

</script>

<template  >
<Header class="header"></Header>
<!-- <router-view></router-view> -->

</template>

<style scoped>
.header{
    width: 100vw;
    height: 70px;
    display: inline-block;
    position: fixed;
    top: 0  ;
    left: 0;
    background-color: rgba(0,0,0,.2);
}
</style>
