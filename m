From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] block, bfq: fix null pointer dereference in
 bfq_bio_bfqg()
Date: Tue, 8 Nov 2022 21:15:08 +0800
Message-ID: <6cd64e77-e14d-ff9c-d97f-055165a7b214@huaweicloud.com>
References: <20221108103434.2853269-1-yukuai1@huaweicloud.com>
 <20221108124841.et6cddvczncp2cz7@quack3>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221108124841.et6cddvczncp2cz7@quack3>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi!

=D4=DA 2022/11/08 20:48, Jan Kara =D0=B4=B5=C0:
>=20
> Hum, that is indeed contrieved ;). Your fixup makes sense so feel free to
> add:
>=20
> Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

Thanks for the review, our test do many unusual operations together...

Thanks,
Kuai
>=20
> 								Honza
>=20
>>
>> diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
>> index 144bca006463..7d624a3a3f0f 100644
>> --- a/block/bfq-cgroup.c
>> +++ b/block/bfq-cgroup.c
>> @@ -610,6 +610,10 @@ struct bfq_group *bfq_bio_bfqg(struct bfq_data *bfq=
d, struct bio *bio)
>>   	struct bfq_group *bfqg;
>>  =20
>>   	while (blkg) {
>> +		if (!blkg->online) {
>> +			blkg =3D blkg->parent;
>> +			continue;
>> +		}
>>   		bfqg =3D blkg_to_bfqg(blkg);
>>   		if (bfqg->online) {
>>   			bio_associate_blkg_from_css(bio, &blkg->blkcg->css);
>> --=20
>> 2.31.1
>>

