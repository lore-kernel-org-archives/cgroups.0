From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH -next 1/6] blk-wbt: fix that wbt can't be disabled by
 default
Date: Fri, 12 May 2023 15:03:45 +0800
Message-ID: <43cbe02a-a4bd-7e6b-6b3c-c35b2e045136@huaweicloud.com>
References: <20230511014509.679482-1-yukuai1@huaweicloud.com>
 <20230511014509.679482-2-yukuai1@huaweicloud.com>
 <20230511151919.GA7880@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230511151919.GA7880-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi,

=D4=DA 2023/05/11 23:19, Christoph Hellwig =D0=B4=B5=C0:
> On Thu, May 11, 2023 at 09:45:04AM +0800, Yu Kuai wrote:
>> @@ -730,8 +730,9 @@ void wbt_enable_default(struct gendisk *disk)
>>   {
>>   	struct request_queue *q =3D disk->queue;
>>   	struct rq_qos *rqos;
>> -	bool disable_flag =3D q->elevator &&
>> -		    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags);
>> +	bool disable_flag =3D (q->elevator &&
>> +		    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags)) ||
>> +		    !IS_ENABLED(CONFIG_BLK_WBT_MQ);
>=20
> Not really new in your patch, but I find the logic here very confusing.
> First the disable_flag really should be enable instead, as that's how
> it's actually checked, and then spelling out the conditions a bit more
> would really help readability.  E.g.
>=20
> 	bool enabled =3D IS_ENABLED(CONFIG_BLK_WBT_MQ);
>=20
> 	if (q->elevator &&
> 	    test_bit(ELEVATOR_FLAG_DISABLE_WBT, &q->elevator->flags))
> 		enable =3D false;

Of course, this looks better, I'll do this in v2.

Thanks,
Kuai
>=20
>=20
> .
>=20

