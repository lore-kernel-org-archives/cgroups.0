From: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Use after free with BFQ and cgroups
Date: Thu, 23 Dec 2021 09:02:55 +0800
Message-ID: <d770663a-911c-c9c1-1185-558634f4c738@huawei.com>
References: <20211125172809.GC19572@quack2.suse.cz>
 <20211126144724.GA31093@blackbody.suse.cz>
 <20211129171115.GC29512@quack2.suse.cz>
 <f03b2b1c-808a-c657-327d-03165b988e7d@huawei.com>
 <20211222152103.GF685@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------DBDA67AA3D957847EA8B3933"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20211222152103.GF685-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fvogt-l3A5Bk7waGM@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--------------DBDA67AA3D957847EA8B3933
Content-Type: text/plain; charset="gbk"; format="flowed"
Content-Transfer-Encoding: base64

1NogMjAyMS8xMi8yMiAyMzoyMSwgSmFuIEthcmEg0LS1wDoKPiBPbiBUaHUgMDktMTItMjEgMTA6
MjM6MzMsIHl1a3VhaSAoQykgd3JvdGU6Cj4+IFdlIGNvbmZpcm1lZCB0aGlzIGJ5IG91ciByZXBy
b2R1Y2VyIHRocm91Z2ggYSBzaW1wbGUgcGF0Y2g6Cj4+IHN0b3AgbWVyZ2luZyBiZnFfcXVldWVz
IGlmIHRoZWlyIHBhcmVudHMgYXJlIGRpZmZlcmVudC4KPiAKPiBDYW4geW91IHBsZWFzZSBzaGFy
ZSB5b3VyIHJlcHJvZHVjZXI/IEkgaGF2ZSBwcmVwYXJlZCBzb21lIHBhdGNoZXMgd2hpY2gKPiBJ
J2QgbGlrZSB0byB2ZXJpZnkgYmVmb3JlIHBvc3RpbmcuLi4gVGhhbmtzIQoKSGksCgpIZXJlIGlz
IHRoZSByZXByb2R1Y2VyLCB1c3VhbGx5IHRoZSBwcm9ibGVtIHdpbGwgY29tZSB1cCB3aXRoaW4g
YW4KaG91ci4KClRoYW5rcywKS3VhaQo+IAo+IAkJCQkJCQkJSG9uemEKPiAK

--------------DBDA67AA3D957847EA8B3933
Content-Type: text/plain; charset="UTF-8"; name="null_bad.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="null_bad.sh"

#!/bin/bash
NR=1
basedir=/sys/fs/cgroup/blkio/null
CG_PREFIX=/sys/fs/cgroup/blkio/null/nullb

function set_cgroup()
{
	testdir=$1
	dev_id=$2
	let weight=RANDOM%900+100
	let iops=RANDOM%1000+100
	let bps=RANDOM%10485760+10485760
	echo "$weight" > $testdir/blkio.bfq.weight
	echo "$dev_id $iops" > $testdir/blkio.throttle.read_iops_device
	echo "$dev_id $iops" > $testdir/blkio.throttle.write_iops_device
	echo "$dev_id $bps" > $testdir/blkio.throttle.read_bps_device
	echo "$dev_id $bps" > $testdir/blkio.throttle.write_bps_device
}

function set_sys()
{
	local queue_dir=/sys/block/$1/queue

	let rq_affinity=RANDOM%3
	echo $rq_affinity > $queue_dir/rq_affinity

	let add_random=RANDOM%2
	echo $add_random > $queue_dir/add_random

	let rotational=RANDOM%2
	echo $rotational > $queue_dir/rotational

	let nomerges=RANDOM%2
	echo $nomerges > $queue_dir/nomerges

	let s_num=RANDOM%5
	case $s_num in
		0)
		scheduler=none
		;;
		1)
		scheduler=bfq
		;;
		2)
		scheduler=bfq
		;;
		3)
		scheduler=none
		;;
	esac
	echo bfq > $queue_dir/scheduler
}

create_cg()
{
	local i
	local path

	for i in $(seq 0 $NR)
	do
		path=${CG_PREFIX}${i}
		mkdir -p $path
	done
}

switch_cg()
{
	local path=${CG_PREFIX}$1
	local t

	for t in $(cat $path/tasks)
	do
		echo $t > /sys/fs/cgroup/blkio/tasks
	done

	echo "tasks in $path"
	cat $path/tasks
}

rm_cg()
{
	local path=${CG_PREFIX}$1

	rmdir $path
	return $?
}

mkdir $basedir
cgdir1=/sys/fs/cgroup/blkio/null/nullb0
cgdir2=/sys/fs/cgroup/blkio/null/nullb1

ADD_MOD="modprobe null_blk"
while true
do
	let flag=RANDOM%2
	if [ $flag -eq 1 ];then
		$ADD_MOD queue_mode=2 blocking=1 nr_devices=2
	else
		$ADD_MOD queue_mode=2 nr_devices=2
	fi
		
	create_cg

	dev_id=`lsblk | grep nullb0 | awk '{print $2}'`
	set_cgroup $basedir $dev_id 
	set_sys nullb0

	dev_id=`lsblk | grep nullb1 | awk '{print $2}'`
	set_cgroup $basedir $dev_id 
	set_sys nullb1

	let flag=RANDOM%20
	if [ $flag -eq 5 ];then
		echo 1 > /sys/block/nullb0/make-it-fail
		echo 1 > /sys/block/nullb1/make-it-fail
	else
		echo 0 > /sys/block/nullb0/make-it-fail
		echo 0 > /sys/block/nullb1/make-it-fail
	fi

	i=0
	while [ $i -le 3 ]
	do
		cgexec -g "blkio:null/nullb0" fio -filename=/dev/nullb0 -ioengine=libaio -time_based=1 -rw=rw -thread -size=100g -bs=512 -numjobs=4 -iodepth=8 -runtime=5 -group_reporting -name=brd-IOwrite -rwmixread=50 &>/dev/null &
		cgexec -g "blkio:null/nullb0" fio -filename=/dev/nullb0 -ioengine=psync -direct=1 -time_based=1 -rw=rw -thread -size=100g -bs=512 -numjobs=4 -iodepth=8 -runtime=5 -group_reporting -name=brd-IOwrite -rwmixread=50 &>/dev/null &
		cgexec -g "blkio:null/nullb1" fio -filename=/dev/nullb1 -ioengine=libaio -time_based=1 -rw=rw -thread -size=100g -bs=1024k -numjobs=4 -iodepth=8 -runtime=5 -group_reporting -name=brd-IOwrite -rwmixread=50 &>/dev/null &
		cgexec -g "blkio:null/nullb1" fio -filename=/dev/nullb1 -ioengine=psync -direct=1 -time_based=1 -rw=rw -thread -size=100g -bs=1024k -numjobs=4 -iodepth=8 -runtime=5 -group_reporting -name=brd-IOwrite -rwmixread=50 &>/dev/null &
		((i=i+1))
	done

	sleep 3

	until rm_cg 0
	do
		switch_cg 0
		sleep 0.1
	done

	until rm_cg 1
	do
		switch_cg 1
		sleep 0.1
	done

	while true
	do
		rmmod null_blk &>/dev/null && break
		sleep 0.1
	done
done


--------------DBDA67AA3D957847EA8B3933--
