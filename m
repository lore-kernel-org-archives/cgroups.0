From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 1/4] blk-iocost: track whether iocg is still online
Date: Mon, 26 Dec 2022 09:10:41 +0800
Message-ID: <edb84ee2-3dd5-8bb4-4417-ed42744d793f@huaweicloud.com>
References: <20221217030527.1250083-1-yukuai1@huaweicloud.com>
 <20221217030527.1250083-2-yukuai1@huaweicloud.com>
 <Y6LhD8CEkcgLUJoQ@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Y6LhD8CEkcgLUJoQ-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Christoph

=D4=DA 2022/12/21 18:33, Christoph Hellwig =D0=B4=B5=C0:
> On Sat, Dec 17, 2022 at 11:05:24AM +0800, Yu Kuai wrote:
>> @@ -459,6 +459,8 @@ struct ioc_gq {
>>   	struct blkg_policy_data		pd;
>>   	struct ioc			*ioc;
>>  =20
>> +	bool online;
>=20
> Nit: maybe tab align this field like the fields above it.
>=20
>> +static void ioc_pd_offline(struct blkg_policy_data *pd)
>> +{
>> +	struct ioc_gq *iocg =3D pd_to_iocg(pd);
>> +	struct ioc *ioc =3D iocg->ioc;
>> +	unsigned long flags;
>> +
>> +	if (ioc) {
>=20
> How could ioc be NULL here?
>=20

As I explained in another thread.. pd_offline_fn() can be called without
pd_init_fn(), which is a bug from upper layer...

blkcg_activate_policy
  spin_lock_irq(&q->queue_lock);
  list_for_each_entry_reverse(blkg, &q->blkg_list
   pd_alloc_fn(GFP_NOWAIT | __GFP_NOWARN,...) -> failed

   spin_unlock_irq(&q->queue_lock);
   // release queue_lock here is problematic, this will cause
pd_offline_fn called without pd_init_fn.
   pd_alloc_fn(__GFP_NOWARN,...)

Thanks,
Kuai
> .
>=20

