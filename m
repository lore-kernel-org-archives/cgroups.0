From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v7 6/9] blk-throttle: use 'READ/WRITE' instead of '0/1'
Date: Wed, 17 Aug 2022 09:33:31 +0800
Message-ID: <3c60db26-540d-2cf3-1ebf-1d1fc47a0494@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-7-yukuai1@huaweicloud.com>
 <Yvv4BOx92l20VqD1@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Yvv4BOx92l20VqD1@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Tejun

=D4=DA 2022/08/17 4:03, Tejun Heo =D0=B4=B5=C0:
> On Tue, Aug 02, 2022 at 10:04:12PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Make the code easier to read, like everywhere else.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Acked-by: Tejun Heo <tj@kernel.org>
>=20
> Let's float trivial acked patches to the front so that they can applied
> without waiting for the rest of the series.
>=20
Good point! I'll move last 4 patches into a new patchset.

Thanks,
Kuai
> Thanks.
>=20

