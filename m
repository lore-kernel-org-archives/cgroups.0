From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect
 rq_qos apis
Date: Fri, 6 Jan 2023 09:33:26 +0800
Message-ID: <ef55a0f1-d3c2-3979-963e-2fa10ba3c2ff@huaweicloud.com>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-4-yukuai1@huaweicloud.com>
 <Y7XyIzGptuqO8EAt@slm.duckdns.org> <Y7YZnM/nqb0gxOei@slm.duckdns.org>
 <df2f7a60-467f-08ce-2a3e-1dc7853424aa@huaweicloud.com>
 <Y7cYKdOwSlfHtj7t@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y7cYKdOwSlfHtj7t-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/01/06 2:34, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Thu, Jan 05, 2023 at 09:35:21AM +0800, Yu Kuai wrote:
>>> Can you please take a look at the following patchset I just posted:
>>>
>>>     https://lkml.kernel.org/r/20230105002007.157497-1-tj-DgEjT+Ai2ygdnm=
+yROfE0A@public.gmane.org
>>>
>>> After that, all these configuration operations are wrapped between
>>> blkg_conf_init() and blkg_conf_exit() which probably are the right plac=
e to
>>> implement the synchronization.
>>
>> I see that, blkg_conf_init() and blkg_conf_exit() is good, however there
>> are some details I want to confirm:
>>
>> 1) rq_qos_add() can be called from iocost/iolatency, where
>> blkg_conf_init() will be called first, while rq_qos_add() can also be
>> called from wbt, where there is no blkg_conf_init(). Hence it seems to
>> me we need two locks here, one to protect rq_qos apis; one to
>> synchronize policy configuration and device removal.
>=20
> wbt's lazy init is tied to one of the block device sysfs files, right? So,
> it *should* already be protected against device removal.

That seems not true, I don't think q->sysfs_lock can protect that,
consider that queue_wb_lat_store() doesn't check if del_gendisk() is
called or not:

t1: wbt lazy init		t2: remove device
queue_attr_store
				del_gendisk
				blk_unregister_queue
				 mutex_lock(&q->sysfs_lock)
			         ...
				 mutex_unlock(&q->sysfs_lock);
				rq_qos_exit
  mutex_lock(&q->sysfs_lock);
   queue_wb_lat_store
   wbt_init
    rq_qos_add
  mutex_unlock(&q->sysfs_lock);

I tried to comfirm that by adding following delay:

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 93d9e9c9a6ea..101c33cb0a2b 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -11,6 +11,7 @@
  #include <linux/blktrace_api.h>
  #include <linux/blk-mq.h>
  #include <linux/debugfs.h>
+#include <linux/delay.h>

  #include "blk.h"
  #include "blk-mq.h"
@@ -734,6 +735,8 @@ queue_attr_store(struct kobject *kobj, struct=20
attribute *attr,
         if (!entry->store)
                 return -EIO;

+       msleep(10000);
+
         mutex_lock(&q->sysfs_lock);
         res =3D entry->store(q, page, length);
         mutex_unlock(&q->sysfs_lock);

And then do the following test:

1) echo 10000 > /sys/block/sdb/queue/wbt_lat_usec &
2) echo 1 > /sys/block/sda/device/delete

Then, following bug is triggered:

[   51.923642] BUG: unable to handle page fault for address:=20
ffffffffffffffed
[   51.924294] #PF: supervisor read access in kernel mode
[   51.924773] #PF: error_code(0x0000) - not-present page
[   51.925252] PGD 1820b067 P4D 1820b067 PUD 1820d067 PMD 0
[   51.925754] Oops: 0000 [#1] PREEMPT SMP
[   51.926123] CPU: 1 PID: 539 Comm: bash Tainted: G        W=20
6.2.0-rc1-next-202212267
[   51.927124] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),=20
BIOS ?-20190727_073836-b4
[   51.928334] RIP: 0010:__rq_qos_issue+0x30/0x60
[   51.928761] Code: 48 89 f5 53 48 89 fb 48 83 05 eb eb c9 0b 01 eb 19=20
48 89 df 48 83 05 e6 e9
[   51.930426] RSP: 0018:ffffc90000c3b9b0 EFLAGS: 00010206
[   51.930905] RAX: 0000000000000000 RBX: ffffffffffffffed RCX:=20
0000000000000017
[   51.931554] RDX: 000007c329800000 RSI: ffff8881022c0380 RDI:=20
ffffffffffffffed
[   51.932197] RBP: ffff8881022c0380 R08: 0000000c385056e3 R09:=20
ffff8881022c05c8
[   51.932841] R10: 0000000000000000 R11: ffff888100a94000 R12:=20
ffff888102145000
[   51.933488] R13: 0000000000000000 R14: ffff888100a94000 R15:=20
ffff8881022c04a0
[   51.934140] FS:  00007fd23def9700(0000) GS:ffff88813bd00000(0000)=20
knlGS:0000000000000000
[   51.934856] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   51.935379] CR2: ffffffffffffffed CR3: 0000000106fff000 CR4:=20
00000000000006e0
[   51.936036] DR0: 0000000000000000 DR1: 0000000000000000 DR2:=20
0000000000000000
[   51.936675] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:=20
0000000000000400
[   51.937315] Call Trace:
[   51.937545]  <TASK>
[   51.937749]  blk_mq_start_request+0x1d1/0x240
[   51.938151]  scsi_queue_rq+0x347/0x1190
[   51.938513]  blk_mq_dispatch_rq_list+0x366/0xef0
[   51.938938]  ? tick_nohz_tick_stopped+0x1a/0x40
[   51.939356]  ? __irq_work_queue_local+0x59/0xd0
[   51.939769]  ? __sbitmap_get_word+0x3b/0xb0
[   51.940153]  __blk_mq_sched_dispatch_requests+0xdd/0x210
[   51.940633]  blk_mq_sched_dispatch_requests+0x38/0xa0
[   51.941089]  __blk_mq_run_hw_queue+0xca/0x110
[   51.941483]  __blk_mq_delay_run_hw_queue+0x1fc/0x210
[   51.941931]  blk_mq_run_hw_queue+0x15c/0x1d0
[   51.942327]  blk_mq_sched_insert_request+0x9c/0x210
[   51.942769]  blk_execute_rq+0xec/0x290
[   51.943121]  __scsi_execute+0x131/0x310
[   51.943492]  sd_sync_cache+0xc6/0x280
[   51.943831]  sd_shutdown+0x7f/0x180
[   51.944155]  sd_remove+0x53/0x80
[   51.944457]  device_remove+0x80/0xa0
[   51.944785]  device_release_driver_internal+0x131/0x270
[   51.945257]  device_release_driver+0x16/0x20
[   51.945643]  bus_remove_device+0x135/0x200

Thanks,
Kuai
>=20
> Thanks.
>=20

