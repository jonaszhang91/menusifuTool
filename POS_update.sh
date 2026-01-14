#!/bin/bash
  
# 脚本维护人员   星星叫
# 脚本更新时间   2025-11-14
# 脚本适用环境   Ubuntu 18.04/22.04
# 升级脚本编号   18030.16.6

SHELL_VERSION='18030.16.6'

UBUNTU_MODE=$(ps -ef | grep desktop | grep -v grep | wc -l)

POS_MODE=$(cat /home/menu/Ports.properties 2>/dev/null |grep SYSTEM_MODEL= | awk -F "=" '{print $2}'| tail -n 1)

VERSION=`awk -F"." '{print $1$2$3$4}' /home/menu/.menusifu/POS/data/version/update_version`

VERSION1=`awk -F "." '{print $1$2$3$4$5}' /home/menu/.menusifu/POS/data/version/update_version`

MYSQL_STATUS=$(ps -ef | grep mysql | grep -v grep | wc -l)

FASTVERSION_DIR=/opt/tomcat7/webapps/kpos/fastversion

FREEDISK=$(df -h | grep -w / | awk -F " " '{print $(NF-2)}'| cut -c1-2 | tr -d '.''G')

#------------------------------------------------------

UPDATE_ID="1r2CFvjxCfjOpc2b5ISfS0ARHcYAT-8Rc"

UPDATE_MD5='12ce532a91e57e150502f52f130afbf8'

#------------------------------------------------------

KPOS_ID="10Cry9LA_bvicvNqBjhQrdWQKirhgrbTk"

KPOS_MD5='046a3a2a450def8b8e624a5a897eda6f'

