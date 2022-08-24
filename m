From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH 4/4] blk-throttle: cleanup throtl_dequeue_tg()
Date: Wed, 24 Aug 2022 09:19:51 +0800
Message-ID: <dd9b7a59-a16a-74f5-011c-664ca91e8ada@huaweicloud.com>
References: <20220823013810.406075-1-yukuai1@huaweicloud.com>
 <20220823013810.406075-5-yukuai1@huaweicloud.com>
 <YwUdouGld9Z7K8r1@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YwUdouGld9Z7K8r1-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun

=D4=DA 2022/08/24 2:34, Tejun Heo =D0=B4=B5=C0:
> On Tue, Aug 23, 2022 at 09:38:10AM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Now that throtl_dequeue_tg() is called when the last bio is dispatched,
>> there is no need to check the flag THROTL_TG_PENDING, since it's ensured
>> to be set when bio is throttled.
>>
>> There are no functional changes.
>>
>> Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>   block/blk-throttle.c | 11 ++++-------
>>   1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 47142a1dd102..e47506a8ef47 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -570,14 +570,11 @@ static void throtl_enqueue_tg(struct throtl_grp *t=
g)
>>  =20
>>   static void throtl_dequeue_tg(struct throtl_grp *tg)
>>   {
>> -	if (tg->flags & THROTL_TG_PENDING) {
>> -		struct throtl_service_queue *parent_sq =3D
>> -			tg->service_queue.parent_sq;
>> +	struct throtl_service_queue *parent_sq =3D tg->service_queue.parent_sq;
>>  =20
>> -		throtl_rb_erase(&tg->rb_node, parent_sq);
>> -		--parent_sq->nr_pending;
>> -		tg->flags &=3D ~THROTL_TG_PENDING;
>> -	}
>> +	throtl_rb_erase(&tg->rb_node, parent_sq);
>> +	--parent_sq->nr_pending;
>> +	tg->flags &=3D ~THROTL_TG_PENDING;
>=20
> Yeah, I don't know about this one. This breaks the symmetry with
> throtl_enqueue_tg() and it's a bit odd that we aren't at least
> WARN_ON_ONCE() on the flag given what the flag tracks. If you want to do
> this, I think the prev approach of just removing the flag is better as th=
at
> was symmetric at least.

Yes, you are right, thanks for the advice. Since now it's a bit
ambivalent, we might as well just remove this patch?

Thanks,
Kuai
>=20
> Thanks.
>=20

