<script setup lang="ts">
import{ref} from 'vue'
import Header from './components/Header.vue'
import SetMenu from './components/SetMenu.vue';
const MenuDom = ref(null)
const ConnetMysql =()=>{
    // console.log('父组件');

    MenuDom.value.getPandC()
}

</script>

<template  >
<Header class="header" @ConnetMysql="ConnetMysql"></Header>
<!-- <router-view></router-view> -->
<SetMenu ref="MenuDom" class="setmenu"></SetMenu>
</template>

<style scoped>
.header{
    width: 100vw;
    height: 70px;
    display: inline-block;
    position: absolute;
    top: 0  ;
    left: 0;
    background-color: rgba(0,0,0,.2);
}
.setmenu{
    float: left;
    height: 100%;
    position: absolute;
    top: 72px;
    box-shadow: -1px -2px  rgba(0,0,0,.6);
}
</style>