######################################################
update_316 (){
if [ $VERSION1 -le 1803016 ];then
sudo rm -f /home/menu/menusifu_magic_update.tar.gz
sudo rm -f /home/menu/kpos.war	
sudo sed -ri "s/(^#DNS=.*|^DNS=.*)/DNS=8.8.8.8/g" /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved.service

sudo rm -f /home/menu/pos_update_history.log
sudo touch /home/menu/pos_update_history.log
sudo chown menu:menu /home/menu/pos_update_history.log
echo "---------------------------------------" >> /home/menu/pos_update_history.log
cat /home/menu/.menusifu/POS/data/version/update_version | sed s"/^/升级前POS版本:  /"g >> /home/menu/pos_update_history.log
read -p "   `echo "\033[33m请输入升级版本的原因: \033[0m"` "  reason
echo "升级版本的原因: $reason" >> /home/menu/pos_update_history.log
			
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo "\033[33m |         开始下载 menusifu_magic_update.tar.gz 安装包         |\033[0m"
echo "\033[33m +--------------------------------------------------------------+\033[0m"

	 wget --no-check-certificate "https://www.googleapis.com/drive/v3/files/${UPDATE_ID}?alt=media&key=AIzaSyCEF_qN9FjNfHPY1V1Dy4O0W5lBgO4K_24" -O /home/menu/menusifu_magic_update.tar.gz
	 sleep 1
	
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo "\033[33m |         下载 menusifu_magic_update.tar.gz 安装包成功         |\033[0m"
echo "\033[33m +--------------------------------------------------------------+\033[0m"
     sleep 1

echo ""
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo "\033[33m |                   开始下载 kpos.war 安装包                   |\033[0m"
echo "\033[33m +--------------------------------------------------------------+\033[0m"

	 wget --no-check-certificate "https://www.googleapis.com/drive/v3/files/${KPOS_ID}?alt=media&key=AIzaSyCEF_qN9FjNfHPY1V1Dy4O0W5lBgO4K_24" -O /home/menu/kpos.war
     sleep 1

echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo "\033[33m |                   下载 kpos.war 安装包成功                   |\033[0m" 
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo ""

echo "\033[33m +--------------------------------------------------------------+\033[0m"  
echo "\033[33m |                    检查下载包文件是否完整                    |\033[0m" 
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo ""

NOW_KPOS_MD5=`md5sum kpos.war|cut -d ' ' -f1`

if [ "$NOW_KPOS_MD5" = "$KPOS_MD5" ];then
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo "\033[33m |                      kpos.war文件包完整                      |\033[0m" 
echo "\033[33m +--------------------------------------------------------------+\033[0m"
echo ""
     sleep 1
else 
echo "\e[5;41m +--------------------------------------------------------------+\e[0m" 
echo "\e[5;41m |           kpos.war文件包不完整，请重新执行升级脚本           |\e[0m"  
echo "\e[5;41m +--------------------------------------------------------------+\e[0m"
sudo rm -f /home/menu/kpos.war
rm -f $0
     sleep 1
     exit 1
fi

NOW_UPDATE_MD5=`md5sum menusifu_magic_update.tar.gz|cut -d ' ' -f1`

if [ "$NOW_UPDATE_MD5" = "$UPDATE_MD5" ];then
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
echo "\033[33m |            menusifu_magic_update.tar.gz文件包完整            |\033[0m" 
echo "\033[33m +--------------------------------------------------------------+\033[0m" 
     sleep 1
else 

echo "\e[5;41m +--------------------------------------------------------------+\e[0m" 
echo "\e[5;41m | menusifu_magic_update.tar.gz文件包不完整，请重新执行升级脚本 |\e[0m"  
echo "\e[5;41m +--------------------------------------------------------------+\e[0m"
sudo rm -f /home/menu/menusifu_magic_update.tar.gz
rm -f $0
     sleep 1
     exit 1	 
fi

if [ $MYSQL_STATUS -ne 0 ]; then
	echo ""
	echo "\033[33m +--------------------------------------------------------------+\033[0m" 
	echo "\033[33m |       升级文件包下载完整,开始备份MySQL数据,请耐心等待...     |\033[0m" 
	echo "\033[33m +--------------------------------------------------------------+\033[0m"
	echo ""
	
	sudo /usr/bin/innobackupex --defaults-file=/etc/mysql/mysql.conf.d/mysqld.cnf --socket=/var/run/mysqld/mysqld.sock --port=22108 --user=root --password='N0mur@4$99!' /opt/backup > /opt/backup/backup.log 2>&1
	if [ $? -eq 0 ]; then

		echo "\033[33m +--------------------------------------------------------------+\033[0m" 
		echo "\033[33m |                 MySQL数据备份成功,开始升级...                |\033[0m" 
		echo "\033[33m +--------------------------------------------------------------+\033[0m"
			sleep 1
		else

		echo "\e[5;41m +--------------------------------------------------------------+\e[0m" 
		echo "\e[5;41m |                  MySQL数据备份失败,升级终止                  |\e[0m"  
		echo "\e[5;41m +--------------------------------------------------------------+\e[0m"
			sleep 1
		rm -f $0
		exit 1
	fi
else
	echo ""
	echo "\033[33m +--------------------------------------------------------------+\033[0m" 
	echo "\033[33m |                 检测为分机环境,不用备份数据库                |\033[0m" 
	echo "\033[33m +--------------------------------------------------------------+\033[0m"
	echo ""
	
fi

####################################以下为升级脚本####################################
#!/bin/bash

SUDO='sudo'
LOG=update.log
UPDATE_FILE_PACKAGE=menusifu_magic_update.tar.gz
UPDATE_FILE=menusifu_magic_update
VERSION_DIR=/home/menu/.menusifu/POS/data/version
UNTAR=${SUDO}' tar zxf'
NEW_UPDATE_POS_VERSION="1.8.0.30.16.6"
LAST_UPDATE_POS_VERSION=""
NEW_UPDATE_SHELL_VERSION=29
LAST_UPDATE_SHELL_VERSION=0
IS_LUBUNTU=0
WAR_DIR=/opt/tomcat7/webapps
FASTVERSION_DIR=/opt/tomcat7/webapps/kpos/fastversion

# contains(string, substring)
#
# Returns 1 if the specified string contains the specified substring,
# otherwise returns 0.
contains()
{
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"
    then
        return 1    # $substring is in $string
    else
        return 0    # $substring is not in $string
    fi
}

#compare_version(string, string)
#
# return 1: need to copy old kiosk/emenu folder to new folder
# othrewise return 0
compare_version()
{
    old_version_file="$1"
    new_version_file="$2"
    if [ ! -f $old_version_file ];then
        return 0
    fi
    if [ ! -f $new_version_file ];then
        return 1
    fi
    old_version=$(head $old_version_file | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~"version"){print $(i+1)} }}' | tr -d ' "')
    new_version=$(head $new_version_file | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~"version"){print $(i+1)} }}' | tr -d ' "')
    if [ "$old_version" = "$new_version" ];then
        return 0
    fi
    if [ $(echo "$old_version" "$new_version" | tr ' ' '\n' | sort -rV | head -n 1) = "$old_version" ];then
        return 1
    else
        return 0
    fi
}

