From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v6 1/3] block, bfq: record how many queues are busy
 in bfq_group
Date: Sat, 28 May 2022 16:37:07 +0800
Message-ID: <7628f927-7131-5e7f-33d9-6029dada57fe@huawei.com>
References: <20220523131818.2798712-1-yukuai3@huawei.com>
 <20220523131818.2798712-2-yukuai3@huawei.com>
 <8D29A46A-4B8A-4F05-BCE3-D9D0F0D2DD5A@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8D29A46A-4B8A-4F05-BCE3-D9D0F0D2DD5A-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Paolo Valente <paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

=D4=DA 2022/05/28 16:18, Paolo Valente =D0=B4=B5=C0:
>=20

>> /*
>> @@ -1660,6 +1678,7 @@ void bfq_del_bfqq_busy(struct bfq_data *bfqd, stru=
ct bfq_queue *bfqq,
>> 	bfq_clear_bfqq_busy(bfqq);
>>
>> 	bfqd->busy_queues[bfqq->ioprio_class - 1]--;
>> +	bfq_inc_busy_queues(bfqq);
>>
>=20
> Why do you increment the number of busy queues for the group on a
> del_bfqq_busy, instead of an add_bfqq_busy?
Hi, Paolo

You'are right, here should be bfq_dec_busy_queues()...
>=20
> Besides, the name of the function bfq_inc_busy_queues does not mention
> the target of the update, namely the group.  This creates a little
> confusion at a first sight, as one sees this function invoked right
> after the update of a field with the same name: bfqd->busy_queues.
Ok, that make sense, I'll move the update of 'bfqd->busy_queues' into
the new api as well.

Thanks,
Kuai
>=20
>> 	if (bfqq->wr_coeff > 1)
>> 		bfqd->wr_busy_queues--;
>> @@ -1683,6 +1702,7 @@ void bfq_add_bfqq_busy(struct bfq_data *bfqd, stru=
ct bfq_queue *bfqq)
>>
>> 	bfq_mark_bfqq_busy(bfqq);
>> 	bfqd->busy_queues[bfqq->ioprio_class - 1]++;
>> +	bfq_dec_busy_queues(bfqq);
>=20
> Same pair of comments as above.
>=20
> Thanks,
> Paolo
>=20
>>
>> 	if (!bfqq->dispatched)
>> 		if (bfqq->wr_coeff =3D=3D 1)
>> --=20
>> 2.31.1
>>
>=20
> .
>=20
