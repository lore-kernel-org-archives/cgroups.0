From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v8 1/4] blk-throttle: fix that io throttle can only work
 for single bio
Date: Fri, 26 Aug 2022 09:07:27 +0800
Message-ID: <de0466d4-f501-da13-c3ee-0798c2761d9f@huaweicloud.com>
References: <20220823033130.874230-1-yukuai1@huaweicloud.com>
 <20220823033130.874230-2-yukuai1@huaweicloud.com>
 <YwUXTL+8E/sPcEUB@slm.duckdns.org>
 <73c72914-e27d-b261-e040-2dd31e8a6b9f@huaweicloud.com>
 <Ywe8Uz4Gy6j/EsUg@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Ywe8Uz4Gy6j/EsUg@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, ming.lei@redhat.com, mkoutny@suse.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Tejun

=D4=DA 2022/08/26 2:15, Tejun Heo =D0=B4=B5=C0:
> On Wed, Aug 24, 2022 at 09:15:32AM +0800, Yu Kuai wrote:
>> This patch actually set two flags when bio is throttled and
>> dispatched, and only iops flag is cleared after the original bio is
>> split. If only one flag can be used, the way that I come up with is
>> that let iops limit become default, which means bio is always counted
>> for iops limit each time blk_throtl_bio() is called. I'm not quite
>> sure yet if iops limit can be counted excessively this way in some
>> special scenario...
>=20
> I don't think we have a path where we clone and re-submit other than
> splitting. What do you think about renaming the flag to BIO_BPS_THROTTLED
> and just assuming that IOPS is always applied?

Yes, I didn't found such path myself, this way sounds good. I'll send a
new version soon.

Thanks,
Kuai
>=20
> Thanks.
>=20

