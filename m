From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v2 4/5] blk-iocost: fix sleeping in atomic context
 warnning
Date: Tue, 15 Nov 2022 09:16:52 +0800
Message-ID: <1644d8fd-a0b4-a6fd-63a2-6309db1bfa11@huaweicloud.com>
References: <20221104023938.2346986-1-yukuai1@huaweicloud.com>
 <20221104023938.2346986-5-yukuai1@huaweicloud.com>
 <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Y3K8MSFWw8eTnxtm@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2022/11/15 6:07, Tejun Heo =D0=B4=B5=C0:
> On Fri, Nov 04, 2022 at 10:39:37AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> match_u64() is called inside ioc->lock, which causes smatch static
>> checker warnings:
>>
>> block/blk-iocost.c:3211 ioc_qos_write() warn: sleeping in atomic context
>> block/blk-iocost.c:3240 ioc_qos_write() warn: sleeping in atomic context
>> block/blk-iocost.c:3407 ioc_cost_model_write() warn: sleeping in atomic
>> context
>>
>> Fix the problem by introducing a mutex and using it while prasing input
>> params.
>=20
> It bothers me that parsing an u64 string requires a GFP_KERNEL memory
> allocation.
>=20
>> @@ -2801,9 +2806,11 @@ static void ioc_rqos_queue_depth_changed(struct r=
q_qos *rqos)
>>   {
>>   	struct ioc *ioc =3D rqos_to_ioc(rqos);
>>  =20
>> +	mutex_lock(&ioc->params_mutex);
>>   	spin_lock_irq(&ioc->lock);
>>   	ioc_refresh_params(ioc, false);
>>   	spin_unlock_irq(&ioc->lock);
>> +	mutex_unlock(&ioc->params_mutex);
>>   }
>=20
> Aren't the params still protected by ioc->lock? Why do we need to grab bo=
th?

Yes, the params is updated inside ioc->lock, but they can be read
without the lock before updating them, which is protected by mutex
instead.

>=20
> Any chance I can persuade you into updating match_NUMBER() helpers to not
> use match_strdup()? They can easily disable irq/preemption and use percpu
> buffers and we won't need most of this patchset.

Do you mean preallocated percpu buffer? Is there any example I can
learn? Anyway, replace match_strdup() to avoid memory allocation sounds
good.

Thanks,
Kuai
>=20
> Thanks.
>=20

