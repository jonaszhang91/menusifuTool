<template>
	<head>
		<div class="logo"><img class="logoImg" src="../imgs/logo.png" /></div>
		<!-- logo -->
		<div class="connect">
			<!-- 链接设置 -->
			<el-input
				class="inputIp"
				v-model="input"
				placeholder="请输入id地址"
			>
				<!-- 输入功能： 点击提示  默认localhost 检测ip正确性 -->
				<template #append>
					<!-- 连接按键 -->
					<el-button class="btn" @click="connetBtn">
						<svg
							t="1676922392227"
							class="icon"
							viewBox="0 0 1024 1024"
							version="1.1"
							xmlns="http://www.w3.org/2000/svg"
							p-id="3121"
							width="30"
							height="30"
						>
							<path
								d="M560 512.414C560 453.643 512.357 406 453.586 406H204.414C145.643 406 98 453.643 98 512.414v0.172C98 571.357 145.643 619 204.414 619h249.172C512.357 619 560 571.357 560 512.586v-0.172z"
								fill="#666666"
								p-id="3122"
							></path>
							<path
								d="M630.024 211.105l20.067 16.805 124.46 103.419L818 366.98v0.146l39.008 33.527 24.734 21.15c22.165 18.618 35.789 41.557 41.386 65.588 5.395 23.169 2.94 47.343-7.045 69.656-7.398 16.532-19.033 32.047-34.867 45.347l-21.025 17.62a128.674 128.674 0 0 1-3.92 3.425l-40.2 33.659-42.484 35.575-118.372 99.341a133.759 133.759 0 0 1-5.123 4.078l-20.068 16.805c-36.162 30.236-79.744 36.785-117.069 22.211-24.069-9.397-45.542-27.555-60.722-53.889l-2.171-3.77c-5.856-13.007-9.497-27.58-10.563-43.322l-0.455 0.443s41.854-154.592 41.854-222.471-41.758-212.887-41.758-212.887c0.035-19.354 3.923-37.113 10.923-52.66l2.171-3.77c14.42-25.015 34.524-42.636 57.131-52.395a112.775 112.775 0 0 1 3.59-1.494c37.325-14.574 80.907-8.024 117.069 22.212z"
								fill="#666666"
								p-id="3123"
							></path>
						</svg>
					</el-button>
				</template>
			</el-input>
			<!-- 设置IP地址 -->
		</div>
		<div class="AcountView">
			<!-- 店铺信息 -->
			<div class="AcountName msg">{{ Acount.name }}</div>
			<div class="Phone msg">{{ Acount.telephone1 }}</div>
			<div class="Addr msg"></div>
		</div>
	</head>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'
const input = ref('localhost')
const Acount = ref({name:"店名",telephone1:"888-888-8888"})
const servertest = () => {
	axios.get('http://localhost:3030/mysqlcon').then((d) => {
		console.log(d.data[0])
        Acount.value = d.data[0]
        console.log(Acount.value);
	})
	// 连接数据库 获取店铺信息 
    
}
const connetBtn = () => {
	// console.log(input.value);
	let alertError = () => {
		alert('请输入正确的ip 地址')
		input.value = ''
		// 错误弹出
	}
	let IpAddr = input.value
	let conNum = 0
	// 正确ip的计数
	if (IpAddr != 'localhost') {
		let ipList = IpAddr.split('.')
		// console.log(ipList);
		// 验证ip 正确性
		if (ipList.length != 4) {
			alertError()
		} else {
			for (let i in ipList) {
				// console.log(ipList[i]);
				let num = Number(ipList[i])
				// console.log(num);
				if (num >= 0 && num <= 255) {
					conNum++
					// 正确的计数 增加
					// 下一步
				} else {
					alertError()
					break
				}
			}
		}
	} else {
		servertest()
		// 下一步
	}
	if (conNum == 4) {
		servertest()
		// 全对 下一步
	}
}
</script>

<style scoped>
.logo {
	height: 60px;
	width: 60px;
	float: left;
	margin-left: 30px;
	line-height: 60px;
	margin-top: 4.5px;
}
.logoImg {
	height: 60px;
	width: 60px;
}
.inputIp {
    float: left;
	width: 180px;
	margin-left: 60px;
	margin-top: 20px;
}
.icon {
	margin-top: -7px;
}
.btn {
	box-shadow: 1px 1px rgba(0, 0, 0, 0.3);
	opacity: 0.9;
	border: 3px solid rgba(0, 0, 0, 0.3);
}
.btn:active {
	position: relative;
	top: 1px;
	left: 1px;
	box-shadow: none;
}

.AcountView{
    height: 70px;
    width: 100%;
    margin-left: 30px;
}
.msg{
    float: left;
    height: 70px;
    width: 140px;
    margin-left: 30px;
    padding-top: 10px;
}
</style>
