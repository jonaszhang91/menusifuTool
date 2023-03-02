import axios from 'axios'
export async function acountMsg(ip) {
    let putout
	await axios.get('http://'+ip+':3030/mysqlcon').then((d) => {
            // console.log(d.data)
        // Acount.value = d.data[0]
        putout = d.data[0]
        console.log(putout);
        
        // // console.log(Acount.value);
        let AcountNav = document.getElementById('AcountView')
        AcountNav.style.marginLeft = 50+'%'
        // 信息栏弹出
	}).catch((error)=>{
        alert('连接错误')
        console.log("ERROR："+error);
       
        // 抛出错误
    })
	// 连接数据库 获取店铺信息 
    // console.log(putout);
    return putout
}

export async function select(ip,value){
    let putout
    await axios.post('http://'+ip+':3030/select',{'fun':value}).then((d)=>{
        putout = d.data
        console.log(d.data);
    }).catch((error)=>{

        console.log("ERROR:"+error);
    })
    return putout
}

