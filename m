From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: WARNING: at kernel/cpuset.c:1139
Date: Wed, 23 Jul 2014 10:50:29 +0800
Message-ID: <53CF22F5.6000206@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups@vger.kernel.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com

commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when 
config changes") introduce the below warning in my server.

[   35.652137] ------------[ cut here ]------------
[   35.652141] WARNING: at kernel/cpuset.c:1139
[   35.652142] Modules linked in: ebtable_nat xt_CHECKSUM bridge stp llc 
be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb4i cxgb4 cxgb3i cxgb3 mdio 
libcxgbi ib_iser iptable_mangle nf_conntrack_ipv4 rdma_cm nf_defrag_ipv4 
xt_conntrack iw_cm nf_conntrack ib_cm ib_sa ib_mad ebtable_filter 
ib_core ebtables ip6_tables ib_addr iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi e1000e ses ptp enclosure pps_core be2net shpchp 
vhost_net tun macvtap macvlan vhost kvm binfmt_misc uinput lpfc 
scsi_transport_fc ipr
[   35.652185] CPU: 36 PID: 1363 Comm: libvirtd Not tainted 
3.16.0-rc5-next-20140721+ #93
[   35.652187] task: c0000003b3443a00 ti: c0000003bb008000 task.ti: 
c0000003bb008000
[   35.652189] NIP: c00000000015ff38 LR: c00000000015ff2c CTR: 
0000000000000000
[   35.652190] REGS: c0000003bb00b850 TRAP: 0700   Not tainted 
(3.16.0-rc5-next-20140721+)
[   35.652191] MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI> CR: 
24004824  XER: 00000000
[   35.652196] CFAR: c00000000045f6cc SOFTE: 1
GPR00: c00000000015ff04 c0000003bb00bad0 c00000000145acf8 0000000000000001
GPR04: c0000003b3dae5d0 0000000000000100 0000000000000000 0000000000000000
GPR08: c0000003b3dae548 0000000000000004 0000000000000000 0000000000000004
GPR12: 0000000000000001 c00000000feea200 0000008066727bd8 0000008066727a30
GPR16: 00000080667dfa08 0000008066727a68 00000080667279f8 00000080667279d0
GPR20: c00000000166acf8 c0000003b3dae530 c000000001311990 c0000003b3dae5d0
GPR24: c0000003b3dae530 c0000003b3dadc00 c0000003b3dae400 0000000000000001
GPR28: 0000000000000000 c000000001311968 c0000003b1873100 c0000003b3dae400
[   35.652219] NIP [c00000000015ff38] .cpuset_write_resmask+0x438/0x8c0
[   35.652221] LR [c00000000015ff2c] .cpuset_write_resmask+0x42c/0x8c0
[   35.652222] Call Trace:
[   35.652224] [c0000003bb00bad0] [c00000000015ff04] 
.cpuset_write_resmask+0x404/0x8c0 (unreliable)
[   35.652227] [c0000003bb00bba0] [c000000000156f08] 
.cgroup_file_write+0x78/0x190
[   35.652230] [c0000003bb00bc50] [c00000000030c490] 
.kernfs_fop_write+0x150/0x1e0
[   35.652233] [c0000003bb00bcf0] [c00000000026b6d0] .vfs_write+0xe0/0x270
[   35.652235] [c0000003bb00bd90] [c00000000026be24] .SyS_write+0x64/0x110
[   35.652238] [c0000003bb00be30] [c00000000000a158] syscall_exit+0x0/0x98
[   35.652239] Instruction dump:
[   35.652240] e93a0000 39549528 e9290118 7fa95000 419e0024 7ea3ab78 
7ee4bb78 38a00100
[   35.652243] 482ff719 60000000 2fa30000 419e0008 <0fe00000> 7f43d378 
4bfffa71 813a006c
[   35.652247] ---[ end trace f91b0c3aadfe71a6 ]---

Thanks,
Mike
