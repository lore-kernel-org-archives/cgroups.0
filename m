From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH RESEND v6 8/8] blk-throttle: clean up flag
 'THROTL_TG_PENDING'
Date: Thu, 28 Jul 2022 19:03:17 +0800
Message-ID: <af637e43-1aac-e4bf-7363-b4771cd91a39@huaweicloud.com>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-9-yukuai1@huaweicloud.com>
 <YuGHjf9MWjirOWcm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <YuGHjf9MWjirOWcm@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>



=D4=DA 2022/07/28 2:44, Tejun Heo =D0=B4=B5=C0:
> On Fri, Jul 01, 2022 at 05:34:41PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> All related operations are inside 'queue_lock', there is no need to use
>> the flag, we only need to make sure throtl_enqueue_tg() is called when
>> the first bio is throttled, and throtl_dequeue_tg() is called when the
>> last throttled bio is dispatched.
>=20
> Ah, okay, so the prev patch was to enable this cleanup. Can you please no=
te
> so in the previous patch and also that this doesn't cause any functional
> changes?
>=20

Of course, I'll do that in next iteration.

Thanks,
Kuai
> Thanks.
>=20

