From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v2 8/9] block: fix null-pointer dereference in
 ioc_pd_init
Date: Thu, 1 Dec 2022 10:12:13 +0800
Message-ID: <9ca2b7ab-7fd3-a9a3-12a6-021a78886b54@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-9-linan122@huawei.com>
 <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Li Nan <linan122@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2022/12/01 4:50, Tejun Heo =D0=B4=B5=C0:
> On Wed, Nov 30, 2022 at 09:21:55PM +0800, Li Nan wrote:
>> Remove block device when iocost is initializing may cause
>> null-pointer dereference:
>>
>> 	CPU1				   CPU2
>>    ioc_qos_write
>>     blkcg_conf_open_bdev
>>      blkdev_get_no_open
>>       kobject_get_unless_zero
>>      blk_iocost_init
>>       rq_qos_add
>>    					del_gendisk
>>    					 rq_qos_exit
>>    					  q->rq_qos =3D rqos->next
>>    					   //iocost is removed from q->roqs
>>        blkcg_activate_policy
>>         pd_init_fn
>>          ioc_pd_init
>>    	 ioc =3D q_to_ioc(blkg->q)
>>   	  //cant find iocost and return null
>>
>> Fix problem by moving rq_qos_exit() to disk_release(). ioc_qos_write() g=
et
>> bd_device.kobj in blkcg_conf_open_bdev(), so disk_release will not be
>> actived until iocost initialization is complited.
>=20
> I think it'd be better to make del_gendisk wait for these in-flight
> operations because this might fix the above particular issue but now all =
the
> policies are exposed to request_queue in a state it never expected before.
>=20
> del_gendisk() is quiescing the queue around rq_qos_exit(), so maybe we can
> piggyback on that and update blkcg_conf_open_bdev() to provide such
> exclusion?

Let del_gendisk waiting for that sounds good, but I'm litter confused
how to do that. Following are what I think about:

1) By mentioning that "del_gendisk() is quiescing the queue", do you
suggest to add rcu_read_lock()? This seems wrong because blk_iocost_init
requires memory allocation.

2) Hold gendisk open mutex

3) Use q_usage_counter, and in the meantime, rq_qos_add() and
blkcg_activate_policy() will need refactoring to factor out freeze
queue.

4) Define a new metux

Thanks,
Kuai
>=20
> Thanks.
>=20

