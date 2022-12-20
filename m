From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next 0/4] blk-cgroup: synchronize del_gendisk() with
 configuring cgroup policy
Date: Tue, 20 Dec 2022 17:19:12 +0800
Message-ID: <e01daffe-a3e3-8bf2-40ee-192a9e70d911@huaweicloud.com>
References: <20221217030908.1261787-1-yukuai1@huaweicloud.com>
 <Y6DP3aOSad8+D1yY@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Y6DP3aOSad8+D1yY@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2022/12/20 4:55, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Sat, Dec 17, 2022 at 11:09:04AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> iocost is initialized when it's configured the first time, and iocost
>> initializing can race with del_gendisk(), which will cause null pointer
>> dereference:
>>
>> t1				t2
>> ioc_qos_write
>>   blk_iocost_init
>>    rq_qos_add
>>    				del_gendisk
>>    				 rq_qos_exit
>>    				 //iocost is removed from q->roqs
>>    blkcg_activate_policy
>>     pd_init_fn
>>      ioc_pd_init
>>       ioc =3D q_to_ioc(blkg->q)
>>       //can't find iocost and return null
>>
>> And iolatency is about to switch to the same lazy initialization.
>>
>> This patchset fix this problem by synchronize rq_qos_add() and
>> blkcg_activate_policy() with rq_qos_exit().
>=20
> So, the patchset seems a bit overly complicated to me. What do you think
> about the following?
>=20
> * These init/exit paths are super cold path, just protecting them with a
>    global mutex is probably enough. If we encounter a scalability problem,
>    it's easy to fix down the line.
>=20
> * If we're synchronizing this with a mutex anyway, no need to grab the
>    queue_lock, right? rq_qos_add/del/exit() can all just hold the mutex.
>=20
> * And we can keep the state tracking within rq_qos. When rq_qos_exit() is
>    called, mark it so that future adds will fail - be that a special ->ne=
xt
>    value a queue flag or whatever.

Yes, that sounds good. BTW, queue_lock is also used to protect
pd_alloc_fn/pd_init_fn=A3=ACand we found that blkcg_activate_policy() is
problematic:

blkcg_activate_policy
  spin_lock_irq(&q->queue_lock);
  list_for_each_entry_reverse(blkg, &q->blkg_list
   pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN,...) -> failed

   spin_unlock_irq(&q->queue_lock);
   // release queue_lock here is problematic, this will cause
pd_offline_fn called without pd_init_fn.
   pd_alloc_fn(__GFP_NOWARN,...)

If we are using a mutex to protect rq_qos ops, it seems the right thing
to do do also using the mutex to protect blkcg_policy ops, and this
problem can be fixed because mutex can be held to alloc memroy with
GFP_KERNEL. What do you think?

Thanks,
Kuai
>=20
> Thanks.
>=20

