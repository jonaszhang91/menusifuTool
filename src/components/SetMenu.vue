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
import { replace } from 'lodash'
import { ref } from 'vue'
import { select } from '../Api/api'
import PrinterSet from './PrinterSet.vue'
const conIP: any = ref('localhost')

const printList = ref([])
const creditList = ref([])
const printId = ref('none')
const printSet = ref(null)
const handleOpen = (key: string, keyPath: string[]) => {
	// console.log(key, keyPath)
}
const handleClose = (key: string, keyPath: string[]) => {
	// console.log(key, keyPath)
}
// -------------
const getPrinter= async ()=>{
    conIP.value = localStorage.getItem('ip')
    console.log(conIP.value);
    
    let printer =  await select(conIP.value,'SELECT name,real_name,interface_value,id from printer')
    printList.value = printer
    
   
}//获取打印机信息
// -------------
//获取信用卡信息
const getCredit = async ()=>{
    let data = 'SELECT name,ip_address,id from device where deleted = 0 and manufacturer_name = "PAX"'
    let credit = await select(conIP.value,data)
    creditList.value = credit
} 
const getPandC = async ()=>{
        await getPrinter();
        await getCredit();

}
// -------------
//---------点开打印机详情------------
const setPrinter = async (data)=>{
    await function infoId(){
        printId.value = data}()
    console.log(printId.value);
    printSet.value.init()
    let elPrint = document.getElementById('printerSet')
    elPrint.style.left = '180px'
    
}
//----------------------------
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
            <!-- -------- 获取打印机--------- -->
				<el-sub-menu index="1">
					<template #title>
						<el-icon><Printer /></el-icon>
						<span>打印机</span>
					</template>
					<el-menu-item-group v-for="i in printList" :title=i.name>
						<el-menu-item @click="setPrinter(i.id)" v-if="i.real_name" >{{i.real_name}}</el-menu-item>
                        <el-menu-item @click="setPrinter(i.id)" v-if="i.interface_value" >{{i.interface_value}}</el-menu-item>
					</el-menu-item-group>
				</el-sub-menu>
                <!-- ----------------- -->
                <!-- ---------获取刷卡机-------- -->
				<el-sub-menu  index="2">
                    <template #title>
					<el-icon><CreditCard /></el-icon>
					<span>刷卡机</span>
                </template>
                    <el-menu-item-group v-for="i in creditList" :title=i.name>
                            <!-- <el-menu-item v-if="i.name" >{{i.name}}</el-menu-item> -->
                            <el-menu-item v-if="i.ip_address" >{{i.ip_address}}</el-menu-item>
                        </el-menu-item-group>
				</el-sub-menu >
                <!-- ----------------- -->
			</el-menu>
		</el-col>
        <!-- ------- 打印机设置模块---------- -->
        <PrinterSet ref="printSet" :info="printId" id="printerSet" @replace= 'getPrinter'></PrinterSet>
        <!-- ----------------- -->
	</div>
</template>

<style scoped>
.menu{
    height: 100%;
    width: 170px;
}
#printerSet{
    display: inline-block;
    position: absolute;
    left: -600px;
    top: 0;
    background: rgb(243, 245, 247);
    width: 500px;
    padding: 20px;
    transition: all 1000ms;
    
}
</style>
