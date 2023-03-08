<script setup lang="ts">
import { reactive, ref } from 'vue'
import { getPrint, select, upDate } from '../Api/api'
import { toRefs, defineProps } from 'vue'
import { el } from 'element-plus/es/locale';
// do not use same name with ref
const emite = defineEmits(['replace'])
const props = defineProps({
	info: String,
})
const { info } = toRefs(props)
const form = reactive({
	name: null, //打印机名称
	ipaddr: null, //ip地址
	cut: 0, // 切纸模式
	Lang: 0, //语言
	SecLang: null, //第二语言
	ThrLang: null, //第三语言
	print: 'default', //本地打印机
	type: 'PRINTER',
})
const conIP = ref()
const localPrinter: any = ref([]) //本地打印机列表
const langList: any = ref([])
const printMsg: any = reactive({})
//--------------获取数据设置-----------------
const getPrintSet = async () => {
	console.log(info)
	conIP.value = localStorage.getItem('ip')

	let data =
		'SELECT name,real_name,language_setting,second_language_id,third_language_id,print_one_item_per_ticket,printer_type,interface_value from printer where id=' +
		info?.value
	// console.log(data);
	let pm: any = await select(conIP.value, data)
	Object.assign(printMsg, pm[0])
}
//------------------------------------
//----------------获取语言------------------
const getLang = async () => {
	conIP.value = localStorage.getItem('ip')
	let data = 'SELECT name,id from system_language where enabled = 1'
	langList.value = await select(conIP.value, data)
}
//---------获取本地打印机详情-------------
const getPrinter = async () => {
	conIP.value = localStorage.getItem('ip')
	localPrinter.value = await getPrint(conIP.value)
	console.log(localPrinter.value)
}
//-----------------------------

//------------提交--------------
const onSubmit = async () => {
	printMsg.name = form.name
	printMsg.interface_value = form.ipaddr
	printMsg.print_one_item_per_ticket = form.cut
	printMsg.language_setting = form.Lang
	printMsg.second_language_id = form.SecLang //第二语言
	printMsg.third_language_id = form.ThrLang //第三语言
	printMsg.real_name = form.print
	printMsg.printer_type = form.type
	console.log(printMsg)
	// if (printMsg.id != null) {
		let upMsg = ''
		for (let i in printMsg) {
			console.log(i)
			console.log(printMsg[i])
			if (typeof printMsg[i] == 'string') {
				upMsg += i + '=' + '"' + printMsg[i] + '"' + ','
			} else {
				upMsg += i + '=' + printMsg[i] + ','
			}
		}
		upMsg = upMsg.slice(0, -1)
		// console.log();

		let data = 'UPDATE printer set ' + upMsg + '  where  id=' + info?.value
		console.log(data)
		conIP.value = localStorage.getItem('ip')
		await upDate(conIP.value, data)
	// }else{
    //     if(printMsg.name & printMsg.real_name){
    //         let inKey =''
    //         let inData = ''

    //     }else{
    //         console.log('数据不全');
    //         //需要为
    //     }
        
        
    // }

	emite('replace')
}
//------------------------------
//----------同步数据-----------
const asData = () => {
	console.log(printMsg)
	// for( let i in printMsg ){
	//     printMsg[i] = String(printMsg[i])
	//     console.log(printMsg[i]);

	// }
	form.name = printMsg.name
	form.ipaddr = printMsg.interface_value
	form.cut = printMsg.print_one_item_per_ticket
	form.Lang = printMsg.language_setting
	form.SecLang = printMsg.second_language_id //第二语言
	form.ThrLang = printMsg.third_language_id //第三语言
	form.type = printMsg.printer_type
    if(printMsg.real_name){
        form.print = printMsg.real_name
    }
	
}
//------------------------
//----------初始化---------
const init = async () => {
	await getPrinter()
	await getLang()
	await getPrintSet()
	await asData()
	// document.getElementById('printerSet')
}
//----------------------
//----------暴露给父组件的方法-----------
defineExpose({
	init,
})
</script>

<template>
	<el-form :model="form" label-width="120px">
		<el-form-item label="打印机">
			<el-input v-model="form.name" />
		</el-form-item>
		<el-form-item label="打印类型">
			<el-select v-model="form.type" placeholder="设置打印类型">
				<el-option label="PRINTER" value="PRINTER" />
				<el-option label="DISPLAY" value="DISPLAY" />
			</el-select>
		</el-form-item>
		<el-form-item v-if="!printMsg.interface_value" label="选择打印机">
			<el-select
				v-model="form.print"
				placeholder="选择相应的打印机驱动"
				@click="getPrinter"
			>
            <el-option  label="默认" value="default" />
				<el-option v-for="i in localPrinter" :label="i" :value="i" />
				<!-- <el-option label="Zone two" value="beijing" /> -->
			</el-select>
		</el-form-item>
		<el-form-item v-if="printMsg.interface_value" label="ip地址">
			<el-input v-model="form.ipaddr" />
		</el-form-item>
		<el-form-item label="设置切菜模式">
			<el-select v-model="form.cut" placeholder="设置切菜模式">
				<el-option label="无设置" :value="0" />
				<el-option label="一套餐一切" :value="1" />
				<el-option label="一子菜一切" :value="2" />
			</el-select>
		</el-form-item>
		<el-form-item label="设置语言模式">
			<el-select v-model="form.Lang" placeholder="设置语言">
				<el-option label="主语言" :value="0" />
				<el-option label="第二语言" :value="1" />
				<el-option label="第三语言" :value="2" />
				<el-option label="主语言加第二语言" :value="3" />
				<el-option label="主语言加第三语言" :value="4" />
				<el-option label="第二语言加主语言" :value="5" />
				<el-option label="全部" :value="6" />
				<el-option label="简称" :value="7" />
				<el-option label="分块显示主语言和第二语言" :value="8" />
				<el-option label="打印第二和第三语言" :value="9" />
			</el-select>
		</el-form-item>
		<el-form-item label="第二语言">
			<el-select v-model="form.SecLang" placeholder="设置切菜模式">
				<el-option label="无" :value="null" />
				<el-option
					v-for="i in langList"
					:label="i.name"
					:value="i.id"
				/>
			</el-select>
		</el-form-item>
		<el-form-item label="第三语言">
			<el-select v-model="form.ThrLang" placeholder="设置切菜模式">
				<el-option label="无" :value="null" />
				<el-option
					v-for="i in langList"
					:label="i.name"
					:value="i.id"
				/>
			</el-select>
		</el-form-item>
		<el-form-item>
			<el-button type="primary" @click="onSubmit">确认</el-button>
			<el-button>取消</el-button>
		</el-form-item>
	</el-form>
</template>

<style scoped></style>
