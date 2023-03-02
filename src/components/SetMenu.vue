<script setup lang="ts">
import {
	Document,
	Menu as IconMenu,
	Location,
	Setting,
    Printer,
    CreditCard,
} from '@element-plus/icons-vue'
import axios from 'axios'
import { ref } from 'vue'
import { select } from '../Api/api'
import PrinterSet from './PrinterSet.vue'
const conIP: any = ref('localhost')

const printList = ref([])
const creditList = ref([])
const handleOpen = (key: string, keyPath: string[]) => {
	console.log(key, keyPath)
}
const handleClose = (key: string, keyPath: string[]) => {
	console.log(key, keyPath)
}

const getPrinter= async ()=>{
    conIP.value = localStorage.getItem('ip')
    console.log(conIP.value);
    
    let printer =  await select(conIP.value,'SELECT name,real_name,interface_value,id from printer')
    printList.value = printer
    
}//获取打印机信息

const getCredit = async ()=>{
    let credit = await select(conIP.value,'SELECT name,ip_address,id from device where deleted = 0 and manufacturer_name = "PAX"')
    creditList.value = credit
} 
const getPandC = async ()=>{
        await getPrinter();
        await getCredit();

}
const showid = (id)=>{
    console.log(id);
    
}
defineExpose({
    getPandC,
})
</script>

<template>
	<div>
		<el-col :span="27" class="menu">
			<el-menu
				active-text-color="#fff"
				background-color="#545c64"
				class="el-menu-vertical-demo"
				default-active="2"
				text-color="#fff"
				@open="handleOpen"
				@close="handleClose"
			>
				<el-sub-menu index="1">
					<template #title>
						<el-icon><Printer /></el-icon>
						<span>打印机</span>
					</template>
					<el-menu-item-group v-for="i in printList" :title=i.name>
						<el-menu-item v-if="i.real_name" >{{i.real_name}}</el-menu-item>
                        <el-menu-item v-if="i.interface_value" >{{i.interface_value}}</el-menu-item>
					</el-menu-item-group>
				</el-sub-menu>
				<el-sub-menu  index="2">
                    <template #title>
					<el-icon><CreditCard /></el-icon>
					<span>刷卡机</span>
                </template>
                    <el-menu-item-group v-for="i in creditList" :title=i.name>
                            <!-- <el-menu-item v-if="i.name" >{{i.name}}</el-menu-item> -->
                            <el-menu-item v-if="i.ip_address" @click='showid(i.id)'>{{i.ip_address}}</el-menu-item>
                        </el-menu-item-group>
				</el-sub-menu >
			</el-menu>
		</el-col>
        <PrinterSet class="printerSet"></PrinterSet>
	</div>
</template>

<style scoped>
.menu{
    height: 100%;
}
.printerSet{
    display: inline-block;
    position: absolute;
    left: 140px;
    top: 000px;
    background: rgb(243, 245, 247);
    width: 700px;
    padding: 20px;
    
}
</style>
