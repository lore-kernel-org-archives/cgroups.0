From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v2 1/2] blk-iocost: add refcounting for iocg
Date: Thu, 5 Jan 2023 09:14:07 +0800
Message-ID: <c63ee2ad-23d5-3be0-c731-28494398b391@huaweicloud.com>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
 <20221227125502.541931-2-yukuai1@huaweicloud.com>
 <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y7XzUee5Bq+DoIC1@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@infradead.org, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi,

=D4=DA 2023/01/05 5:44, Tejun Heo =D0=B4=B5=C0:
> On Tue, Dec 27, 2022 at 08:55:01PM +0800, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> iocost requires that child iocg must exit before parent iocg, otherwise
>> kernel might crash in ioc_timer_fn(). However, currently iocg is exited
>> in pd_free_fn(), which can't guarantee such order:
>>
>> 1) remove cgroup can concurrent with deactivate policy;
>> 2) blkg_free() triggered by remove cgroup is asynchronously, remove
>> child cgroup can concurrent with remove parent cgroup;
>>
>> Fix the problem by add refcounting for iocg, and child iocg will grab
>> reference of parent iocg, so that parent iocg will wait for all child
>> iocg to be exited.
>=20
> Wouldn't it be better to do this refcnting in the blk-cgroup core code
> rather than in blk-iocost?
>=20

The problem is that I can't find a proper way to fix the competition
that pd_free_fn() can be called from different context:

1) from blkg_free() that is called asynchronously from removing cgroup;
2) from blkcg_deactivate_policy() that is called from removing device;

1) is related to blkg, while 2) is not, hence refcnting from blkg can't
fix the problem. refcnting from blkcg_policy_data should be ok, but I
see that bfq already has the similar refcnting, while other policy
doesn't require such refcnting.

Any suggestions?

Thanks,
Kuai
> Thanks.
>=20

