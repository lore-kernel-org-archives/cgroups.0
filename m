From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v7 4/9] blk-throttle: fix io hung due to configuration
 updates
Date: Wed, 17 Aug 2022 09:30:30 +0800
Message-ID: <215b4842-c09f-d622-7127-c8b1d9ce3aa9@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-5-yukuai1@huaweicloud.com>
 <Yvv3jcycOguuEbA3@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yvv3jcycOguuEbA3-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Tejun!

=D4=DA 2022/08/17 4:01, Tejun Heo =D0=B4=B5=C0:
> On Tue, Aug 02, 2022 at 10:04:10PM +0800, Yu Kuai wrote:
> ...
>> +static void __tg_update_skipped(struct throtl_grp *tg, bool rw)
>> +{
>> +	unsigned long jiffy_elapsed =3D jiffies - tg->slice_start[rw];
>> +	u64 bps_limit =3D tg_bps_limit(tg, rw);
>> +	u32 iops_limit =3D tg_iops_limit(tg, rw);
>> +
>> +	/*
>> +	 * If config is updated while bios are still throttled, calculate and
>> +	 * accumulate how many bytes/io are waited across changes. And
>> +	 * bytes/io_skipped will be used to calculate new wait time under new
>> +	 * configuration.
>> +	 *
>> +	 * Following calculation won't overflow as long as bios that are
>> +	 * dispatched later won't preempt already throttled bios. Even if such
>> +	 * overflow do happen, there should be no problem because unsigned is
>> +	 * used here, and bytes_skipped/io_skipped will be updated correctly.
>> +	 */
>=20
> Would it be easier if the fields were signed? It's fragile and odd to
> explain "these are unsigned but if they underflow they behave just like
> signed when added" when they can just be signed. Also, I have a hard time
> understand what "preempt" means above.

I think preempt shound never happen based on current FIFO
implementation, perhaps
>=20
>> +	if (bps_limit !=3D U64_MAX)
>> +		tg->bytes_skipped[rw] +=3D
>> +			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
>> +			tg->bytes_disp[rw];
>> +	if (iops_limit !=3D UINT_MAX)
>> +		tg->io_skipped[rw] +=3D
>> +			calculate_io_allowed(iops_limit, jiffy_elapsed) -
>> +			tg->io_disp[rw];
>=20
> So, this is calculating the budgets to carry over. Can we name them
> accordingly? I don't know what "skipped" means.

Yeah, thanks for you advice, art of naming is a little hard for me...
How do you think about these name: extended_bytes/io_budget?
>=20
>> @@ -115,6 +115,17 @@ struct throtl_grp {
>>   	uint64_t bytes_disp[2];
>>   	/* Number of bio's dispatched in current slice */
>>   	unsigned int io_disp[2];
>> +	/*
>> +	 * The following two fields are updated when new configuration is
>> +	 * submitted while some bios are still throttled, they record how many
>> +	 * bytes/io are waited already in previous configuration, and they will
>> +	 * be used to calculate wait time under new configuration.
>> +	 *
>> +	 * Number of bytes will be skipped in current slice
>> +	 */
>> +	uint64_t bytes_skipped[2];
>> +	/* Number of bio will be skipped in current slice */
>> +	unsigned int io_skipped[2];
>=20
> So, the code seems to make sense but the field names and comments don't
> really, at least to me. I can't find an intuitive understanding of what's
> being skipped. Can you please take another stab at making this more
> understandable?
>=20
> Thanks.
>=20