#check if the system is lubuntu
LUBUNTU_PROCESS_ID=$(ps -ef | grep 'Lubuntu\|lxqt' | grep -v grep | awk '{print $2}')
if [ -n "$LUBUNTU_PROCESS_ID" ];then
    IS_LUBUNTU=1
fi

################### Check Update Version ######################
echo  "\033[32m ################## check update version... #################### \033[0m"
if [ ! -d $VERSION_DIR ];then
    $SUDO mkdir $VERSION_DIR
fi
if [ -f $VERSION_DIR/update_version ];then
    LAST_UPDATE_POS_VERSION=$(cat $VERSION_DIR/update_version)
    echo "\033[32m ######### The last installed update package is "$LAST_UPDATE_POS_VERSION" ####### \033[0m"
else
    echo "\033[32m #### This mbox has not installed any update packages!... #### \033[0m"
fi

if [ $(echo "$NEW_UPDATE_POS_VERSION" "$LAST_UPDATE_POS_VERSION" | tr ' ' '\n' | sort -rV | head -n 1) != "$NEW_UPDATE_POS_VERSION" ];then
    echo "\033[32m #### It does not support installation of lower versions!... ##### \033[0m"
    echo ""
    exit
fi

if [ -d "$FASTVERSION_DIR" ];then
    if [ -n "$(ls -A "$FASTVERSION_DIR")" ]; then
        echo -n "There are some patches .  Are you sure you want to upgrade?  (y/n)"
        read UPGRADE
        if [ "$UPGRADE" != "y" ]&&[ "$UPGRADE" != "Y" ];then
            exit
        fi
    fi
fi

if [ -f $VERSION_DIR/update_shell_version ];then
    LAST_UPDATE_SHELL_VERSION=$(cat $VERSION_DIR/update_shell_version)
