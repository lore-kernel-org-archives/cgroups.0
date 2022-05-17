From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next] block: fix io hung of setting throttle limit
 frequently
Date: Tue, 17 May 2022 11:12:28 +0800
Message-ID: <ca251645-8d52-7a93-6ac2-579d97922a9e@huawei.com>
References: <20220516014429.33723-1-zhangwensheng5@huawei.com>
 <YoKmCOAzwzw3Lz7g@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <YoKmCOAzwzw3Lz7g@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Zhang Wensheng <zhangwensheng5@huawei.com>, "ming.lei@redhat.com >> Ming Lei" <ming.lei@redhat.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

=D4=DA 2022/05/17 3:29, Tejun Heo =D0=B4=B5=C0:
> On Mon, May 16, 2022 at 09:44:29AM +0800, Zhang Wensheng wrote:
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index 469c483719be..8acb205dfa85 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -1321,12 +1321,14 @@ static void tg_conf_updated(struct throtl_grp *t=
g, bool global)
>>   	 * that a group's limit are dropped suddenly and we don't want to
>>   	 * account recently dispatched IO with new low rate.
>>   	 */
>> -	throtl_start_new_slice(tg, READ);
>> -	throtl_start_new_slice(tg, WRITE);
>> +	if (!timer_pending(&sq->parent_sq->pending_timer)) {
>> +		throtl_start_new_slice(tg, READ);
>> +		throtl_start_new_slice(tg, WRITE);
>>  =20
>> -	if (tg->flags & THROTL_TG_PENDING) {
>> -		tg_update_disptime(tg);
>> -		throtl_schedule_next_dispatch(sq->parent_sq, true);
>> +		if (tg->flags & THROTL_TG_PENDING) {
>> +			tg_update_disptime(tg);
>> +			throtl_schedule_next_dispatch(sq->parent_sq, true);
>> +		}
>=20
> Yeah, but this ends up breaking the reason why it's starting the new slic=
es
> in the first place explained in the commit above, right? I'm not sure what
> the right solution is but this likely isn't it.
>=20
Hi, Tejun

Ming added a condition in tg_with_in_bps_limit():
-       if (bps_limit =3D=3D U64_MAX) {
+       /* no need to throttle if this bio's bytes have been accounted */
+       if (bps_limit =3D=3D U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {

Which will let the first throttled bio to be issued immediately once
the config if updated.

Do you think this behaviour is OK? If so, we can do the same for
tg_with_in_iops_limit.

Thanks,
Kuai

>=20
