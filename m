From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v7 8/9] blk-throttle: cleanup tg_update_disptime()
Date: Wed, 17 Aug 2022 09:38:45 +0800
Message-ID: <b06bbbce-ffd1-4a07-3f74-eac8411edd97@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-9-yukuai1@huaweicloud.com>
 <Yvv5as5BVuqjw6PX@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Yvv5as5BVuqjw6PX@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Tejun=A3=A1

=D4=DA 2022/08/17 4:09, Tejun Heo =D0=B4=B5=C0:
> On Tue, Aug 02, 2022 at 10:04:14PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> tg_update_disptime() only need to adjust postion for 'tg' in
>> 'parent_sq', there is no need to call throtl_enqueue/dequeue_tg().
>>
>> Save a little overhead in tg_update_disptime() and prepare to cleanup
>> flag 'THROTL_TG_PENDING', there are no functional changes.
>=20
> Does this actually help anything? Given that the heavy part of the operat=
ion
> remains the same, this might not be much of an optimization. Is there eve=
n a
> microbench that can show the difference?

It's right heavy part remains the same, the patch just remove some
unnecessary operations. And I didn't run benchmark to test that yet.

Thanks,
Kuai
>=20
> Thanks.
>=20