fi
if [ $LAST_UPDATE_SHELL_VERSION -eq 0 ];then
    if [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.11" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.12" ];then
        LAST_UPDATE_SHELL_VERSION=1
    elif [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.13" ];then
        LAST_UPDATE_SHELL_VERSION=2
    elif [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.14" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.15" ];then
        LAST_UPDATE_SHELL_VERSION=3
    elif [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.15_plus" ];then
        LAST_UPDATE_SHELL_VERSION=4
    elif [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.15_p2" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.15_p3" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.17" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.18" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.19" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.20" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.21" ]||[ "$LAST_UPDATE_POS_VERSION" = "1.8.0.22" ];then
        LAST_UPDATE_SHELL_VERSION=5
    elif [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.23" ];then
        LAST_UPDATE_SHELL_VERSION=6
    elif [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.24" ];then
        LAST_UPDATE_SHELL_VERSION=7
    elif [ "$LAST_UPDATE_POS_VERSION" = "1.8.0.25" ];then
        LAST_UPDATE_SHELL_VERSION=8
    fi
fi
echo  "\033[32m ############### check update version complete! ################ \033[0m"
echo ""

################### Execute Update Shells ######################
curr_dir=$(pwd)
echo  "\033[32m ################## execute update shells... ################### \033[0m"
$UNTAR $UPDATE_FILE_PACKAGE

for dir in `ls $UPDATE_FILE | sort -g`;
  do
    update_shell_name=$dir
    contains  $update_shell_name "__"
    ##shell name contains "__", and check whether this update shell has been executed
    if [ $? -eq 1 ]&&[ ${update_shell_name%%__*} -gt $LAST_UPDATE_SHELL_VERSION ];then
      shell_name=${update_shell_name##*__}
      echo  "\033[32m ############## execute $shell_name update shells... ############## \033[0m"
      cd "$UPDATE_FILE"/"$update_shell_name"
      $SUDO chmod +x "$shell_name"_update.sh
      $SUDO sh "$shell_name"_update.sh $IS_LUBUNTU >> $curr_dir/$LOG 2>&1
      cd $curr_dir
    elif [ $? -eq 1 ]&&[ ${update_shell_name##*__} = "$NEW_UPDATE_POS_VERSION" ];then
      shell_name=${update_shell_name##*__}
      echo  "\033[32m ############## execute $shell_name update shells... ############## \033[0m"
      cd "$UPDATE_FILE"/"$update_shell_name"
      $SUDO chmod +x "$shell_name"_update.sh
      $SUDO sh "$shell_name"_update.sh $IS_LUBUNTU >> $curr_dir/$LOG 2>&1
      cd $curr_dir
    fi
  done
cd $curr_dir

echo  "\033[32m ############### execute update shells complete! ############### \033[0m"
echo ""

###################update kpos package###################
$SUDO echo $NEW_UPDATE_POS_VERSION > $VERSION_DIR/update_version
$SUDO echo $NEW_UPDATE_SHELL_VERSION > $VERSION_DIR/update_shell_version
echo "\033[32m ##################### update kpos.war... ####################### \033[0m"
$SUDO systemctl stop tomcat
$SUDO rm -rf $WAR_DIR/cloudDatahub*
$SUDO cp "$UPDATE_FILE"/cloudDatahub.war $WAR_DIR -f
$SUDO rm -rf $WAR_DIR/versionloader*
$SUDO cp "$UPDATE_FILE"/versionloader.war $WAR_DIR -f
#$SUDO rm -rf $WAR_DIR/cloud-datahub-v2*
#$SUDO cp "$UPDATE_FILE"/cloud-datahub-v2.war $WAR_DIR -f

$SUDO rm -rf $WAR_DIR/kpos.war
$SUDO cp ./kpos.war $WAR_DIR -f
$SUDO unzip -q -o $WAR_DIR/kpos.war -d $WAR_DIR/kpos-new

compare_version $WAR_DIR/kpos/kiosklite/public/version.json $WAR_DIR/kpos-new/kiosklite/public/version.json
if [ $? -eq 1 ];then
    echo "update kiosk version"
    $SUDO rm -rf $WAR_DIR/kpos-new/kiosklite
    $SUDO cp -rp $WAR_DIR/kpos/kiosklite $WAR_DIR/kpos-new/
fi

compare_version $WAR_DIR/kpos/emenu/version.json $WAR_DIR/kpos-new/emenu/version.json
if [ $? -eq 1 ];then
    echo "update emenu version"
    $SUDO rm -rf $WAR_DIR/kpos-new/emenu
    $SUDO cp -rp $WAR_DIR/kpos/emenu $WAR_DIR/kpos-new/
fi

$SUDO rm -rf $WAR_DIR/kpos
$SUDO mv $WAR_DIR/kpos-new $WAR_DIR/kpos
$SUDO chown menu -R $WAR_DIR/kpos
$SUDO chgrp menu -R $WAR_DIR/kpos

if [ $IS_LUBUNTU -eq 1 ];then
    $SUDO /opt/POS/do_stop_pos >> $curr_dir/$LOG 2>&1
    ps -ef |grep show_pos_icon |awk '{print $2}'|xargs kill -9 >> $curr_dir/$LOG 2>&1
    $SUDO rm -rf /opt/menusifu
    $SUDO cp -rp "$UPDATE_FILE"/menusifu /opt/ -f
    $SUDO chmod +x /opt/menusifu/menusifu_pos_extention
fi

$SUDO systemctl start tomcat
$SUDO rm -rf $UPDATE_FILE
echo "\033[32m ################### update kpos.war complete! ################## \033[0m"

####################################以上为升级脚本####################################

sudo awk -F " " 'BEGIN{OFS="---> "}NR==6{print $2,$3}' /home/menu/POS_update.sh >> /home/menu/pos_update_history.log
sudo date  "+本次升级时间是: %Y-%m-%d %H:%M:%S" >> /home/menu/pos_update_history.log
sudo rm -f /var/spool/cron/crontabs/menu 
sudo echo "45 5 * * * sudo service tomcat restart" > /var/spool/cron/crontabs/menu
sudo echo "10 15 * * 0 sudo rm -f /opt/backup/*.zip" >> /var/spool/cron/crontabs/menu
sudo echo "0 16 * * * sudo find /opt/backup/* -maxdepth 0 -mtime +2 -type d -exec rm -rf {} \;" >> /var/spool/cron/crontabs/menu
sudo echo "32 5 */3 * * sudo /sbin/reboot" >> /var/spool/cron/crontabs/menu
sudo echo "11 15 * * * sudo rm -f /opt/backup/*.crypt" >> /var/spool/cron/crontabs/menu
sudo chmod 600 /var/spool/cron/crontabs/menu
sudo chown menu:crontab /var/spool/cron/crontabs/menu

echo ""
echo "\033[33m +--------------------------------------------------------------+\033[0m"
echo "\033[33m |                      POS升级新版本成功!                      |\033[0m"
echo "\033[33m +--------------------------------------------------------------+\033[0m"

sudo rm -f /home/menu/menusifu_magic_update.tar.gz
sudo rm -f /home/menu/kpos.war
cd ~ && wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1bUuONlceqolnOFhAY14bzfky-Czj0NKy' -O /home/menu/pit && unzip /home/menu/pit && sudo cp -rf /home/menu/1.8.0.30.16.6-fast-0-PIT-12443/kpos/* /opt/apache-tomcat-7.0.93/webapps/kpos/ && mysql -u root --password='N0mur@4$99!' kpos < /home/menu/1.8.0.30.16.6-fast-0-PIT-12443/0_db.sql &&sudo service tomcat restart
sudo sudo chown menu:menu /home/menu/latest_update.log
echo "$SHELL_VERSION" > /home/menu/latest_update.log
echo ""

	else
echo ""
echo "\e[5;41m +--------------------------------------------------------------+\e[0m" 
echo "\e[5;41m |   发现已安装的POS软件版本比准备升级的版本更高，请核对版本！  |\e[0m"  
echo "\e[5;41m +--------------------------------------------------------------+\e[0m"
	rm -f $0
    exit 1
    fi
}

emenu_update (){

	echo "\033[34m +--------------------------------------------------------------+\033[0m" 
	echo "\033[34m |                      开始升级E-menu版本                      |\033[0m"
	echo "\033[34m +--------------------------------------------------------------+\033[0m"
	echo ""

	cd /home/menu/ && rm -f /home/menu/emenu.zip && wget  https://github.com/jonaszhang91/menusifuTool/raw/refs/heads/master/emenu.zip
	sleep 1
	
	echo "\033[33m===========================================\033[0m"
	cat /opt/apache-tomcat-7.0.93/webapps/kpos/emenu/version.json 2>/dev/null | sed -n '3p'|sed s"/^/   升级前 E-Menu/"
	echo ""
	
	sudo rm -rf /opt/apache-tomcat-7.0.93/webapps/kpos/emenu
    sudo rm -rf /home/menu/emenu
    unzip -q emenu.zip -d /home/menu/
    sudo cp -r /home/menu/emenu/* /opt/apache-tomcat-7.0.93/webapps/kpos/
	
	echo "\033[33m +--------------------------------------+\033[0m"
	echo "\033[33m |             EMENU升级完成            |\033[0m"
	echo "\033[33m +--------------------------------------+\033[0m"

	echo ""
	cat /opt/apache-tomcat-7.0.93/webapps/kpos/emenu/version.json 2>/dev/null | sed -n '3p'|sed s"/^/   升级后 E-Menu/"
	echo "\033[33m===========================================\033[0m"

}

kiosk_update (){

	echo "\033[34m +--------------------------------------------------------------+\033[0m" 
	echo "\033[34m |                       开始升级Kiosk版本                      |\033[0m"
	echo "\033[34m +--------------------------------------------------------------+\033[0m"
	echo ""
		
	cd /home/menu/ && rm -f /home/menu/kiosklite.zip && wget https://github.com/jonaszhang91/menusifuTool/raw/refs/heads/master/kiosklite.zip
	sleep 1
	
	echo "\033[33m===========================================\033[0m"
	cat /opt/apache-tomcat-7.0.93/webapps/kpos/kiosklite/version.json 2>/dev/null | sed -n '3p'|sed s"/^/   升级前 Kiosk /"g
	echo ""
	
	sudo rm -rf /opt/apache-tomcat-7.0.93/webapps/kpos/kiosklite
    unzip -q kiosklite.zip -d /opt/apache-tomcat-7.0.93/webapps/kpos/
	
	echo "\033[33m +--------------------------------------+\033[0m"
	echo "\033[33m |             KISOK升级完成            |\033[0m"
	echo "\033[33m +--------------------------------------+\033[0m"

	echo ""
	cat /opt/apache-tomcat-7.0.93/webapps/kpos/kiosklite/version.json 2>/dev/null | sed -n '3p'|sed s"/^/   升级后 Kiosk /"g
	echo "\033[33m===========================================\033[0m"

}

#-----------------------------------------------------------------------------------------

trap_handler() {
	echo "\033[33m\n   脚本被中断，正在退出脚本...\033[0m"
    rm -f $0
    exit 1
}

trap 'trap_handler' INT
trap 'trap_handler' TSTP
trap 'trap_handler' TERM
trap 'trap_handler' QUIT
trap 'trap_handler' ABRT


if [ "$(id -u)" != "0" ]; then
	echo "\033[33m +---------------------------------------------------------+\033[0m" 
	echo "\033[33m |                                                         |\033[0m" 
	echo "\033[33m |          注意：脚本开头必须使用 sudo 才可以执行           |\033[0m" 
	echo "\033[33m |                                                         |\033[0m" 
	echo "\033[33m +---------------------------------------------------------+\033[0m"
	rm -f $0
	exit 1
fi

if [ "$FREEDISK" -lt "6" ]; then
	echo "\e[5;41m +--------------------------------------------------------+\e[0m" 
	echo "\e[5;41m |                                                        |\e[0m" 
	echo "\e[5;41m |         注意：当前空闲磁盘低于6GB，升级存在风险        |\e[0m"
	echo "\e[5;41m |                                                        |\e[0m" 	
	echo "\e[5;41m +--------------------------------------------------------+\e[0m"
		echo ""
		read -p "   `echo "\033[33m确认要进行升级吗? \033[0m"` "  FD
        if [ "$FD" != "y" ]&&[ "$FD" != "Y" ];then
			echo "\033[33m --------------------脚本程序已经退出----------------------\033[0m"
			rm -f $0
            exit
			fi
fi


if [ "$1" = 18030.16 ];then
	update_316
	rm -f $0
	exit 0
fi

if [ -d "$FASTVERSION_DIR" ];then
    if [ -n "$(ls -A "$FASTVERSION_DIR")" -a $MYSQL_STATUS -ne 0 ]; then
		echo "\033[33m +--------------------------------------------------------+\033[0m" 
		echo "\033[33m |                  已安装的快速迭代补丁                  |\033[0m"
		echo "\033[33m |                                                        |\033[0m"
	    echo "\033[33m |             Salefore店铺没有备注就可以升级             |\033[0m" 
		echo "\033[33m +--------------------------------------------------------+\033[0m"
		grep -Evh "功能说明|适用版本|补丁信息" /opt/apache-tomcat-7.0.93/webapps/kpos/fastversion/*.md
		echo ""
		echo ""
        read -p "`echo "\e[5;41m当前POS有安装快速迭代补丁，确定要升级吗？(y/n): \e[0m"` "  UPGRADE
        if [ "$UPGRADE" != "y" ]&&[ "$UPGRADE" != "Y" ];then
			echo "\033[33m --------------------脚本程序已经退出----------------------\033[0m"
			rm -f $0
            exit
        fi
    fi
fi

echo ""

while true
do
echo "\033[33m +--------------------------------------------------------+\033[0m"
if [ "$UBUNTU_MODE" = "0" ]; then
	sudo sed -i "s/30 14/30 2/g" /etc/crontab
	echo "\033[34m |                   Ubuntu模式---MBOX                    |\033[0m" 
else
	sudo sed -i "s/30 14 \* \* \* /30 15 \* \* \* /g" /etc/crontab
	echo "\033[33m |                   POS模式---$POS_MODE                     |\033[0m"
fi
echo "\033[33m |                                                        |\033[0m" 
echo "\033[33m | 1：升级 POS $SHELL_VERSION                                 |\033[0m"
echo "\033[33m | 2: 升级 E-Menu 最新版本                                |\033[0m"
echo "\033[33m | 3: 升级 Kiosk  最新版本                                |\033[0m"
echo "\033[33m | 4: 升级 Datahub 1.0.1.19                               |\033[0m"                            
echo "\033[33m |                                                        |\033[0m"
echo "\033[33m | 0: 退出程序                                            |\033[0m"
echo "\033[33m |                                                        |\033[0m"
echo "\033[33m |                                     版本号--$SHELL_VERSION |\033[0m"
echo "\033[33m +--------------------------------------------------------+\033[0m"
cat /home/menu/latest_update.log 2>/dev/null | sed s"/^/`echo "\033[33m   最近一次POS升级使用的升级脚本版本是--->\033[0m"` /"g

test -f /home/menu/latest_update.log || touch /home/menu/latest_update.log
if [ "$(cat /home/menu/latest_update.log)" = "$SHELL_VERSION" ];then
	echo "\e[5;41m +--------------------------------------------------------+\e[0m" 
	echo "\e[5;41m |      客户环境已经运行过本脚本，请核对避免重复升级      |\e[0m"  
	echo "\e[5;41m +--------------------------------------------------------+\e[0m" 	
fi
read -p "   `echo "\033[33m请选择需要的操作选项数字,按回车键确认: \033[0m"` "  answer
if [ "$answer" = "1"  ];then
	if [ $MYSQL_STATUS -ne 0 ]; then
			update_316
			sleep 1
			emenu_update
			sleep 1
			kiosk_update
			rm -f $0
			tail -f /opt/apache-tomcat-7.0.93/logs/appserver.log
	else
			echo "\033[34m +--------------------------------------------------------------+\033[0m" 
			echo "\033[34m |                        检测为分机环境                        |\033[0m"
			echo "\033[34m +--------------------------------------------------------------+\033[0m"
			update_316
			rm -f $0
		exit
	fi
		
elif [ "$answer" = "2" ]
    then
	emenu_update
	rm -f $0
	exit 

elif [ "$answer" = "3" ]
    then
	kiosk_update
	rm -f $0
	exit

elif [ "$answer" = "4" ]
	then
	cd /home/menu/ && rm -f cloudDatahub.war && wget --user=baol22 --password=1qaz@WSX6788 http://menusifu.com.cn:29120/datahub_package/cloudDatahub.war
	sleep 1

DATEHUB_MD5=`md5sum cloudDatahub.war|cut -d ' ' -f1`

	if [ "$DATEHUB_MD5" = "1b6ae0e2a30fc23fcb5fe6fedf0c320b" ];then

	echo "\033[33m +------------------------------------------------------+\033[0m" 
	echo "\033[33m |             CloudDatahub.war文件完整                 |\033[0m" 
	echo "\033[33m +------------------------------------------------------+\033[0m" 
		sleep 1
	else 
	echo "\e[5;41m +------------------------------------------------------+\e[0m" 
	echo "\e[5;41m |       CloudDatahub.war文件包不完整，请重新下载       |\e[0m"  
	echo "\e[5;41m +------------------------------------------------------+\e[0m"
		exit 1
    fi

	sudo rm -f /opt/apache-tomcat-7.0.93/webapps/cloudDatahub.war
	sudo rm -rf /opt/apache-tomcat-7.0.93/webapps/cloudDatahub
    sudo cp /home/menu/cloudDatahub.war /opt/apache-tomcat-7.0.93/webapps/
    sudo service tomcat restart
	
	echo ""
	echo "\033[33m +------------------------------------------------------+\033[0m" 
 	echo "\033[33m |      CloudDatahub.war升级成功，正在重启POS....       |\033[0m" 
	echo "\033[33m +------------------------------------------------------+\033[0m" 
	rm -f $0
	exit 0

elif [ $answer = 0 ]
	then
	echo "\033[33m --------------------脚本程序已经退出----------------------\033[0m"
	rm -f $0
	exit 0	

else
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo ""	
echo "\e[5;41m +--------------------------------------------------------+\e[0m" 
echo "\e[5;41m |          输入的选项编号错误，请核实后重新输入          |\e[0m"  
echo "\e[5;41m +--------------- ----------------------------------------+\e[0m"  
 		
fi
done