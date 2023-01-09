From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next 3/4] block/rq_qos: use a global mutex to protect
 rq_qos apis
Date: Mon, 9 Jan 2023 09:38:07 +0800
Message-ID: <31e57528-39a5-84ed-8ea0-5c61bab00541@huaweicloud.com>
References: <20230104085354.2343590-1-yukuai1@huaweicloud.com>
 <20230104085354.2343590-4-yukuai1@huaweicloud.com>
 <Y7XyIzGptuqO8EAt@slm.duckdns.org> <Y7YZnM/nqb0gxOei@slm.duckdns.org>
 <df2f7a60-467f-08ce-2a3e-1dc7853424aa@huaweicloud.com>
 <Y7cYKdOwSlfHtj7t@slm.duckdns.org>
 <ef55a0f1-d3c2-3979-963e-2fa10ba3c2ff@huaweicloud.com>
 <Y7hnH9GT6D469Vuu@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y7hnH9GT6D469Vuu@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2023/01/07 2:23, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Fri, Jan 06, 2023 at 09:33:26AM +0800, Yu Kuai wrote:
>>> wbt's lazy init is tied to one of the block device sysfs files, right? =
So,
>>> it *should* already be protected against device removal.
>>
>> That seems not true, I don't think q->sysfs_lock can protect that,
>> consider that queue_wb_lat_store() doesn't check if del_gendisk() is
>> called or not:
>>
>> t1: wbt lazy init		t2: remove device
>> queue_attr_store
>> 				del_gendisk
>> 				blk_unregister_queue
>> 				 mutex_lock(&q->sysfs_lock)
>> 			         ...
>> 				 mutex_unlock(&q->sysfs_lock);
>> 				rq_qos_exit
>>   mutex_lock(&q->sysfs_lock);
>>    queue_wb_lat_store
>>    wbt_init
>>     rq_qos_add
>>   mutex_unlock(&q->sysfs_lock);
>=20
> So, it's not sysfs_lock but sysfs file deletion. When a kernfs, which bac=
ks
> sysfs, file is removed, it disables future operations and drains all
> inflight ones before returning, so you remove the interface files before
> cleaning up the object that it interacts with, you don't have to worry ab=
out
> racing against file operations as none can be in flight at that point.

Ok, thanks for explanation, I'll look into this and try to find out how
this works.

>=20
>> I tried to comfirm that by adding following delay:
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index 93d9e9c9a6ea..101c33cb0a2b 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/blktrace_api.h>
>>   #include <linux/blk-mq.h>
>>   #include <linux/debugfs.h>
>> +#include <linux/delay.h>
>>
>>   #include "blk.h"
>>   #include "blk-mq.h"
>> @@ -734,6 +735,8 @@ queue_attr_store(struct kobject *kobj, struct attrib=
ute
>> *attr,
>>          if (!entry->store)
>>                  return -EIO;
>>
>> +       msleep(10000);
>> +
>>          mutex_lock(&q->sysfs_lock);
>>          res =3D entry->store(q, page, length);
>>          mutex_unlock(&q->sysfs_lock);
>>
>> And then do the following test:
>>
>> 1) echo 10000 > /sys/block/sdb/queue/wbt_lat_usec &
>> 2) echo 1 > /sys/block/sda/device/delete
>>
>> Then, following bug is triggered:
>>
>> [   51.923642] BUG: unable to handle page fault for address:
>> ffffffffffffffed
>> [   51.924294] #PF: supervisor read access in kernel mode
>> [   51.924773] #PF: error_code(0x0000) - not-present page
>> [   51.925252] PGD 1820b067 P4D 1820b067 PUD 1820d067 PMD 0
>> [   51.925754] Oops: 0000 [#1] PREEMPT SMP
>> [   51.926123] CPU: 1 PID: 539 Comm: bash Tainted: G        W
>> 6.2.0-rc1-next-202212267
>> [   51.927124] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BI=
OS
>> ?-20190727_073836-b4
>> [   51.928334] RIP: 0010:__rq_qos_issue+0x30/0x60
>=20
> This indicates that we aren't getting the destruction order right. It cou=
ld
> be that there are other reasons why the ordering is like this and we might
> have to synchronize separately.
>=20
> Sorry that I've been asking you to go round and round but block device
> add/remove paths have always been really tricky and we wanna avoid adding
> more complications if at all possible. Can you see why the device is being
> destroyed before the queue attr is removed?

Of course, I'll glad to help, I'll let you know if I have any progress.

Thanks,
Kuai

